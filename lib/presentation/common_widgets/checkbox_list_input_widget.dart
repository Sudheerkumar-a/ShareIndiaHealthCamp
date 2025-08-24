import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';

class CheckboxListInputWidget extends StatelessWidget {
  final List<Map<String, dynamic>> inputData;
  final Map<String, dynamic> selectedData;
  final String title;
  final bool isMandetory;
  final Function(Map) onSelected;
  CheckboxListInputWidget({
    required this.title,
    required this.inputData,
    required this.onSelected,
    this.selectedData = const {},
    this.isMandetory = false,
    super.key,
  });

  final _onDataChanged = ValueNotifier(false);
  Map<String, dynamic> data = {};
  final ValueNotifier _isReactive = ValueNotifier(false);

  List<Widget> _getWidgetsByData(BuildContext context, int row) {
    final widgets = List<Widget>.empty(growable: true);
    final dropdownItems =
        [
              {'id': '1', 'name': 'Reactive'},
              {'id': '2', 'name': 'Non Reactive'},
            ]
            .map(
              (item) =>
                  NameIDModel.fromDistrictsJson(
                    item as Map<String, dynamic>,
                  ).toEntity(),
            )
            .toList();
    for (int c = 0; c < 2; c++) {
      final index = c + (row * 2);
      if (index >= inputData.length) {
        widgets.add(Expanded(child: SizedBox()));
      } else {
        final item = inputData[index];
        widgets.add(
          Expanded(
            child:
                (item['type'] == 'collection')
                    ? (FormEntity()
                          ..name = 'result'
                          ..type = 'collection'
                          ..placeholderEn = 'Select Result'
                          ..inputFieldData = {
                            'items': dropdownItems,
                            'doSort': false,
                          }
                          ..fieldValue =
                              dropdownItems
                                  .where((e) => e.name == data['result'])
                                  .firstOrNull
                          ..onDatachnage = (value) {
                            _isReactive.value = value.id == 1;
                            data['result'] = value.name;
                            onSelected.call(data);
                          })
                        .getWidget(context)
                    : (item['type'] == 'confirmcheck')
                    ? ValueListenableBuilder(
                      valueListenable: _isReactive,
                      builder: (context, isReactive, child) {
                        return (FormEntity()
                              ..name = 'referred'
                              ..type = 'confirmcheck'
                              ..isHidden =
                                  data['result'] != dropdownItems[0].name
                              ..horizontalSpace = 20
                              ..fieldValue = data['referred'] == 1
                              ..labelEn = item['label']
                              ..labelTe = item['label']
                              ..onDatachnage = (value) {
                                item['value'] = value.toString();
                                data['referred'] = value ? 1 : 0;
                                onSelected.call(data);
                              })
                            .getWidget(context);
                      },
                    )
                    : CheckboxListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      value: data['done'] == 1,
                      title: Text(
                        item['label'],
                        style: context.textFontWeight400,
                      ),
                      onChanged: (value) {
                        item['value'] = value;
                        data['done'] = (value == true) ? 1 : 0;
                        onSelected.call(data);
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
    data.addAll(selectedData);
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
