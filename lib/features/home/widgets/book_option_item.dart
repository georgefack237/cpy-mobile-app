import 'package:flutter/material.dart';
import 'package:cpy_app/utils/globals.dart';
import '../../../utils/icons/myIcon.dart';

class BookOptionItem extends StatelessWidget {
  const BookOptionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.stats,
    required this.bgColor
  });

  final String icon;
  final String title;
  final String stats;
  final List<Color> bgColor;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(16),
      height: screenSize.width * 0.49 / 2,
      width: screenSize.width * 0.89 / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_getPadding(screenSize)),
          gradient: LinearGradient(colors: bgColor.reversed.toList())
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            decoration: BoxDecoration(
              color: bgColor[1].withOpacity(.9),
              shape: BoxShape.circle,
            ),
            child: MyIcon(
              color: Colors.white,
              size: screenSize.width * 0.055,
              icon: icon,
            ),
          ),

          SizedBox(width: screenSize.width * 0.035),

          // Text Content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stats,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: _getFontSize12(screenSize),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: screenSize.width * 0.006),

                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: _getFontSize20(screenSize),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods to safely get values
  double _getPadding(Size screenSize) {
    try {
      return appPadding.padH16(screenSize);
    } catch (e) {
      return 16.0; // Default fallback
    }
  }

  double _getFontSize12(Size screenSize) {
    try {
      return fontSizes.font12(screenSize);
    } catch (e) {
      return 12.0; // Default fallback
    }
  }

  double _getFontSize20(Size screenSize) {
    try {
      return fontSizes.font20(screenSize);
    } catch (e) {
      return 20.0; // Default fallback
    }
  }
}