import 'package:flutter/material.dart';
import '../atoms/app_text_field_atom.dart';
import '../atoms/app_icon_button_atom.dart';

/// A reusable search bar molecule composed of text field and action atoms
/// Following atomic design principles - composed from atoms
class AppSearchBarMolecule extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onFilter;
  final TextEditingController? controller;
  final bool showFilterButton;
  final bool enabled;
  final bool autofocus;
  final Widget? leading;
  final List<Widget>? actions;

  const AppSearchBarMolecule({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFilter,
    this.controller,
    this.showFilterButton = false,
    this.enabled = true,
    this.autofocus = false,
    this.leading,
    this.actions,
  });

  @override
  State<AppSearchBarMolecule> createState() => _AppSearchBarMoleculeState();
}

class _AppSearchBarMoleculeState extends State<AppSearchBarMolecule> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
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
          if (widget.leading != null) widget.leading!,
          Expanded(
            child: AppSearchFieldAtom(
              controller: _controller,
              hintText: widget.hintText,
              onSubmitted: widget.onSubmitted,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              onClear: _hasText ? _handleClear : null,
            ),
          ),
          if (widget.showFilterButton)
            AppIconButtonAtom(
              icon: Icons.filter_list,
              onPressed: widget.enabled ? widget.onFilter : null,
              tooltip: 'Filter',
              color: colorScheme.onSurfaceVariant,
            ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
    );
  }
}

/// A compact search bar variant for app bars
class AppBarSearchMolecule extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AppBarSearchMolecule({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            )
          : null,
      title: AppSearchFieldAtom(
        controller: controller,
        hintText: hintText ?? 'Search...',
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        autofocus: true,
      ),
      actions: actions,
    );
  }
}

/// A search bar with suggestions dropdown
class AppSearchBarWithSuggestionsMolecule extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSuggestionSelected;
  final Future<List<String>> Function(String) getSuggestions;
  final TextEditingController? controller;
  final bool enabled;

  const AppSearchBarWithSuggestionsMolecule({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    required this.getSuggestions,
    this.controller,
    this.enabled = true,
  });

  @override
  State<AppSearchBarWithSuggestionsMolecule> createState() =>
      _AppSearchBarWithSuggestionsMoleculeState();
}

class _AppSearchBarWithSuggestionsMoleculeState
    extends State<AppSearchBarWithSuggestionsMolecule> {
  late TextEditingController _controller;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() async {
    widget.onChanged?.call(_controller.text);

    if (_controller.text.isEmpty) {
      _removeOverlay();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await widget.getSuggestions(_controller.text);
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
        if (suggestions.isNotEmpty) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _removeOverlay();
      }
    }
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: context.findRenderObject()?.semanticBounds.width ?? 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 56),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () {
                      _controller.text = suggestion;
                      widget.onSuggestionSelected?.call(suggestion);
                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AppSearchBarMolecule(
        controller: _controller,
        hintText: widget.hintText,
        onSubmitted: widget.onSubmitted,
        enabled: widget.enabled,
        actions: _isLoading
            ? [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ]
            : null,
      ),
    );
  }
}