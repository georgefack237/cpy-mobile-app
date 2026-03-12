import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';

class HymnBookItem extends StatelessWidget {
  const HymnBookItem({super.key, required this.hymnBook});

  final HymnBookCollection hymnBook;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.only(top: 25, bottom: 25, left: 20, right:20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: primaryLight
      ),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      
                      gradient: LinearGradient(colors:  [primary, primarySoft]),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Center(
                      child: MyIcon(
                          size: 22,
                          icon: MyIcons.hymnBookIcon,
                          color: Colors.white
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),


                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(hymnBook.nameFr, style: TextStyle(
                          fontSize: fontSizes.font15(context.screenSize),
                          fontFamily: 'Poppins')
                      ),

                    ],
                  )



                ],
              ),


              const Icon(Icons.more_vert_outlined, size: 16),

            ],
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    const MyIcon(size: 15, icon: MyIcons.hymnIcon, color: Colors.black54, padding: EdgeInsets.zero),
                    const SizedBox(width: 10),
                    Text("${hymnBook.hymnSongsCount} cantiques", style:  TextStyle(
                        fontSize: fontSizes.font12(context.screenSize),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: Colors.black54
                    ))

                  ],
                ),




                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    const MyIcon(size: 15, icon: MyIcons.poemIcon, color: dark, padding: EdgeInsets.zero),
                    const SizedBox(width: 10),
                    Text("${hymnBook.hymnPoemsCount} poèmes", style:  TextStyle(
                        fontSize: fontSizes.font12(context.screenSize),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Colors.black54
                    ))

                  ],
                )



              ],
            ),
          ),

        ],
      ),
    );
  }
}
