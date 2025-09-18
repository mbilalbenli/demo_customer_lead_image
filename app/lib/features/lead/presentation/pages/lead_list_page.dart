import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../drawers/create_lead_drawer.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/base/base_page.dart';
import '../providers/lead_providers.dart';
import '../states/lead_list_state.dart';
import '../organisms/lead_list_organism.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/lead_entity.dart' as domain;

class LeadListPage extends BasePage<LeadListState> {
  const LeadListPage({super.key}) : super(
    initialShowAppBar: true,
    wrapWithScroll: false,
  );

  @override 
  ConsumerState<LeadListPage> createState() => _LeadListPageState();
}

class _LeadListPageState extends BasePageState<LeadListPage, LeadListState>
    with TickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  ProviderListenable<LeadListState> get vmProvider => leadListViewModelProvider;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeOutCubic,
    );
    _searchAnimationController.forward();
  }


  @override
  void dispose() {
    _searchAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(leadListViewModelProvider);

    return AppBar(
      title: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          l10n?.customerLeads ?? 'Customer Leads',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: theme.brightness,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      actions: [
        // Lead count badge
        if (state.leads.isNotEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${state.leads.length} ${state.leads.length == 1 ? 'lead' : 'leads'}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (ctx) => FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          // Open the bottom sheet instead of drawer
          showModalBottomSheet(
            context: ctx,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CreateLeadDrawer(
              onCreated: () async {
                await ref.read(leadListViewModelProvider.notifier).fetchLeads(refresh: true);
                if (context.mounted) Navigator.pop(context);
              },
            ),
          );
        },
        tooltip: 'Add Lead',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget? buildEndDrawer(BuildContext context, WidgetRef ref) {
    return null; // No longer using end drawer
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leadListViewModelProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (state.errorMessage != null) {
      return _buildErrorState(context, ref, state, theme);
    }

    if (state.leads.isEmpty && !state.isBusy) {
      return _buildEmptyStateWithSearch(context, ref, state, l10n, theme);
    }

    return Column(
      children: [
        // Enhanced Search bar
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.5),
            end: Offset.zero,
          ).animate(_searchAnimation),
          child: FadeTransition(
            opacity: _searchAnimation,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: l10n?.search ?? 'Search',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(leadListViewModelProvider.notifier).searchLeads('');
                            HapticFeedback.lightImpact();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {});
                  ref.read(leadListViewModelProvider.notifier).searchLeads(value);
                },
              ),
            ),
          ),
        ),
        // Lead list with enhanced styling
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: RefreshIndicator(
              onRefresh: () async {
                HapticFeedback.mediumImpact();
                await ref.read(leadListViewModelProvider.notifier).fetchLeads(refresh: true);
              },
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
              child: LeadListOrganism(
                leads: state.leads.map((lead) => _convertToLeadItemData(lead)).toList(),
                isLoading: state.isLoadingMore,
                searchQuery: _searchController.text,
                onLeadTap: (lead) {
                  HapticFeedback.lightImpact();
                  context.go(RouteNames.getLeadDetailPath(lead.id));
                },
                onLeadImagesTap: (lead) {
                  HapticFeedback.lightImpact();
                  context.go(RouteNames.getLeadDetailPath(lead.id));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    LeadListState state,
    ThemeData theme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 64,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Connection Error',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'Unable to load leads',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(leadListViewModelProvider.notifier).fetchLeads(refresh: true);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateWithSearch(
    BuildContext context,
    WidgetRef ref,
    LeadListState state,
    AppLocalizations? l10n,
    ThemeData theme,
  ) {
    return Column(
      children: [
        // Search bar always visible
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            enabled: !state.isBusy,
            decoration: InputDecoration(
              hintText: l10n?.search ?? 'Search',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {});
              ref.read(leadListViewModelProvider.notifier).searchLeads(value);
            },
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                          theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_outline_rounded,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n?.noLeadsFound ?? 'No leads yet',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Start building your customer base',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
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
        return LeadListStatus.active;
      case domain.LeadStatus.proposal:
        return LeadListStatus.active;
      case domain.LeadStatus.negotiation:
        return LeadListStatus.active;
      case domain.LeadStatus.closed:
        return LeadListStatus.converted;
      case domain.LeadStatus.lost:
        return LeadListStatus.lost;
    }
  }
}
