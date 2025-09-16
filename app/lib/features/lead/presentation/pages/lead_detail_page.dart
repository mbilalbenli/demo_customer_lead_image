import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/base_page.dart';
import '../states/lead_detail_state.dart';
import '../organisms/lead_detail_organism.dart';
import '../providers/lead_providers.dart';

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

    return AppBar(
      title: Text(lead?.customerName.value ?? 'Lead Details'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      actions: [
        if (lead != null)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit Lead'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Lead', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  context.go('/leads/${widget.leadId}/edit');
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

    return LeadDetailOrganism(
      lead: state.lead!,
      maxImageCount: state.maxImageCount,
      isLoading: state.core.isBusy,
      onEdit: () => context.go('/leads/${widget.leadId}/edit'),
      onDelete: () => _showDeleteConfirmation(context, ref),
      onViewImages: () => context.go('/leads/${widget.leadId}/images'),
      onAddImage: () => context.go('/leads/${widget.leadId}/images/add'),
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
            onPressed: () => context.go('/leads'),
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
              context.go('/leads');
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

}