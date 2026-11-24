import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
        'SUPABASE_URL and SUPABASE_ANON_KEY must be defined using --dart-define.',
      );
    }
    await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
    _isInitialized = true;
  }

  SupabaseClient get client => Supabase.instance.client;

  // ── Auth ──────────────────────────────────────────────────────────────────

  User? get currentUser => _isInitialized ? client.auth.currentUser : null;

  bool get isSignedIn => currentUser != null;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // ── User Profile ──────────────────────────────────────────────────────────

  /// Returns the user_profiles row for the currently signed-in user.
  Future<Map<String, dynamic>?> fetchCurrentUserProfile() async {
    final uid = currentUser?.id;
    if (uid == null) return null;
    try {
      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', uid)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  /// Returns the role string ('FIELD_AGENT' | 'HOUSEHOLD' | 'ADMIN' | 'CLUSTER_HEAD') or null.
  Future<String?> fetchCurrentUserRole() async {
    final profile = await fetchCurrentUserProfile();
    return profile?['role'] as String?;
  }

  // ── Cluster Head helpers ──────────────────────────────────────────────────

  /// Returns the cluster_id for the currently signed-in CLUSTER_HEAD, or null.
  Future<String?> fetchClusterHeadClusterId() async {
    final uid = currentUser?.id;
    if (uid == null) return null;
    try {
      final record = await client
          .from('cluster_heads')
          .select('cluster_id')
          .eq('user_id', uid)
          .eq('is_active', true)
          .maybeSingle();
      return record?['cluster_id'] as String?;
    } catch (_) {
      return null;
    }
  }

  // ── Households ────────────────────────────────────────────────────────────

  /// Fetch all households assigned to the current FIELD_AGENT.
  Future<List<Map<String, dynamic>>> fetchAgentHouseholds() async {
    final uid = currentUser?.id;
    if (uid == null) return [];
    try {
      // Step 1: get household IDs from the assignments table (source of truth)
      final assignments = await client
          .from('household_agent_assignments')
          .select('household_id')
          .eq('agent_id', uid)
          .eq('is_active', true);

      if (assignments.isEmpty) return [];

      final householdIds = (assignments as List)
          .map((a) => a['household_id'] as String)
          .toList();

      // Step 2: fetch the household rows
      final households = await client
          .from('households')
          .select()
          .inFilter('id', householdIds);

      // Step 3: fetch the most recent survey for each household
      final List<Map<String, dynamic>> result = [];
      for (final h in households) {
        // Fetch up to 2 surveys so we can prefer draft over correction_required
        final surveys = await client
            .from('surveys')
            .select()
            .eq('household_id', h['id'] as String)
            .order('created_at', ascending: false)
            .limit(2);
        final surveyList = surveys as List;
        Map<String, dynamic>? survey;
        if (surveyList.isNotEmpty) {
          // Prefer draft over correction_required so Resume Draft opens the draft record
          final draftSurvey = surveyList.firstWhere(
            (s) => s['status'] == 'draft',
            orElse: () => <String, dynamic>{},
          );
          survey = (draftSurvey as Map<String, dynamic>).isNotEmpty
              ? draftSurvey
              : surveyList.first as Map<String, dynamic>;
        }
        result.add({...h, 'survey': survey});
      }
      return result;
    } catch (e) {
      return [];
    }
  }

  /// Fetch the household record for the current HOUSEHOLD user.
  Future<Map<String, dynamic>?> fetchMyHousehold() async {
    final uid = currentUser?.id;
    debugPrint('[DIAG] fetchMyHousehold() called');
    debugPrint('[DIAG] currentUser?.id = $uid');
    debugPrint(
      '[DIAG] currentSession?.user.id = ${client.auth.currentSession?.user.id}',
    );
    if (uid == null) {
      debugPrint(
        '[DIAG] UID is null — session not ready or user not logged in. Returning null.',
      );
      return null;
    }
    try {
      debugPrint('[DIAG] Querying households WHERE household_user_id = $uid');
      final household = await client
          .from('households')
          .select()
          .eq('household_user_id', uid)
          .maybeSingle();
      debugPrint('[DIAG] households query result: $household');
      if (household == null) {
        debugPrint(
          '[DIAG] Query returned zero rows for UID=$uid. No household linked.',
        );
        debugPrint(
          '[DIAG] Supabase URL in use: ${const String.fromEnvironment('SUPABASE_URL')}',
        );
        return null;
      }
      debugPrint(
        '[DIAG] Household row found: id=${household['id']}, household_user_id=${household['household_user_id']}',
      );

      // Fetch survey
      debugPrint(
        '[DIAG] --- Query 2: surveys WHERE household_id = ${household['id']} (.maybeSingle()) ---',
      );
      Map<String, dynamic>? survey;
      try {
        final surveyRows = await client
            .from('surveys')
            .select()
            .eq('household_id', household['id'] as String)
            .order('created_at', ascending: false)
            .limit(1);
        survey = surveyRows.isNotEmpty ? surveyRows.first : null;
        debugPrint('[DIAG] surveys query result: $survey');
        debugPrint(
          '[DIAG] surveys query returned: ${survey == null ? "0 rows (null)" : "1 row"}',
        );
      } catch (e) {
        debugPrint('[DIAG] surveys query THREW EXCEPTION: $e');
        debugPrint('[DIAG] surveys exception type: ${e.runtimeType}');
        debugPrint('[DIAG] *** THIS IS LIKELY THE QUERY CAUSING THE 406 ***');
        rethrow;
      }

      // Fetch assigned agent profile
      Map<String, dynamic>? agentProfile;
      if (household['assigned_agent_id'] != null) {
        debugPrint(
          '[DIAG] --- Query 3: user_profiles WHERE id = ${household['assigned_agent_id']} (.maybeSingle()) ---',
        );
        try {
          agentProfile = await client
              .from('user_profiles')
              .select()
              .eq('id', household['assigned_agent_id'] as String)
              .maybeSingle();
          debugPrint('[DIAG] user_profiles query result: $agentProfile');
          debugPrint(
            '[DIAG] user_profiles query returned: ${agentProfile == null ? "0 rows (null)" : "1 row"}',
          );
        } catch (e) {
          debugPrint('[DIAG] user_profiles .maybeSingle() THREW EXCEPTION: $e');
          debugPrint('[DIAG] user_profiles exception type: ${e.runtimeType}');
          debugPrint('[DIAG] *** THIS IS LIKELY THE QUERY CAUSING THE 406 ***');
          rethrow;
        }
      }

      // When a latest survey exists, overlay display fields with survey response values.
      final Map<String, dynamic> surveyResponses =
          (survey != null && survey['responses'] is Map)
          ? Map<String, dynamic>.from(survey['responses'] as Map)
          : {};
      return {
        ...household,
        'survey': survey,
        'agent': agentProfile,
        if (surveyResponses.containsKey('da7a7fd2-e473-4b22-b1a1-c63480fff856'))
          'respondent_name':
              surveyResponses['da7a7fd2-e473-4b22-b1a1-c63480fff856'],
        if (surveyResponses.containsKey('c7da5296-7818-4a79-ab72-befd32ba3533'))
          'contact_number':
              surveyResponses['c7da5296-7818-4a79-ab72-befd32ba3533'],
        if (surveyResponses.containsKey('1886cee1-3664-4f54-b62f-c46bb10662ac'))
          'family_size':
              surveyResponses['1886cee1-3664-4f54-b62f-c46bb10662ac'],
        if (surveyResponses.containsKey('1886cee1-3664-4f54-b62f-c46bb10662ac'))
          'members_count':
              surveyResponses['1886cee1-3664-4f54-b62f-c46bb10662ac'],
        if (surveyResponses.containsKey('992bb431-235a-4aec-bf92-d3f435ecde84'))
          'tribe_community':
              surveyResponses['992bb431-235a-4aec-bf92-d3f435ecde84'],
        if (surveyResponses.containsKey('170f0236-d389-4b69-a02c-93bd4b5485e3'))
          'household_type':
              surveyResponses['170f0236-d389-4b69-a02c-93bd4b5485e3'],
        if (survey != null && survey['last_survey_date'] != null)
          'survey_date': survey['last_survey_date'],
      };
    } catch (e, stack) {
      debugPrint('[DIAG] fetchMyHousehold() EXCEPTION caught: $e');
      debugPrint('[DIAG] Exception type: ${e.runtimeType}');
      debugPrint('[DIAG] Stack trace: $stack');
      return null;
    }
  }

  /// Fetch published bulletins visible to the current HOUSEHOLD user.
  Future<List<Map<String, dynamic>>> fetchHouseholdBulletins() async {
    try {
      final data = await client
          .from('bulletins')
          .select(
            'id, title, body, published_at, created_at, user_profiles!published_by(full_name)',
          )
          .eq('is_active', true)
          .order('published_at', ascending: false)
          .limit(20);
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      return [];
    }
  }

  /// Fetch questions (with answers) for the current HOUSEHOLD user.
  Future<List<Map<String, dynamic>>> fetchHouseholdQuestions(
    String householdId,
  ) async {
    try {
      final data = await client
          .from('household_questions')
          .select(
            'id, question_text, is_answered, created_at, question_answers(id, answer_text, created_at, user_profiles!answered_by(full_name))',
          )
          .eq('household_id', householdId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      return [];
    }
  }

  /// Submit a new question from the current HOUSEHOLD user.
  Future<void> submitHouseholdQuestion({
    required String householdId,
    required String questionText,
  }) async {
    final uid = currentUser?.id;
    await client.from('household_questions').insert({
      'household_id': householdId,
      'asked_by': uid,
      'question_text': questionText,
      'is_answered': false,
    });
  }
}
