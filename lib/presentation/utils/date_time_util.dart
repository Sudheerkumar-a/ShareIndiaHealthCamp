import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';

import 'dialogs.dart';

Future<dynamic> selectDate(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String dateFormat = '',
  Function(DateTime)? callBack,
}) async {
  final currentDate = DateTime.now();
  DateTime selectedDate = initialDate ?? firstDate ?? currentDate;
  if (!kIsWeb && Platform.isIOS) {
    Dialogs()
        .showiOSDatePickerDialog(
          context,
          CupertinoDatePicker(
            initialDateTime: initialDate ?? currentDate,
            minimumDate:
                firstDate ?? DateTime(currentDate.year - 1, currentDate.month),
            maximumDate: lastDate ?? DateTime(2024),
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            // This is called when the user changes the time.
            onDateTimeChanged: (DateTime newTime) {
              selectedDate = newTime;
            },
          ),
        )
        .then((value) {
          callBack?.call(selectedDate);
        });
  } else {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? currentDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary:
                    context.resources.color.viewBgColor, // header text color
                onSurface:
                    context.resources.color.viewBgColor, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:
                      context.resources.color.viewBgColor, // button text color
                ),
              ),
            ),
            child: child!,
          ),
    ).then((value){
      if(value!=null) {
        callBack?.call(value);
      }
    });
  }
}

Future<void> selectTime(
  BuildContext context, {
  DateTime? startTime,
  required Function(DateTime) callBack,
}) async {
  DateTime selectedTime = startTime ?? DateTime.now();

  if (Platform.isAndroid) {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime ?? DateTime.now()),
      initialEntryMode: TimePickerEntryMode.dial,
      builder:
          (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: context.resources.color.viewBgColor,
                  onSurface:
                      context.resources.color.viewBgColor, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        context
                            .resources
                            .color
                            .viewBgColor, // button text color
                  ),
                ),
              ),
              child: child!,
            ),
          ),
    );
    if (picked != null) {
      callBack(
        DateTime(
          selectedTime.year,
          selectedTime.month,
          selectedTime.day,
          picked.hour,
          picked.minute,
        ),
      );
    }
  } else {
    Dialogs()
        .showiOSDatePickerDialog(
          context,
          CupertinoDatePicker(
            initialDateTime: startTime ?? DateTime.now(),
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            // This is called when the user changes the time.
            onDateTimeChanged: (DateTime newTime) {
              selectedTime = newTime;
            },
          ),
        )
        .then((value) {
          callBack(selectedTime);
        });
  }
}
