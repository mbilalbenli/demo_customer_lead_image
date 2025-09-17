import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../atoms/lead_status_chip_atom.dart';
import '../../domain/entities/lead_entity.dart';

/// A feature-specific molecule for displaying lead information in a card
/// Composed from lead atoms and shows image count
/// Following atomic design principles - composed from atoms
class LeadCardMolecule extends StatefulWidget {
  final String leadName;
  final String? company;
  final String? email;
  final String? phone;
  final LeadStatus status;
  final int imageCount;
  final VoidCallback? onTap;
  final VoidCallback? onImagesTap;
  final bool showImageCount;
  final bool selected;
  final bool compact;

  const LeadCardMolecule({
    super.key,
    required this.leadName,
    this.company,
    this.email,
    this.phone,
    required this.status,
    required this.imageCount,
    this.onTap,
    this.onImagesTap,
    this.showImageCount = true,
    this.selected = false,
    this.compact = false,
  });

  @override
  State<LeadCardMolecule> createState() => _LeadCardMoleculeState();
}

class _LeadCardMoleculeState extends State<LeadCardMolecule>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.compact) {
      return _buildCompactCard(context, theme, colorScheme);
    } else {
      return _buildStandardCard(context, theme, colorScheme);
    }
  }

  Widget _buildStandardCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: widget.selected ? 0.1 : 0.05),
                  blurRadius: widget.selected ? 12 : 8,
                  offset: Offset(0, widget.selected ? 4 : 2),
                ),
              ],
            ),
            child: Material(
              color: widget.selected
                  ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                borderRadius: BorderRadius.circular(16),
                splashColor: colorScheme.primary.withValues(alpha: 0.1),
                highlightColor: colorScheme.primary.withValues(alpha: 0.05),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row with Avatar and Name
                      Row(
                        children: [
                          Hero(
                            tag: 'lead_avatar_${widget.leadName}_${widget.email}',
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorScheme.primary.withValues(alpha: 0.8),
                                    colorScheme.secondary.withValues(alpha: 0.8),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  widget.leadName.substring(0, widget.leadName.length >= 2 ? 2 : 1).toUpperCase(),
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.leadName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.company != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.company!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Status and Image Count
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              LeadStatusChipAtom(status: widget.status),
                              if (widget.showImageCount) ...[
                                const SizedBox(height: 6),
                                _buildImageCountBadge(colorScheme),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Contact Info Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            if (widget.email != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 16,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.email!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (widget.email != null && widget.phone != null)
                              const SizedBox(height: 8),
                            if (widget.phone != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    size: 16,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.phone!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: widget.selected
                  ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                borderRadius: BorderRadius.circular(12),
                splashColor: colorScheme.primary.withValues(alpha: 0.1),
                highlightColor: colorScheme.primary.withValues(alpha: 0.05),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.8),
                              colorScheme.secondary.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: Text(
                            widget.leadName.substring(0, widget.leadName.length >= 2 ? 2 : 1).toUpperCase(),
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.leadName,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                LeadStatusChipAtom(
                                  status: widget.status,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (widget.email != null) ...[
                                  Icon(
                                    Icons.email_outlined,
                                    size: 14,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.email!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (widget.showImageCount) ...[
                        const SizedBox(width: 8),
                        _buildImageCountBadge(colorScheme),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageCountBadge(ColorScheme colorScheme) {
    final bool isAtLimit = widget.imageCount >= 10;
    final bool isEmpty = widget.imageCount == 0;

    return InkWell(
      onTap: widget.onImagesTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isAtLimit
                ? [
                    colorScheme.error.withValues(alpha: 0.1),
                    colorScheme.errorContainer.withValues(alpha: 0.2),
                  ]
                : isEmpty
                    ? [
                        colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      ]
                    : [
                        colorScheme.primaryContainer.withValues(alpha: 0.3),
                        colorScheme.secondaryContainer.withValues(alpha: 0.2),
                      ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAtLimit
                ? colorScheme.error.withValues(alpha: 0.2)
                : colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEmpty ? Icons.add_a_photo_outlined : Icons.photo_library_outlined,
              size: 16,
              color: isAtLimit
                  ? colorScheme.error
                  : isEmpty
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              '${widget.imageCount}/10',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isAtLimit
                    ? colorScheme.error
                    : isEmpty
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid variant of the lead card for grid layouts
class LeadGridCardMolecule extends StatelessWidget {
  final String leadName;
  final String? company;
  final LeadStatus status;
  final int imageCount;
  final VoidCallback? onTap;
  final VoidCallback? onImagesTap;

  const LeadGridCardMolecule({
    super.key,
    required this.leadName,
    this.company,
    required this.status,
    required this.imageCount,
    this.onTap,
    this.onImagesTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.8),
                      colorScheme.secondary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    leadName.substring(0, leadName.length >= 2 ? 2 : 1).toUpperCase(),
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                leadName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (company != null) ...[
                const SizedBox(height: 4),
                Text(
                  company!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 8),
              LeadStatusChipAtom(status: status),
              const SizedBox(height: 8),
              if (onImagesTap != null)
                InkWell(
                  onTap: onImagesTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: imageCount >= 10
                          ? colorScheme.errorContainer
                          : colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 16,
                          color: imageCount >= 10
                              ? colorScheme.onErrorContainer
                              : colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$imageCount/10',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: imageCount >= 10
                                ? colorScheme.onErrorContainer
                                : colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}