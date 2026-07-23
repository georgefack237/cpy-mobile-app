import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';

/// Same card language as [HymnBookItem] — white surface, soft shadow,
/// a stat chip, and the same trailing soft-circle button — just with
/// a gradient icon tile standing in for the leading illustration,
/// since this item doesn't carry an SVG asset.
class HymnItemCollectionItem extends StatelessWidget {
  const HymnItemCollectionItem({super.key, required this.hymnBook, required this.isPoem});

  final HymnBookCollection hymnBook;
  final bool isPoem;

  static const double _cardRadius = 22;
  static const double _iconSize = 56;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
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
          _icon(),
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
                _statChip(context),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _trailingButton(),
        ],
      ),
    );
  }

  Widget _icon() {
    return Container(
      width: _iconSize,
      height: _iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, primarySoft]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: MyIcon(size: 24, icon: MyIcons.hymnBookIcon, color: Colors.white),
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

  Widget _statChip(BuildContext context) {
    final label = isPoem ? "${hymnBook.hymnPoemsCount} poèmes" : "${hymnBook.hymnSongsCount} cantiques";
    final icon = isPoem ? MyIcons.poemIcon : MyIcons.hymnIcon;

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
}