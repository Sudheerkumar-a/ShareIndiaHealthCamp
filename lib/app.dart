import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/config/app_routes.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/enum/enum.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shareindia_health_camp/data/local/user_data_db.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final Locale locale = Locale(context.resources.getLocal());
    isSelectedLocalEn = (locale.languageCode == LocalEnum.en.name);
    var theme = context.resources.theme;
    theme.fontFamily(
      locale.languageCode == LocalEnum.te.name ? locale.languageCode : fontFamilyEN,
    );
    userToken = context.userDataDB.get(UserDataDB.userToken, defaultValue: '');
    return MaterialApp(
      locale: locale,
      debugShowCheckedModeBanner: false,
      title: 'shareindia',
      theme: theme.theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle:
          (BuildContext context) => context.resources.string.appTitle,
      initialRoute:
          AppRoutes.initialRoute,
      routes: AppRoutes.getRoutes(),
    );
  }
}
