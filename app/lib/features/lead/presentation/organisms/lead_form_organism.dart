import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_text_field_atom.dart';
import '../../../../core/widgets/atoms/app_button_atom.dart';
import '../atoms/lead_status_badge_atom.dart';
import '../../domain/entities/lead_entity.dart';

class LeadFormOrganism extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String company;
  final String notes;
  final LeadStatus status;
  final bool isFormValid;
  final bool hasChanges;
  final bool isLoading;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onCompanyChanged;
  final ValueChanged<String> onNotesChanged;
  final ValueChanged<LeadStatus> onStatusChanged;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  const LeadFormOrganism({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.notes,
    required this.status,
    required this.isFormValid,
    required this.hasChanges,
    required this.isLoading,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onCompanyChanged,
    required this.onNotesChanged,
    required this.onStatusChanged,
    required this.onSave,
    this.onCancel,
  });

  @override
  State<LeadFormOrganism> createState() => _LeadFormOrganismState();
}

class _LeadFormOrganismState extends State<LeadFormOrganism> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _companyController = TextEditingController(text: widget.company);
    _notesController = TextEditingController(text: widget.notes);
  }

  @override
  void didUpdateWidget(LeadFormOrganism oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name) {
      _nameController.text = widget.name;
    }
    if (oldWidget.email != widget.email) {
      _emailController.text = widget.email;
    }
    if (oldWidget.phone != widget.phone) {
      _phoneController.text = widget.phone;
    }
    if (oldWidget.company != widget.company) {
      _companyController.text = widget.company;
    }
    if (oldWidget.notes != widget.notes) {
      _notesController.text = widget.notes;
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Section
          Row(
            children: [
              Text(
                'Status:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              LeadStatusBadgeAtom(status: widget.status),
            ],
          ),

          const SizedBox(height: 24),

          // Basic Information
          Text(
            'Basic Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          AppTextFieldAtom(
            controller: _nameController,
            labelText: 'Full Name *',
            onChanged: widget.onNameChanged,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            prefixIcon: const Icon(Icons.person),
          ),

          const SizedBox(height: 16),

          AppTextFieldAtom(
            controller: _emailController,
            labelText: 'Email Address *',
            onChanged: widget.onEmailChanged,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email),
          ),

          const SizedBox(height: 16),

          AppTextFieldAtom(
            controller: _phoneController,
            labelText: 'Phone Number',
            onChanged: widget.onPhoneChanged,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone),
          ),

          const SizedBox(height: 16),

          AppTextFieldAtom(
            controller: _companyController,
            labelText: 'Company',
            onChanged: widget.onCompanyChanged,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            prefixIcon: const Icon(Icons.business),
          ),

          const SizedBox(height: 24),

          // Status Selection
          Text(
            'Lead Status',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<LeadStatus>(
            initialValue: widget.status,
            decoration: InputDecoration(
              labelText: 'Status',
              prefixIcon: const Icon(Icons.flag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: LeadStatus.values.map((LeadStatus value) {
              return DropdownMenuItem<LeadStatus>(
                value: value,
                child: Text(_getStatusDisplayName(value)),
              );
            }).toList(),
            onChanged: (LeadStatus? value) {
              if (value != null) {
                widget.onStatusChanged(value);
              }
            },
          ),

          const SizedBox(height: 24),

          // Notes
          Text(
            'Notes',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          AppTextFieldAtom(
            controller: _notesController,
            labelText: 'Additional Notes',
            onChanged: widget.onNotesChanged,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            prefixIcon: const Icon(Icons.notes),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              if (widget.onCancel != null) ...[
                Expanded(
                  child: AppButtonAtom.secondary(
                    text: 'Cancel',
                    onPressed: widget.onCancel,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: AppButtonAtom.primary(
                  text: 'Save Lead',
                  onPressed: (widget.isFormValid && widget.hasChanges && !widget.isLoading) ? widget.onSave : null,
                  isLoading: widget.isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusDisplayName(LeadStatus status) {
    switch (status) {
      case LeadStatus.active:
        return 'Active';
      case LeadStatus.inactive:
        return 'Inactive';
      case LeadStatus.converted:
        return 'Converted';
      case LeadStatus.lost:
        return 'Lost';
    }
  }
}