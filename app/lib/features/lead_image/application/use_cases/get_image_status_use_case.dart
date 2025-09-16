import 'package:dartz/dartz.dart';
import '../../domain/repositories/lead_image_repository.dart';

class GetImageStatusUseCase {
  final LeadImageRepository _repository;

  GetImageStatusUseCase(this._repository);

  Future<Either<Exception, Map<String, dynamic>>> execute(String leadId) async {
    return await _repository.getImageStatus(leadId);
  }
}