import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/connectivity_service.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class ConnectivitySubscriptionRequested extends ConnectivityEvent {
  const ConnectivitySubscriptionRequested();
}

class _ConnectivityStatusChanged extends ConnectivityEvent {
  final ConnectivityState state;

  const _ConnectivityStatusChanged(this.state);

  @override
  List<Object?> get props => [state];
}

class ConnectivityBlocState extends Equatable {
  final ConnectivityState status;

  const ConnectivityBlocState({this.status = ConnectivityState.online});

  bool get isOnline => status == ConnectivityState.online;
  bool get isOffline => status == ConnectivityState.offline;

  @override
  List<Object?> get props => [status];
}

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityBlocState> {
  final ConnectivityService _connectivityService;
  StreamSubscription<ConnectivityState>? _subscription;

  ConnectivityBloc({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService ?? ConnectivityService.instance,
        super(ConnectivityBlocState(
          status: (connectivityService ?? ConnectivityService.instance).state,
        )) {
    on<ConnectivitySubscriptionRequested>(_onSubscriptionRequested);
    on<_ConnectivityStatusChanged>(_onStatusChanged);
  }

  Future<void> _onSubscriptionRequested(
    ConnectivitySubscriptionRequested event,
    Emitter<ConnectivityBlocState> emit,
  ) async {
    emit(ConnectivityBlocState(status: _connectivityService.state));
    await _subscription?.cancel();
    _subscription = _connectivityService.connectivityStream.listen((state) {
      add(_ConnectivityStatusChanged(state));
    });
  }

  void _onStatusChanged(
    _ConnectivityStatusChanged event,
    Emitter<ConnectivityBlocState> emit,
  ) {
    emit(ConnectivityBlocState(status: event.state));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
