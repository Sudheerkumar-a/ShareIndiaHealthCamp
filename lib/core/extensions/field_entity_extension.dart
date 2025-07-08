
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/injection_container.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/checkbox_list_input_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/dropdown_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/location_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/multi_select_dropdown_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/radio_items_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/upload_attachment_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/yesnoconfirm_widget.dart';
import 'package:shareindia_health_camp/presentation/utils/date_time_util.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';

extension FieldEntityExtension on FormEntity {
  Future<List<NameIDEntity>?> _getAccountTypes() async {
    if (url == null && inputFieldData?['items'] == null) {
      return null;
    }
    if (inputFieldData?['items'] == null) {
      final response = await sl<ServicesBloc>().getFieldInputData(
        apiUrl: url ?? '',
        requestParams: urlInputData ?? {},
        requestModel: requestModel ?? ListModel.fromMandalJson,
      );
      if (response is ServicesStateSuccess) {
        return Future<List<NameIDEntity>>.value(
          ((response).responseEntity.entity as ListEntity).items
              .map((item) => item as NameIDEntity)
              .toList(),
        );
      } else {
        return Future<List<NameIDEntity>>.value([]);
      }
    }
    return Future.value((inputFieldData?['items'] ?? []) as List<NameIDEntity>);
  }

  Widget getWidget(BuildContext context) {
    final resources = context.resources;
    bool isVisible = !(isHidden ?? false);
    bool isMandetory = (isVisible && (validation?.required ?? false));
    switch (type) {
      case 'collection':
        return FutureBuilder<List<NameIDEntity>?>(
          future: _getAccountTypes(),
          builder: (context, snapshot) {
            if (inputFieldData?['doSort'] ?? true) {
              (snapshot.data ?? []).sort(
                (a, b) => (a.toString()).compareTo(b.toString()),
              );
            }
            if (snapshot.data != null) {
              if (inputFieldData == null) {
                inputFieldData = {'items': snapshot.data};
              } else {
                inputFieldData['items'] ??= snapshot.data;
              }
            }
            return Visibility(
              visible: isVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child:
                    multi == true
                        ? MultiSelectDropDownWidget<NameIDEntity>(
                          list: snapshot.data ?? [],
                          height: resources.dimen.dp27,
                          labelText: getLabel,
                          errorMessage: isMandetory ? getLabel : '',
                          isMandetory: isMandetory,
                          hintText: placeholder,
                          selectedItems:
                              fieldValue ??
                              List<NameIDEntity>.empty(growable: true),
                          callback: (value) async {
                            onDatachnage?.call(value);
                          },
                        )
                        : DropDownWidget<NameIDEntity>(
                          list: snapshot.data ?? [],
                          height: resources.dimen.dp27,
                          labelText: getLabel,
                          errorMessage: isMandetory ? getLabel : '',
                          isMandetory: isMandetory,
                          hintText: placeholder,
                          selectedValue: fieldValue,
                          callback: (value) async {
                            fieldValue = value;
                            onDatachnage?.call(value);
                          },
                        ),
              ),
            );
          },
        );
      case 'text' || 'number' || 'phone' || 'textarea' || 'email':
        final textEditingController = TextEditingController();
        textEditingController.text = fieldValue ?? '';
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: RightIconTextWidget(
              isEnabled: isEnabled ?? true,
              height: resources.dimen.dp27,
              textInputType:
                  (type == 'number' || type == 'phone')
                      ? TextInputType.number
                      : null,
              textInputAction: TextInputAction.next,
              labelText: getLabel,
              hintText: placeholder,
              maxLines: type == 'textarea' ? 4 : 1,
              errorMessage: isMandetory ? getLabel : '',
              isMandetory: isMandetory,
              regex: validation?.regex,
              maxLength: validation?.maxLength,
              textController: textEditingController,
              isValid: (value) {
                if (value.isEmpty) {
                  return messages?.requiredMessage;
                } else if (!RegExp(validation?.regex ?? '').hasMatch(value)) {
                  return messages?.regexMessage;
                } else if (value.length > (validation?.maxLength ?? 2000)) {
                  return messages?.maxLengthMessage;
                } else if ((validation?.max is int) &&
                    (int.tryParse(value) ?? 0) > (validation?.max ?? 2000)) {
                  return messages?.maxMessage;
                } else if ((validation?.min is int) &&
                    (int.tryParse(value) ?? 0) < (validation?.min ?? 0)) {
                  return messages?.minMessage;
                }
                return null;
              },
              onChanged: (value) {
                fieldValue = value;
                onDatachnage?.call(value);
              },
            ),
          ),
        );
      case 'checkbox':
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CheckboxListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(getLabel, style: context.textFontWeight400),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              controlAffinity: ListTileControlAffinity.leading,
              value: fieldValue ?? false,
              onChanged: (isChecked) {
                onDatachnage?.call(isChecked);
              },
            ),
          ),
        );
      case 'radio':
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (getLabel.isNotEmpty) ...[
                  Text(
                    getLabel,
                    style: context.textFontWeight400.onFontSize(
                      context.resources.fontSize.dp14,
                    ),
                  ),
                  SizedBox(width: resources.dimen.dp20),
                ],
                RadioItemsWidget(
                  items: inputFieldData,
                  onItemSelected: (value) async {
                    onDatachnage?.call(value);
                  },
                  selectedItem: fieldValue,
                ),
              ],
            ),
          ),
        );
      case 'radiovertical':
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getLabel,
                  style: context.textFontWeight400.onFontSize(
                    context.resources.fontSize.dp14,
                  ),
                ),
                SizedBox(width: resources.dimen.dp20),
                RadioItemsWidget(
                  type: RadioItemsType.vertical,
                  items: inputFieldData,
                  onItemSelected: (value) async {
                    onDatachnage?.call(value);
                  },
                  selectedItem: fieldValue,
                ),
              ],
            ),
          ),
        );
      case 'date' || 'dateFrom' || 'dateTo':
        final textEditingController = TextEditingController();
        textEditingController.text = fieldValue ?? '';
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: InkWell(
              onTap: () {
                if (timeOnly == true) {
                  selectTime(
                    context,
                    callBack: (dateTime) {
                      textEditingController.text = getDateByformat(
                        "hh:mm a",
                        dateTime,
                      );
                      fieldValue = textEditingController.text;
                    },
                  );
                } else {
                  DateTime? firstDate;
                  selectDate(
                    context,
                    firstDate: firstDate,
                    initialDate:
                        fieldValue != null
                            ? getDateTimeByString(
                              'dd/MM/yyyy',
                              fieldValue ?? '',
                            )
                            : firstDate,
                    callBack: (dateTime) {
                      textEditingController.text = getDateByformat(
                        hasTime == true ? "dd/MM/yyyy HH:mm:ss" : "dd/MM/yyyy",
                        dateTime,
                      );
                      fieldValue = textEditingController.text;
                      onDatachnage?.call(textEditingController.text);
                    },
                  );
                }
              },
              child: RightIconTextWidget(
                isEnabled: false,
                height: resources.dimen.dp27,
                textInputAction: TextInputAction.next,
                labelText: getLabel,
                hintText: placeholder,
                maxLines: 1,
                errorMessage: (isMandetory) ? getLabel : '',
                isMandetory: isMandetory,
                regex: validation?.regex,
                textController: textEditingController,
                disableColor: Color(0xFFFFFFFF),
                suffixIconPath: suffixIcon,
                isValid: (value) {
                  if (value.isEmpty) {
                    return messages?.requiredMessage;
                  } else if (!RegExp(validation?.regex ?? '').hasMatch(value)) {
                    return messages?.regexMessage;
                  } else if (value.length > (validation?.maxLength ?? 200)) {
                    return messages?.maxLengthMessage;
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
            ),
          ),
        );
      case 'file' || 'image':
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: UploadAttachmentWidget(
              height: resources.dimen.dp27,
              labelText: getLabel,
              errorMessage: isMandetory ? getLabel : '',
              isMandetory: isMandetory,
              allowedExtensions:
                  validation?.extensions?.replaceAll('.', '').split(', ') ?? [],
              maxSize: validation?.maxSize ?? 1,
              selectedFileData: inputFieldData,
              onSelected: (uploadResponseEntity) async {
                if (uploadResponseEntity?.documentData != null) {
                  uploadResponseEntity?.documentData = uploadResponseEntity
                      .documentData
                      ?.replaceAll('data:image/png;base64,', '');
                  onDatachnage?.call(uploadResponseEntity);
                } else {
                  onDatachnage?.call(null);
                }
              },
            ),
          ),
        );

      case 'labelheader':
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              getLabel,
              style: context.textFontWeight600.onColor(
                resources.color.viewBgColor,
              ),
            ),
          ),
        );
      case 'label':
        return Visibility(
          visible: isVisible,
          child: Text(
            getLabel,
            style: context.textFontWeight500.onFontSize(
              resources.fontSize.dp12,
            ),
          ),
        );

      case 'button':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () {},
              child: ActionButtonWidget(
                width: 110,
                text: getLabel,
                color:
                    fieldValue != null
                        ? resources.color.viewBgColor
                        : resources.iconBgColor,
                padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp20,
                  vertical: context.resources.dimen.dp7,
                ),
              ),
            ),
          ),
        );
      case 'location':
        final data = {'field': this, 'data': fieldValue ?? {}};
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: LocationWidget(
              locationData: data,
              onDataChanged: (data) {
                onDatachnage?.call(data);
              },
            ),
          ),
        );
      case 'termsconditions':
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Checkbox(
                  value: fieldValue ?? false,
                  onChanged: (value) {
                    onDatachnage?.call(value);
                  },
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text:
                          isSelectedLocalEn ? 'I have read and agree the' : '',
                      children: [
                        TextSpan(
                          text:
                              isSelectedLocalEn
                                  ? 'Terms & Conditions'
                                  : 'الشروط والأحكام',
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp12)
                              .onColor(resources.color.viewBgColor)
                              .copyWith(decoration: TextDecoration.underline),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Dialogs.showDialogWithClose(
                                    context,
                                    showClose: false,
                                    SizedBox(),
                                  ).then((value) {
                                    if (context.mounted) {}
                                  });
                                },
                        ),
                        TextSpan(
                          text:
                              isSelectedLocalEn
                                  ? ' of this service'
                                  : ' لهذه الخدمة',
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp12)
                              .onColor(resources.color.viewBgColor),
                        ),
                      ],
                    ),
                    style: context.textFontWeight400
                        .onColor(resources.color.viewBgColor)
                        .onFontSize(resources.fontSize.dp12),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'confirmcheck':
        {
          return Visibility(
            visible: isVisible,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: YesNoconfirmWidget(
                question: getLabel,
                isMandetory: validation?.required??false,
                selectedValue: fieldValue,
                onSelected: (value) {
                  fieldValue = value;
                  onDatachnage?.call(value);
                },
              ),
            ),
          );
        }
      case 'listcheckbox':
        {
          return Visibility(
            visible: isVisible,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: CheckboxListInputWidget(
                inputData: inputFieldData,
                title: getLabel,
                isMandetory: validation?.required??false,
                onSelected: (value) {
                  fieldValue = value;
                  onDatachnage?.call(value);
                },
              ),
            ),
          );
        }
      default:
        return const SizedBox();
    }
  }
}
