import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class OcrRemoteDataSource {
  Future<RecognizedText> processImage(String imagePath);
}

class OcrRemoteDataSourceImpl implements OcrRemoteDataSource {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Future<RecognizedText> processImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    return await _textRecognizer.processImage(inputImage);
  }
}
