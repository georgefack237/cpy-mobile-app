import 'package:cpy_app/data/models/poem_model.dart';
import 'package:cpy_app/features/hymns/pages/widgets/poem_details_page.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/icons/myIcon.dart';
import '../../../../utils/icons/my_icons.dart';

class PoemItem extends StatelessWidget {
  const PoemItem({super.key, required this.poem});

  final PoemModel poem;

  // Same soft-card tokens as the hymn card: 24px radius, low-opacity
  // shadow, flat pastel tile instead of a bold color block.
  static const double _cardRadius = 24;
  static const double _thumbRadius = 16;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(_cardRadius),
      splashColor: primarySoft.withOpacity(.12),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PoemDetailsPage(poem: poem)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
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
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: primarySoft.withOpacity(.14),
                borderRadius: BorderRadius.circular(_thumbRadius),
              ),
              child: const Center(
                child: MyIcon(size: 20, icon: MyIcons.poemIcon, color: primary, padding: EdgeInsets.zero),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poem.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSizes.font15(context.screenSize),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    poem.paroles.toLowerCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSizes.font11(context.screenSize),
                      fontWeight: FontWeight.w400,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: primarySoft.withOpacity(.10),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.more_vert_outlined, size: 15, color: dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}