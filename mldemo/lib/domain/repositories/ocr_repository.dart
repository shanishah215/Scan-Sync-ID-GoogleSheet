import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/aadhaar_details.dart';

abstract class OcrRepository {
  Future<Either<Failure, AadhaarDetails>> processAadhaarImage(String imagePath);
}
