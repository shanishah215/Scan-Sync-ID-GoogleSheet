import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/aadhaar_details.dart';
import '../repositories/aadhaar_sync_repository.dart';

class SyncAadhaarUseCase implements UseCase<String, AadhaarDetails> {
  final AadhaarSyncRepository _repository;

  SyncAadhaarUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(AadhaarDetails details) async {
    return await _repository.syncAadhaar(details);
  }
}
