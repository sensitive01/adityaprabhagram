import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

/**
 * Derive a username from a full name and role prefix.
 * Pattern: <prefix>.<first_word_of_name_lowercased>
 * e.g. CLUSTER_HEAD "Ranjit Singh" → "ch.ranjit"
 *      FIELD_AGENT  "Mohan Sharma" → "fa.mohan"
 * Falls back to the email prefix if name is empty.
 */
function deriveUsername(fullName: string, email: string, role: string): string {
  const prefix = role === "CLUSTER_HEAD" ? "ch" : "fa";
  const firstName = fullName.trim().split(/\s+/)[0] ?? "";
  const base = firstName.length > 0
    ? firstName.toLowerCase().replace(/[^a-z0-9]/g, "")
    : email.split("@")[0].toLowerCase().replace(/[^a-z0-9]/g, "");
  return `${prefix}.${base}`;
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 1. Verify the caller is an authenticated ADMIN
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing authorization header" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Create an anon client to verify the caller's JWT
    const anonClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } }
    );

    const { data: { user: callerUser }, error: callerError } = await anonClient.auth.getUser();
    if (callerError || !callerUser) {
      return new Response(
        JSON.stringify({ error: "Unauthorized: invalid session" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Check caller role in user_profiles
    const { data: callerProfile, error: profileError } = await anonClient
      .from("user_profiles")
      .select("role")
      .eq("id", callerUser.id)
      .maybeSingle();

    if (profileError || !callerProfile || callerProfile.role !== "ADMIN") {
      return new Response(
        JSON.stringify({ error: "Forbidden: only ADMIN can create users" }),
        { status: 403, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 2. Parse request body
    const body = await req.json();
    const { fullName, email, password, phone, username, clusterId, role } = body;

    if (!fullName || !email || !password) {
      return new Response(
        JSON.stringify({ error: "fullName, email, and password are required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const userRole: string = role === "CLUSTER_HEAD" ? "CLUSTER_HEAD" : "FIELD_AGENT";

    // 3. Use service-role client for privileged operations (server-side only)
    const adminClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
      { auth: { autoRefreshToken: false, persistSession: false } }
    );

    // 4. Check for duplicate email (safe server-side check)
    const { data: existingUsers, error: listError } = await adminClient.auth.admin.listUsers();
    if (listError) {
      return new Response(
        JSON.stringify({ error: "Failed to check existing users: " + listError.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }
    const emailExists = existingUsers.users.some(
      (u) => u.email?.toLowerCase() === email.trim().toLowerCase()
    );
    if (emailExists) {
      return new Response(
        JSON.stringify({ error: "A user with this email already exists." }),
        { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 5. Generate the final username BEFORE creating the Auth user.
    //    If the caller supplied a username, use it; otherwise derive one from the name.
    //    This value is passed in user_metadata so that handle_new_user() sets
    //    user_profiles.username on the initial INSERT — never via a subsequent UPDATE,
    //    which would be rejected by the immutability trigger.
    const finalUsername: string =
      (username && username.trim().length > 0)
        ? username.trim()
        : deriveUsername(fullName, email, userRole);

    // 6. Create the Auth user with all required metadata.
    //    handle_new_user() reads raw_user_meta_data and creates user_profiles with:
    //      username         ← finalUsername
    //      full_name        ← fullName
    //      role             ← userRole
    //      must_change_password ← true
    const { data: authData, error: createError } = await adminClient.auth.admin.createUser({
      email: email.trim(),
      password: password,
      email_confirm: true,
      user_metadata: {
        username: finalUsername,
        full_name: fullName.trim(),
        role: userRole,
        must_change_password: true,
      },
    });

    if (createError || !authData.user) {
      return new Response(
        JSON.stringify({ error: createError?.message ?? "Failed to create auth user" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const newUserId = authData.user.id;

    // 7. Update supplementary profile fields that handle_new_user() does not set
    //    (phone). Do NOT include username, full_name, role, or must_change_password
    //    here — those are already set by the trigger and updating them would either
    //    be a no-op or trigger the immutability constraint.
    if (phone && phone.trim().length > 0) {
      const { error: profileUpdateError } = await adminClient
        .from("user_profiles")
        .update({ phone: phone.trim() })
        .eq("id", newUserId);

      if (profileUpdateError) {
        // Rollback: delete the auth user we just created
        await adminClient.auth.admin.deleteUser(newUserId);
        return new Response(
          JSON.stringify({ error: "Failed to update user profile: " + profileUpdateError.message }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    // 8. Assign to cluster if provided
    if (clusterId) {
      if (userRole === "CLUSTER_HEAD") {
        const { error: chError } = await adminClient
          .from("cluster_heads")
          .insert({ cluster_id: clusterId, user_id: newUserId, is_active: true });
        if (chError) {
          // Roll back the auth user so we don't leave an orphaned account
          await adminClient.auth.admin.deleteUser(newUserId);
          return new Response(
            JSON.stringify({ error: "Failed to assign cluster head to cluster: " + chError.message }),
            { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
          );
        }
      } else {
        const { error: faError } = await adminClient
          .from("field_agent_cluster_assignments")
          .insert({ agent_id: newUserId, cluster_id: clusterId, is_active: true });
        if (faError) {
          console.error("field_agent_cluster_assignments insert error:", faError.message);
          // Non-fatal: user created, cluster assignment failed
        }
      }
    }

    return new Response(
      JSON.stringify({ success: true, userId: newUserId }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    console.error("Unhandled error:", err);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
