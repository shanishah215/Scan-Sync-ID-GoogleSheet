import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/aadhaar_details.dart';

abstract class AadhaarSyncRepository {
  Future<Either<Failure, String>> syncAadhaar(AadhaarDetails details);
}
