import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';

class NcdScreeningWidget extends StatelessWidget {
  final List<Map<String, dynamic>> inputData;
  final String title;
  final bool isMandetory;
  final Function(Map) onSelected;
  NcdScreeningWidget({
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
                                      {'id': '1', 'name': 'Reactive'},
                                      {'id': '2', 'name': 'Non-Reactive'},
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
    final items = List<FormEntity>.empty(growable: true);
    items.addAll([
      FormEntity()
        ..name = 'screened'
        ..type = 'confirmcheck'
        ..verticalSpace = 5
        ..labelEn = 'Screened'
        ..labelTe = 'Screened'
        ..onDatachnage = (value) {
          final child =
              items.where((item) => item.name == 'result').firstOrNull;
          if (child != null) {
            child.isHidden = !value;
            child.fieldValue = null;
          }
          _onDataChanged.value = !_onDataChanged.value;
        },
      FormEntity()
        ..name = 'result'
        ..type = 'collection'
        ..verticalSpace = 5
        ..isHidden = true
        ..validation = (FormValidationEntity()..required = true)
        ..placeholderEn = 'Select Result'
        ..inputFieldData = {
          'items':
              [
                    {'id': '1', 'name': 'Normal'},
                    {'id': '2', 'name': 'Abnormal'},
                    {'id': '3', 'name': 'Known'},
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
        ..onDatachnage = (value) {
          final child =
              items.where((item) => item.name == 'referred').firstOrNull;
          if (child != null) {
            if (value.id == 2) {
              child.isHidden = false;
              child.fieldValue = null;
            } else {
              child.isHidden = true;
              child.fieldValue = null;
            }
          }
          _onDataChanged.value = !_onDataChanged.value;
        },
      FormEntity()
        ..name = 'referred'
        ..type = 'confirmcheck'
        ..verticalSpace = 5
        ..isHidden = true
        ..labelEn = 'Referred'
        ..labelTe = 'Referred'
        ..onDatachnage = (value) {},
    ]);
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  items[0].getWidget(context),
                  SizedBox(width: 200, child: items[1].getWidget(context)),
                  items[2].getWidget(context),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
