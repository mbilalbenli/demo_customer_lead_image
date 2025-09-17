import 'package:dartz/dartz.dart';
import '../entities/lead_entity.dart';

abstract class LeadRepository {
  Future<Either<Exception, LeadEntity>> getLeadById(String id);

  Future<Either<Exception, List<LeadEntity>>> getLeadsList({
    int page = 1,
    int pageSize = 20,
  });
}
