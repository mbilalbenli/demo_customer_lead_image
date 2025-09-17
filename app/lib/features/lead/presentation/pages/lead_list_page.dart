import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/base/base_page.dart';
import '../providers/lead_providers.dart';
import '../states/lead_list_state.dart';
import '../organisms/lead_list_organism.dart';
import '../../../../core/widgets/molecules/app_empty_state_molecule.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/organisms/app_navigation_drawer_organism.dart';
import '../../domain/entities/lead_entity.dart' as domain;

class LeadListPage extends BasePage<LeadListState> {
  const LeadListPage({super.key}) : super(
    initialShowAppBar: true,
    wrapWithScroll: false,
  );

  @override
  ConsumerState<LeadListPage> createState() => _LeadListPageState();
}

class _LeadListPageState extends BasePageState<LeadListPage, LeadListState> {
  @override
  ProviderListenable<LeadListState> get vmProvider => leadListViewModelProvider;

  @override
  PreferredSizeWidget buildAppBar(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AppBar(
      // When drawer is provided, Scaffold shows hamburger automatically
      title: Text(l10n?.customerLeads ?? 'Customer Leads'),
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      centerTitle: false,
      // Simplified: remove duplicate search/add from AppBar
      actions: const [],
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leadListViewModelProvider);
    // Hide FAB on empty state to avoid duplication with centered CTA
    if (!state.isBusy && state.leads.isEmpty) return null;

    return FloatingActionButton(
      onPressed: () => context.go(RouteNames.leadCreatePath),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget? buildDrawer(BuildContext context, WidgetRef ref) {
    return const AppNavigationDrawerOrganism();
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leadListViewModelProvider);
    final l10n = AppLocalizations.of(context);

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.errorMessage}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(leadListViewModelProvider.notifier).fetchLeads(refresh: true);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.leads.isEmpty && !state.isBusy) {
      return Column(
        children: [
          // Search bar always visible
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              enabled: !state.isBusy,
              decoration: InputDecoration(
                hintText: l10n?.searchLeadsPlaceholder ?? 'Search leads...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                ref.read(leadListViewModelProvider.notifier).searchLeads(value);
              },
            ),
          ),
          Expanded(
            child: AppEmptyStateMolecule(
              icon: Icons.people_outline,
              title: l10n?.noLeadsFound ?? 'No leads found',
              // Simplified copy: avoid referring to + FAB here
              message: 'Create your first customer lead',
              actionText: l10n?.addLead ?? l10n?.createLead ?? 'Add Lead',
              onAction: () => context.go(RouteNames.leadCreatePath),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n?.searchLeadsPlaceholder ?? 'Search leads...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            onChanged: (value) {
              ref.read(leadListViewModelProvider.notifier).searchLeads(value);
            },
          ),
        ),
        // Lead list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(leadListViewModelProvider.notifier).fetchLeads(refresh: true);
            },
            child: LeadListOrganism(
              leads: state.leads.map((lead) => _convertToLeadItemData(lead)).toList(),
              isLoading: state.isLoadingMore,
              onLeadTap: (lead) {
                context.go(RouteNames.getLeadDetailPath(lead.id));
              },
              onLeadImagesTap: (lead) {
                context.go(RouteNames.getLeadDetailPath(lead.id));
              },
            ),
          ),
        ),
      ],
    );
  }

  LeadItemData _convertToLeadItemData(domain.LeadEntity lead) {
    return LeadItemData(
      id: lead.id,
      name: lead.customerName.value,
      company: null, // Add company field to LeadEntity if needed
      email: lead.email.value,
      phone: lead.phone.value,
      status: _convertLeadStatus(lead.status),
      imageCount: lead.imageCount,
    );
  }

  LeadListStatus _convertLeadStatus(domain.LeadStatus status) {
    switch (status) {
      case domain.LeadStatus.newLead:
        return LeadListStatus.active;
      case domain.LeadStatus.contacted:
        return LeadListStatus.inactive;
      case domain.LeadStatus.qualified:
        return LeadListStatus.active; // Map qualified to active for now
      case domain.LeadStatus.proposal:
        return LeadListStatus.active; // Map proposal to active for now
      case domain.LeadStatus.negotiation:
        return LeadListStatus.active; // Map negotiation to active for now
      case domain.LeadStatus.closed:
        return LeadListStatus.converted;
      case domain.LeadStatus.lost:
        return LeadListStatus.lost;
    }
  }
}
