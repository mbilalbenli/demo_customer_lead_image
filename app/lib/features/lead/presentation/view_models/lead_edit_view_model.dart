import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base/base_view_model.dart';
import '../states/lead_edit_state.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/lead_entity.dart';

class LeadEditViewModel extends BaseViewModel<LeadEditState> {
  LeadEditViewModel() : super(const LeadEditState());

  @override
  void onInit() {
    AppLogger.info('LeadEditViewModel initialized');
    setTitle('Edit Lead');
    setShowAppBar(true);
  }

  Future<void> loadLead(String leadId) async {
    await executeWithLoading(
      operation: () async {
        await Future.delayed(const Duration(seconds: 1));
        return LeadEntity.create(
          id: leadId,
          customerName: 'John Doe',
          email: 'john@example.com',
          phone: '+1 234 567 8900',
          description: 'Tech Corp - Important client',
          status: LeadStatus.converted,
          imageCount: 5,
        );
      },
      operationName: 'Loading lead',
      onSuccess: (lead) {
        // Extract company and notes from description
        final parts = lead.description.split(' - ');
        final company = parts.isNotEmpty ? parts.first : '';
        final notes = parts.length > 1 ? parts.sublist(1).join(' - ') : '';

        state = state.copyWith(
          originalLead: lead,
          name: lead.customerName.value,
          email: lead.email.value,
          phone: lead.phone.value,
          company: company,
          notes: notes,
          status: lead.status,
        );
        _validateForm();
      },
      onError: (error) {
        setTitle('Failed to load lead');
        AppLogger.error('Error loading lead: $error');
      },
    );
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

    final hasChanges = state.originalLead != null && (
      state.name != state.originalLead!.customerName.value ||
      state.email != state.originalLead!.email.value ||
      state.phone != state.originalLead!.phone.value ||
      state.status != state.originalLead!.status
    );

    state = state.copyWith(
      isFormValid: isValid,
      hasChanges: hasChanges,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> saveLead() async {
    if (!state.isFormValid || !state.hasChanges) return;

    await executeWithLoading(
      operation: () async {
        await Future.delayed(const Duration(seconds: 2));
        return LeadEntity.create(
          id: state.originalLead!.id,
          customerName: state.name,
          email: state.email,
          phone: state.phone,
          description: '${state.company}${state.notes.isNotEmpty ? ' - ${state.notes}' : ''}',
          status: state.status!,
          imageCount: state.originalLead!.imageCount,
        );
      },
      operationName: 'Updating lead',
      onSuccess: (lead) {
        state = state.copyWith(
          originalLead: lead,
          hasChanges: false,
        );
        setTitle('Lead Updated Successfully');
        AppLogger.info('Lead updated: ${lead.id}');
      },
      onError: (error) {
        setTitle('Failed to update lead');
        AppLogger.error('Error updating lead: $error');
      },
    );
  }
}

final leadEditViewModelProvider =
    StateNotifierProvider<LeadEditViewModel, LeadEditState>(
  (ref) => LeadEditViewModel(),
);