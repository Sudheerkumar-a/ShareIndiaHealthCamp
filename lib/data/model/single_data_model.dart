// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/data/model/base_model.dart';
import 'package:shareindia_health_camp/data/model/services_model.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';

class SingleDataModel extends BaseModel {
  dynamic value;

  SingleDataModel();

  factory SingleDataModel.fromCreateRequest(Map<String, dynamic> json) {
    var createRequestModel = SingleDataModel();
    createRequestModel.value = json['data']?['ticketId'] ?? json['message'];
    return createRequestModel;
  }

  @override
  SingleDataEntity toEntity() {
    return SingleDataEntity(value);
  }
}

class ListModel extends BaseModel {
  List<dynamic> items = [];

  ListModel.fromMandalJson(Map<String, dynamic> json) {
    final response = json['data']?['mandals'];
    if (response != null) {
      response.forEach((v) {
        items.add(NameIDModel.fromMandalJson(v).toEntity());
      });
    }
  }

  ListModel.fromDistrictsJson(Map<String, dynamic> json) {
    final response = json['data'];
    if (response != null) {
      response.forEach((v) {
        items.add(NameIDModel.fromDistrictsJson(v).toEntity());
      });
    }
  }

  ListModel.fromAgents(Map<String, dynamic> json) {
    final response = json['data'];
    if (response != null) {
      response.forEach((v) {
        items.add(AgentDataModel.fromJson(v).toEntity());
      });
    }
  }

  @override
  ListEntity toEntity() {
    return ListEntity()..items = items;
  }
}

class NameIDModel extends BaseModel {
  int? id;
  String? name;

  NameIDModel();
  factory NameIDModel.fromIdNameJson(Map<String, dynamic> json) {
    var nameIDModel = NameIDModel();
    nameIDModel.id = int.tryParse(json['id']);
    nameIDModel.name = json['name'];
    return nameIDModel;
  }
  factory NameIDModel.fromDistrictsJson(Map<String, dynamic> json) {
    var nameIDModel = NameIDModel();
    nameIDModel.id = int.tryParse('${json['id']}');
    nameIDModel.name = json['name'];
    return nameIDModel;
  }

  factory NameIDModel.fromMandalJson(Map<String, dynamic> json) {
    var nameIDModel = NameIDModel();
    nameIDModel.id = int.tryParse(json['mandal_id']);
    nameIDModel.name = json['mandal_name'];
    return nameIDModel;
  }

  @override
  NameIDEntity toEntity() {
    return NameIDEntity()
      ..id = id
      ..name = name;
  }
}
