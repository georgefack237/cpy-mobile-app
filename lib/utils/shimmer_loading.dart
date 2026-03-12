import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';

class ShimmerContainer extends StatelessWidget {
  final BuildContext context;

  const ShimmerContainer({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenSize.height * .44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[200]!,
            Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}