import 'package:equatable/equatable.dart';
import 'package:shareindia_health_camp/data/remote/api_urls.dart';
import 'package:shareindia_health_camp/domain/entities/base_entity.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/services_usecase.dart';

part 'services_state.dart';

class ServicesBloc extends Cubit<ServicesState> {
  final ServicesUseCase servicesUseCase;
  ServicesBloc({required this.servicesUseCase}) : super(Init());

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
  }) async {
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
    required Map<String, dynamic> requestParams,
  }) async {
    final result = await servicesUseCase.submitData(
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

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
