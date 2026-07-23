import 'package:flutter/material.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';

class NoInternetView extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;
  final String? buttonLabel;

  const NoInternetView({
    super.key,
    required this.onRetry,
    this.message,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon badge
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primaryLighter,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 36,
                color: primary,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Pas de connexion',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: dark,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              message ?? 'Vérifiez votre connexion Internet et réessayez.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                color: muted,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: onRetry,
                child: Text(
                  buttonLabel ?? 'Réessayer',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}