import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';
import '../../../utils/colors/light_colors.dart';

class IntroButton extends StatelessWidget {
  const IntroButton({super.key, required this.onPressed, this.download});

  final Function() onPressed;
  final bool? download;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(context.screenSize.width * .040),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            color: primaryDarkest),
        child:  Center(
          child: Text(
             download == null ? "Suivant" : "Télécharger",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                fontSize: 15
              )
          ),
        ),
      ),
    );;
  }
}
