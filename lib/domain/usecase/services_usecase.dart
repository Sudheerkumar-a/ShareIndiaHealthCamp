import 'package:dartz/dartz.dart';
import 'package:shareindia_health_camp/core/error/failures.dart';
import 'package:shareindia_health_camp/data/model/api_response_model.dart';
import 'package:shareindia_health_camp/data/model/dashboard_model.dart';
import 'package:shareindia_health_camp/data/model/master_data_models.dart';
import 'package:shareindia_health_camp/data/model/services_model.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/data/remote/api_urls.dart';
import 'package:shareindia_health_camp/domain/entities/api_entity.dart';
import 'package:shareindia_health_camp/domain/entities/dashboard_entity.dart';
import 'package:shareindia_health_camp/domain/entities/master_data_entities.dart';
import 'package:shareindia_health_camp/domain/entities/services_entity.dart';
import 'package:shareindia_health_camp/domain/repository/apis_repository.dart';
import 'package:shareindia_health_camp/domain/usecase/base_usecase.dart';

import '../entities/single_data_entity.dart';

class ServicesUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  ServicesUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<DashboardEntity>>> getDashboardData({
    required Map<String, dynamic> requestParams,
  }) async {
    var apiResponse = await apisRepository.post<DashboardModel>(
      apiUrl: dashboardApiUrl,
      requestParams: requestParams,
      responseModel: DashboardModel.fromJson,
    );
    return apiResponse.fold(
      (l) {
        return Left(l);
      },
      (r) {
        var apiResponseEntity = r.toEntity<DashboardEntity>();
        return Right(apiResponseEntity);
      },
    );
  }

  Future<Either<Failure, ApiEntity<ReportDataEntity>>> getReportsData({
    required Map<String, dynamic> requestParams,
  }) async {
    var apiResponse = await apisRepository.post<ReportDataModel>(
      apiUrl: reportListApiUrl,
      requestParams: requestParams,
      responseModel: ReportDataModel.fromJson,
    );
    return apiResponse.fold(
      (l) {
        return Left(l);
      },
      (r) {
        var apiResponseEntity = r.toEntity<ReportDataEntity>();
        return Right(apiResponseEntity);
      },
    );
  }

  Future<Either<Failure, ApiEntity<ListEntity>>> getMandalList({
    required Map<String, dynamic> requestParams,
  }) async {
    var apiResponse = await apisRepository.post<ListModel>(
      apiUrl: mandalListApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromMandalJson,
    );
    return apiResponse.fold(
      (l) {
        return Left(l);
      },
      (r) {
        var apiResponseEntity = r.toEntity<ListEntity>();
        return Right(apiResponseEntity);
      },
    );
  }
}
