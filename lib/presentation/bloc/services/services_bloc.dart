import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shareindia_health_camp/data/local/local_database.dart'
    show MandalEntity, LocalDatabase;
import 'package:shareindia_health_camp/data/model/screening_model.dart';
import 'package:shareindia_health_camp/data/remote/api_urls.dart';
import 'package:shareindia_health_camp/domain/entities/base_entity.dart';
import 'package:shareindia_health_camp/domain/entities/screening_entity.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/services_usecase.dart';

part 'services_state.dart';

class ServicesBloc extends Cubit<ServicesState> {
  final ServicesUseCase servicesUseCase;
  final LocalDatabase localDatabase;
  ServicesBloc({required this.servicesUseCase, required this.localDatabase})
    : super(Init());

  Future<ServicesState> getDashboardData({
    required Map<String, dynamic> requestParams,
    emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(ServicesStateLoading());
    }
    final result = await servicesUseCase.getDashboardData(
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    if (emitResponse) {
      emit(responseState);
    }
    return responseState;
  }

  Future<ServicesState> getMonthwiseData({
    required Map<String, dynamic> requestParams,
    emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(ServicesStateLoading());
    }
    final result = await servicesUseCase.getDashboardData(
      apiUrl: dashboardMonthwiseApiUrl,
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    if (emitResponse) {
      emit(responseState);
    }
    return responseState;
  }

  Future<ServicesState> getReportsData({
    required Map<String, dynamic> requestParams,
    emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(ServicesStateLoading());
    }
    final result = await servicesUseCase.getReportsData(
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    if (emitResponse) {
      emit(responseState);
    }
    return responseState;
  }

  Future<ServicesState> getMandalList({
    required Map<String, dynamic> requestParams,
    emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(ServicesStateLoading());
    }
    final result = await servicesUseCase.getMandalList(
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    if (emitResponse) {
      emit(responseState);
    }
    return responseState;
  }

  Future<ServicesState> getFieldInputData({
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    required dynamic Function(Map<String, dynamic>) requestModel,
    // List<NameIDEntity> cacheList = const [],
  }) async {
    // if (cacheList.isNotEmpty) {
    //   print('Cache List : ${cacheList.length}');
    //   return ServicesStateSuccess(
    //     responseEntity: ApiEntity()..entity = (ListEntity()..items = cacheList),
    //   );
    // }
    final result = await servicesUseCase.getFieldData(
      apiUrl: apiUrl,
      requestParams: requestParams,
      responseModel: requestModel,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    return responseState;
  }

  Future<ServicesState> submitData({
    required String apiUrl,
    required Map<String, dynamic> requestParams,
  }) async {
    final result = await servicesUseCase.submitData(
      apiUrl: apiUrl,
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    return responseState;
  }

  Future<ServicesState> submitMultipartData({
    required String apiUrl,
    required Map<String, dynamic> requestParams,
  }) async {
    final result = await servicesUseCase.submitMultipartData(
      apiUrl: apiUrl,
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    return responseState;
  }

  Future<ServicesState> getAgentsList({
    required Map<String, dynamic> requestParams,
    emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(ServicesStateLoading());
    }
    final result = await servicesUseCase.getAgentsList(
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    if (emitResponse) {
      emit(responseState);
    }
    return responseState;
  }

  Future<ServicesState> deleteAgent({
    required Map<String, dynamic> requestParams,
    emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(ServicesStateLoading());
    }
    final result = await servicesUseCase.deleteAgent(
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    if (emitResponse) {
      emit(responseState);
    }
    return responseState;
  }

  Future<ServicesState> getCampList({
    required Map<String, dynamic> requestParams,
    emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(ServicesStateLoading());
    }
    final result = await servicesUseCase.getCampList(
      requestParams: requestParams,
    );
    final responseState = result.fold(
      (l) => ServicesStateApiError(message: _getErrorMessage(l)),
      (r) {
        return ServicesStateSuccess(responseEntity: r);
      },
    );
    if (emitResponse) {
      emit(responseState);
    }
    return responseState;
  }

  Future<ServicesState> getLocalCampList({
    required Map<String, dynamic> requestParams,
    emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(ServicesStateLoading());
    }
    final result = await localDatabase.getUnsyncedCamps();
    final responseState = ServicesStateSuccess(
      responseEntity:
          ApiEntity()
            ..entity =
                (ListEntity()
                  ..items =
                      result
                          .map(
                            (e) =>
                                CampModel.fromJson(
                                  jsonDecode(e.data),
                                ).toEntity(),
                          )
                          .toList()),
    );
    if (emitResponse) {
      emit(responseState);
    }
    return responseState;
  }

  Future<List<NameIDEntity>> getLocalMandalList() async {
    final mandals = await localDatabase.getMandals();
    return mandals
        .map(
          (e) =>
              (NameIDEntity()
                ..id = e.id
                ..name = e.name),
        )
        .toList();
  }

  Future<void> insertMandalList(int districtId) async {
    final mandals = await localDatabase.getMandals();
    if (mandals.isEmpty) {
      final result = await servicesUseCase.getMandalList(
        requestParams: {'dist_id': districtId},
      );
      result.fold((l) => null, (r) async {
        List<NameIDEntity> mandalList = [];
        if (r.entity is ListEntity) {
          mandalList = ((r.entity as ListEntity).items).cast<NameIDEntity>();
        }
        if (mandalList.isNotEmpty) {
          await localDatabase.insertmandals(
            mandalList
                .map((e) => MandalEntity(id: e.id ?? 0, name: e.name ?? ''))
                .toList(),
          );
        }
      });
    }
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
