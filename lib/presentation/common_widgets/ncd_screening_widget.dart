import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';

class NcdScreeningWidget extends StatefulWidget {
  final List<Map<String, dynamic>> inputData;
  final Map<dynamic, dynamic>? selctedData;
  final String title;
  final bool isMandetory;
  final Function(Map) onSelected;
  NcdScreeningWidget({
    required this.title,
    required this.inputData,
    required this.onSelected,
    this.selctedData,
    this.isMandetory = false,
    super.key,
  });

  @override
  State<NcdScreeningWidget> createState() => _NcdScreeningWidgetState();
}

class _NcdScreeningWidgetState extends State<NcdScreeningWidget> {
  Map data = {};

  List<Widget> _getWidgetsByData(BuildContext context, int row) {
    final widgets = List<Widget>.empty(growable: true);
    for (int c = 0; c < 2; c++) {
      final index = c + (row * 2);
      if (index >= widget.inputData.length) {
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
                                      {'id': '2', 'name': 'Non Reactive'},
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
                        item['value'] = value == true ? 1 : 0;
                        setState(() {});
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

  final items = List<FormEntity>.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    data.addAll(
      widget.selctedData ?? {'screened': 0, 'values': {}, 'referred': 0},
    );
    if (items.isEmpty) {
      items.addAll([
        FormEntity()
          ..name = 'screened'
          ..type = 'confirmcheck'
          ..verticalSpace = 5
          ..labelEn = 'Screened'
          ..labelTe = 'Screened'
          ..fieldValue = data["screened"] != null ? data["screened"] == 1 : null
          ..onDatachnage = (value) {
            final childrens = items.sublist(1, items.length - 1);
            for (var child in childrens) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            data["screened"] = value ? 1 : 0;
            widget.onSelected.call(data);
            setState(() {});
          },
        FormEntity()
          ..name = 'referred'
          ..type = 'confirmcheck'
          ..verticalSpace = 5
          ..isHidden = data["referred"] == null
          ..labelEn = 'Referred'
          ..labelTe = 'Referred'
          ..fieldValue = data["referred"] != null ? data["referred"] == 1 : null
          ..onDatachnage = (value) {
            data["referred"] = value == true ? 1 : 0;
            widget.onSelected.call(data);
          },
      ]);
      if (widget.title == 'Hypertension') {
        items.insert(
          1,
          FormEntity()
            ..name = 'systolic'
            ..type = 'number'
            ..verticalSpace = 5
            ..isHidden = data["screened"] != 1
            ..placeholder = 'systolic'
            ..validation =
                (FormValidationEntity()
                  ..isRequired = true
                  ..maxLength = 3
                  ..regex = numberRegExp)
            ..messages =
                (FormMessageEntity()
                  ..requiredText = 'Please Enter systolic value'
                  ..regex = 'Please Enter valid systolic value')
            ..fieldValue = data["systolic"]
            ..onDatachnage = (value) {
              final child =
                  items.where((item) => item.name == 'referred').firstOrNull;
              final isHiiden = child?.isHidden;
              child?.isHidden =
                  ((int.tryParse(value) ?? 0) <= 140 &&
                      (int.tryParse(data["diastolic"] ?? '0') ?? 0) <= 90);
              child?.fieldValue = null;
              data["systolic"] = value;
              widget.onSelected.call(data);
              if (isHiiden != child?.isHidden) {
                setState(() {});
              }
            },
        );
        items.insert(
          2,
          FormEntity()
            ..name = 'diastolic'
            ..type = 'number'
            ..verticalSpace = 5
            ..isHidden = data["screened"] != 1
            ..placeholder = 'diastolic'
            ..validation =
                (FormValidationEntity()
                  ..isRequired = true
                  ..maxLength = 3
                  ..regex = numberRegExp)
            ..messages =
                (FormMessageEntity()
                  ..requiredText = 'Please Enter diastolic value'
                  ..regex = 'Please Enter valid diastolic value')
            ..fieldValue = data["diastolic"]
            ..onDatachnage = (value) {
              final child =
                  items.where((item) => item.name == 'referred').firstOrNull;
              final isHiiden = child?.isHidden;
              child?.isHidden =
                  ((int.tryParse(value) ?? 0) <= 100 &&
                      (int.tryParse(data["systolic"] ?? '0') ?? 0) <= 160);
              child?.fieldValue = null;
              data["diastolic"] = value;
              widget.onSelected.call(data);
              if (isHiiden != child?.isHidden) {
                setState(() {});
              }
            },
        );
      } else if (widget.title == 'Diabetes') {
        items.insert(
          1,
          FormEntity()
            ..name = 'bloodsugar:'
            ..type = 'number'
            ..verticalSpace = 5
            ..isHidden = data["screened"] != 1
            ..placeholder = 'Random Blood sugar'
            ..validation =
                (FormValidationEntity()
                  ..isRequired = true
                  ..maxLength = 3
                  ..regex = numberRegExp)
            ..messages =
                (FormMessageEntity()
                  ..requiredText = 'Please Enter Blood sugar value'
                  ..regex = 'Please Enter valid Blood sugar: value')
            ..fieldValue = data["bloodsugar"]
            ..onDatachnage = (value) {
              final child =
                  items.where((item) => item.name == 'referred').firstOrNull;
              final isHiiden = child?.isHidden;
              child?.isHidden = (int.tryParse(value) ?? 0) <= 200;
              child?.fieldValue = null;
              data["bloodsugar"] = value;
              widget.onSelected.call(data);
              if (isHiiden != child?.isHidden) {
                setState(() {});
              }
            },
        );
      } else {
        items.insert(
          1,
          FormEntity()
            ..name = 'result'
            ..type = 'collection'
            ..verticalSpace = 5
            ..isHidden = true
            ..validation = (FormValidationEntity()..isRequired = true)
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
              child?.isHidden = value.id != 2;
              child?.fieldValue = null;
              data["abnormal"] = value.id == 2 ? 1 : 0;
              widget.onSelected.call(data);
              setState(() {});
            },
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: widget.title,
            style: context.textFontWeight600.onFontSize(
              context.resources.fontSize.dp14,
            ),
            children: [
              if (widget.isMandetory)
                TextSpan(
                  text: ' *',
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp14)
                      .onColor(Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(items.length, (index) {
              return KeyedSubtree(
                key: ValueKey(items[index].name),
                child:
                    (index == 0 || index == items.length - 1)
                        ? items[index].getWidget(context)
                        : SizedBox(
                          width: 200,
                          child: items[index].getWidget(context),
                        ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
