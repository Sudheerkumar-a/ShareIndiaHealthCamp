import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shareindia_health_camp/core/common/log.dart';
import 'package:shareindia_health_camp/core/config/flavor_config.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/enum/enum.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/data/local/user_data_db.dart';
import 'package:shareindia_health_camp/domain/entities/master_data_entities.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/update_dialog_widget.dart';
import 'package:mime/mime.dart';
import 'package:app_version_update/app_version_update.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:url_launcher/url_launcher.dart';

sendEmail(BuildContext context, String email) async {
  final result = await launchUrl(
    Uri.parse("mailto:${Uri.encodeComponent(email)}"),
  );
  if (result == false && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Center(child: Text('could_not_launch_this_app'))),
    );
  }
}

launchAppUrl() {
  if (Platform.isAndroid || Platform.isIOS) {
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=com.ihs.apsacs"
          : "https://apps.apple.com/app/id1063110068",
    );
    launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

launchWebUrl(String url) {
  if (Platform.isAndroid || Platform.isIOS) {
    final uri = Uri.parse(url);
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

String getAppUrl() {
  return Platform.isAndroid
      ? 'https://play.google.com/store/apps/details?id=uaq.gov.shareindia'
      : 'https://apps.apple.com/ae/app/shareindia/id1063110068';
}

double distance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371;
  final dLat = deg2rad(lat2 - lat1);
  final dLon = deg2rad(lon2 - lon1);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final d = R * c;
  return d;
}

double deg2rad(deg) {
  return deg * (pi / 180);
}

String getCurrentDateByformat(String format) {
  return DateFormat(format).format(DateTime.now());
}

String getDateByformat(String format, DateTime dateTime) {
  try {
    return dateTime.year == 0 ? '' : DateFormat(format).format(dateTime);
  } catch (error) {
    return '';
  }
}

DateTime getDateTimeByString(String format, String date) {
  try {
    return DateFormat(format).parse(date);
  } catch (error) {
    return DateTime(0);
  }
}

startTimer({required Duration duration, required Function callback}) {
  Timer.periodic(duration, (Timer t) => callback());
}

int daysBetween(DateTime from, DateTime to) {
  return (to.difference(from).inSeconds);
}

int getDays(DateTime from, DateTime to) {
  return getHours(from, to) ~/ 24;
}

int getHours(DateTime from, DateTime to) {
  return daysBetween(from, to) ~/ (60 * 60);
}

int getMinutes(DateTime from, DateTime to) {
  return daysBetween(from, to) ~/ (60);
}

String getHoursMinutesFormat(DateTime from, DateTime to) {
  var minutes = getMinutes(from, to);
  return '${minutes ~/ 60}.${minutes % 60} hrs';
}

String getRemainingHoursMinutesFormat(DateTime from, DateTime to) {
  var minutes = 480 - getMinutes(from, to);
  if (minutes < 1) {
    return '0';
  }
  return '${(minutes ~/ 60)}.${minutes % 60} hrs';
}

logout(BuildContext context) {
  Iterable keys = [
    UserDataDB.loginDisplayName + UserDataDB.enLocalSufix,
    UserDataDB.loginDisplayName + UserDataDB.arLocalSufix,
    UserDataDB.userEmail,
    UserDataDB.userType,
    UserDataDB.userToken,
  ];
  context.userDataDB.deleteAll(keys);
  userToken = '';
  Phoenix.rebirth(context);
}

bool isImage(String path) {
  final mimeType = lookupMimeType(path);

  return mimeType?.startsWith('image/') ?? false;
}

bool isPdf(String path) {
  final mimeType = lookupMimeType(path);

  return mimeType?.startsWith('application/pdf') ?? false;
}

double getTopSafeAreaHeight(BuildContext context) {
  printLog('${MediaQuery.of(context).padding.top}');
  return MediaQuery.of(context).padding.top;
}

double getBottomSafeAreaHeight(BuildContext context) {
  printLog('${MediaQuery.of(context).padding.bottom}');
  return MediaQuery.of(context).padding.bottom;
}

Size getScrrenSize(BuildContext context) {
  printLog('${MediaQuery.of(context).size}');
  return MediaQuery.of(context).size;
}

bool isDesktop(BuildContext context, {Size? size}) {
  size ??= screenSize;
  return size.width > 600;
}

Map<String, dynamic> getFCMMessageData({
  required String to,
  required String title,
  required String body,
  String type = '',
  String imageUrl = '',
  String audioUrl = '',
  String notificationId = '',
}) {
  return {
    "to": '/topics/$to',
    "notification": {
      "id": notificationId,
      "title": title,
      "body": body,
      "image_url": imageUrl,
      "audio_url": audioUrl,
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "sound": "default",
    },
    "data": {
      "id": notificationId,
      "title": title,
      "body": body,
      "image_url": imageUrl,
      "audio_url": audioUrl,
      "type": type,
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      "notification_id": notificationId,
    },
    "priority": "high",
  };
}

String getLeavesApproverFCMBodyText(
  String prefix,
  String leaveName,
  String fromDate,
  String toDate,
) {
  return '$prefix has applied for $leaveName Request from $fromDate to $toDate';
}

// String getWeatherIcon(int weatherCode) {
//   switch (weatherCode) {
//     case 2 || 3:
//       return DrawableAssets.icCloudy; //Cloudy
//     //case 45&&48: return DrawableAssets.bgWeather;//Foggy
//     case 61 || 63 || 65 || 66 || 67:
//       return DrawableAssets.icRain; //Rain
//     case 95 || 96 || 99:
//       return DrawableAssets.icStorm; //Thunderstorm
//     default:
//       return DrawableAssets.icSun;
//   }
// }

bool isStringArabic(String text) {
  final RegExp arabic = RegExp(r'[\u0621-\u064A]+');
  if (arabic.hasMatch(text.trim())) return true;
  return false;
}

String getFontNameByString(String text) {
  return isStringArabic(text) ? fontFamilyAR : fontFamilyEN;
}

Future<String> doUaePassLogin() async {
  // final uaePassPlugin = UaePass();
  // // await uaePassPlugin.setUpSandbox();
  // await uaePassPlugin.setUpEnvironment(uaePassMobClientId,
  //     uaePassMobClientSecret, uaePassAppUrlScheme, uaePassState,
  //     isProduction: true, redirectUri: uaePassRedirectUri);
  return "";
}

String getGoogleStaticMapUrl(double lat, double long) {
  return 'https://maps.googleapis.com/maps/api/staticmap?zoom=15&size=600x400&maptype=roadmap&markers=color:red|label:S|$lat,$long&key=AIzaSyB_aALVvfyHAL9WGro-3EJ6L3JZ86bWgIQ';
}

String getUploadFileRequestString(Map<String, dynamic> fileData) {
  String name = getCurrentDateByformat("yyMMddHHmmss") + fileData['fileType'];
  String data =
      "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:upl='http://xmlns.oracle.com/UAQBusinessProcess/UAQ_DocumentUpload_Download_Ser/Upload_DownloadBpel'>\n<soapenv:Header>\n<wsse:Security xmlns:wsse='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'>\n<wsse:UsernameToken xmlns:wsu='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'>\n<wsse:Username>uaqdev</wsse:Username>\n<wsse:Password Type='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText'>welcome1</wsse:Password>\n</wsse:UsernameToken>\n</wsse:Security>\n</soapenv:Header>\n<soapenv:Body>\n<upl:UploadInput>\n<upl:DocName>$name</upl:DocName>\n<upl:DocTitle>${fileData['fileName']}</upl:DocTitle>\n<upl:DocType>Document</upl:DocType>\n<upl:DocSecurityGroup>Public</upl:DocSecurityGroup>\n<upl:AuthorName>uaqdev</upl:AuthorName>\n<upl:FileList>\n<upl:FileRecord>\n<upl:Filename>$name</upl:Filename>\n<upl:FileContent>${fileData['fileNamebase64data']}</upl:FileContent>\n</upl:FileRecord>\n</upl:FileList>\n</upl:UploadInput>\n</soapenv:Body>\n</soapenv:Envelope>";
  return data;
}

TransformationController getZoomViewTransformationController() {
  final viewTransformationController = TransformationController();
  viewTransformationController.value.setEntry(0, 0, 2);
  viewTransformationController.value.setEntry(1, 1, 2);
  viewTransformationController.value.setEntry(2, 2, 2);
  viewTransformationController.value.setEntry(0, 3, -160);
  viewTransformationController.value.setEntry(1, 3, -80);
  return viewTransformationController;
}

String get getImageBaseUrl =>
    '${FlavorConfig.instance.values.portalBaseUrl}Attachments/';

List<StatusType> getStatusTypes() {
  return [
    StatusType.notAssigned,
    StatusType.open,
    StatusType.hold,
    StatusType.reject,
    StatusType.closed,
    StatusType.returned,
    StatusType.acquired,
  ];
}

List<PriorityType> getPriorityTypes() {
  return [
    PriorityType.low,
    PriorityType.medium,
    PriorityType.high,
    PriorityType.critical,
  ];
}

Future<bool> exportToExcel(ExportDataEntity exportData, {int? category}) async {
  try {
    final workbook = excel.Workbook();
    final sheet = workbook.worksheets[0];

    // ✅ This is correct — merge range A1:C1
    final mergedRange = sheet.getRangeByName('B2:D2');
    mergedRange.merge();

    // Set title with style
    final titleCell = sheet.getRangeByName('B2');
    titleCell.setText(exportData.title);
    titleCell.cellStyle
      ..bold = true
      ..fontSize = 18
      ..hAlign = excel.HAlignType.left
      ..fontColor = '#007ACC';

    final mergedRange2 = sheet.getRangeByName('E2:G2');
    mergedRange2.merge();
    final titleCell2 = sheet.getRangeByName('E2');
    titleCell2.setText('Date:${exportData.date}');
    titleCell2.cellStyle
      ..bold = true
      ..fontSize = 14
      ..hAlign = excel.HAlignType.left
      ..fontColor = '#007ACC';
    final columns = exportData.columns;
    for (int col = 0; col < columns.length; col++) {
      double estimatedWidth = (columns.length * 0.8).clamp(15, 50);
      final range = sheet.getRangeByIndex(4, col + 2);
      range.setText(columns[col]);
      range.columnWidth = estimatedWidth;
      final style = range.cellStyle;
      style.fontSize = 12;
      style.bold = true;
      style.fontColor = "#D32030";
      style.hAlign = excel.HAlignType.left;
      style.vAlign = excel.VAlignType.top;
      range.cellStyle = style;
    }

    for (int row = 0; row < exportData.rows.length; row++) {
      final item = exportData.rows[row];
      final columnsData =
          category != null ? item.toFilterJson(category) : item.toExcel();
      int col = 0;
      for (var item in (columnsData as Map<String, dynamic>).entries) {
        final value = '${item.value ?? ''}';
        printLog((value.length * 0.8).clamp(15, 50));
        int estimatedWidth = (value.length * 0.8).clamp(15, 50).toInt();
        final range = sheet.getRangeByIndex(row + 5, col + 2);
        range.setText(value);
        range.columnWidth = estimatedWidth.toDouble();
        final style = range.cellStyle;
        style.fontSize = 12;
        style.hAlign = excel.HAlignType.left;
        style.vAlign = excel.VAlignType.top;
        style.wrapText = true;
        range.cellStyle = style;
        col++;
      }
    }

    // Save to file
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Get temporary directory
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/ihs_outcome_report_${exportData.date}.xlsx';

    // Save the file
    final File file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    // Share the file
    final params = ShareParams(
      text: 'Check out this Excel file!',
      files: [XFile(path)],
    );
    await SharePlus.instance.share(params);
  } catch (e) {
    return false;
  }
  return true;
}

checkIsUpdateAvailabe(BuildContext context) async {
  try {
    AppVersionResult result = await AppVersionUpdate.checkForUpdates(
      playStoreId: "com.ihs.apsacs",
    );

    if (result.storeVersion != null &&
        result.canUpdate == true &&
        context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const UpdateDialogWidget();
        },
      );
    } else {
      printLog("App is up to date");
    }
  } catch (e) {
    printLog("Error checking update: $e");
  }
}
