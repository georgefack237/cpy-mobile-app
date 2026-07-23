import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';

/// Shared error / no-connection state — soft icon circle, title,
/// optional message, and one or two full-width rounded buttons. Used
/// wherever a screen needs to show "something went wrong" or "no
/// internet" instead of a bare `Text(provider.error!)`.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    required this.primaryLabel,
    required this.onPrimaryAction,
    this.secondaryLabel,
    this.onSecondaryAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String primaryLabel;
  final VoidCallback onPrimaryAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fontSizes.font15(context.screenSize),
                fontWeight: FontWeight.w600,
                color: black,
              ),
            ),
            if (message != null && message!.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font12(context.screenSize),
                  color: dark.withOpacity(.6),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onPrimaryAction,
                child: Text(
                  primaryLabel,
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                ),
              ),
            ),
            if (secondaryLabel != null && onSecondaryAction != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE7E5E0)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: onSecondaryAction,
                  child: Text(
                    secondaryLabel!,
                    style: TextStyle(fontFamily: 'Poppins', color: black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}