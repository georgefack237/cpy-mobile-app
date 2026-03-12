
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';

class MediaTypeButton extends StatelessWidget {
  const MediaTypeButton({super.key, required this.onTap, required this.label, required this.selected});

  final Function() onTap;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: context.screenSize.width / 3.6,
        decoration: BoxDecoration(
          color: selected ? primaryDarkest : primary.withOpacity(.1),
          borderRadius: BorderRadius.circular(30)
        ),
        child: Center(
          child: Text(label,
          style: TextStyle(
            color: selected ? Colors.white : dark,
            fontSize: 13.3,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300
          )),
        ),
      ),
    );
  }
}
