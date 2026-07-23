import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HymnBookItem extends StatelessWidget {
  const HymnBookItem({super.key, required this.hymnBook, required this.asset});

  final HymnBookCollection hymnBook;
  final String asset;

  // ----------------------------------------------------------------------
  // Design tokens — all colors below (primary / primarySoft / primaryLight /
  // dark / muted / black) come straight from your existing light_colors.dart,
  // nothing new was introduced.
  // ----------------------------------------------------------------------
  static const double _cardRadius = 22;
  static const double _illustrationSize = 96;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _illustration(asset: asset),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hymnBook.nameFr,
                  style: TextStyle(
                    fontSize: fontSizes.font15(context.screenSize),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                _statsRow(context),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _trailingButton(),
        ],
      ),
    );
  }

  /// The illustration on its own, no tinted backdrop — matching how
  /// BibleProject lets its artwork sit directly on the card, and bigger
  /// now that it doesn't need to be boxed into a small tile.
  Widget _illustration({required String asset}) {
    return SizedBox(
      width: _illustrationSize,
      height: _illustrationSize,
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _trailingButton() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: primarySoft.withOpacity(.16),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.more_vert_outlined, size: 16, color: dark),
      ),
    );
  }

  /// Small soft pill combining an icon + label — replaces the old bare
  /// icon-and-text row with something that reads as one clean chip.
  Widget _statChip({
    required BuildContext context,
    required String icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyIcon(size: 13, icon: icon, color: primary, padding: EdgeInsets.zero),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSizes.font11(context.screenSize),
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _statChip(context: context, icon: MyIcons.hymnIcon, label: "${hymnBook.hymnSongsCount} cantiques"),
        _statChip(context: context, icon: MyIcons.poemIcon, label: "${hymnBook.hymnPoemsCount} poèmes"),
      ],
    );
  }
}