import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key, required this.onPressed});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(60)
        ),
        child: Center(
          child: Text(
            'Passer',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: fontSizes.font13(context.screenSize),
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
}
