import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/data/models/hymn_song.dart';
import 'package:cpy_app/data/test_data/hymn_test_data.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_song_details_page.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors/light_colors.dart';


class HymnItem extends StatefulWidget {
  const HymnItem({super.key, required this.hymnSong});

  final HymnSong hymnSong;

  @override
  State<HymnItem> createState() => _HymnItemState();
}

class _HymnItemState extends State<HymnItem> {
  // Softer, rounder card: bigger radius, gentler shadow than before.
  static const double _cardRadius = 24;
  static const double _thumbRadius = 16;

  bool get _isAvailable => widget.hymnSong.fileSize != null;

  String get _sizeLabel {
    if (widget.hymnSong.fileSize == null) return '0.0 mb';
    return "${double.parse("${widget.hymnSong.fileSize! / (1024 * 1024)}").toStringAsFixed(2)} mb";
  }

  String get _categoryLabel =>
      hymnCategories.where((c) => c.id == widget.hymnSong.categoryId).first.nameFr;

  /// Thumbnail tile with a small "available offline" dot floating on its
  /// corner. Kept as a flat, low-contrast pastel tint (no gradient) so it
  /// reads as soft rather than a bold colored block.
  Widget _thumbnail() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: primarySoft.withOpacity(.14),
            borderRadius: BorderRadius.circular(_thumbRadius),
          ),
          child: const Center(
            child: MyIcon(size: 20, icon: MyIcons.hymnIcon, color: primary, padding: EdgeInsets.zero),
          ),
        ),
        if (_isAvailable)
          Positioned(
            bottom: -3,
            right: -3,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withOpacity(.75)),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Category pill, same shape/role as MediaFileItem's "PDF / LIEN" badge —
  /// lightened further so it sits as a soft label rather than a solid chip.
  Widget _categoryBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _categoryLabel,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSizes.font11(context.screenSize) * .85,
          fontWeight: FontWeight.w600,
          color: primary,
          letterSpacing: .2,
        ),
      ),
    );
  }

  Widget _trailingButton() {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: primarySoft.withOpacity(.10),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.more_vert_outlined, size: 15, color: dark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(_cardRadius),
      splashColor: primarySoft.withOpacity(.12),
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HymnSongDetailsPage(hymnSong: widget.hymnSong, songId: widget.hymnSong.id!)));
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
            _thumbnail(),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hymnSong.title!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSizes.font15(context.screenSize),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _sizeLabel,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSizes.font11(context.screenSize),
                      color: muted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _categoryBadge(context),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _trailingButton(),
          ],
        ),
      ),
    );
  }
}