import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../features/lead_image/domain/repositories/lead_image_repository.dart';
import '../../../features/lead_image/data/repositories/lead_image_repository_impl.dart';
import '../../../features/lead_image/data/datasources/image_remote_datasource.dart';
import '../../../features/lead_image/data/datasources/image_cache_datasource.dart';
import '../../../features/lead_image/data/services/base64_encoder_service.dart';
import '../../../features/lead_image/data/services/image_compressor_service.dart';
import '../../../features/lead_image/infrastructure/services/image_api_service.dart';
import '../../../features/lead_image/infrastructure/services/base64_converter.dart';
import '../../../features/lead_image/application/use_cases/get_images_by_lead_use_case.dart';
import '../../../features/lead_image/application/use_cases/upload_image_use_case.dart';
import '../../../features/lead_image/application/use_cases/delete_image_use_case.dart';
import '../../../features/lead_image/application/use_cases/get_image_status_use_case.dart';
import '../../../features/lead_image/application/use_cases/batch_upload_images_use_case.dart';
import '../../../features/lead_image/application/use_cases/validate_images_use_case.dart';
import '../../../features/lead_image/application/use_cases/compress_image_use_case.dart';

class LeadImageInjector {
  static void initialize(GetIt sl) {
    // API Services
    sl.registerLazySingleton<ImageApiService>(
      () => ImageApiService(),
    );

    // Services
    sl.registerLazySingleton(() => Base64EncoderService());
    sl.registerLazySingleton(() => ImageCompressorService());
    sl.registerLazySingleton(() => Base64Converter());

    // Data sources
    sl.registerLazySingleton<ImageRemoteDataSource>(
      () => ImageRemoteDataSourceImpl(dio: sl<Dio>()),
    );

    sl.registerLazySingleton<ImageCacheDataSource>(
      () => ImageCacheDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
    );

    // Repository
    sl.registerLazySingleton<LeadImageRepository>(
      () => LeadImageRepositoryImpl(
        remoteDataSource: sl<ImageRemoteDataSource>(),
        cacheDataSource: sl<ImageCacheDataSource>(),
        connectivity: sl<Connectivity>(),
        uuid: sl<Uuid>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetImagesByLeadUseCase(sl<LeadImageRepository>()));
    sl.registerLazySingleton(() => UploadImageUseCase(sl<LeadImageRepository>()));
    sl.registerLazySingleton(() => DeleteImageUseCase(sl<LeadImageRepository>()));
    sl.registerLazySingleton(() => GetImageStatusUseCase(sl<LeadImageRepository>()));
    sl.registerLazySingleton(() => BatchUploadImagesUseCase(sl<LeadImageRepository>()));
    sl.registerLazySingleton(() => ValidateImagesUseCase());
    sl.registerLazySingleton(() => CompressImageUseCase());

    // TODO: Add additional use cases as they are created:
    // - UploadMultipleImagesUseCase
    // - ReplaceImageUseCase
    // - CaptureImageUseCase
    // - CompressAndEncodeImageUseCase
    // - GetImageSlotsAvailableUseCase
  }
}
