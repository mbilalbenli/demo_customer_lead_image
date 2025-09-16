import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../states/lead_list_state.dart';
import '../states/lead_detail_state.dart';
import '../states/lead_search_state.dart';
import '../view_models/lead_list_view_model.dart';
import '../view_models/lead_detail_view_model.dart';
import '../view_models/lead_search_view_model.dart';
import '../../application/use_cases/get_leads_list_use_case.dart';
import '../../application/use_cases/get_lead_by_id_use_case.dart';

final getIt = GetIt.instance;

// Lead List Provider
final leadListViewModelProvider =
    StateNotifierProvider<LeadListViewModel, LeadListState>(
  (ref) => LeadListViewModel(
    getIt<GetLeadsListUseCase>(),
  ),
);

// Lead Detail Provider - Family that takes leadId
final leadDetailViewModelProvider = StateNotifierProvider.family<
    LeadDetailViewModel, LeadDetailState, String>(
  (ref, leadId) {
    final viewModel = LeadDetailViewModel(getIt<GetLeadByIdUseCase>());
    viewModel.setLeadId(leadId);
    return viewModel;
  },
);

// Lead Search Provider
final leadSearchViewModelProvider =
    StateNotifierProvider<LeadSearchViewModel, LeadSearchState>(
  (ref) => LeadSearchViewModel(),
);

// Selected Lead ID Provider
final selectedLeadIdProvider = StateProvider<String?>((ref) => null);