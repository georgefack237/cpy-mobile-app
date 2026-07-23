import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/icons/myIcon.dart';
import '../../../../utils/icons/my_icons.dart';
import '../../../../utils/permissions.dart';

/// Handles the storage-permission flow for hymn audio downloads.
/// Previously two ~70-line near-identical dialog blocks duplicated
/// inline in HymnSongDetailsPage (one for iOS, one for pre-Android-11) —
/// now one method, one dialog builder.
class HymnDownloadPermissionHandler {
  /// Returns true if permission is already granted (or not required on
  /// this OS version). If not granted, shows the explainer dialog and
  /// returns false — the caller should ask again after the dialog flow.
  Future<bool> ensurePermission(BuildContext context) async {
    if (Platform.isIOS) {
      final status = await Permission.storage.status;
      if (status.isGranted) return true;
      _showPermissionDialog(context, status);
      return false;
    }

    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt > 30) {
      return true;
    }

    final status = await Permission.storage.status;
    if (status.isGranted) return true;

    _showPermissionDialog(context, status);
    return false;
  }

  void _showPermissionDialog(BuildContext context, PermissionStatus status) {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Theme(
          data: ThemeData(canvasColor: Colors.orange, dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            title: Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              height: MediaQuery.of(context).size.height * .21,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: MyIcon(color: Colors.white, icon: MyIcons.downloadIcon, size: 50),
              ),
            ),
            content: const Text(
              "L'enregistrement de l'audio nécessite l'accès au stockage.",
              style: TextStyle(color: Colors.black54, fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.w400),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Pas maintenant",
                  style: TextStyle(color: primary, fontFamily: "Poppins", fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(
                  "Continuer",
                  style: TextStyle(color: primary, fontFamily: "Poppins", fontSize: 15, fontWeight: FontWeight.w500),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (status.isDenied) {
                    await MyPermissionHandler.storagePermission(context);
                  } else if (status.isPermanentlyDenied) {
                    await openAppSettings();
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}