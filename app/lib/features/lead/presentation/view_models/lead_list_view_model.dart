import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/app_logger.dart';
import '../states/lead_list_state.dart';
import '../../application/use_cases/get_leads_list_use_case.dart';

class LeadListViewModel extends BaseViewModel<LeadListState> {
  final GetLeadsListUseCase _getLeadsListUseCase;

  LeadListViewModel(this._getLeadsListUseCase)
      : super(const LeadListState());

  @override
  void onInit() {
    AppLogger.info('LeadListViewModel initialized');
    fetchLeads();
  }

  Future<void> fetchLeads({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        leads: [],
        currentPage: 1,
        hasMorePages: false,
      );
    }

    await executeWithLoading(
      operation: () async {
        final result = await _getLeadsListUseCase.execute(
          page: state.currentPage,
          pageSize: 20,
        );
        return result.fold(
          (error) => throw error,
          (leads) => leads,
        );
      },
      operationName: 'Fetching leads',
      onSuccess: (leads) {
        state = state.copyWith(
          leads: refresh ? leads : [...state.leads, ...leads],
          currentPage: state.currentPage + 1,
          hasMorePages: leads.length >= 20,
        );
        setTitle('${state.leads.length} Leads');
      },
      onError: (error) {
        state = state.copyWith(errorMessage: error.toString());
        AppLogger.error('Failed to fetch leads', error);
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMorePages) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await _getLeadsListUseCase.execute(
        page: state.currentPage,
        pageSize: 20,
      );

      result.fold(
        (error) {
          state = state.copyWith(
            isLoadingMore: false,
            errorMessage: error.toString(),
          );
        },
        (leads) {
          state = state.copyWith(
            leads: [...state.leads, ...leads],
            currentPage: state.currentPage + 1,
            hasMorePages: leads.length >= 20,
            isLoadingMore: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  void searchLeads(String query) {
    state = state.copyWith(searchQuery: query);
    // Filter leads locally for demo
    if (query.isEmpty) {
      fetchLeads(refresh: true);
    } else {
      final filteredLeads = state.leads.where((lead) {
        final searchLower = query.toLowerCase();
        return lead.customerName.value.toLowerCase().contains(searchLower) ||
               lead.email.value.toLowerCase().contains(searchLower) ||
               lead.phone.value.contains(query);
      }).toList();

      state = state.copyWith(leads: filteredLeads);
    }
  }

  void navigateToLeadDetail(String leadId) {
    // Navigation will be handled by the UI
    AppLogger.info('Navigating to lead detail: $leadId');
  }
}