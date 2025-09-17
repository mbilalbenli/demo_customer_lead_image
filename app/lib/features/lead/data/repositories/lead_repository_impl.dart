import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/lead_entity.dart';
import '../../domain/repositories/lead_repository.dart';
import '../datasources/lead_remote_datasource.dart';
import '../datasources/lead_local_datasource.dart';
import '../models/lead_model.dart';
import '../../../../core/utils/app_logger.dart';

class LeadRepositoryImpl implements LeadRepository {
  final LeadRemoteDataSource _remoteDataSource;
  final LeadLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  LeadRepositoryImpl({
    required LeadRemoteDataSource remoteDataSource,
    required LeadLocalDataSource localDataSource,
    required Connectivity connectivity,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivity = connectivity;

  @override
  Future<Either<Exception, LeadEntity>> getLeadById(String id) async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        // Try to get from cache when offline
        AppLogger.info('Offline mode - fetching lead from cache');
        final cachedLead = await _localDataSource.getCachedLead(id);
        if (cachedLead != null) {
          return Right(cachedLead.toEntity());
        }
        return Left(Exception('No internet connection and no cached data available'));
      }

      // Online - fetch from remote
      final leadModel = await _remoteDataSource.getLeadById(id);

      // Cache the result
      await _localDataSource.cacheLead(leadModel);

      return Right(leadModel.toEntity());
    } catch (e) {
      AppLogger.error('Failed to get lead by id', e);

      // Try cache as fallback
      final cachedLead = await _localDataSource.getCachedLead(id);
      if (cachedLead != null) {
        AppLogger.info('Returning cached lead as fallback');
        return Right(cachedLead.toEntity());
      }

      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<LeadEntity>>> getLeadsList({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        AppLogger.info('Offline mode - fetching leads from cache');
        final cachedLeads = await _localDataSource.getCachedLeadsList();
        return Right(cachedLeads.map((model) => model.toEntity()).toList());
      }

      final leadModels = await _remoteDataSource.getLeadsList(
        page: page,
        pageSize: pageSize,
      );

      // Cache the first page
      if (page == 1) {
        await _localDataSource.cacheLeadsList(leadModels);
      }

      return Right(leadModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      AppLogger.error('Failed to get leads list', e);

      // Try cache as fallback
      final cachedLeads = await _localDataSource.getCachedLeadsList();
      if (cachedLeads.isNotEmpty) {
        AppLogger.info('Returning cached leads as fallback');
        return Right(cachedLeads.map((model) => model.toEntity()).toList());
      }

      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<LeadEntity>>> searchLeads({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        // Search in cached leads when offline
        AppLogger.info('Offline mode - searching in cached leads');
        final cachedLeads = await _localDataSource.getCachedLeadsList();
        final filteredLeads = cachedLeads.where((lead) {
          final searchQuery = query.toLowerCase();
          return lead.customerName.toLowerCase().contains(searchQuery) ||
                 lead.email.toLowerCase().contains(searchQuery) ||
                 lead.phone.contains(searchQuery) ||
                 (lead.description.toLowerCase().contains(searchQuery));
        }).toList();
        return Right(filteredLeads.map((model) => model.toEntity()).toList());
      }

      final leadModels = await _remoteDataSource.searchLeads(
        query: query,
        page: page,
        pageSize: pageSize,
      );

      return Right(leadModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      AppLogger.error('Failed to search leads', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, LeadEntity>> createLead(LeadEntity lead) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return Left(Exception('Cannot create lead while offline'));
      }

      final leadModel = LeadModel.fromEntity(lead);
      final createdLead = await _remoteDataSource.createLead(leadModel);

      // Cache the new lead
      await _localDataSource.cacheLead(createdLead);

      // Update cached list
      final cachedLeads = await _localDataSource.getCachedLeadsList();
      await _localDataSource.cacheLeadsList([createdLead, ...cachedLeads]);

      return Right(createdLead.toEntity());
    } catch (e) {
      AppLogger.error('Failed to create lead', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, LeadEntity>> updateLead(LeadEntity lead) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return Left(Exception('Cannot update lead while offline'));
      }

      final leadModel = LeadModel.fromEntity(lead);
      final updatedLead = await _remoteDataSource.updateLead(leadModel);

      // Update cache
      await _localDataSource.cacheLead(updatedLead);

      return Right(updatedLead.toEntity());
    } catch (e) {
      AppLogger.error('Failed to update lead', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> deleteLead(String id) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return Left(Exception('Cannot delete lead while offline'));
      }

      await _remoteDataSource.deleteLead(id);

      // Remove from cache
      await _localDataSource.removeCachedLead(id);

      return const Right(null);
    } catch (e) {
      AppLogger.error('Failed to delete lead', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, int>> getImageCountForLead(String leadId) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        // Try cache when offline
        final cachedCount = await _localDataSource.getCachedImageCount(leadId);
        if (cachedCount != null) {
          return Right(cachedCount);
        }
        return Left(Exception('No internet connection and no cached data available'));
      }

      final count = await _remoteDataSource.getImageCountForLead(leadId);

      // Cache the count
      await _localDataSource.cacheImageCount(leadId, count);

      return Right(count);
    } catch (e) {
      AppLogger.error('Failed to get image count', e);

      // Try cache as fallback
      final cachedCount = await _localDataSource.getCachedImageCount(leadId);
      if (cachedCount != null) {
        return Right(cachedCount);
      }

      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> canAddImageToLead(String leadId) async {
    try {
      final countResult = await getImageCountForLead(leadId);
      return countResult.fold(
        (error) => Left(error),
        (count) => Right(count < 10),
      );
    } catch (e) {
      AppLogger.error('Failed to check if can add image', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> incrementImageCount(String leadId) async {
    try {
      final leadResult = await getLeadById(leadId);
      return leadResult.fold(
        (error) => Left(error),
        (lead) async {
          if (lead.imageCount >= 10) {
            return Left(Exception('Maximum image limit reached'));
          }

          final updatedLead = lead.copyWith(
            imageCount: lead.imageCount + 1,
            updatedAt: DateTime.now(),
          );

          final updateResult = await updateLead(updatedLead);
          return updateResult.fold(
            (error) => Left(error),
            (_) => const Right(null),
          );
        },
      );
    } catch (e) {
      AppLogger.error('Failed to increment image count', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> decrementImageCount(String leadId) async {
    try {
      final leadResult = await getLeadById(leadId);
      return leadResult.fold(
        (error) => Left(error),
        (lead) async {
          if (lead.imageCount <= 0) {
            return const Right(null); // Already at 0
          }

          final updatedLead = lead.copyWith(
            imageCount: lead.imageCount - 1,
            updatedAt: DateTime.now(),
          );

          final updateResult = await updateLead(updatedLead);
          return updateResult.fold(
            (error) => Left(error),
            (_) => const Right(null),
          );
        },
      );
    } catch (e) {
      AppLogger.error('Failed to decrement image count', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<LeadEntity>>> getLeadsWithImages() async {
    try {
      final leadsResult = await getLeadsList();
      return leadsResult.fold(
        (error) => Left(error),
        (leads) => Right(leads.where((lead) => lead.imageCount > 0).toList()),
      );
    } catch (e) {
      AppLogger.error('Failed to get leads with images', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<LeadEntity>>> getLeadsAtImageLimit() async {
    try {
      final leadsResult = await getLeadsList();
      return leadsResult.fold(
        (error) => Left(error),
        (leads) => Right(leads.where((lead) => lead.isAtImageLimit).toList()),
      );
    } catch (e) {
      AppLogger.error('Failed to get leads at image limit', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> clearCache() async {
    try {
      await _localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      AppLogger.error('Failed to clear cache', e);
      return Left(Exception(e.toString()));
    }
  }
}