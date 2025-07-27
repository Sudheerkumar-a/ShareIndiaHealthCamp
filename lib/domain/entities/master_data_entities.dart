// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class UploadResponseEntity extends BaseEntity {
  int? documentDataId;
  int? documentTypeId;
  int? did;
  String? documentName;
  String? documentData;
  String? documentType;

  @override
  List<Object?> get props => [documentDataId];

  Map<String, dynamic> toJson() => {
    'fileId': documentDataId,
    'fileDid': did,
    'fileName': documentName,
  };
  @override
  String toString() {
    return documentName ?? '';
  }
}

class ExportDataEntity extends BaseEntity {
  String? title;
  String? date;
  List<String> columns = [];
  dynamic rows;
}
