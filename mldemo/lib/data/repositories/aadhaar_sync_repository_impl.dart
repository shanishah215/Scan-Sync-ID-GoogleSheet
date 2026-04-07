import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/aadhaar_details.dart';
import '../../domain/repositories/aadhaar_sync_repository.dart';
import '../datasources/aadhaar_remote_datasource.dart';
import '../models/aadhaar_model.dart';

class AadhaarSyncRepositoryImpl implements AadhaarSyncRepository {
  final AadhaarRemoteDataSource _remoteDataSource;

  AadhaarSyncRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> syncAadhaar(AadhaarDetails details) async {
    try {
      final model = AadhaarModel.fromEntity(details);
      final result = await _remoteDataSource.syncAadhaar(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
