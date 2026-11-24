import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/local_database_service.dart';
import '../../services/sync_service.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

class SyncStarted extends SyncEvent {
  const SyncStarted();
}

class SyncCheckRequested extends SyncEvent {
  const SyncCheckRequested();
}

class SyncState extends Equatable {
  final int pendingCount;
  final bool isSyncing;
  final DateTime? lastSyncTime;

  const SyncState({
    this.pendingCount = 0,
    this.isSyncing = false,
    this.lastSyncTime,
  });

  SyncState copyWith({
    int? pendingCount,
    bool? isSyncing,
    DateTime? lastSyncTime,
  }) {
    return SyncState(
      pendingCount: pendingCount ?? this.pendingCount,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  List<Object?> get props => [pendingCount, isSyncing, lastSyncTime];
}

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncService _syncService;
  final LocalDatabaseService _localDbService;

  SyncBloc({
    SyncService? syncService,
    LocalDatabaseService? localDbService,
  })  : _syncService = syncService ?? SyncService.instance,
        _localDbService = localDbService ?? LocalDatabaseService.instance,
        super(const SyncState()) {
    on<SyncStarted>(_onSyncStarted);
    on<SyncCheckRequested>(_onSyncCheckRequested);
  }

  Future<void> _onSyncCheckRequested(
    SyncCheckRequested event,
    Emitter<SyncState> emit,
  ) async {
    final pending = await _localDbService.getPendingSyncOperations();
    emit(state.copyWith(
      pendingCount: pending.length,
    ));
  }

  Future<void> _onSyncStarted(
    SyncStarted event,
    Emitter<SyncState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));
    try {
      await _syncService.triggerSync();
      final pending = await _localDbService.getPendingSyncOperations();
      emit(state.copyWith(
        isSyncing: false,
        pendingCount: pending.length,
        lastSyncTime: DateTime.now(),
      ));
    } catch (_) {
      emit(state.copyWith(isSyncing: false));
    }
  }
}
