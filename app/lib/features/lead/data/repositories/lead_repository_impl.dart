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
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        AppLogger.info('Offline mode - fetching lead from cache');
        final cachedLead = await _localDataSource.getCachedLead(id);
        if (cachedLead != null) {
          return Right(cachedLead.toEntity());
        }
        return Left(Exception('No internet connection and no cached data available'));
      }

      final leadModel = await _remoteDataSource.getLeadById(id);
      await _localDataSource.cacheLead(leadModel);
      return Right(leadModel.toEntity());
    } catch (e) {
      AppLogger.error('Failed to get lead by id', e);
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

      if (connectivityResult.contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        AppLogger.info('Offline mode - fetching leads from cache');
        final cachedLeads = await _localDataSource.getCachedLeadsList();
        return Right(cachedLeads.map((model) => model.toEntity()).toList());
      }

      final leadModels = await _remoteDataSource.getLeadsList(
        page: page,
        pageSize: pageSize,
      );

      if (page == 1) {
        await _localDataSource.cacheLeadsList(leadModels);
      }

      return Right(leadModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      AppLogger.error('Failed to get leads list', e);
      final cachedLeads = await _localDataSource.getCachedLeadsList();
      if (cachedLeads.isNotEmpty) {
        AppLogger.info('Returning cached leads as fallback');
        return Right(cachedLeads.map((model) => model.toEntity()).toList());
      }
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, LeadEntity>> createLead({
    required String name,
    required String email,
    required String phone,
    String? description,
  }) async {
    try {
      final model = LeadModel(
        id: '',
        customerName: name,
        email: email,
        phone: phone,
        description: description ?? '',
        status: LeadStatus.newLead,
        imageCount: 0,
        availableImageSlots: 10,
        canAddMoreImages: true,
        createdAt: DateTime.now(),
      );

      final created = await _remoteDataSource.createLead(model);
      // Cache created lead
      await _localDataSource.cacheLead(created);
      return Right(created.toEntity());
    } catch (e) {
      AppLogger.error('Failed to create lead', e);
      return Left(Exception(e.toString()));
    }
  }
}
