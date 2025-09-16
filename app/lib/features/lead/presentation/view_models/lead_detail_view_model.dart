import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/app_logger.dart';
import '../states/lead_detail_state.dart';
import '../../application/use_cases/get_lead_by_id_use_case.dart';

class LeadDetailViewModel extends BaseViewModel<LeadDetailState> {
  final GetLeadByIdUseCase getLeadByIdUseCase;
  String? leadId;

  LeadDetailViewModel(this.getLeadByIdUseCase)
      : super(const LeadDetailState());

  @override
  void onInit() {
    AppLogger.info('LeadDetailViewModel initialized');
  }

  void setLeadId(String id) {
    leadId = id;
    fetchLeadDetail();
  }

  Future<void> loadLeadDetails({bool refresh = false}) async {
    if (leadId != null) {
      await fetchLeadDetail();
    }
  }

  Future<void> fetchLeadDetail() async {
    if (leadId == null) {
      AppLogger.error('Lead ID is null');
      return;
    }
    await executeWithLoading(
      operation: () async {
        // Use actual use case when available
        final result = await getLeadByIdUseCase.execute(leadId!);
        return result.fold(
          (error) => throw error,
          (lead) => lead,
        );
      },
      operationName: 'Loading lead details',
      onSuccess: (lead) {
        state = state.copyWith(
          lead: lead,
          imageCount: lead.imageCount,
          canAddImage: lead.canAddImage,
          maxImageCount: 10,
        );
        setTitle(lead.customerName.value);
        setShowAppBar(true);

        // Show warning if near limit
        if (lead.imageCount >= 8) {
          AppLogger.warning('Lead is near image limit: ${lead.imageCount}/10');
        }
      },
      onError: (error) {
        state = state.copyWith(errorMessage: error.toString());
        AppLogger.error('Failed to fetch lead detail', error);
      },
    );
  }

  Future<void> deleteLead() async {
    await executeWithLoading(
      operation: () async {
        await Future.delayed(const Duration(seconds: 1));
        // Mock delete - replace with actual API call
      },
      operationName: 'Deleting lead',
      onSuccess: (_) {
        AppLogger.info('Lead deleted successfully');
      },
      onError: (error) {
        AppLogger.error('Failed to delete lead', error);
      },
    );
  }

  void refreshImageCount(int newCount) {
    if (state.lead != null) {
      final updatedLead = state.lead!.copyWith(imageCount: newCount);
      state = state.copyWith(
        lead: updatedLead,
        imageCount: newCount,
        canAddImage: newCount < state.maxImageCount,
      );
    }
  }

  String getImageStatusMessage() {
    if (state.isAtImageLimit) {
      return 'Maximum images reached';
    } else if (state.imageCount >= 8) {
      return 'Almost at limit (${state.remainingImageSlots} slots left)';
    } else {
      return '${state.imageCount} images uploaded';
    }
  }
}

