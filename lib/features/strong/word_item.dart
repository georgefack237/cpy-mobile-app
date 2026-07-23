import 'package:cpy_app/features/strong/data/model/word_reference.dart';
import 'package:cpy_app/features/strong/pages/word_details_page.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';

import '../../utils/colors/light_colors.dart';
import '../../utils/globals.dart';

class WordItem extends StatelessWidget {
  const WordItem({super.key, required this.wordReference});

  final WordReference wordReference;

  // Same card language as HymnItem / HymnBookItem: soft rounded card,
  // low-contrast shadow, no divider — cards are separated by margin only.
  static const double _cardRadius = 24;
  static const double _tileRadius = 16;

  /// Tinted letter tile, same treatment as HymnItem's thumbnail —
  /// a soft pastel square instead of a solid CircleAvatar.
  Widget _letterTile(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: primarySoft.withOpacity(.14),
        borderRadius: BorderRadius.circular(_tileRadius),
      ),
      child: Center(
        child: Text(
          wordReference.word[0].toUpperCase(),
          style: TextStyle(
            fontSize: fontSizes.font15(context.screenSize),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: primary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(_cardRadius),
      splashColor: primarySoft.withOpacity(.12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordDetailsPage(wordReference: wordReference),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.035),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _letterTile(context),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wordReference.word,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSizes.font15(context.screenSize),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wordReference.definition,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSizes.font13(context.screenSize),
                      color: muted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}