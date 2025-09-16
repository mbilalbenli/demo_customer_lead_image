import 'package:flutter/material.dart';
import '../atoms/lead_info_text_atom.dart';
import '../atoms/lead_action_button_atom.dart';

/// A feature-specific molecule for displaying lead contact information
/// Following atomic design principles - composed from atoms
class LeadContactInfoMolecule extends StatelessWidget {
  final String? email;
  final String? phone;
  final String? address;
  final String? company;
  final String? website;
  final VoidCallback? onEmailTap;
  final VoidCallback? onPhoneTap;
  final VoidCallback? onAddressTap;
  final VoidCallback? onWebsiteTap;
  final bool showActions;
  final bool compact;

  const LeadContactInfoMolecule({
    super.key,
    this.email,
    this.phone,
    this.address,
    this.company,
    this.website,
    this.onEmailTap,
    this.onPhoneTap,
    this.onAddressTap,
    this.onWebsiteTap,
    this.showActions = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactView(context);
    } else {
      return _buildStandardView(context);
    }
  }

  Widget _buildStandardView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (email != null) ...[
            Row(
              children: [
                Expanded(
                  child: LeadInfoTextAtom.email(
                    email: email!,
                    onTap: onEmailTap,
                  ),
                ),
                if (showActions)
                  LeadActionButtonAtom.email(
                    onPressed: onEmailTap,
                    size: ButtonSize.small,
                    showLabel: false,
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          if (phone != null) ...[
            Row(
              children: [
                Expanded(
                  child: LeadInfoTextAtom.phone(
                    phone: phone!,
                    onTap: onPhoneTap,
                  ),
                ),
                if (showActions)
                  LeadActionButtonAtom.call(
                    onPressed: onPhoneTap,
                    size: ButtonSize.small,
                    showLabel: false,
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          if (company != null) ...[
            LeadInfoTextAtom.company(
              company: company!,
            ),
            const SizedBox(height: 12),
          ],

          if (address != null) ...[
            LeadInfoTextAtom.address(
              address: address!,
              onTap: onAddressTap,
            ),
            const SizedBox(height: 12),
          ],

          if (website != null) ...[
            Row(
              children: [
                Expanded(
                  child: LeadInfoTextAtom(
                    label: 'Website',
                    value: website!,
                    icon: Icons.language,
                    onTap: onWebsiteTap,
                    copyable: true,
                  ),
                ),
                if (showActions)
                  IconButton(
                    icon: Icon(Icons.open_in_new),
                    iconSize: 18,
                    onPressed: onWebsiteTap,
                    tooltip: 'Open website',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactView(BuildContext context) {

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (email != null)
          LeadInfoBadgeAtom(
            text: email!,
            icon: Icons.email_outlined,
          ),
        if (phone != null)
          LeadInfoBadgeAtom(
            text: phone!,
            icon: Icons.phone_outlined,
          ),
        if (company != null)
          LeadInfoBadgeAtom(
            text: company!,
            icon: Icons.business_outlined,
          ),
      ],
    );
  }
}

/// A quick contact action bar for leads
class LeadQuickActionsMolecule extends StatelessWidget {
  final VoidCallback? onCall;
  final VoidCallback? onEmail;
  final VoidCallback? onMessage;
  final VoidCallback? onSchedule;
  final bool showLabels;
  final ButtonSize buttonSize;
  final MainAxisAlignment alignment;

  const LeadQuickActionsMolecule({
    super.key,
    this.onCall,
    this.onEmail,
    this.onMessage,
    this.onSchedule,
    this.showLabels = false,
    this.buttonSize = ButtonSize.medium,
    this.alignment = MainAxisAlignment.spaceEvenly,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (onCall != null)
          LeadActionButtonAtom.call(
            onPressed: onCall,
            size: buttonSize,
            showLabel: showLabels,
          ),
        if (onEmail != null)
          LeadActionButtonAtom.email(
            onPressed: onEmail,
            size: buttonSize,
            showLabel: showLabels,
          ),
        if (onMessage != null)
          LeadActionButtonAtom.message(
            onPressed: onMessage,
            size: buttonSize,
            showLabel: showLabels,
          ),
        if (onSchedule != null)
          LeadActionButtonAtom(
            actionType: LeadActionType.schedule,
            onPressed: onSchedule,
            size: buttonSize,
            showLabel: showLabels,
          ),
      ],
    );
  }
}