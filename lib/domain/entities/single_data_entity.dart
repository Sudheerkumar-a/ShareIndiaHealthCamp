// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/enum/enum.dart';
import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class SingleDataEntity extends BaseEntity {
  final dynamic value;

  SingleDataEntity(this.value);
}

class ListEntity extends BaseEntity {
  List<dynamic> items = [];
}

class NameIDEntity extends BaseEntity {
  int? id;
  String? name;

  NameIDEntity();
  @override
  List<Object?> get props => [id, name];
  @override
  String toString() {
    return name ?? '';
  }
}

class FormEntity extends BaseEntity {
  String? name;
  String? groupName;
  String? type;
  String? url;
  Map<String, dynamic>? urlInputData;
  dynamic Function(Map<String, dynamic>)? requestModel;
  String? parameterName;
  String? label;
  String? labelTe;
  String? labelEn;
  String? placeholder;
  String? placeholderEn;
  String? placeholderTe;
  String? suffixIcon;
  bool? repeated;
  bool? multi;
  bool? isHidden;
  bool? isEnabled;
  bool? timeOnly;
  bool? hasTime;
  int? priority;
  int? cols;
  double? verticalSpace;
  double? horizontalSpace;
  dynamic fieldValue;
  dynamic inputFieldData;
  Function(dynamic)? onDatachnage;
  List<String> responseFields = [];
  List<LKPchildrenEntity> lkpChildren = [];
  List<String> children = [];
  FormValidationEntity? validation;
  FormMessageEntity? messages;
  FieldParentEntity? parent;

  @override
  List<Object?> get props => [name, groupName, url, labelEn, labelTe];

  String get getLabel => (isSelectedLocalEn ? labelEn : labelTe) ?? label ?? '';
  String get getPlaceholder =>
      (isSelectedLocalEn ? placeholderEn : placeholderTe) ?? placeholder ?? '';
}

class LKPchildrenEntity extends BaseEntity {
  int? childIndex;
  String? childname;
  List<int> parentValue = [];

  @override
  List<Object?> get props => [childIndex, parentValue];
}

class FormValidationEntity extends BaseEntity {
  bool? required;
  int? maxLength;
  int? maxSize;
  String? extensions;
  String? regex;
  String? relatedTo;
  String? relatedMin;
  dynamic min;
  dynamic max;

  @override
  List<Object?> get props => [required, maxLength];
}

class FormMessageEntity extends BaseEntity {
  String? required;
  String? requiredEn;
  String? requiredTe;
  String? maxLength;
  String? maxLengthEn;
  String? maxLengthAr;
  String? regex;
  String? regexEn;
  String? regexTe;
  String? max;
  String? maxEn;
  String? maxTe;
  String? min;
  String? minEn;
  String? minAr;
  String? validate;
  String? validateEn;
  String? validateAr;

  @override
  List<Object?> get props => [requiredEn, maxLengthEn];

  String? get requiredMessage =>
      (isSelectedLocalEn ? requiredEn : requiredTe) ?? required;
  String? get maxLengthMessage =>
      (isSelectedLocalEn ? maxLengthEn : maxLengthAr) ?? maxLength;
  String? get regexMessage => (isSelectedLocalEn ? regexEn : regexTe) ?? regex;
  String? get maxMessage => (isSelectedLocalEn ? maxEn : maxTe) ?? max;
  String? get minMessage => (isSelectedLocalEn ? minEn : minAr) ?? min;
  String? get validateMessage =>
      (isSelectedLocalEn ? validateEn : validateAr) ?? validate;
}

class FieldParentEntity extends BaseEntity {
  dynamic parentValue;
  String? parentName;
  String? parentType;
  String? parentAction;

  @override
  List<Object?> get props => [parentValue, parentName];
}

class DropdownDataEntity extends BaseEntity {
  String? children;
  List<DropdownItemEntity> items = [];

  @override
  List<Object?> get props => [children];
}

class DropdownItemEntity extends BaseEntity {
  int? id;
  String? textEn;
  String? textAr;
  String? displayTextEn;
  String? displayTextAr;
  String? url;
  String? value;
  String? nameAr;
  String? nameEn;
  String? email;
  List<String>? ext;
  int? maxSize;
  bool? isRequired;
  bool? isActive;
  bool? isPublished;

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return (isSelectedLocalEn ? textEn ?? nameEn : textAr ?? nameAr) ?? '';
  }

  String get name => (isSelectedLocalEn ? nameEn : nameAr) ?? '';

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "valueEn": textEn ?? '',
    "valueAr": textAr ?? '',
    "url": url ?? '',
  };
}

class GooglePlaceEntity {
  String? placeName;
  String? placeID;

  @override
  String toString() {
    return placeName ?? '';
  }
}

class TableColumnEntity {
  String? columnName;
  Color columnColor = Color(0xff212B4B);
  Function? onClick;

  @override
  String toString() {
    return columnName ?? '';
  }
}
