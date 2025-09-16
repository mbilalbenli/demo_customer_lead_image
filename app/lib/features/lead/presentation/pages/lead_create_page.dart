import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/base_page.dart';
import '../view_models/lead_create_view_model.dart';
import '../states/lead_create_state.dart';
import '../organisms/lead_form_organism.dart';

/// Lead creation page with form validation
/// Following atomic design principles and base architecture
class LeadCreatePage extends BasePage<LeadCreateState> {
  const LeadCreatePage({super.key}) : super(
    initialShowAppBar: true,
    wrapWithScroll: true,
  );

  ProviderListenable<LeadCreateState> get vmProvider => leadCreateViewModelProvider;

  @override
  ConsumerState<LeadCreatePage> createState() => _LeadCreatePageState();
}

class _LeadCreatePageState extends BasePageState<LeadCreatePage, LeadCreateState> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  ProviderListenable<LeadCreateState> get vmProvider => leadCreateViewModelProvider;

  @override
  void initState() {
    super.initState();
    // Initialize view model
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leadCreateViewModelProvider.notifier).onInitWithContext(context);
    });
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('New Lead'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _handleCancel(context, ref),
      ),
      actions: [
        TextButton(
          onPressed: () => _handleSave(context, ref),
          child: Text(
            'Save',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vmProvider);

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
              status: state.status,
              isFormValid: state.isFormValid,
              hasChanges: false,
              isLoading: state.core.isBusy,
              onNameChanged: (value) {
                ref.read(leadCreateViewModelProvider.notifier).updateName(value);
              },
              onEmailChanged: (value) {
                ref.read(leadCreateViewModelProvider.notifier).updateEmail(value);
              },
              onPhoneChanged: (value) {
                ref.read(leadCreateViewModelProvider.notifier).updatePhone(value);
              },
              onCompanyChanged: (value) {
                ref.read(leadCreateViewModelProvider.notifier).updateCompany(value);
              },
              onNotesChanged: (value) {
                ref.read(leadCreateViewModelProvider.notifier).updateNotes(value);
              },
              onStatusChanged: (status) {
                ref.read(leadCreateViewModelProvider.notifier).updateStatus(status);
              },
              onSave: () {
                ref.read(leadCreateViewModelProvider.notifier).saveLead();
              },
              onCancel: () => context.pop(),
            ),
          ),
        ),

        // Error message
        if (state.errorMessage != null)
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
                    state.errorMessage!,
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

  void _handleSave(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(leadCreateViewModelProvider.notifier).saveLead();

      final state = ref.read(leadCreateViewModelProvider);
      if (state.errorMessage == null && context.mounted) {
        context.go('/leads');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lead created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _handleCancel(BuildContext context, WidgetRef ref) {
    if (_hasUnsavedChanges()) {
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
                context.go('/leads');
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
      context.go('/leads');
    }
  }

  bool _hasUnsavedChanges() {
    final state = ref.read(leadCreateViewModelProvider);
    return state.name.isNotEmpty ||
        state.email.isNotEmpty ||
        state.phone.isNotEmpty ||
        state.company.isNotEmpty ||
        state.notes.isNotEmpty;
  }

  // ignore: unused_element
  void _showAddImageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Images Later'),
        content: const Text(
          'You can add images after creating the lead. Save the lead first, then manage images from the lead details page.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}