import 'package:flutter/material.dart';
import '../../domain/entities/lead_entity.dart';

class LeadStatusBadgeAtom extends StatelessWidget {
  final LeadStatus status;
  final bool isCompact;

  const LeadStatusBadgeAtom({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getStatusColors(theme);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
        border: Border.all(
          color: colors.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isCompact ? 6 : 8,
            height: isCompact ? 6 : 8,
            decoration: BoxDecoration(
              color: colors.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isCompact ? 4 : 6),
          Text(
            _getStatusText(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textColor,
              fontWeight: FontWeight.w500,
              fontSize: isCompact ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
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

  _StatusColors _getStatusColors(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (status) {
      case LeadStatus.newLead:
        return _StatusColors(
          backgroundColor: Colors.green.shade50,
          borderColor: Colors.green.shade200,
          textColor: Colors.green.shade800,
          dotColor: Colors.green.shade600,
        );
      case LeadStatus.contacted:
        return _StatusColors(
          backgroundColor: Colors.grey.shade50,
          borderColor: Colors.grey.shade200,
          textColor: Colors.grey.shade800,
          dotColor: Colors.grey.shade600,
        );
      case LeadStatus.qualified:
        return _StatusColors(
          backgroundColor: Colors.orange.shade50,
          borderColor: Colors.orange.shade200,
          textColor: Colors.orange.shade800,
          dotColor: Colors.orange.shade600,
        );
      case LeadStatus.proposal:
        return _StatusColors(
          backgroundColor: Colors.purple.shade50,
          borderColor: Colors.purple.shade200,
          textColor: Colors.purple.shade800,
          dotColor: Colors.purple.shade600,
        );
      case LeadStatus.negotiation:
        return _StatusColors(
          backgroundColor: Colors.amber.shade50,
          borderColor: Colors.amber.shade200,
          textColor: Colors.amber.shade800,
          dotColor: Colors.amber.shade600,
        );
      case LeadStatus.closed:
        return _StatusColors(
          backgroundColor: Colors.blue.shade50,
          borderColor: Colors.blue.shade200,
          textColor: Colors.blue.shade800,
          dotColor: Colors.blue.shade600,
        );
      case LeadStatus.lost:
        return _StatusColors(
          backgroundColor: colorScheme.errorContainer,
          borderColor: colorScheme.error.withValues(alpha: 0.3),
          textColor: colorScheme.onErrorContainer,
          dotColor: colorScheme.error,
        );
    }
  }
}

class _StatusColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color dotColor;

  const _StatusColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.dotColor,
  });
}