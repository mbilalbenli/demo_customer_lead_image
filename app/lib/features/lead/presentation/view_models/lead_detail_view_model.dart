import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/app_logger.dart';
import '../states/lead_detail_state.dart';
import '../../application/use_cases/get_lead_by_id_use_case.dart';

class LeadDetailViewModel extends BaseViewModel<LeadDetailState> {
  final GetLeadByIdUseCase _getLeadByIdUseCase;
  String? _leadId;

  LeadDetailViewModel(this._getLeadByIdUseCase)
      : super(const LeadDetailState());

  @override
  void onInit() {
    AppLogger.info('LeadDetailViewModel initialized');
  }

  void setLeadId(String leadId) {
    _leadId = leadId;
    fetchLeadDetail();
  }

  Future<void> fetchLeadDetail() async {
    if (_leadId == null) {
      AppLogger.error('Lead ID is null');
      state = state.copyWith(errorMessage: 'No lead ID provided');
      return;
    }

    await executeWithLoading(
      operation: () async {
        final result = await _getLeadByIdUseCase.execute(_leadId!);
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

  void navigateToImageGallery() {
    if (_leadId != null) {
      // Navigation will be handled by the UI
      AppLogger.info('Navigating to image gallery for lead: $_leadId');
    }
  }

  void refreshImageCount(int newCount) {
    if (state.lead != null) {
      final updatedLead = state.lead!.copyWith(imageCount: newCount);
      state = state.copyWith(
        lead: updatedLead,
        imageCount: newCount,
        canAddImage: newCount < state.maxImages,
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