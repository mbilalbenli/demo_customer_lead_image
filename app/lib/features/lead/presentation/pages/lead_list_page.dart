import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/base_page.dart';
import '../providers/lead_providers.dart';
import '../states/lead_list_state.dart';
import '../organisms/lead_list_organism.dart';
import '../atoms/empty_state_atom.dart';
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
    final state = ref.watch(leadListViewModelProvider);
    return AppBar(
      title: Text(state.title),
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.go('/leads/search');
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            context.go('/leads/create');
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.read(leadListViewModelProvider.notifier).fetchLeads(refresh: true);
          },
        ),
      ],
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        context.go('/leads/create');
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leadListViewModelProvider);

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
              decoration: InputDecoration(
                hintText: 'Search leads...',
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
          const Expanded(
            child: EmptyStateAtom(
              icon: Icons.people_outline,
              title: 'No Leads Found',
              subtitle: 'Start by adding your first lead',
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
              hintText: 'Search leads...',
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
                context.go('/leads/${lead.id}');
              },
              onLeadImagesTap: (lead) {
                context.go('/leads/${lead.id}/images');
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
      case domain.LeadStatus.active:
        return LeadListStatus.active;
      case domain.LeadStatus.inactive:
        return LeadListStatus.inactive;
      case domain.LeadStatus.converted:
        return LeadListStatus.converted;
      case domain.LeadStatus.lost:
        return LeadListStatus.lost;
    }
  }
}