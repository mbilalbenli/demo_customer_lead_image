import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../features/lead/domain/repositories/lead_repository.dart';
import '../../../features/lead/data/repositories/lead_repository_impl.dart';
import '../../../features/lead/data/datasources/lead_remote_datasource.dart';
import '../../../features/lead/data/datasources/lead_local_datasource.dart';
import '../../../features/lead/infrastructure/services/lead_api_service.dart';
import '../../../features/lead/application/use_cases/get_lead_by_id_use_case.dart';
import '../../../features/lead/application/use_cases/get_leads_list_use_case.dart';

class LeadInjector {
  static void initialize(GetIt sl) {
    // API Service
    sl.registerLazySingleton<LeadApiService>(
      () => LeadApiService(),
    );

    // Data sources
    sl.registerLazySingleton<LeadRemoteDataSource>(
      () => LeadRemoteDataSourceImpl(dio: sl<Dio>()),
    );

    sl.registerLazySingleton<LeadLocalDataSource>(
      () => LeadLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
    );

    // Repository
    sl.registerLazySingleton<LeadRepository>(
      () => LeadRepositoryImpl(
        remoteDataSource: sl<LeadRemoteDataSource>(),
        localDataSource: sl<LeadLocalDataSource>(),
        connectivity: sl<Connectivity>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetLeadByIdUseCase(sl<LeadRepository>()));
    sl.registerLazySingleton(() => GetLeadsListUseCase(sl<LeadRepository>()));

    // TODO: Add additional use cases as they are created:
    // - CreateLeadUseCase
    // - UpdateLeadUseCase
    // - DeleteLeadUseCase
    // - SearchLeadsUseCase
    // - CheckCanAddImageUseCase
  }
}