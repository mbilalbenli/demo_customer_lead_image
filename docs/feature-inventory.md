# Feature Inventory

This document captures the current minimal app features and structure after the redesign.

## Features
- splash
  - Domain/Data/Presentation for health checks
- main
  - Minimal white page with AppBar only

## Removed Features
- system_monitor (entire directory)
- settings (entire directory)
- home (replaced by `main`)
- core/navigation (router and routes)

## Directories under `app/lib/features`
```
app/lib/features/
├── main/
│   └── presentation/
│       ├── pages/main_page.dart
│       ├── providers/main_providers.dart
│       ├── states/main_state.dart
│       └── viewmodels/main_viewmodel.dart
└── splash/
    ├── data/
    │   ├── datasources/health_check_remote_datasource.dart
    │   ├── models/health_check_model.dart (+ generated)
    │   └── repositories/health_check_repository_impl.dart
    ├── domain/
    │   ├── entities/health_check_result.dart
    │   ├── repositories/health_check_repository.dart
    │   └── usecases/(check_*_usecase.dart)
    └── presentation/
        ├── pages/splash_page.dart
        ├── providers/splash_providers.dart
        ├── states/splash_state.dart
        └── widgets (atoms/molecules/organisms/templates)
```

## Core utilities preserved
- Core DI `core/di/injection_container.dart`
- Networking `core/infrastructure/network/`
- Base widgets `core/presentation/base/`
- Theme `core/theme/app_theme.dart`
- Localization `core/utils/temp_l10n.dart`

