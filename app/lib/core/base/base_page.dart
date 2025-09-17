import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_state.dart';
import '../widgets/app_loader.dart';

/// Content placement enum for BasePage
enum ContentPlacement {
  center,
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

abstract class BasePage<T extends BaseState> extends ConsumerStatefulWidget {
  final bool wrapWithScroll;
  final bool initialShowAppBar;

  const BasePage({
    super.key,
    this.wrapWithScroll = true,
    this.initialShowAppBar = false,
  });

  @override
  ConsumerState<BasePage<T>> createState();
}

abstract class BasePageState<P extends BasePage<T>, T extends BaseState> extends ConsumerState<P> {
  /// Must be implemented to provide the view model provider
  ProviderListenable<T> get vmProvider;

  /// Must be implemented to build the main page content
  Widget buildPage(BuildContext context, WidgetRef ref);

  /// Optional: Override to provide custom AppBar
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) => null;

  /// Optional: Override to provide custom FloatingActionButton
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) => null;

  /// Optional: Override to change content placement
  ContentPlacement get contentPlacement => ContentPlacement.center;

  /// Optional: Override to change the title
  String get title => 'Base Page';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vmProvider);

    // Get the AppBar - either from state or custom implementation
    final appBar = state.showAppBar || widget.initialShowAppBar
        ? (buildAppBar(context, ref) ?? AppBar(title: Text(state.title.isNotEmpty ? state.title : title)))
        : null;

    // Build main content
    Widget content = buildPage(context, ref);

    // Wrap with scroll if requested
    if (widget.wrapWithScroll) {
      content = SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                (appBar?.preferredSize.height ?? 0) -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: content,
        ),
      );
    }

    // Apply content placement
    content = _applyContentPlacement(content);

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Stack(
          children: [
            content,
            // Add AppLoader overlay
            AppLoader(
              isLoading: state.isBusy,
              loadingKey: state.widgetKeyForLoadingPosition,
              loadingMessage: state.busyOperation,
            ),
          ],
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context, ref),
    );
  }

  Widget _applyContentPlacement(Widget child) {
    switch (contentPlacement) {
      case ContentPlacement.center:
        return Center(child: child);
      case ContentPlacement.topLeft:
        return Align(alignment: Alignment.topLeft, child: child);
      case ContentPlacement.topCenter:
        return Align(alignment: Alignment.topCenter, child: child);
      case ContentPlacement.topRight:
        return Align(alignment: Alignment.topRight, child: child);
      case ContentPlacement.centerLeft:
        return Align(alignment: Alignment.centerLeft, child: child);
      case ContentPlacement.centerRight:
        return Align(alignment: Alignment.centerRight, child: child);
      case ContentPlacement.bottomLeft:
        return Align(alignment: Alignment.bottomLeft, child: child);
      case ContentPlacement.bottomCenter:
        return Align(alignment: Alignment.bottomCenter, child: child);
      case ContentPlacement.bottomRight:
        return Align(alignment: Alignment.bottomRight, child: child);
    }
  }
}