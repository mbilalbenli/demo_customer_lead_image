import 'package:dartz/dartz.dart';
import '../entities/lead_entity.dart';

abstract class LeadRepository {
  Future<Either<Exception, LeadEntity>> getLeadById(String id);

  Future<Either<Exception, List<LeadEntity>>> getLeadsList({
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Exception, List<LeadEntity>>> searchLeads({
    required String query,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Exception, LeadEntity>> createLead(LeadEntity lead);

  Future<Either<Exception, LeadEntity>> updateLead(LeadEntity lead);

  Future<Either<Exception, void>> deleteLead(String id);

  Future<Either<Exception, int>> getImageCountForLead(String leadId);

  Future<Either<Exception, bool>> canAddImageToLead(String leadId);

  Future<Either<Exception, void>> incrementImageCount(String leadId);

  Future<Either<Exception, void>> decrementImageCount(String leadId);

  Future<Either<Exception, List<LeadEntity>>> getLeadsWithImages();

  Future<Either<Exception, List<LeadEntity>>> getLeadsAtImageLimit();

  Future<Either<Exception, void>> clearCache();
}