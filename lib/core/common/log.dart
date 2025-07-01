import 'package:flutter/foundation.dart';

void printLog(Object log) {
  if (kDebugMode) {
    print(log);
  }
}

void logFirbaseScreenView({required String screenName}) {}

void logFirbaseEvent({
  required String eventname,
  Map<String, dynamic>? params,
}) {}

void logFirbaseEventClick({
  required String eventname,
  Map<String, dynamic>? params,
}) {}
