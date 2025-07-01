// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/share_india/patient_form_a.dart';
import 'package:shareindia_health_camp/presentation/share_india/patient_form_b.dart';

class PatientFormScreen extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: PatientFormScreen(),
      ),
    );
  }

  PatientFormScreen({super.key});
  final ValueNotifier _patientForm = ValueNotifier('A');
  PatientFormA? patientFormA;
  PatientFormB? patientFormB;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Urine Tenofovir Test to Assess Adherence and Predict Resistance (UTTAR)',
                style: context.textFontWeight600.onColor(
                  context.resources.color.viewBgColor,
                ),
              ),
            ),
            SizedBox(height: context.resources.dimen.dp20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _patientForm,
                builder: (context, value, child) {
                  patientFormA ??= PatientFormA(
                    callback: (p0) {
                      _patientForm.value = p0;
                    },
                  );
                  patientFormB ??= PatientFormB(
                    callback: (p0) {
                      _patientForm.value = p0;
                    },
                  );
                  return (value == 'A' ? patientFormA : patientFormB) ??
                      const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
