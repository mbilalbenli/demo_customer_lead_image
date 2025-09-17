import 'package:permission_handler/permission_handler.dart';
import '../../utils/app_logger.dart';

class PermissionService {
  Future<bool> requestCameraPermission() async {
    try {
      AppLogger.info('Requesting camera permission');

      final status = await Permission.camera.status;
      if (status.isGranted) {
        AppLogger.info('Camera permission already granted');
        return true;
      }

      if (status.isPermanentlyDenied) {
        AppLogger.warning('Camera permission permanently denied');
        await openAppSettings();
        return false;
      }

      final result = await Permission.camera.request();
      final granted = result.isGranted;

      if (granted) {
        AppLogger.info('Camera permission granted');
      } else {
        AppLogger.warning('Camera permission denied');
      }

      return granted;
    } catch (e) {
      AppLogger.error('Failed to request camera permission', e);
      return false;
    }
  }

  Future<bool> requestStoragePermission() async {
    try {
      AppLogger.info('Requesting storage permission');

      // For Android 13+ (API 33+), we need to use photos permission
      if (await Permission.photos.status.isDenied) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }

      // For older Android versions
      final status = await Permission.storage.status;
      if (status.isGranted) {
        AppLogger.info('Storage permission already granted');
        return true;
      }

      if (status.isPermanentlyDenied) {
        AppLogger.warning('Storage permission permanently denied');
        await openAppSettings();
        return false;
      }

      final result = await Permission.storage.request();
      final granted = result.isGranted;

      if (granted) {
        AppLogger.info('Storage permission granted');
      } else {
        AppLogger.warning('Storage permission denied');
      }

      return granted;
    } catch (e) {
      AppLogger.error('Failed to request storage permission', e);
      return false;
    }
  }

  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    try {
      AppLogger.info('Requesting multiple permissions: ${permissions.length}');
      return await permissions.request();
    } catch (e) {
      AppLogger.error('Failed to request multiple permissions', e);
      return {};
    }
  }

  Future<bool> checkPermission(Permission permission) async {
    try {
      final status = await permission.status;
      return status.isGranted;
    } catch (e) {
      AppLogger.error('Failed to check permission', e);
      return false;
    }
  }

  Future<bool> shouldShowRequestRationale(Permission permission) async {
    try {
      final status = await permission.status;
      return status.isDenied && !status.isPermanentlyDenied;
    } catch (e) {
      AppLogger.error('Failed to check permission rationale', e);
      return false;
    }
  }

  Future<void> openSettings() async {
    try {
      AppLogger.info('Opening app settings');
      await openAppSettings();
    } catch (e) {
      AppLogger.error('Failed to open app settings', e);
    }
  }
}