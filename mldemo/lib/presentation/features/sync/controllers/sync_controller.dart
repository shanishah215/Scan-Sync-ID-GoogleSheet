import 'package:get/get.dart';
import '../../../../domain/entities/aadhaar_details.dart';
import '../../../../domain/usecases/sync_aadhaar_usecase.dart';

class SyncController extends GetxController {
  final SyncAadhaarUseCase _syncAadhaarUseCase;

  SyncController(this._syncAadhaarUseCase);

  final RxBool isSyncing = false.obs;
  final RxString status = "".obs;
  final RxString error = "".obs;

  Future<void> syncData(AadhaarDetails details) async {
    isSyncing.value = true;
    error.value = "";
    status.value = "Submitting Data...";

    final result = await _syncAadhaarUseCase(details);

    result.fold(
      (failure) {
        error.value = failure.message;
        status.value = "Sync Failed";
        isSyncing.value = false;
      },
      (successStatus) {
        status.value = "Sync Success: $successStatus";
        isSyncing.value = false;
      },
    );
  }
}
