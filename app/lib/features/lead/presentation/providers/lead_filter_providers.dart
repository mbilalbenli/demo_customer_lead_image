import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/lead_entity.dart';
import 'lead_providers.dart';

// Filter Options Provider
final leadFilterOptionsProvider = StateProvider<LeadFilterOptions>(
  (ref) => const LeadFilterOptions(),
);

// Filtered Leads Provider
final filteredLeadsProvider = Provider<List<LeadEntity>>((ref) {
  final leads = ref.watch(leadListViewModelProvider).leads;
  final filters = ref.watch(leadFilterOptionsProvider);

  return leads.where((lead) {
    // Filter by status
    if (filters.status != null && lead.status != filters.status) {
      return false;
    }

    // Filter by image count
    if (filters.hasImages != null) {
      final hasImages = lead.imageCount > 0;
      if (filters.hasImages! != hasImages) {
        return false;
      }
    }

    // Filter by image count range
    if (filters.minImageCount != null &&
        lead.imageCount < filters.minImageCount!) {
      return false;
    }
    if (filters.maxImageCount != null &&
        lead.imageCount > filters.maxImageCount!) {
      return false;
    }

    // Filter by search query
    if (filters.searchQuery.isNotEmpty) {
      final query = filters.searchQuery.toLowerCase();
      final matchesName = lead.customerName.value.toLowerCase().contains(query);
      final matchesEmail = lead.email.value.toLowerCase().contains(query);
      final matchesPhone = lead.phone.value.contains(query);

      if (!matchesName && !matchesEmail && !matchesPhone) {
        return false;
      }
    }

    // Filter by date range
    if (filters.startDate != null &&
        lead.createdAt.isBefore(filters.startDate!)) {
      return false;
    }
    if (filters.endDate != null &&
        lead.createdAt.isAfter(filters.endDate!)) {
      return false;
    }

    return true;
  }).toList();
});

// Sort Options Provider
final leadSortOptionProvider = StateProvider<LeadSortOption>(
  (ref) => LeadSortOption.nameAsc,
);

// Sorted Leads Provider
final sortedLeadsProvider = Provider<List<LeadEntity>>((ref) {
  final leads = ref.watch(filteredLeadsProvider);
  final sortOption = ref.watch(leadSortOptionProvider);

  final sortedList = List<LeadEntity>.from(leads);

  switch (sortOption) {
    case LeadSortOption.nameAsc:
      sortedList.sort((a, b) =>
          a.customerName.value.compareTo(b.customerName.value));
      break;
    case LeadSortOption.nameDesc:
      sortedList.sort((a, b) =>
          b.customerName.value.compareTo(a.customerName.value));
      break;
    case LeadSortOption.dateAsc:
      sortedList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case LeadSortOption.dateDesc:
      sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case LeadSortOption.imageCountAsc:
      sortedList.sort((a, b) => a.imageCount.compareTo(b.imageCount));
      break;
    case LeadSortOption.imageCountDesc:
      sortedList.sort((a, b) => b.imageCount.compareTo(a.imageCount));
      break;
    case LeadSortOption.statusAsc:
      sortedList.sort((a, b) => a.status.index.compareTo(b.status.index));
      break;
  }

  return sortedList;
});

// Active Filters Count Provider
final activeFiltersCountProvider = Provider<int>((ref) {
  final filters = ref.watch(leadFilterOptionsProvider);
  int count = 0;

  if (filters.status != null) count++;
  if (filters.hasImages != null) count++;
  if (filters.minImageCount != null) count++;
  if (filters.maxImageCount != null) count++;
  if (filters.searchQuery.isNotEmpty) count++;
  if (filters.startDate != null) count++;
  if (filters.endDate != null) count++;

  return count;
});

// Has Active Filters Provider
final hasActiveFiltersProvider = Provider<bool>((ref) {
  return ref.watch(activeFiltersCountProvider) > 0;
});

// Lead Statistics Provider
final leadStatisticsProvider = Provider<LeadStatistics>((ref) {
  final leads = ref.watch(leadListViewModelProvider).leads;

  if (leads.isEmpty) {
    return const LeadStatistics();
  }

  final totalImages = leads.fold<int>(0, (sum, lead) => sum + lead.imageCount);
  final leadsWithImages = leads.where((lead) => lead.imageCount > 0).length;
  final leadsWithoutImages = leads.length - leadsWithImages;
  final averageImages = totalImages / leads.length;
  final maxImages = leads.map((lead) => lead.imageCount).reduce(
        (max, count) => count > max ? count : max,
      );

  return LeadStatistics(
    totalLeads: leads.length,
    totalImages: totalImages,
    leadsWithImages: leadsWithImages,
    leadsWithoutImages: leadsWithoutImages,
    averageImagesPerLead: averageImages,
    maxImagesOnLead: maxImages,
  );
});

// Models
class LeadFilterOptions {
  final LeadStatus? status;
  final bool? hasImages;
  final int? minImageCount;
  final int? maxImageCount;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;

  const LeadFilterOptions({
    this.status,
    this.hasImages,
    this.minImageCount,
    this.maxImageCount,
    this.searchQuery = '',
    this.startDate,
    this.endDate,
  });

  LeadFilterOptions copyWith({
    LeadStatus? status,
    bool? hasImages,
    int? minImageCount,
    int? maxImageCount,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return LeadFilterOptions(
      status: status ?? this.status,
      hasImages: hasImages ?? this.hasImages,
      minImageCount: minImageCount ?? this.minImageCount,
      maxImageCount: maxImageCount ?? this.maxImageCount,
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  LeadFilterOptions clear() {
    return const LeadFilterOptions();
  }
}

enum LeadSortOption {
  nameAsc,
  nameDesc,
  dateAsc,
  dateDesc,
  imageCountAsc,
  imageCountDesc,
  statusAsc,
}

class LeadStatistics {
  final int totalLeads;
  final int totalImages;
  final int leadsWithImages;
  final int leadsWithoutImages;
  final double averageImagesPerLead;
  final int maxImagesOnLead;

  const LeadStatistics({
    this.totalLeads = 0,
    this.totalImages = 0,
    this.leadsWithImages = 0,
    this.leadsWithoutImages = 0,
    this.averageImagesPerLead = 0.0,
    this.maxImagesOnLead = 0,
  });
}