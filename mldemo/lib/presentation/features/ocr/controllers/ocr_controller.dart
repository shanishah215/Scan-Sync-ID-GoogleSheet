import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/aadhaar_details.dart';
import '../../../../domain/usecases/process_aadhaar_image.dart';

class OcrController extends GetxController {
  final ProcessAadhaarImage _processAadhaarImage;
  final ImagePicker _imagePicker = ImagePicker();

  OcrController(this._processAadhaarImage);

  final RxString pickedImagePath = "".obs;
  final RxBool isRecognizing = false.obs;
  final Rx<AadhaarDetails?> aadhaarDetails = Rx<AadhaarDetails?>(null);
  final RxString error = "".obs;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      pickedImagePath.value = pickedFile.path;
      _processImage(pickedFile.path);
    }
  }

  Future<void> _processImage(String path) async {
    isRecognizing.value = true;
    error.value = "";
    
    final result = await _processAadhaarImage(path);
    
    result.fold(
      (failure) {
        error.value = failure.message;
        isRecognizing.value = false;
      },
      (details) {
        aadhaarDetails.value = details;
        isRecognizing.value = false;
      },
    );
  }
}
