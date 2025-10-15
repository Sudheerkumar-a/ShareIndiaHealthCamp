// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/home/user_dashboard.dart';

class UserHomeNavigatorScreen extends BaseScreenWidget {
  UserHomeNavigatorScreen({super.key});
  static late GlobalKey<NavigatorState> homeKey;
  late UserDashboard userDashboard;
  @override
  Widget build(BuildContext context) {
    homeKey = GlobalKey<NavigatorState>();
    userDashboard = UserDashboard();
    return Navigator(
      key: homeKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext _) => userDashboard,
          settings: settings,
        );
      },
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  @override
  doDispose() {}
}
