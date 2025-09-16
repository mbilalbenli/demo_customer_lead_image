import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../states/lead_list_state.dart';
import '../states/lead_detail_state.dart';
import '../view_models/lead_list_view_model.dart';
import '../view_models/lead_detail_view_model.dart';
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

// Lead Detail Provider
final leadDetailViewModelProvider =
    StateNotifierProvider<LeadDetailViewModel, LeadDetailState>(
  (ref) => LeadDetailViewModel(
    getIt<GetLeadByIdUseCase>(),
  ),
);

// Selected Lead ID Provider
final selectedLeadIdProvider = StateProvider<String?>((ref) => null);