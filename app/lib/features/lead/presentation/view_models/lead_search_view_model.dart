import '../../../../core/base/base_view_model.dart';
import '../states/lead_search_state.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/lead_entity.dart';

class LeadSearchViewModel extends BaseViewModel<LeadSearchState> {
  LeadSearchViewModel() : super(const LeadSearchState());

  @override
  void onInit() {
    AppLogger.info('LeadSearchViewModel initialized');
    setTitle('Search Leads');
    setShowAppBar(true);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    if (query.isNotEmpty) {
      _performSearch();
    } else {
      state = state.copyWith(
        results: [],
        searchResults: [],
        isSearching: false,
        hasSearched: false,
        errorMessage: null,
      );
    }
  }

  void addFilter(String filter) {
    final updatedFilters = [...state.filters, filter];
    final updatedActiveFilters = [...state.activeFilters, filter];
    state = state.copyWith(
      filters: updatedFilters,
      activeFilters: updatedActiveFilters,
    );
    if (state.searchQuery.isNotEmpty) {
      _performSearch();
    }
  }

  void removeFilter(String filter) {
    final updatedFilters = state.filters.where((f) => f != filter).toList();
    final updatedActiveFilters = state.activeFilters.where((f) => f != filter).toList();
    state = state.copyWith(
      filters: updatedFilters,
      activeFilters: updatedActiveFilters,
    );
    if (state.searchQuery.isNotEmpty) {
      _performSearch();
    }
  }

  void clearFilters() {
    state = state.copyWith(
      filters: [],
      activeFilters: [],
      availableFilters: [],
    );
    if (state.searchQuery.isNotEmpty) {
      _performSearch();
    }
  }

  void search(String query) {
    updateSearchQuery(query);
  }

  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      results: [],
      searchResults: [],
      isSearching: false,
      hasSearched: false,
      errorMessage: null,
    );
  }

  Future<void> _performSearch() async {
    if (state.searchQuery.isEmpty) return;

    state = state.copyWith(isSearching: true);

    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final results = await _mockSearchLeads(
        state.searchQuery,
        state.filters,
      );

      state = state.copyWith(
        results: results,
        searchResults: results,
        isSearching: false,
        hasSearched: true,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        results: [],
        searchResults: [],
        isSearching: false,
        hasSearched: true,
        errorMessage: error.toString(),
      );
      AppLogger.error('Error searching leads: $error');
    }
  }

  Future<List<LeadEntity>> _mockSearchLeads(String query, List<String> filters) async {
    final allLeads = [
      LeadEntity.create(
        id: '1',
        customerName: 'John Doe',
        email: 'john@example.com',
        phone: '+1 234 567 8900',
        description: 'Tech Corp - Important client',
        status: LeadStatus.closed,
        imageCount: 5,
      ),
      LeadEntity.create(
        id: '2',
        customerName: 'Jane Smith',
        email: 'jane@example.com',
        phone: '+1 234 567 8901',
        description: 'Design Studio - Creative project',
        status: LeadStatus.newLead,
        imageCount: 3,
      ),
      LeadEntity.create(
        id: '3',
        customerName: 'Mike Johnson',
        email: 'mike@example.com',
        phone: '+1 234 567 8902',
        description: 'Startup Inc - New opportunity',
        status: LeadStatus.contacted,
        imageCount: 0,
      ),
    ];

    return allLeads.where((lead) {
      final matchesQuery = lead.customerName.value.toLowerCase().contains(query.toLowerCase()) ||
          lead.email.value.toLowerCase().contains(query.toLowerCase()) ||
          (lead.description?.toLowerCase().contains(query.toLowerCase()) ?? false);

      if (filters.isEmpty) return matchesQuery;

      final matchesFilters = filters.every((filter) {
        switch (filter.toLowerCase()) {
          case 'active':
            return lead.status == LeadStatus.newLead;
          case 'inactive':
            return lead.status == LeadStatus.contacted;
          case 'lost':
            return lead.status == LeadStatus.lost;
          case 'converted':
            return lead.status == LeadStatus.closed;
          case 'has images':
            return lead.imageCount > 0;
          case 'no images':
            return lead.imageCount == 0;
          default:
            return true;
        }
      });

      return matchesQuery && matchesFilters;
    }).toList();
  }
}