import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_button_atom.dart';
import '../../domain/entities/lead_entity.dart';

class LeadActionBarMolecule extends StatelessWidget {
  final LeadEntity lead;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isLoading;

  const LeadActionBarMolecule({
    super.key,
    required this.lead,
    required this.onEdit,
    required this.onDelete,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Actions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Primary Actions
            Row(
              children: [
                Expanded(
                  child: AppButtonAtom.primary(
                    text: 'Edit Lead',
                    onPressed: !isLoading ? onEdit : null,
                    icon: Icons.edit,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButtonAtom.secondary(
                    text: 'Contact',
                    onPressed: !isLoading ? () => _showContactOptions(context) : null,
                    icon: Icons.contact_page,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Status Actions
            if (lead.status != LeadStatus.closed) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatusButton(
                      context,
                      'Mark Active',
                      Icons.check_circle,
                      LeadStatus.newLead,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusButton(
                      context,
                      'Mark Converted',
                      Icons.star,
                      LeadStatus.closed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Danger Zone
            const Divider(),
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: colorScheme.error,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Danger Zone',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: AppButtonAtom.danger(
                text: 'Delete Lead',
                onPressed: !isLoading ? () => _showDeleteConfirmation(context) : null,
                icon: Icons.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String text,
    IconData icon,
    LeadStatus targetStatus,
  ) {
    if (lead.status == targetStatus) {
      return const SizedBox.shrink();
    }

    return OutlinedButton.icon(
      onPressed: !isLoading ? () => _changeStatus(context, targetStatus) : null,
      icon: Icon(icon),
      label: Text(text),
    );
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact ${lead.customerName.value}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Send Email'),
              subtitle: Text(lead.email.value),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement email functionality
              },
            ),

            if (lead.phone.value.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Phone'),
                subtitle: Text(lead.phone.value),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Implement phone functionality
                },
              ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeStatus(BuildContext context, LeadStatus newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Lead Status'),
        content: Text(
          'Are you sure you want to change the status of "${lead.customerName.value}" to ${_getStatusName(newStatus)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement status change
            },
            child: const Text('Change Status'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lead'),
        content: Text(
          'Are you sure you want to delete "${lead.customerName.value}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getStatusName(LeadStatus status) {
    switch (status) {
      case LeadStatus.newLead:
        return 'New';
      case LeadStatus.contacted:
        return 'Contacted';
      case LeadStatus.qualified:
        return 'Qualified';
      case LeadStatus.proposal:
        return 'Proposal';
      case LeadStatus.negotiation:
        return 'Negotiation';
      case LeadStatus.closed:
        return 'Closed';
      case LeadStatus.lost:
        return 'Lost';
    }
  }
}