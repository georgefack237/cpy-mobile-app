import 'package:cpy_app/features/strong/data/model/word_reference.dart';
import 'package:cpy_app/features/strong/pages/word_details_page.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';

import '../../utils/colors/light_colors.dart';
import '../../utils/globals.dart';
import '../../utils/icons/myIcon.dart';
import '../../utils/icons/my_icons.dart';

class WordItem extends StatelessWidget {
  const WordItem({super.key, required this.wordReference});

  final WordReference wordReference;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> WordDetailsPage(wordReference: wordReference)));
        },
        child: Column(
          children: [
            ListTile(
                leading: CircleAvatar(
                  backgroundColor: primary.withOpacity(.7),
                  child: Center(
                    child: Text(wordReference.word[0],
                        style: TextStyle(
                            fontSize: fontSizes.font15(context.screenSize),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        )),
                  ),
                ),

                title:Text(wordReference.word,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: fontSizes.font15(context.screenSize),
                    )
                ),

                subtitle:Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Text(wordReference.definition,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: fontSizes.font13(context.screenSize),
                      )),
                ),
                trailing: const MyIcon(
                    size: 18,
                    icon: MyIcons.moreVert,
                    color: dark,
                    padding: EdgeInsets.zero
                )
            ),

            Divider(color: const Color(0xFFf4f4f4).withOpacity(.5), thickness: 1),


          ],
        )

    );
  }
}
