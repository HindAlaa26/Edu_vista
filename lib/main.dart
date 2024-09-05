import 'package:device_preview/device_preview.dart';
import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/firebase_options.dart';
import 'package:edu_vista/screens/splash_screen.dart';
import 'package:edu_vista/services/pref_service.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/cart_bloc/cart_bloc.dart';
import 'bloc/cart_bloc/cart_event.dart';
import 'bloc/course_bloc/course_bloc.dart';
import 'bloc/lecture_bloc/lecture_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  await dotenv.load(fileName: ".env");
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => AuthCubit()),
          BlocProvider(create: (ctx) => LectureBloc()),
          BlocProvider(create: (ctx) => CourseBloc()),
          BlocProvider(create: (ctx) => CartBloc()..add(LoadCart())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        builder: (context, child) {
          return MaterialApp(
            title: 'Edu Vista',
            scrollBehavior: CustomScrollBehaviour(),
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: "PlusJakartaSans",
              colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
              appBarTheme:
                  const AppBarTheme(color: ColorUtility.scaffoldBackground),
              scaffoldBackgroundColor: ColorUtility.scaffoldBackground,
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          );
        });
  }
}

class CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
