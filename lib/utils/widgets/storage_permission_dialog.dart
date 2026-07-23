import 'package:flutter/material.dart';

import '../../features/download_app_resources/storage_permission.dart';
import '../../utils/colors/light_colors.dart';
import '../../utils/icons/myIcon.dart';
import '../../utils/icons/my_icons.dart';

/// Shows the "why we need this" rationale dialog and, if the person taps
/// Accepter, actually requests the permission and returns the result —
/// so the caller never has to guess whether anything happened.
Future<StoragePermissionResult> showStoragePermissionDialog(BuildContext context) async {
  final result = await showDialog<StoragePermissionResult>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Theme(
        data: ThemeData(
          canvasColor: Colors.orange,
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        child: AlertDialog(
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Container(
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30),
            width: double.infinity,
            child: const Center(
              child: MyIcon(color: Colors.white, icon: MyIcons.downloadIcon, size: 46),
            ),
          ),
          content: const Text(
            "Cette permission permet à l'application de créer et d'enregistrer les fichiers téléchargés (cantiques, lexique)",
            style: TextStyle(color: dark, fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(StoragePermissionResult.denied),
              child: const Text(
                "Pas maintenant",
                style: TextStyle(color: muted, fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            TextButton(
              onPressed: () async {
                final requestResult = await StoragePermissionService().request();
                if (context.mounted) Navigator.of(context).pop(requestResult);
              },
              child: const Text(
                "Accepter",
                style: TextStyle(color: primary, fontFamily: "Poppins", fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
    },
  );

  return result ?? StoragePermissionResult.denied;
}