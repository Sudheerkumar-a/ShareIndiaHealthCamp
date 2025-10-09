import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shareindia_health_camp/core/config/flavor_config.dart';
import 'package:shareindia_health_camp/core/network/network_info.dart';
import 'package:shareindia_health_camp/data/local/local_database.dart';
import 'package:shareindia_health_camp/data/remote/dio_logging_interceptor.dart';
import 'package:shareindia_health_camp/data/remote/remote_data_source.dart';
import 'package:shareindia_health_camp/data/repository/apis_repository_impl.dart';
import 'package:shareindia_health_camp/domain/repository/apis_repository.dart';
import 'package:shareindia_health_camp/domain/usecase/services_usecase.dart';
import 'package:shareindia_health_camp/domain/usecase/user_usecase.dart';
import 'package:shareindia_health_camp/presentation/bloc/user/user_bloc.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(() => UserBloc(userUseCase: sl()));
  sl.registerFactory(
    () => ServicesBloc(servicesUseCase: sl(), localDatabase: sl()),
  );
  // Use Case
  sl.registerLazySingleton(() => ServicesUseCase(apisRepository: sl()));
  sl.registerLazySingleton(() => UserUseCase(apisRepository: sl()));

  // Repository
  sl.registerLazySingleton<ApisRepository>(
    () => ApisRepositoryImpl(dataSource: sl(), networkInfo: sl()),
  );

  // Data Source
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(dio: sl()),
  );

  /**
   * ! Core
   */
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  /**
   * ! External
   */
  // Local Data Source
  sl.registerLazySingleton<LocalDatabase>(() => LocalDatabase());
  // Dio
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.portalBaseUrl;
    dio.interceptors.add(DioLoggingInterceptor());
    return dio;
  });
}
