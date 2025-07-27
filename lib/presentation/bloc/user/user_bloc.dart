import 'package:equatable/equatable.dart';
import 'package:shareindia_health_camp/domain/entities/base_entity.dart';
import 'package:shareindia_health_camp/domain/usecase/user_usecase.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_state.dart';

class UserBloc extends Cubit<UserState> {
  final UserUseCase userUseCase;
  UserBloc({required this.userUseCase}) : super(Init());

  Future<UserState> validateUser(
    Map<String, dynamic> requestParams, {
    bool emitResponse = false,
  }) async {
    if (emitResponse) {
      emit(OnLoginLoading());
    }
    final result = await userUseCase.validateUser(requestParams: requestParams);
    final apiResponseState = (result.fold(
      (l) => OnLoginApiError(message: l.errorMessage),
      (r) => OnApiResponse(responseEntity: r),
    ));
    if (emitResponse) {
      emit(apiResponseState);
    }
    return apiResponseState;
  }

  Future<UserEntity> getUserData(Map<String, dynamic> requestParams) async {
    final result = await userUseCase.getUserData(requestParams: requestParams);
    return result.fold((l) => UserEntity(), (r) => r.entity ?? UserEntity());
  }
}
