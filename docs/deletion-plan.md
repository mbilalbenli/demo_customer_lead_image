# Deletion Plan (Executed)

Removed code and assets to achieve minimal app:

## Directories removed
- app/lib/features/system_monitor/
- app/lib/features/settings/
- app/lib/features/home/
- app/lib/core/navigation/
- app/test/features/

## Files removed (examples)
- app/lib/core/navigation/app_router.dart
- app/lib/core/navigation/route_names.dart
- app/lib/core/navigation/route_paths.dart
- app/test/widget_test.dart

## Pubspec cleanup
- Removed: go_router, flutter_animate, skeletonizer, mockito, dotted_border, http, dartz, image, local_auth, flutter_secure_storage, exif, icons_plus, flutter_native_splash
- Kept: flutter_riverpod, get_it, dio, freezed_annotation, json_annotation, shared_preferences, logger, flutter_dotenv
- Dev: build_runner, freezed, json_serializable, flutter_lints, flutter_test, integration_test

## Post‑cleanup validation
- Ran code generation via build_runner
- flutter analyze → No issues found

