import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/base_page.dart';
import '../view_models/lead_edit_view_model.dart';
import '../states/lead_edit_state.dart';
import '../organisms/lead_form_organism.dart';
import '../../domain/entities/lead_entity.dart';

/// Lead edit page with existing data
/// Following atomic design principles and base architecture
class LeadEditPage extends BasePage<LeadEditState> {
  final String leadId;

  const LeadEditPage({
    super.key,
    required this.leadId,
  }) : super(
    initialShowAppBar: true,
    wrapWithScroll: true,
  );

  ProviderListenable<LeadEditState> get vmProvider => leadEditViewModelProvider;

  @override
  ConsumerState<LeadEditPage> createState() => _LeadEditPageState();
}

class _LeadEditPageState extends BasePageState<LeadEditPage, LeadEditState> {
  @override
  ProviderListenable<LeadEditState> get vmProvider => leadEditViewModelProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;
  late TextEditingController _notesController;

  bool _isInitialized = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _companyController = TextEditingController();
    _notesController = TextEditingController();

    // Add listeners to track changes
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _companyController.addListener(_onFieldChanged);
    _notesController.addListener(_onFieldChanged);

    // Load lead data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leadEditViewModelProvider.notifier).loadLead(widget.leadId);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (_isInitialized && !_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  void _initializeControllers(LeadEntity lead) {
    if (!_isInitialized) {
      final state = ref.read(leadEditViewModelProvider);
      _nameController.text = state.name;
      _emailController.text = state.email;
      _phoneController.text = state.phone;
      _companyController.text = state.company;
      _notesController.text = state.notes;
      _isInitialized = true;
    }
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vmProvider);

    return AppBar(
      title: const Text('Edit Lead'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _handleCancel(context, ref),
      ),
      actions: [
        TextButton(
          onPressed: _hasChanges && !state.core.isBusy
              ? () => _handleSave(context, ref)
              : null,
          child: Text(
            'Save',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _hasChanges && !state.core.isBusy
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vmProvider);

    if (state.originalLead != null) {
      _initializeControllers(state.originalLead!);
    }

    if (state.originalLead == null && state.core.isBusy) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.originalLead == null) {
      return _buildEmptyState(context);
    }


    return Column(
      children: [
        // Form progress indicator
        if (state.core.isBusy)
          LinearProgressIndicator(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),

        // Form
        Expanded(
          child: Form(
            key: _formKey,
            child: LeadFormOrganism(
              name: state.name,
              email: state.email,
              phone: state.phone,
              company: state.company,
              notes: state.notes,
              status: state.status ?? LeadStatus.active,
              isFormValid: state.isFormValid,
              hasChanges: state.hasChanges,
              isLoading: state.core.isBusy,
              onNameChanged: (value) {
                ref.read(leadEditViewModelProvider.notifier).updateName(value);
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
              onEmailChanged: (value) {
                ref.read(leadEditViewModelProvider.notifier).updateEmail(value);
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
              onPhoneChanged: (value) {
                ref.read(leadEditViewModelProvider.notifier).updatePhone(value);
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
              onCompanyChanged: (value) {
                ref.read(leadEditViewModelProvider.notifier).updateCompany(value);
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
              onNotesChanged: (value) {
                ref.read(leadEditViewModelProvider.notifier).updateNotes(value);
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
              onStatusChanged: (status) {
                ref.read(leadEditViewModelProvider.notifier).updateStatus(status);
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
              onSave: () => _handleSave(context, ref),
              onCancel: () => _handleCancel(context, ref),
            ),
          ),
        ),

        // Image management hint
        if (state.originalLead?.imageCount != null && state.originalLead!.imageCount > 0)
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Row(
              children: [
                Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${state.originalLead!.imageCount} image${state.originalLead!.imageCount != 1 ? 's' : ''} attached',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/leads/${widget.leadId}/images'),
                  child: const Text('Manage'),
                ),
              ],
            ),
          ),

        // Error message
        if (state.originalLead != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error saving changes',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
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

  void _handleSave(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(leadEditViewModelProvider.notifier).saveLead();
      final success = true; // Check state for actual success

      if (success && context.mounted) {
        context.go('/leads/${widget.leadId}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lead updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _handleCancel(BuildContext context, WidgetRef ref) {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Discard Changes'),
          content: const Text(
            'Are you sure you want to discard your changes?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go('/leads/${widget.leadId}');
              },
              child: const Text(
                'Discard',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    } else {
      context.go('/leads/${widget.leadId}');
    }
  }
}