import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/enum/enum.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/data/local/app_settings_db.dart';
import 'package:shareindia_health_camp/l10n/app_localizations.dart';
import 'package:shareindia_health_camp/res/colors/base_clors.dart';
import 'package:shareindia_health_camp/res/colors/theme_peach_colors.dart';
import 'package:shareindia_health_camp/res/colors/theme_red_colors.dart';
import 'package:shareindia_health_camp/res/dimentions/font_dimension.dart';
import 'package:shareindia_health_camp/res/dimentions/font_dimension_big.dart';
import 'package:shareindia_health_camp/res/dimentions/font_dimension_small.dart';
import 'package:shareindia_health_camp/res/theme/app_theme.dart';
import 'package:shareindia_health_camp/res/theme/theme_peach.dart';
import 'package:shareindia_health_camp/res/theme/theme_red.dart';
import 'dimentions/app_dimension.dart';
import 'dimentions/font_dimension_default.dart';

class Resources {
  final BuildContext context;
  static String selectedLocalValue = LocalEnum.en.name;
  Resources(this.context);

  BaseColors get color {
    //final theme = context.appSettingsDB.get(AppSettingsDB.appThemeKey);
    return ThemePeachColors();
  }

  ApplicationTheme get theme {
    //final theme = context.appSettingsDB.get(AppSettingsDB.appThemeKey);
    return ThemePeach.instance;
  }

  AppDimension get dimen {
    return AppDimension();
  }

  void setTheme(ThemeEnum theme) {
    (theme == ThemeEnum.peach)
        ? context.appSettingsDB.put(
          AppSettingsDB.appThemeKey,
          ThemeEnum.peach.name,
        )
        : (theme == ThemeEnum.blue)
        ? context.appSettingsDB.put(
          AppSettingsDB.appThemeKey,
          ThemeEnum.blue.name,
        )
        : context.appSettingsDB.put(
          AppSettingsDB.appThemeKey,
          ThemeEnum.red.name,
        );
    Phoenix.rebirth(context);
  }

  bool get isLocalEn => selectedLocalValue == LocalEnum.en.name;

  String get currentLocalCode => selectedLocalValue;

  void setLocal({String? language}) {
    if (language != null) {
      context.appSettingsDB.put(AppSettingsDB.appLocalKey, language);
    } else {
      final local = context.appSettingsDB.get(
        AppSettingsDB.appLocalKey,
        defaultValue: LocalEnum.en.name,
      );
      (local == LocalEnum.te.name)
          ? context.appSettingsDB.put(
            AppSettingsDB.appLocalKey,
            LocalEnum.en.name,
          )
          : context.appSettingsDB.put(
            AppSettingsDB.appLocalKey,
            LocalEnum.te.name,
          );
    }
    Phoenix.rebirth(context);
  }

  String getLocal() {
    final local = context.appSettingsDB.get(
      AppSettingsDB.appLocalKey,
      defaultValue: LocalEnum.en.name,
    );
    selectedLocalValue = local;
    return local;
  }

  ThemeEnum getTheme() {
    // final theme = context.appSettingsDB
    //     .get(AppSettingsDB.appThemeKey, defaultValue: ThemeEnum.peach.name);
    // return ThemeEnum.values.byName(theme);
    return ThemeEnum.red;
  }

  Color get iconBgColor => color.iconTintColor;

  LinearGradient get appBgGradient => LinearGradient(
    colors: [iconBgColor, color.colorWhite],
    begin: const FractionalOffset(0.5, 0.0),
    end: const FractionalOffset(0.0, 0.5),
    stops: const [0.0, 1.0],
    tileMode: TileMode.clamp,
  );

  FontSizeEnum? currentFontSize;

  FontSizeEnum getUserSelcetedFontSize() {
    if (currentFontSize == null) {
      final fontSize = context.appSettingsDB.get(
        AppSettingsDB.appFontSizeKey,
        defaultValue: 2,
      );
      currentFontSize = FontSizeEnum.fromSize(fontSize);
    }
    return currentFontSize ?? FontSizeEnum.defaultSize;
  }

  void setFontSize(FontSizeEnum size) {
    context.appSettingsDB.put(AppSettingsDB.appFontSizeKey, size.size);
    Phoenix.rebirth(context);
  }

  FontDimensions get fontSize {
    switch (getUserSelcetedFontSize()) {
      case FontSizeEnum.bigSize:
        return FontDimensionsBig();
      case FontSizeEnum.smallSize:
        return FontDimensionsSmall();
      default:
        return FontDimensionsDefault();
    }
  }

  AppLocalizations? appLocalizations;

  AppLocalizations get string {
    appLocalizations ??= AppLocalizations.of(context)!;
    return appLocalizations!;
  }

  String get currentFontName => isSelectedLocalEn ? fontFamilyEN : fontFamilyAR;

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
