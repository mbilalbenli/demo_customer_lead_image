import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_state.dart';

abstract class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});
}

abstract class BasePageState<T extends BasePage> extends BaseState<T> {
  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @protected
  Widget? buildFloatingActionButton() => null;

  @protected
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  @protected
  Widget? buildBottomNavigationBar() => null;

  @protected
  Widget? buildBottomSheet() => null;

  @protected
  Widget? buildDrawer() => null;

  @protected
  Widget? buildEndDrawer() => null;

  @protected
  Color? get backgroundColor => null;

  @protected
  bool get resizeToAvoidBottomInset => true;

  @protected
  bool get extendBody => false;

  @protected
  bool get extendBodyBehindAppBar => false;

  @protected
  bool get safeArea => true;

  @protected
  EdgeInsets get safePadding => EdgeInsets.zero;

  @protected
  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final body = buildBody(context);

    Widget content = Scaffold(
      appBar: buildAppBar(context),
      body: safeArea
          ? SafeArea(
              minimum: safePadding,
              child: body,
            )
          : body,
      floatingActionButton: buildFloatingActionButton(),
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: buildBottomNavigationBar(),
      bottomSheet: buildBottomSheet(),
      drawer: buildDrawer(),
      endDrawer: buildEndDrawer(),
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );

    return content;
  }

  @protected
  Widget buildLoadingOverlay({String? message}) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @protected
  Widget buildErrorWidget(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @protected
  Widget buildEmptyWidget({String? message, Widget? icon}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ??
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            const SizedBox(height: 16),
            Text(
              message ?? 'No data available',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}