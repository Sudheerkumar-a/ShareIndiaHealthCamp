import 'package:flutter/widgets.dart';
import 'package:shareindia_health_camp/presentation/home/user_main_screen.dart';
import 'package:shareindia_health_camp/presentation/login/login_screen.dart';
import 'package:shareindia_health_camp/presentation/profile/profile_screen.dart';
import 'package:shareindia_health_camp/presentation/splash_screen.dart';

class AppRoutes {
  static String initialRoute = '/';
  static String startRoute = '/start';
  static String loginRoute = '/login';
  static String guestMainRoute = '/guestMain';
  static String userMainRoute = '/dashboard';
  static String homeRoute = '/home';
  static String tourRoute = '/tour';
  static String profileRoute = '/profile';
  static String ticketRoute = '/ticket/:id';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.initialRoute: (context) => const SplashScreen(),
      AppRoutes.userMainRoute: (context) => const UserMainScreen(),
      AppRoutes.loginRoute: (context) => LoginScreen(),
      AppRoutes.profileRoute: (context) => ProfileScreen(),
    };
  }
}
