import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

      decoration: BoxDecoration(
        color: const Color(0xFF60C1C4),
        borderRadius: BorderRadius.circular(8)
      ),
      child: const Row(
        children: [
          Text('Next', style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight:FontWeight.w500

          )),

          SizedBox(width: 10),

          MyIcon(size: 12, icon: MyIcons.arrowForward, padding: EdgeInsets.zero)

        ],
      ),
    );
  }
}


class MainButton extends StatelessWidget {
  const MainButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

      decoration: BoxDecoration(
          color: const Color(0xFF60C1C4),
          borderRadius: BorderRadius.circular(8)
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          MyIcon(size: 14, icon: MyIcons.downloadIcon, padding: EdgeInsets.zero),

          SizedBox(width: 15),

          Text('Télécharger', style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight:FontWeight.w500

          )),



        ],
      ),
    );
  }
}
