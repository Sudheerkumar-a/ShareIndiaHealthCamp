import 'package:dartz/dartz.dart';
import 'package:shareindia_health_camp/core/error/failures.dart';
import 'package:shareindia_health_camp/data/model/api_response_model.dart';
import 'package:shareindia_health_camp/data/model/login_model.dart';
import 'package:shareindia_health_camp/data/remote/api_urls.dart';
import 'package:shareindia_health_camp/domain/entities/api_entity.dart';
import 'package:shareindia_health_camp/domain/entities/user_entity.dart';
import 'package:shareindia_health_camp/domain/repository/apis_repository.dart';
import 'package:shareindia_health_camp/domain/usecase/base_usecase.dart';

import '../../data/model/single_data_model.dart';
import '../entities/single_data_entity.dart';

class UserUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  UserUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<LoginEntity>>> validateUser({
    required Map<String, dynamic> requestParams,
  }) async {
    var apiResponse = await apisRepository.post<LoginModel>(
      apiUrl: validateUserApiUrl,
      requestParams: requestParams,
      responseModel: LoginModel.fromJson,
    );
    return apiResponse.fold(
      (l) {
        return Left(l);
      },
      (r) {
        var apiResponseEntity = r.toEntity<LoginEntity>();
        return Right(apiResponseEntity);
      },
    );
  }

  @override
  Future<Either<Failure, ApiEntity<UserEntity>>> getUserData({
    required Map<String, dynamic> requestParams,
  }) async {
    var apiResponse = await apisRepository.get<UserModel>(
      apiUrl: userDetailsApiUrl,
      requestParams: requestParams,
      responseModel: UserModel.fromJson,
    );
    return apiResponse.fold(
      (l) {
        return Left(l);
      },
      (r) {
        var apiResponseEntity = r.toEntity<UserEntity>();
        return Right(apiResponseEntity);
      },
    );
  }
}
