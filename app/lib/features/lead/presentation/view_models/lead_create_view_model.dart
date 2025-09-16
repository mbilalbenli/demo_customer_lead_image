import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base/base_view_model.dart';
import '../states/lead_create_state.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/lead_entity.dart';

class LeadCreateViewModel extends BaseViewModel<LeadCreateState> {
  LeadCreateViewModel() : super(const LeadCreateState());

  @override
  void onInit() {
    AppLogger.info('LeadCreateViewModel initialized');
    setTitle('Create New Lead');
    setShowAppBar(true);
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
    _validateForm();
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
    _validateForm();
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value);
    _validateForm();
  }

  void updateCompany(String value) {
    state = state.copyWith(company: value);
    _validateForm();
  }

  void updateNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void updateStatus(LeadStatus status) {
    state = state.copyWith(status: status);
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
    if (!state.isFormValid) return;

    await executeWithLoading(
      operation: () async {
        await Future.delayed(const Duration(seconds: 2));
        return LeadEntity.create(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          customerName: state.name,
          email: state.email,
          phone: state.phone,
          description: '${state.company}${state.notes.isNotEmpty ? ' - ${state.notes}' : ''}',
          status: state.status,
          imageCount: 0,
        );
      },
      operationName: 'Creating lead',
      onSuccess: (lead) {
        setTitle('Lead Created Successfully');
        AppLogger.info('Lead created: ${lead.id}');
      },
      onError: (error) {
        setTitle('Failed to create lead');
        AppLogger.error('Error creating lead: $error');
      },
    );
  }
}

final leadCreateViewModelProvider =
    StateNotifierProvider<LeadCreateViewModel, LeadCreateState>(
  (ref) => LeadCreateViewModel(),
);