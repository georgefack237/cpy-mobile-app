import 'package:flutter/material.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/dimensions/fontsizes.dart';
import '../../../utils/globals.dart';

/// One "lesson" card: a numbered step, a short explanation, a boxed
/// mockup reproducing the relevant piece of the real UI, and a legend
/// matching each numbered badge inside the mockup to its explanation.
class GuideSection extends StatelessWidget {
  const GuideSection({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.mockup,
    this.legend = const [],
  });

  final int stepNumber;
  final String title;
  final String description;
  final Widget mockup;
  final List<String> legend;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: primaryLight, shape: BoxShape.circle),
                child: Text(
                  '$stepNumber',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 12, color: primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: fontSizes.font15(context.screenSize),
                    color: black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fontSizes.font13(context.screenSize),
              color: dark.withOpacity(.75),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFECEAE5)),
            ),
            child: mockup,
          ),
          if (legend.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...List.generate(
              legend.length,
                  (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GuideBadge(number: i + 1),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        legend[i],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fontSizes.font12(context.screenSize),
                          color: dark.withOpacity(.8),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small numbered circle — used both pinned onto a mockup element and
/// in front of its matching legend line.
class GuideBadge extends StatelessWidget {
  const GuideBadge({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Text(
        '$number',
        style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 11, color: Colors.white),
      ),
    );
  }
}

/// Pins a numbered badge to the top-right corner of any mockup piece
/// (an icon, a chip, a slider...) so the reader can match it to the
/// legend line with the same number below the mockup box.
class Badged extends StatelessWidget {
  const Badged({super.key, required this.number, required this.child});

  final int number;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(top: -8, right: -8, child: GuideBadge(number: number)),
      ],
    );
  }
}