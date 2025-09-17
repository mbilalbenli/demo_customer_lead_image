import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Simple app-wide navigation drawer organism
/// Keeps to Atomic Design (organism) and theme tokens
class AppNavigationDrawerOrganism extends StatelessWidget {
  const AppNavigationDrawerOrganism({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  l10n?.appTitle ?? 'App',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: Text(l10n?.leads ?? 'Leads'),
              onTap: () {
                Navigator.of(context).pop();
                // Navigation handled by callers via Router; keep simple here
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n?.settings ?? 'Settings'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

