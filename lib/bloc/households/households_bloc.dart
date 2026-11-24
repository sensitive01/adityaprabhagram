import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/household_model.dart';
import '../../services/connectivity_service.dart';
import '../../services/local_database_service.dart';
import '../../services/supabase_service.dart';
import 'households_event.dart';
import 'households_state.dart';

export 'households_event.dart';
export 'households_state.dart';

class HouseholdsBloc extends Bloc<HouseholdsEvent, HouseholdsState> {
  final SupabaseService _supabaseService;
  final LocalDatabaseService _localDbService;
  final ConnectivityService _connectivityService;

  HouseholdsBloc({
    SupabaseService? supabaseService,
    LocalDatabaseService? localDbService,
    ConnectivityService? connectivityService,
  })  : _supabaseService = supabaseService ?? SupabaseService.instance,
        _localDbService = localDbService ?? LocalDatabaseService.instance,
        _connectivityService = connectivityService ?? ConnectivityService.instance,
        super(const HouseholdsInitial()) {
    on<HouseholdsFetchRequested>(_onFetchRequested);
    on<HouseholdsSearchChanged>(_onSearchChanged);
    on<HouseholdsFilterChanged>(_onFilterChanged);
    on<HouseholdStatusUpdated>(_onHouseholdStatusUpdated);
  }

  Future<void> _onFetchRequested(
    HouseholdsFetchRequested event,
    Emitter<HouseholdsState> emit,
  ) async {
    emit(const HouseholdsLoading());

    try {
      final isOnline = _connectivityService.isOnline;
      List<HouseholdModel> households = [];

      if (isOnline) {
        final rawList = await _supabaseService.fetchAgentHouseholds();
        households = rawList.map(HouseholdModel.fromSupabase).toList();
        await _mergeLocalDrafts(households);
      } else {
        await _loadLocalDraftsOnly(households);
      }

      emit(_createLoadedState(
        all: households,
        filter: 'All',
        query: '',
      ));
    } catch (_) {
      final localHouseholds = <HouseholdModel>[];
      try {
        await _loadLocalDraftsOnly(localHouseholds);
      } catch (_) {}

      if (localHouseholds.isNotEmpty) {
        emit(_createLoadedState(
          all: localHouseholds,
          filter: 'All',
          query: '',
        ));
      } else {
        emit(const HouseholdsError('Failed to load households. Pull down to retry.'));
      }
    }
  }

  void _onSearchChanged(
    HouseholdsSearchChanged event,
    Emitter<HouseholdsState> emit,
  ) {
    if (state is HouseholdsLoaded) {
      final current = state as HouseholdsLoaded;
      emit(_createLoadedState(
        all: current.allHouseholds,
        filter: current.selectedFilter,
        query: event.query,
      ));
    }
  }

  void _onFilterChanged(
    HouseholdsFilterChanged event,
    Emitter<HouseholdsState> emit,
  ) {
    if (state is HouseholdsLoaded) {
      final current = state as HouseholdsLoaded;
      emit(_createLoadedState(
        all: current.allHouseholds,
        filter: event.filter,
        query: current.searchQuery,
      ));
    }
  }

  void _onHouseholdStatusUpdated(
    HouseholdStatusUpdated event,
    Emitter<HouseholdsState> emit,
  ) {
    if (state is HouseholdsLoaded) {
      final current = state as HouseholdsLoaded;
      final updatedList = current.allHouseholds.map((h) {
        if (h.id == event.householdId) {
          return h.copyWith(
            surveyStatus: event.status,
            surveyId: event.surveyId ?? h.surveyId,
          );
        }
        return h;
      }).toList();

      emit(_createLoadedState(
        all: updatedList,
        filter: current.selectedFilter,
        query: current.searchQuery,
      ));
    }
  }

  HouseholdsLoaded _createLoadedState({
    required List<HouseholdModel> all,
    required String filter,
    required String query,
  }) {
    final filtered = _applyFilters(all, filter, query);

    final pending = all.where((h) =>
        h.surveyStatus == SurveyStatus.noSurvey ||
        h.surveyStatus == SurveyStatus.draft).length;
    final correction = all.where((h) =>
        h.surveyStatus == SurveyStatus.correctionRequired).length;
    final approved = all.where((h) =>
        h.surveyStatus == SurveyStatus.approved).length;

    return HouseholdsLoaded(
      allHouseholds: all,
      filteredHouseholds: filtered,
      selectedFilter: filter,
      searchQuery: query,
      pendingCount: pending,
      correctionCount: correction,
      approvedCount: approved,
    );
  }

  List<HouseholdModel> _applyFilters(
    List<HouseholdModel> all,
    String filter,
    String query,
  ) {
    return all.where((h) {
      final matchesFilter = switch (filter) {
        'Start Survey' => h.surveyStatus == SurveyStatus.noSurvey,
        'Draft' => h.surveyStatus == SurveyStatus.draft,
        'Submitted' => h.surveyStatus == SurveyStatus.submitted,
        'Under Review' => h.surveyStatus == SurveyStatus.underReview,
        'Correction Required' => h.surveyStatus == SurveyStatus.correctionRequired,
        'Approved' => h.surveyStatus == SurveyStatus.approved,
        _ => true,
      };

      if (!matchesFilter) return false;

      if (query.isEmpty) return true;
      final q = query.toLowerCase();
      return h.name.toLowerCase().contains(q) ||
          h.headName.toLowerCase().contains(q) ||
          h.village.toLowerCase().contains(q) ||
          h.id.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _mergeLocalDrafts(List<HouseholdModel> households) async {
    if (!_localDbService.isAvailable) return;
    final uid = _supabaseService.currentUser?.id;
    if (uid == null) return;

    try {
      for (final household in households) {
        if (household.surveyId != null) continue;
        final localRows = await _localDbService.getSurveysForHousehold(household.id);
        if (localRows.isEmpty) continue;

        final latestLocal = localRows.reduce((a, b) {
          final aTime = a['updated_at'] as String? ?? '';
          final bTime = b['updated_at'] as String? ?? '';
          return aTime.compareTo(bTime) >= 0 ? a : b;
        });

        final localSurveyId = latestLocal['survey_id'] as String?;
        if (localSurveyId == null) continue;

        final idx = households.indexOf(household);
        if (idx >= 0) {
          households[idx] = HouseholdModel(
            id: household.id,
            name: household.name,
            headName: household.headName,
            village: household.village,
            cluster: household.cluster,
            district: household.district,
            surveyStatus: SurveyStatus.draft,
            lastSurveyDate: (latestLocal['updated_at'] as String? ?? '').length >= 10
                ? (latestLocal['updated_at'] as String).substring(0, 10)
                : 'Offline draft',
            membersCount: household.membersCount,
            lat: household.lat,
            lng: household.lng,
            rejectionReason: null,
            avatarUrl: household.avatarUrl,
            avatarSemanticLabel: household.avatarSemanticLabel,
            surveyId: localSurveyId,
            isLocalDraft: true,
          );
        }
      }
    } catch (_) {}
  }

  Future<void> _loadLocalDraftsOnly(List<HouseholdModel> households) async {
    if (!_localDbService.isAvailable) return;
    try {
      final uid = _supabaseService.currentUser?.id;
      if (uid == null) return;
      final rows = await _localDbService.getSurveysForAgent(uid);
      final seenHouseholds = <String>{};
      for (final r in rows) {
        final hid = r['household_id'] as String? ?? '';
        final sid = r['survey_id'] as String? ?? '';
        final updatedAt = r['updated_at'] as String? ?? '';
        if (hid.isNotEmpty && sid.isNotEmpty && seenHouseholds.add(hid)) {
          households.add(HouseholdModel.fromLocalDraft(
            householdId: hid,
            surveyId: sid,
            updatedAt: updatedAt,
          ));
        }
      }
    } catch (_) {}
  }
}
