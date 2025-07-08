import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/presentation/home/user_main_screen.dart';
import 'package:shareindia_health_camp/presentation/login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (userToken.isEmpty&&context.mounted) {
        LoginScreen.start(context);
      } else if (context.mounted) {
        UserMainScreen.start(context);
      }
    });
    return SizedBox();
  }
}
