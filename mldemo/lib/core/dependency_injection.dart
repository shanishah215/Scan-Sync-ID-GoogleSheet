import 'package:get/get.dart';
import '../data/datasources/ocr_remote_datasource.dart';
import '../data/datasources/aadhaar_remote_datasource.dart';
import '../data/repositories/ocr_repository_impl.dart';
import '../data/repositories/aadhaar_sync_repository_impl.dart';
import '../domain/repositories/ocr_repository.dart';
import '../domain/repositories/aadhaar_sync_repository.dart';
import '../domain/usecases/process_aadhaar_image.dart';
import '../domain/usecases/sync_aadhaar_usecase.dart';
import '../presentation/features/ocr/controllers/ocr_controller.dart';
import '../presentation/features/sync/controllers/sync_controller.dart';

class DependencyInjection {
  static void init() {
    // Data Sources
    Get.lazyPut<OcrRemoteDataSource>(() => OcrRemoteDataSourceImpl());
    Get.lazyPut<AadhaarRemoteDataSource>(() => AadhaarRemoteDataSourceImpl());

    // Repositories
    Get.lazyPut<OcrRepository>(() => OcrRepositoryImpl(Get.find()));
    Get.lazyPut<AadhaarSyncRepository>(() => AadhaarSyncRepositoryImpl(Get.find()));

    // Use Cases
    Get.lazyPut(() => ProcessAadhaarImage(Get.find()));
    Get.lazyPut(() => SyncAadhaarUseCase(Get.find()));

    // Controllers
    Get.lazyPut(() => OcrController(Get.find()));
    Get.lazyPut(() => SyncController(Get.find()));
  }
}
