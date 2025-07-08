import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/radio_items_widget.dart';

class YesNoconfirmWidget extends StatelessWidget {
  final List<String> answers;
  final String question;
  final bool isMandetory;
  final bool? selectedValue;
  final Function(bool) onSelected;
  const YesNoconfirmWidget({
    required this.question,
    this.answers = const ['Yes', 'No'],
    required this.onSelected,
    this.isMandetory = false,
    this.selectedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: question,
            style: context.textFontWeight400.onFontSize(
              context.resources.fontSize.dp14,
            ),
            children: [
              if (isMandetory)
                TextSpan(
                  text: ' *',
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp14)
                      .onColor(Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
        RadioItemsWidget(
          items: answers,
          selectedItem:
              selectedValue != null
                  ? (selectedValue == true)
                      ? answers[0]
                      : answers[1]
                  : null,
          onItemSelected: (value) {
            if (value == 'Yes') {
              onSelected(true);
            } else {
              onSelected(false);
            }
          },
        ),
      ],
    );
  }
}
