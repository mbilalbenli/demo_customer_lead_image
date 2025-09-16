import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/base_page.dart';
import '../states/lead_search_state.dart';
import '../providers/lead_providers.dart';
import '../organisms/lead_list_organism.dart';
import '../molecules/lead_filter_chip_molecule.dart';
import '../atoms/empty_state_atom.dart';
import '../../domain/entities/lead_entity.dart';

/// Lead search page with filters and results
/// Following atomic design principles and base architecture
class LeadSearchPage extends BasePage<LeadSearchState> {
  const LeadSearchPage({super.key}) : super(
    initialShowAppBar: false,
    wrapWithScroll: false,
  );

  @override
  ConsumerState<LeadSearchPage> createState() => _LeadSearchPageState();
}

class _LeadSearchPageState extends BasePageState<LeadSearchPage, LeadSearchState> {
  late TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();

  @override
  ProviderListenable<LeadSearchState> get vmProvider => leadSearchViewModelProvider;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vmProvider);

    return Column(
      children: [
        // Custom search app bar
        _buildSearchHeader(context, ref, state),

        // Filters
        if (state.availableFilters.isNotEmpty)
          _buildFilterSection(context, ref, state),

        // Search results count
        if (state.searchQuery.isNotEmpty || state.activeFilters.isNotEmpty)
          _buildResultsCount(context, state),

        // Results
        Expanded(
          child: _buildResults(context, ref, state),
        ),
      ],
    );
  }

  Widget _buildSearchHeader(BuildContext context, WidgetRef ref, LeadSearchState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/leads'),
              ),

              // Search field
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  decoration: InputDecoration(
                    hintText: 'Search leads by name, email, or phone...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(leadSearchViewModelProvider.notifier).clearSearch();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(leadSearchViewModelProvider.notifier).search(value);
                  },
                  onSubmitted: (value) {
                    ref.read(leadSearchViewModelProvider.notifier).search(value);
                  },
                  textInputAction: TextInputAction.search,
                ),
              ),

              // Filter button
              if (state.availableFilters.isNotEmpty)
                IconButton(
                  icon: Badge(
                    isLabelVisible: state.activeFilters.isNotEmpty,
                    label: Text('${state.activeFilters.length}'),
                    child: const Icon(Icons.filter_list),
                  ),
                  onPressed: () => _showFilterDialog(context, ref),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context, WidgetRef ref, LeadSearchState state) {
    if (state.activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...state.activeFilters.map((filter) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: LeadFilterChipMolecule(
              label: filter,
              filterType: FilterType.status,
              selected: true,
              onRemove: () {
                ref.read(leadSearchViewModelProvider.notifier).removeFilter(filter);
              },
            ),
          )),
          TextButton.icon(
            onPressed: () {
              ref.read(leadSearchViewModelProvider.notifier).clearFilters();
            },
            icon: const Icon(Icons.clear_all, size: 18),
            label: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCount(BuildContext context, LeadSearchState state) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${state.results.length} result${state.results.length != 1 ? 's' : ''} found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (state.isSearching)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, WidgetRef ref, LeadSearchState state) {
    if (state.isSearching && state.results.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.errorMessage != null) {
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
              'Error searching leads',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(leadSearchViewModelProvider.notifier).search(_searchController.text);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.searchQuery.isEmpty && state.activeFilters.isEmpty) {
      return const Center(
        child: EmptyStateAtom(
          icon: Icons.search,
          title: 'Start Searching',
          subtitle: 'Enter a search term or apply filters to find leads',
        ),
      );
    }

    if (state.results.isEmpty) {
      return const Center(
        child: EmptyStateAtom(
          icon: Icons.search_off,
          title: 'No Results Found',
          subtitle: 'Try adjusting your search or filters',
        ),
      );
    }

    return LeadListOrganism(
      leads: state.results.map((lead) => LeadItemData(
        id: lead.id,
        name: lead.customerName.value,
        company: null, // Add if needed
        email: lead.email.value,
        phone: lead.phone.value,
        status: _convertLeadStatus(lead.status),
        imageCount: lead.imageCount,
      )).toList(),
      isLoading: state.isLoadingMore,
      onLeadTap: (lead) {
        context.go('/leads/${lead.id}');
      },
      onLeadImagesTap: (lead) {
        context.go('/leads/${lead.id}/images');
      },
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Leads',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // Add filter options here
              const Text('Filter options coming soon...'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Apply filters
                      Navigator.of(sheetContext).pop();
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  LeadListStatus _convertLeadStatus(LeadStatus status) {
    switch (status) {
      case LeadStatus.active:
        return LeadListStatus.active;
      case LeadStatus.inactive:
        return LeadListStatus.inactive;
      case LeadStatus.converted:
        return LeadListStatus.converted;
      case LeadStatus.lost:
        return LeadListStatus.lost;
    }
  }
}