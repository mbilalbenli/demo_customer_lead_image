import 'package:flutter/material.dart';
import '../../domain/entities/lead_entity.dart';

/// A feature-specific atom for displaying lead status as a chip
/// Following atomic design principles - smallest lead-specific component
class LeadStatusChipAtom extends StatelessWidget {
  final LeadStatus status;
  final VoidCallback? onTap;
  final bool showIcon;
  final EdgeInsets? padding;
  final double? fontSize;

  const LeadStatusChipAtom({
    super.key,
    required this.status,
    this.onTap,
    this.showIcon = true,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final statusConfig = _getStatusConfig(status, colorScheme);

    Widget chip = Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusConfig.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusConfig.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              statusConfig.icon,
              size: 16,
              color: statusConfig.textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            statusConfig.label,
            style: TextStyle(
              color: statusConfig.textColor,
              fontSize: fontSize ?? 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      chip = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: chip,
      );
    }

    return chip;
  }

  _StatusConfig _getStatusConfig(LeadStatus status, ColorScheme colorScheme) {
    switch (status) {
      case LeadStatus.newLead:
        return _StatusConfig(
          label: 'New',
          icon: Icons.verified,
          backgroundColor: colorScheme.primaryContainer,
          borderColor: colorScheme.primary.withValues(alpha: 0.3),
          textColor: colorScheme.onPrimaryContainer,
        );
      case LeadStatus.contacted:
        return _StatusConfig(
          label: 'Contacted',
          icon: Icons.pause_circle,
          backgroundColor: colorScheme.secondaryContainer,
          borderColor: colorScheme.secondary.withValues(alpha: 0.3),
          textColor: colorScheme.onSecondaryContainer,
        );
      case LeadStatus.qualified:
        return _StatusConfig(
          label: 'Qualified',
          icon: Icons.star,
          backgroundColor: Colors.orange.shade50,
          borderColor: Colors.orange.shade300,
          textColor: Colors.orange.shade800,
        );
      case LeadStatus.proposal:
        return _StatusConfig(
          label: 'Proposal',
          icon: Icons.description,
          backgroundColor: Colors.purple.shade50,
          borderColor: Colors.purple.shade300,
          textColor: Colors.purple.shade800,
        );
      case LeadStatus.negotiation:
        return _StatusConfig(
          label: 'Negotiation',
          icon: Icons.handshake,
          backgroundColor: Colors.amber.shade50,
          borderColor: Colors.amber.shade300,
          textColor: Colors.amber.shade800,
        );
      case LeadStatus.closed:
        return _StatusConfig(
          label: 'Closed',
          icon: Icons.check_circle,
          backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.1),
          borderColor: const Color(0xFF4CAF50).withValues(alpha: 0.3),
          textColor: const Color(0xFF2E7D32),
        );
      case LeadStatus.lost:
        return _StatusConfig(
          label: 'Lost',
          icon: Icons.cancel,
          backgroundColor: colorScheme.errorContainer,
          borderColor: colorScheme.error.withValues(alpha: 0.3),
          textColor: colorScheme.onErrorContainer,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _StatusConfig({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

/// A mini version of the status chip
class LeadStatusDotAtom extends StatelessWidget {
  final LeadStatus status;
  final double size;
  final bool showTooltip;

  const LeadStatusDotAtom({
    super.key,
    required this.status,
    this.size = 8,
    this.showTooltip = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _getStatusColor(status, colorScheme);

    Widget dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );

    if (showTooltip) {
      dot = Tooltip(
        message: _getStatusLabel(status),
        child: dot,
      );
    }

    return dot;
  }

  Color _getStatusColor(LeadStatus status, ColorScheme colorScheme) {
    switch (status) {
      case LeadStatus.newLead:
        return colorScheme.primary;
      case LeadStatus.contacted:
        return colorScheme.secondary;
      case LeadStatus.qualified:
        return Colors.orange;
      case LeadStatus.proposal:
        return Colors.purple;
      case LeadStatus.negotiation:
        return Colors.amber;
      case LeadStatus.closed:
        return const Color(0xFF4CAF50);
      case LeadStatus.lost:
        return colorScheme.error;
    }
  }

  String _getStatusLabel(LeadStatus status) {
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