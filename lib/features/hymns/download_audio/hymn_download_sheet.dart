import 'package:flutter/material.dart';

import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/icons/myIcon.dart';
import '../../../../utils/icons/my_icons.dart';

/// "Download this audio" bottom sheet.
///
/// Structure: a centered hero icon badge (primary gradient) sets the
/// tone, file type/size are shown as two side-by-side stat chips
/// instead of a plain label/value list, and the CTA keeps its
/// accent/gold gradient — orange stays reserved for that one action
/// moment rather than spreading it across the whole sheet, so it still
/// draws the eye as the thing to tap.
class HymnDownloadActionsSheet extends StatelessWidget {
  const HymnDownloadActionsSheet({
    super.key,
    required this.fileType,
    required this.fileSizeMb,
    required this.onDownload,
  });

  final String fileType;
  final String fileSizeMb;
  final VoidCallback onDownload;

  static Future<void> show({
    required BuildContext context,
    required String fileType,
    required String fileSizeMb,
    required VoidCallback onDownload,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => HymnDownloadActionsSheet(
        fileType: fileType,
        fileSizeMb: fileSizeMb,
        onDownload: onDownload,
      ),
    );
  }

  Widget _statChip({required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: primaryLight.withOpacity(.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: dark.withOpacity(.65)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 24, offset: const Offset(0, -4)),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE4E4E4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Hero icon badge — gives the sheet a focal point instead of
          // opening straight into a text row, same soft-circle-icon
          // language as the error/offline states elsewhere.
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primary, primarySoft]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: primary.withOpacity(.25), blurRadius: 16, offset: const Offset(0, 6)),
                ],
              ),
              child: const Icon(Icons.audiotrack_rounded, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Télécharger l\'audio',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18, color: black),
          ),
          const SizedBox(height: 4),
          Text(
            'Écoutez ce cantique hors connexion',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 12.5, color: dark.withOpacity(.6)),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              _statChip(icon: Icons.description_outlined, label: 'Type', value: fileType.toUpperCase()),
              const SizedBox(width: 10),
              _statChip(icon: Icons.sd_storage_outlined, label: 'Taille', value: fileSizeMb),
            ],
          ),

          const SizedBox(height: 24),

          // CTA — accent/gold gradient, the one place orange shows up,
          // so it still reads as *the* action to take.
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              onDownload();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [accent, lightGradientOrange]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: accent.withOpacity(.3), blurRadius: 16, offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MyIcon(icon: MyIcons.download, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Télécharger',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}