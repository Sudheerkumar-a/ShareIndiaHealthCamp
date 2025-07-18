import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shareindia_health_camp/app.dart';
import 'package:shareindia_health_camp/core/config/base_url_config.dart';
import 'package:shareindia_health_camp/core/config/flavor_config.dart';
import 'package:shareindia_health_camp/data/local/app_settings_db.dart';
import 'package:shareindia_health_camp/injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(AppSettingsDB.name);
  FlavorConfig(
    flavor: Flavor.DEVELOPMENT,
    values: FlavorValues(
      portalBaseUrl: baseUrlDevelopment,
      mdSOABaseUrl: baseUrlSOAProd,
    ),
  );
  await di.init();
  runApp(Phoenix(child: const App()));
}
