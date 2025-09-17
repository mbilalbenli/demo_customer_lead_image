import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base/base_view_model.dart';
import '../states/lead_create_state.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/lead_entity.dart';
import '../../application/use_cases/create_lead_use_case.dart';
import '../../../../core/di/injection_container.dart';

class LeadCreateViewModel extends BaseViewModel<LeadCreateState> {
  final CreateLeadUseCase _createLeadUseCase;

  LeadCreateViewModel(this._createLeadUseCase) : super(const LeadCreateState());

  @override
  void onInit() {
    AppLogger.info('LeadCreateViewModel initialized');
    setTitle('Create New Lead');
    setShowAppBar(true);
  }

  void updateName(String value) {
    state = state.copyWith(name: value, hasChanges: true);
    _validateForm();
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value, hasChanges: true);
    _validateForm();
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value, hasChanges: true);
    _validateForm();
  }

  void updateCompany(String value) {
    state = state.copyWith(company: value, hasChanges: true);
    _validateForm();
  }

  void updateNotes(String value) {
    state = state.copyWith(notes: value, hasChanges: true);
  }

  void updateStatus(LeadStatus status) {
    state = state.copyWith(status: status, hasChanges: true);
  }

  void _validateForm() {
    final isValid = state.name.isNotEmpty &&
        state.email.isNotEmpty &&
        _isValidEmail(state.email);
    state = state.copyWith(isFormValid: isValid);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> saveLead() async {
    AppLogger.info('saveLead called - isFormValid: ${state.isFormValid}, hasChanges: ${state.hasChanges}');
    if (!state.isFormValid) {
      AppLogger.warning('Form is not valid, returning early');
      return;
    }

    await executeWithLoading(
      operation: () async {
        AppLogger.info('Creating lead with params - name: ${state.name}, email: ${state.email}');
        final params = CreateLeadParams(
          name: state.name,
          email: state.email,
          phone: state.phone,
          company: state.company,
          notes: state.notes,
          status: state.status,
        );

        final result = await _createLeadUseCase(params);
        return result.fold(
          (failure) => throw Exception(failure.toString()),
          (lead) => lead,
        );
      },
      operationName: 'Creating lead',
      onSuccess: (lead) {
        state = state.copyWith(
          errorMessage: null,
          hasChanges: false,
          leadCreatedSuccessfully: true,
        );
        setTitle('Lead Created Successfully');
        AppLogger.info('Lead created: ${lead.id}');

        // Navigation will be handled by the page watching the state change
      },
      onError: (error) {
        state = state.copyWith(
          errorMessage: error.toString(),
        );
        setTitle('Failed to create lead');
        AppLogger.error('Error creating lead: $error');
      },
    );
  }
}

final leadCreateViewModelProvider =
    StateNotifierProvider<LeadCreateViewModel, LeadCreateState>(
  (ref) => LeadCreateViewModel(sl<CreateLeadUseCase>()),
);