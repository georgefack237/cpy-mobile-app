import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';

class HymnItemCollectionItem extends StatelessWidget {
  const HymnItemCollectionItem({super.key, required this.hymnBook, required this.isPoem});

  final HymnBookCollection hymnBook;
  final bool isPoem;

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

                      Text(hymnBook.nameFr, style: const TextStyle(fontSize: 15, fontFamily: 'Roboto')),
                      const SizedBox(height: 5),
                      Text( isPoem ? "${hymnBook.hymnPoemsCount} poems":"${hymnBook.hymnSongsCount} cantiques", style: TextStyle(fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w300, color: dark),),

                    ],
                  )



                ],
              ),



              const Icon(Icons.more_vert_outlined, size: 16),

            ],
          ),


         // const SizedBox(height: 20),




        ],
      ),
    );
  }
}
