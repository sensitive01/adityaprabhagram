import os
import sys
import json
import datetime
import psycopg2
from psycopg2 import sql
from psycopg2.extras import RealDictCursor

# Configuration
TENANT_REF = "mhpbfrgivzscspgfiege"
REGION = "ap-southeast-1"
DIRECT_HOST = f"db.{TENANT_REF}.supabase.co"
POOLER_HOST = f"aws-0-{REGION}.pooler.supabase.com"

def get_connection(password):
    """Safely connects to Supabase PostgreSQL using direct host or pooler."""
    endpoints = [
        {"host": DIRECT_HOST, "port": 5432, "user": "postgres"},
        {"host": POOLER_HOST, "port": 6543, "user": f"postgres.{TENANT_REF}"},
        {"host": POOLER_HOST, "port": 5432, "user": f"postgres.{TENANT_REF}"},
    ]

    for ep in endpoints:
        print(f"Connecting to {ep['host']}:{ep['port']} as '{ep['user']}'...")
        try:
            conn = psycopg2.connect(
                host=ep["host"],
                port=ep["port"],
                user=ep["user"],
                password=password,
                dbname="postgres",
                connect_timeout=10,
                sslmode="require"
            )
            # Enforce read-only session to guarantee safety (zero data mutation possible)
            conn.set_session(readonly=True, autocommit=True)
            print(f"[SUCCESS] Connected in READ-ONLY mode to {ep['host']}:{ep['port']}\n")
            return conn
        except Exception as e:
            print(f"  Connection attempt failed: {e}")

    return None

def json_serializer(obj):
    """Custom serializer for dates, datetimes, decimals, and UUIDs."""
    if isinstance(obj, (datetime.datetime, datetime.date, datetime.time)):
        return obj.isoformat()
    return str(obj)

def dump_database(password):
    conn = get_connection(password)
    if not conn:
        print("\n[ERROR] Unable to connect. Please verify the database password in the Supabase Dashboard.")
        print(f"Go to: https://supabase.com/dashboard/project/{TENANT_REF}/settings/database")
        return False

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir = os.path.join(os.getcwd(), "backups", f"backup_{timestamp}")
    os.makedirs(backup_dir, exist_ok=True)
    sql_dump_path = os.path.join(backup_dir, f"apg_full_backup_{timestamp}.sql")

    print(f"Target Backup Directory: {backup_dir}")
    print(f"Target SQL Dump: {sql_dump_path}\n")

    summary = {}

    with conn.cursor() as cur:
        # Get list of public tables
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
            ORDER BY table_name;
        """)
        tables = [r[0] for r in cur.fetchall()]

    print(f"Found {len(tables)} tables in 'public' schema.")

    with open(sql_dump_path, "w", encoding="utf-8") as sql_file:
        sql_file.write(f"-- AdityaPrabhaGram Database Backup\n")
        sql_file.write(f"-- Generated At: {datetime.datetime.now().isoformat()}\n")
        sql_file.write(f"-- Supabase Project: {TENANT_REF}\n\n")
        sql_file.write("BEGIN;\n\n")

        for table in tables:
            json_path = os.path.join(backup_dir, f"{table}.json")
            try:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute(sql.SQL("SELECT * FROM public.{}").format(sql.Identifier(table)))
                    rows = cur.fetchall()
                    count = len(rows)
                    summary[table] = count
                    print(f"  -> Dumped '{table}': {count} rows")

                    # Save JSON
                    with open(json_path, "w", encoding="utf-8") as jf:
                        json.dump(rows, jf, default=json_serializer, indent=2)

                    # Append SQL INSERTs
                    if count > 0:
                        sql_file.write(f"-- Table: public.{table} ({count} rows)\n")
                        columns = list(rows[0].keys())
                        col_identifiers = sql.SQL(", ").join([sql.Identifier(c) for c in columns])

                        for row in rows:
                            values = [row[c] for c in columns]
                            insert_stmt = cur.mogrify(
                                sql.SQL("INSERT INTO public.{} ({}) VALUES ({}) ON CONFLICT DO NOTHING;\n").format(
                                    sql.Identifier(table),
                                    col_identifiers,
                                    sql.SQL(", ").join([sql.Placeholder()] * len(values))
                                ).as_string(conn),
                                values
                            ).decode("utf-8")
                            sql_file.write(insert_stmt)
                        sql_file.write("\n")

            except Exception as e:
                print(f"  [WARNING] Error dumping table '{table}': {e}")
                summary[table] = f"Error: {e}"

        sql_file.write("COMMIT;\n")

    conn.close()

    # Write summary manifest
    manifest_path = os.path.join(backup_dir, "manifest.json")
    with open(manifest_path, "w", encoding="utf-8") as mf:
        json.dump({
            "project": TENANT_REF,
            "timestamp": timestamp,
            "total_tables": len(tables),
            "table_row_counts": summary
        }, mf, indent=2)

    print("\n==========================================")
    print("BACKUP COMPLETED SUCCESSFULLY!")
    print(f"Directory: {backup_dir}")
    print(f"SQL file:  {sql_dump_path}")
    print("==========================================")
    return True

if __name__ == "__main__":
    pwd = sys.argv[1] if len(sys.argv) > 1 else "AdityaPG@2026"
    dump_database(pwd)
