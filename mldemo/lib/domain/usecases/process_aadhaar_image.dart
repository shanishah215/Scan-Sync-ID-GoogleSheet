import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/aadhaar_details.dart';
import '../repositories/ocr_repository.dart';

class ProcessAadhaarImage implements UseCase<AadhaarDetails, String> {
  final OcrRepository _repository;

  ProcessAadhaarImage(this._repository);

  @override
  Future<Either<Failure, AadhaarDetails>> call(String imagePath) async {
    return await _repository.processAadhaarImage(imagePath);
  }
}
