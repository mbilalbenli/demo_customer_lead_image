import 'package:flutter/material.dart';

typedef WidgetBuilderFn = Widget Function(BuildContext context);

class ErrorBoundary extends StatefulWidget {
  final WidgetBuilderFn builder;
  final Widget? fallback;

  const ErrorBoundary({super.key, required this.builder, this.fallback});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallback ?? _defaultFallback(context, _error!);
    }
    try {
      return widget.builder(context);
    } catch (e) {
      setState(() => _error = e);
      return widget.fallback ?? _defaultFallback(context, e);
    }
  }

  Widget _defaultFallback(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text('Something went wrong', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(error.toString(), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => setState(() => _error = null),
              child: const Text('Retry'),
            )
          ],
        ),
      ),
    );
  }
}

