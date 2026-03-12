
import 'package:cpy_app/data/models/poem_model.dart';
import 'package:cpy_app/features/hymns/pages/widgets/poem_details_page.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';

import '../../../../utils/icons/myIcon.dart';
import '../../../../utils/icons/my_icons.dart';

class PoemItem extends StatelessWidget {
  const PoemItem({super.key, required this.poem});

  final PoemModel poem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) => PoemDetailsPage(poem: poem)));

      },
      child: Column(
        children: [

          ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF3B5898).withOpacity(0.05),
                child: const MyIcon(size: 20, icon: MyIcons.poemIcon, color:Color(0xFF3B5898), padding: EdgeInsets.all(11)),
              ),

              title:Text(poem.title, style: const TextStyle(fontSize: 15, fontFamily: 'Roboto')),
              subtitle:Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                    poem.paroles.toLowerCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                        fontSize: fontSizes.font12(context.screenSize),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Colors.black54
                    )),
              ),
          ),

          Divider(color: const Color(0xFFf4f4f4).withOpacity(.5), thickness: 1),


        ],
      ),
    );
  }
}

