import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import './bloc/blocs.dart';
import './services/connectivity_service.dart';
import './services/local_database_service.dart';
import './services/supabase_service.dart';
import './services/sync_service.dart';
import './widgets/custom_error_widget.dart';
import 'core/app_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await SupabaseService.initialize();
    debugPrint('[Supabase] Initialized successfully with URL: ${SupabaseService.supabaseUrl}');
  } catch (e) {
    debugPrint('[Supabase] Failed to initialize: $e');
  }

  // Phase 1: Initialize local SQLite database (additive — does not affect existing Supabase flows).
  try {
    await LocalDatabaseService.instance.initialize();
    if (!LocalDatabaseService.instance.isAvailable) {
      debugPrint(
        '[LocalDB] Database unavailable after initialization. '
        'Error: ${LocalDatabaseService.instance.initializationError}',
      );
    }
  } catch (e) {
    debugPrint('[LocalDB] Initialization failed (non-fatal): $e');
  }

  // Phase 1: Initialize connectivity service (additive — no behavior change in Phase 1).
  try {
    await ConnectivityService.instance.initialize();
    debugPrint(
      '[Connectivity] Service ready. State: ${ConnectivityService.instance.state.name}',
    );
  } catch (e) {
    debugPrint('[Connectivity] Initialization failed (non-fatal): $e');
  }

  // Phase 2: Initialize sync service — drains queue when connectivity returns.
  try {
    SyncService.instance.initialize();
    debugPrint('[SyncService] Initialized.');
  } catch (e) {
    debugPrint('[SyncService] Initialization failed (non-fatal): $e');
  }

  bool hasShownError = false;

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!hasShownError) {
      hasShownError = true;

      // Reset flag after 3 seconds to allow error widget on new screens
      Future.delayed(Duration(seconds: 5), () {
        hasShownError = false;
      });

      return CustomErrorWidget(errorDetails: details);
    }
    return SizedBox.shrink();
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Bloc.observer = const AppBlocObserver();

  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(const AuthCheckRequested()),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (context) => ConnectivityBloc()..add(const ConnectivitySubscriptionRequested()),
        ),
        BlocProvider<SyncBloc>(
          create: (context) => SyncBloc(),
        ),
        BlocProvider<HouseholdsBloc>(
          create: (context) => HouseholdsBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          title: 'AdityaPrabhaGram',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        );
      },
    );
  }
}
