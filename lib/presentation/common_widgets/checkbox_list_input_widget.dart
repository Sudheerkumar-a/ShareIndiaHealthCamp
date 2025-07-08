import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';

class CheckboxListInputWidget extends StatelessWidget {
  final List<Map<String, dynamic>> inputData;
  final String title;
  final bool isMandetory;
  final Function(Map) onSelected;
  CheckboxListInputWidget({
    required this.title,
    required this.inputData,
    required this.onSelected,
    this.isMandetory = false,
    super.key,
  });

  final _onDataChanged = ValueNotifier(false);
  List<Map> data = [];

  List<Widget> _getWidgetsByData(BuildContext context, int row) {
    final widgets = List<Widget>.empty(growable: true);
    for (int c = 0; c < 2; c++) {
      final index = c + (row * 2);
      if (index >= inputData.length) {
        widgets.add(Expanded(child: SizedBox()));
      } else {
        final item = data[index];
        widgets.add(
          Expanded(
            child:
                (item['type'] == 'collection')
                    ? (FormEntity()
                          ..name = 'result'
                          ..type = 'collection'
                          ..placeholderEn = 'Select Result'
                          ..inputFieldData = {
                            'items':
                                [
                                      {'id': '1', 'name': 'Positive'},
                                      {'id': '2', 'name': 'Negative'},
                                      {'id': '3', 'name': 'NA'},
                                    ]
                                    .map(
                                      (item) =>
                                          NameIDModel.fromDistrictsJson(
                                            item as Map<String, dynamic>,
                                          ).toEntity(),
                                    )
                                    .toList(),
                            'doSort': false,
                          }
                          ..onDatachnage = (value) {})
                        .getWidget(context)
                    : CheckboxListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      value: item['value'] ?? false,
                      title: Text(
                        item['label'],
                        style: context.textFontWeight400,
                      ),
                      onChanged: (value) {
                        item['value'] = value;
                        _onDataChanged.value = !_onDataChanged.value;
                      },
                      visualDensity: VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                    ),
          ),
        );
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    data = inputData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            style: context.textFontWeight600.onFontSize(
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
        ValueListenableBuilder(
          valueListenable: _onDataChanged,
          builder: (context, value, child) {
            return Column(
              children: [
                for (int r = 0; r < inputData.length / 2; r++)
                  Row(children: _getWidgetsByData(context, r)),
              ],
            );
          },
        ),
      ],
    );
  }
}
