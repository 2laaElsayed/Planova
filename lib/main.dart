import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_router.dart';
import 'package:planova_app/core/di/service_locator.dart';
import 'package:planova_app/core/utils/app_bloc_observer.dart';
import 'package:planova_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = AppBlocObserver();

  await initializeDependencies();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: DevicePreview(enabled: true, builder: (context) => const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // Device Preview
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      routerConfig: AppRouter.router(authProvider),

      // Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.kPrimary,
          primary: AppColors.kPrimary,
        ),
        scaffoldBackgroundColor: AppColors.kBackGround,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.kBackGround,
          elevation: 0,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}
