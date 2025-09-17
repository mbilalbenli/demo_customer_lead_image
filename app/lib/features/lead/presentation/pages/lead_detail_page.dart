import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/base/base_page.dart';
import '../../../../l10n/app_localizations.dart';
import '../states/lead_detail_state.dart';
import '../providers/lead_providers.dart';
import '../organisms/lead_detail_with_gallery_organism.dart';
import '../../../lead_image/presentation/providers/image_providers.dart';
import '../../presentation/view_models/lead_edit_view_model.dart';
import '../organisms/lead_form_organism.dart';
import '../../domain/entities/lead_entity.dart';
import 'package:image_picker/image_picker.dart';

/// Lead detail page with prominent image section
/// Following atomic design principles and base architecture
class LeadDetailPage extends BasePage<LeadDetailState> {
  final String leadId;

  const LeadDetailPage({
    super.key,
    required this.leadId,
  }) : super(
    initialShowAppBar: true,
    wrapWithScroll: false,
  );

  ProviderListenable<LeadDetailState> get vmProvider => leadDetailViewModelProvider(leadId);

  @override
  ConsumerState<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends BasePageState<LeadDetailPage, LeadDetailState> {
  @override
  ProviderListenable<LeadDetailState> get vmProvider => leadDetailViewModelProvider(widget.leadId);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leadDetailViewModelProvider(widget.leadId).notifier).loadLeadDetails();
    });
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vmProvider);
    final lead = state.lead;
    final l10n = AppLocalizations.of(context);

    return AppBar(
      title: Text(
        lead != null
            ? '${lead.customerName.value} ${l10n?.details ?? 'Details'}'
            : l10n?.leadDetails ?? 'Lead Details',
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      centerTitle: false,
      actions: [
        if (lead != null)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text(l10n?.editLead ?? 'Edit Lead'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      l10n?.deleteLead ?? 'Delete Lead',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditDialog(context, ref);
                  break;
                case 'delete':
                  _showDeleteConfirmation(context, ref);
                  break;
              }
            },
          ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vmProvider);

    if (state.errorMessage != null) {
      return _buildErrorState(context, ref, state.errorMessage!);
    }

    if (state.lead == null && state.core.isBusy) {
      return _buildLoadingState();
    }

    if (state.lead == null) {
      return _buildEmptyState(context);
    }

    return LeadDetailWithGalleryOrganism(
      lead: state.lead!,
      leadId: widget.leadId,
      maxImageCount: state.maxImageCount,
      isLoading: state.core.isBusy,
      onEdit: () => _showEditDialog(context, ref),
      onDelete: () => _showDeleteConfirmation(context, ref),
      onManagePhotos: () => _showAddPhotoDrawer(context, ref),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading lead',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.read(leadDetailViewModelProvider(widget.leadId).notifier).loadLeadDetails(refresh: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Lead not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go(RouteNames.leadListPath),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Leads'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Lead'),
        content: const Text(
          'Are you sure you want to delete this lead? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(leadDetailViewModelProvider(widget.leadId).notifier).deleteLead();
              context.go(RouteNames.leadListPath);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    // Trigger load BEFORE building the dialog to avoid modifying providers during build
    final editVm = ref.read(leadEditViewModelProvider.notifier);
    // Ensure provider modification happens after current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      editVm.loadLead(widget.leadId);
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SizedBox(
            width: 520,
            child: Consumer(
              builder: (context, ref, _) {
                final editState = ref.watch(leadEditViewModelProvider);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Text('Edit Lead', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Flexible(
                      child: SingleChildScrollView(
                        child: LeadFormOrganism(
                          name: editState.name,
                          email: editState.email,
                          phone: editState.phone,
                          company: editState.company,
                          notes: editState.notes,
                          status: editState.status ?? LeadStatus.newLead,
                          isFormValid: editState.isFormValid,
                          hasChanges: editState.hasChanges,
                          isLoading: editState.core.isBusy,
                          onNameChanged: (v) => editVm.updateName(v),
                          onEmailChanged: (v) => editVm.updateEmail(v),
                          onPhoneChanged: (v) => editVm.updatePhone(v),
                          onCompanyChanged: (v) => editVm.updateCompany(v),
                          onNotesChanged: (v) => editVm.updateNotes(v),
                          onStatusChanged: (s) => editVm.updateStatus(s),
                          onSave: () async {
                            await editVm.saveLead();
                            if (context.mounted) {
                              Navigator.of(dialogContext).pop();
                              // Refresh details
                              ref.read(leadDetailViewModelProvider(widget.leadId).notifier).loadLeadDetails(refresh: true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Lead updated successfully'), backgroundColor: Colors.green),
                              );
                            }
                          },
                          onCancel: () => Navigator.of(dialogContext).pop(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddPhotoDrawer(BuildContext context, WidgetRef ref) {
    final imgVm = ref.read(imageGalleryViewModelProvider(widget.leadId).notifier);
    final images = ref.read(imageGalleryViewModelProvider(widget.leadId)).images;
    final maxImages = ref.read(imageGalleryViewModelProvider(widget.leadId)).maxImages;

    if (images.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum images reached (10/10)')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            const Text('Add Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${images.length}/$maxImages', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                imgVm.pickAndUploadImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                imgVm.pickAndUploadImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
