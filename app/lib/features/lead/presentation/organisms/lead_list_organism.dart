import 'package:flutter/material.dart';
import '../molecules/lead_card_molecule.dart';
import '../../../../core/widgets/molecules/app_empty_state_molecule.dart';
import '../../../../core/widgets/molecules/app_loading_overlay_molecule.dart';
import '../../domain/entities/lead_entity.dart';

/// A feature-specific organism for displaying a list of leads
/// Shows lead cards with image counts
/// Following atomic design principles - composed from molecules and atoms
class LeadListOrganism extends StatelessWidget {
  final List<LeadItemData> leads;
  final bool isLoading;
  final String? searchQuery;
  final Set<String> selectedIds;
  final ValueChanged<LeadItemData>? onLeadTap;
  final ValueChanged<LeadItemData>? onLeadImagesTap;
  final ValueChanged<String>? onSelectionChanged;
  final bool selectionMode;
  final ScrollController? scrollController;
  final bool compact;

  const LeadListOrganism({
    super.key,
    required this.leads,
    this.isLoading = false,
    this.searchQuery,
    this.selectedIds = const {},
    this.onLeadTap,
    this.onLeadImagesTap,
    this.onSelectionChanged,
    this.selectionMode = false,
    this.scrollController,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && leads.isEmpty) {
      return _buildLoadingState(context);
    }

    if (leads.isEmpty) {
      return _buildEmptyState(context);
    }

    return Stack(
      children: [
        ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: leads.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final lead = leads[index];
            final isSelected = selectedIds.contains(lead.id);

            return LeadCardMolecule(
              leadName: lead.name,
              company: lead.company,
              email: lead.email,
              phone: lead.phone,
              status: _convertListStatusToLeadStatus(lead.status),
              imageCount: lead.imageCount,
              selected: isSelected,
              compact: compact,
              onTap: () {
                if (selectionMode) {
                  onSelectionChanged?.call(lead.id);
                } else {
                  onLeadTap?.call(lead);
                }
              },
              onImagesTap: lead.imageCount > 0 || lead.imageCount < 10
                  ? () => onLeadImagesTap?.call(lead)
                  : null,
              showImageCount: true,
            );
          },
        ),
        if (isLoading)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Loading more leads...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return AppSkeletonLoadingMolecule.card(
          height: compact ? 80 : 160,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      return Center(
        child: AppEmptyStateMolecule.noResults(
          message: 'No leads found for "$searchQuery"',
        ),
      );
    }

    return Center(
      child: AppEmptyStateMolecule(
        icon: Icons.people_outline,
        title: 'No Leads Yet',
        message: 'Start adding leads to manage customer relationships',
      ),
    );
  }

  LeadStatus _convertListStatusToLeadStatus(LeadListStatus status) {
    switch (status) {
      case LeadListStatus.active:
        return LeadStatus.active;
      case LeadListStatus.inactive:
        return LeadStatus.inactive;
      case LeadListStatus.converted:
        return LeadStatus.converted;
      case LeadListStatus.lost:
        return LeadStatus.lost;
    }
  }
}

/// A grid variant of the lead list organism
class LeadGridOrganism extends StatelessWidget {
  final List<LeadItemData> leads;
  final bool isLoading;
  final ValueChanged<LeadItemData>? onLeadTap;
  final ValueChanged<LeadItemData>? onLeadImagesTap;
  final ScrollController? scrollController;
  final int crossAxisCount;

  const LeadGridOrganism({
    super.key,
    required this.leads,
    this.isLoading = false,
    this.onLeadTap,
    this.onLeadImagesTap,
    this.scrollController,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && leads.isEmpty) {
      return _buildLoadingState(context);
    }

    if (leads.isEmpty) {
      return Center(
        child: AppEmptyStateMolecule(
          icon: Icons.grid_view,
          title: 'No Leads',
          message: 'Your leads will appear here',
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];

        return LeadGridCardMolecule(
          leadName: lead.name,
          company: lead.company,
          status: _convertListStatusToLeadStatus(lead.status),
          imageCount: lead.imageCount,
          onTap: () => onLeadTap?.call(lead),
          onImagesTap: lead.imageCount > 0 || lead.imageCount < 10
              ? () => onLeadImagesTap?.call(lead)
              : null,
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return AppSkeletonLoadingMolecule.card();
      },
    );
  }

  LeadStatus _convertListStatusToLeadStatus(LeadListStatus status) {
    switch (status) {
      case LeadListStatus.active:
        return LeadStatus.active;
      case LeadListStatus.inactive:
        return LeadStatus.inactive;
      case LeadListStatus.converted:
        return LeadStatus.converted;
      case LeadListStatus.lost:
        return LeadStatus.lost;
    }
  }
}

/// Data model for lead items
class LeadItemData {
  final String id;
  final String name;
  final String? company;
  final String? email;
  final String? phone;
  final LeadListStatus status;
  final int imageCount;

  const LeadItemData({
    required this.id,
    required this.name,
    this.company,
    this.email,
    this.phone,
    required this.status,
    required this.imageCount,
  });
}

/// Enum for lead status in list display
enum LeadListStatus {
  active,
  inactive,
  converted,
  lost,
}