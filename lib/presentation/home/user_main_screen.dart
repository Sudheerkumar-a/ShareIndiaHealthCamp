// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/data/local/app_settings_db.dart';
import 'package:shareindia_health_camp/domain/entities/user_credentials_entity.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/side_bar.dart';
import 'package:shareindia_health_camp/presentation/home/user_home_navigator_screen.dart';
import 'package:shareindia_health_camp/presentation/profile/profile_navigator_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/reports_navigator_screen.dart';
import 'package:shareindia_health_camp/presentation/utils/NavbarNotifier.dart';
import 'package:shareindia_health_camp/res/resources.dart';

class UserMainScreen extends StatefulWidget {
  static start(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: UserMainScreen(),
      ),
      (_) => false,
    );
  }

  static ValueNotifier onUnAuthorizedResponse = ValueNotifier<bool>(false);
  static ValueNotifier onNetworkConnectionError = ValueNotifier<int>(1);
  const UserMainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<UserMainScreen> {
  final NavbarNotifier _navbarNotifier = NavbarNotifier();
  int backpressCount = 0;
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  BaseScreenWidget? currentScreen;
  int activeTab = 0;
  double sideBarWidth = 200;
  late SideBar sideBar;
  final titles = [
    'Integrated Health Services (IHS) - APSACS',
    'Integrated Health Services (IHS) - APSACS',
    'Profile',
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex.value == index) {
      _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
    }
    _selectedIndex.value = index;
    context.appSettingsDB.put(AppSettingsDB.selectedSideBarIndex, index);
  }

  Widget getScreen(int index) {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    if (UserCredentialsEntity.details(context).user?.isAdmin == 2) {
      switch (index) {
        case 0:
          currentScreen = ReportsNavigatorScreen();
        case 1:
          currentScreen = ReportsNavigatorScreen();
        case 2:
          currentScreen = ProfileNavigatorScreen();
        default:
          currentScreen = ReportsNavigatorScreen();
      }
    } else {
      switch (index) {
        case 0:
          currentScreen = UserHomeNavigatorScreen();
        case 1:
          currentScreen = ReportsNavigatorScreen();
        case 2:
          currentScreen = ProfileNavigatorScreen();
        default:
          currentScreen = UserHomeNavigatorScreen();
      }
    }
    return currentScreen ?? UserHomeNavigatorScreen();
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex.value = 0;
    sideBar = SideBar(
      onItemSelected: (p0) {
        _onItemTapped(p0);
        selectedSideBarIndex = p0;
      },
      seletedItem: _selectedIndex.value,
    );
    UserMainScreen.onUnAuthorizedResponse.addListener(() {
      if (UserMainScreen.onUnAuthorizedResponse.value && context.mounted) {
        UserMainScreen.onUnAuthorizedResponse.value = false;
        logout(context);
      }
    });
  }

  @override
  void dispose() {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: resources.color.appScaffoldBg,
          resizeToAvoidBottomInset: false,
          drawer: SizedBox(
            width: 200,
            child: SideBar(
              onItemSelected: (p0) {
                _onItemTapped(p0);
                selectedSideBarIndex = p0;
              },
              seletedItem: selectedSideBarIndex,
            ),
          ),
          body: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (context, index, child) {
              return Column(
                children: [
                  MSearchUserAppBarWidget(title: titles[index]),
                  Expanded(child: getScreen(index)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
