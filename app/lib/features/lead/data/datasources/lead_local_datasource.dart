import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lead_model.dart';
import '../../../../core/utils/app_logger.dart';

abstract class LeadLocalDataSource {
  Future<void> cacheLeadsList(List<LeadModel> leads);
  Future<List<LeadModel>> getCachedLeadsList();
  Future<void> cacheLead(LeadModel lead);
  Future<LeadModel?> getCachedLead(String id);
  Future<void> removeCachedLead(String id);
  Future<void> clearCache();
  Future<void> cacheImageCount(String leadId, int count);
  Future<int?> getCachedImageCount(String leadId);
}

class LeadLocalDataSourceImpl implements LeadLocalDataSource {
  final SharedPreferences _sharedPreferences;

  static const String _leadsListKey = 'cached_leads_list';
  static const String _leadPrefix = 'cached_lead_';
  static const String _imageCountPrefix = 'cached_image_count_';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const Duration _cacheValidity = Duration(hours: 1);

  LeadLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheLeadsList(List<LeadModel> leads) async {
    try {
      AppLogger.info('Caching ${leads.length} leads');
      final jsonList = leads.map((lead) => lead.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await _sharedPreferences.setString(_leadsListKey, jsonString);
      await _sharedPreferences.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      AppLogger.error('Failed to cache leads list', e);
      throw Exception('Failed to cache leads list');
    }
  }

  @override
  Future<List<LeadModel>> getCachedLeadsList() async {
    try {
      AppLogger.info('Fetching cached leads list');

      // Check cache validity
      final timestamp = _sharedPreferences.getInt(_cacheTimestampKey);
      if (timestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (DateTime.now().difference(cacheTime) > _cacheValidity) {
          AppLogger.info('Cache expired, returning empty list');
          return [];
        }
      }

      final jsonString = _sharedPreferences.getString(_leadsListKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        final leads = jsonList.map((json) => LeadModel.fromJson(json)).toList();
        AppLogger.info('Retrieved ${leads.length} cached leads');
        return leads;
      }
      return [];
    } catch (e) {
      AppLogger.error('Failed to get cached leads list', e);
      return [];
    }
  }

  @override
  Future<void> cacheLead(LeadModel lead) async {
    try {
      AppLogger.info('Caching lead: ${lead.id}');
      final jsonString = json.encode(lead.toJson());
      await _sharedPreferences.setString('$_leadPrefix${lead.id}', jsonString);
    } catch (e) {
      AppLogger.error('Failed to cache lead', e);
      throw Exception('Failed to cache lead');
    }
  }

  @override
  Future<LeadModel?> getCachedLead(String id) async {
    try {
      AppLogger.info('Fetching cached lead: $id');
      final jsonString = _sharedPreferences.getString('$_leadPrefix$id');
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString);
        return LeadModel.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to get cached lead', e);
      return null;
    }
  }

  @override
  Future<void> removeCachedLead(String id) async {
    try {
      AppLogger.info('Removing cached lead: $id');
      await _sharedPreferences.remove('$_leadPrefix$id');

      // Also update the cached list if it exists
      final leads = await getCachedLeadsList();
      final updatedLeads = leads.where((lead) => lead.id != id).toList();
      if (updatedLeads.length != leads.length) {
        await cacheLeadsList(updatedLeads);
      }
    } catch (e) {
      AppLogger.error('Failed to remove cached lead', e);
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      AppLogger.info('Clearing all lead cache');
      final keys = _sharedPreferences.getKeys();
      for (final key in keys) {
        if (key.startsWith(_leadPrefix) ||
            key == _leadsListKey ||
            key == _cacheTimestampKey ||
            key.startsWith(_imageCountPrefix)) {
          await _sharedPreferences.remove(key);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to clear cache', e);
    }
  }

  @override
  Future<void> cacheImageCount(String leadId, int count) async {
    try {
      AppLogger.info('Caching image count for lead $leadId: $count');
      await _sharedPreferences.setInt('$_imageCountPrefix$leadId', count);
    } catch (e) {
      AppLogger.error('Failed to cache image count', e);
    }
  }

  @override
  Future<int?> getCachedImageCount(String leadId) async {
    try {
      final count = _sharedPreferences.getInt('$_imageCountPrefix$leadId');
      AppLogger.info('Retrieved cached image count for lead $leadId: $count');
      return count;
    } catch (e) {
      AppLogger.error('Failed to get cached image count', e);
      return null;
    }
  }
}