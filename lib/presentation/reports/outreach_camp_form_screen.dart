import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';

class OutreachCampFormScreen extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: OutreachCampFormScreen(),
      ),
    );
  }

  const OutreachCampFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Padding(padding: EdgeInsets.all(resources.dimen.dp20));
  }
}
