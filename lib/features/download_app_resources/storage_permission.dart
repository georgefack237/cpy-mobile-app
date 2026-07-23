
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

enum StoragePermissionResult { granted, denied, permanentlyDenied }

/// Centralizes the platform-specific storage-permission logic that was
/// previously copy-pasted (with tiny inconsistencies) across at least three
/// files. Deliberately has no BuildContext / UI concerns — showing a
/// rationale dialog or an app-settings prompt is the caller's job (see
/// `storage_permission_dialog.dart`), this service only answers "what's the
/// actual platform permission state right now".
class StoragePermissionService {
  /// iOS apps can write into their own sandboxed Documents directory
  /// without any system permission prompt — "storage permission" is an
  /// Android-only concept, so this is always `granted` on iOS.
  Future<StoragePermissionResult> check() async {
    if (Platform.isIOS) return StoragePermissionResult.granted;

    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    // Scoped storage (API 30+) doesn't need the legacy runtime permission
    // for app-owned directories.
    if (deviceInfo.version.sdkInt > 30) return StoragePermissionResult.granted;

    final status = await Permission.storage.status;
    if (status.isGranted) return StoragePermissionResult.granted;
    if (status.isPermanentlyDenied) return StoragePermissionResult.permanentlyDenied;
    return StoragePermissionResult.denied;
  }

  Future<StoragePermissionResult> request() async {
    if (Platform.isIOS) return StoragePermissionResult.granted;

    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt > 30) return StoragePermissionResult.granted;

    final status = await Permission.storage.request();
    if (status.isGranted) return StoragePermissionResult.granted;
    if (status.isPermanentlyDenied) return StoragePermissionResult.permanentlyDenied;
    return StoragePermissionResult.denied;
  }
}