import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../services/supabase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseService _supabaseService;

  AuthBloc({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService.instance,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!_supabaseService.isSignedIn) {
      emit(const AuthUnauthenticated());
      return;
    }

    try {
      final user = _supabaseService.currentUser;
      if (user == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      final role = await _supabaseService.fetchCurrentUserRole();
      if (role == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      final profile = await _supabaseService.fetchCurrentUserProfile();
      emit(AuthAuthenticated(user: user, role: role, profile: profile));
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _supabaseService.signIn(
        email: event.email.trim(),
        password: event.password,
      );

      final user = response.user;
      if (user == null) {
        emit(const AuthFailure('Login failed. Please check your credentials.'));
        return;
      }

      final role = await _supabaseService.fetchCurrentUserRole();
      if (role == null) {
        await _supabaseService.signOut();
        emit(const AuthFailure('Unable to determine account role. Please try again.'));
        return;
      }

      final profile = await _supabaseService.fetchCurrentUserProfile();
      emit(AuthAuthenticated(user: user, role: role, profile: profile));
    } on AuthException catch (e) {
      debugPrint('[AuthBloc] AuthException during sign in: ${e.message} (status: ${e.statusCode})');
      final errorText = e.message.toLowerCase();
      final isNetworkError = errorText.contains('socketexception') ||
          errorText.contains('failed host lookup') ||
          errorText.contains('clientexception') ||
          errorText.contains('connection refused') ||
          errorText.contains('network is unreachable');

      if (isNetworkError) {
        emit(const AuthFailure(
          'No internet connection. Please connect to the internet to sign in.',
        ));
      } else {
        emit(AuthFailure(e.message));
      }
    } catch (e, stackTrace) {
      debugPrint('[AuthBloc] Unexpected error during sign in: $e');
      debugPrint('[AuthBloc] StackTrace: $stackTrace');
      final errorText = e.toString().toLowerCase();
      final isNetworkError = errorText.contains('socketexception') ||
          errorText.contains('failed host lookup') ||
          errorText.contains('clientexception') ||
          errorText.contains('connection refused') ||
          errorText.contains('network is unreachable');

      if (isNetworkError) {
        emit(const AuthFailure(
          'No internet connection. Please connect to the internet to sign in.',
        ));
      } else {
        emit(const AuthFailure('Login failed. Please try again.'));
      }
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _supabaseService.signOut();
    } catch (_) {}
    emit(const AuthUnauthenticated());
  }
}
