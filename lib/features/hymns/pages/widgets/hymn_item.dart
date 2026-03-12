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


class HymnItem extends StatelessWidget {
  const HymnItem({super.key, required this.hymnSong});
  
  final HymnSong hymnSong;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
       Navigator.push(context, MaterialPageRoute(builder: (context) => HymnSongDetailsPage(hymnSong: hymnSong, songId: hymnSong.id!,)));
      },
      child: Column(
        children: [

          ListTile(
            leading: CircleAvatar(
                backgroundColor: const Color(0xFF3B5898).withOpacity(0.05),
              child: const MyIcon(size: 20, icon: MyIcons.hymnIcon, color:Color(0xFF3B5898), padding: EdgeInsets.all(11)),
            ),

            title:Text(hymnSong.title!, style: const TextStyle(fontSize: 15, fontFamily: 'Roboto')),

            subtitle:Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text("${ hymnSong.fileSize != null ? double.parse("${(hymnSong.fileSize!)/(1024 * 1024)}").toStringAsFixed(2): 0.0 } mb | ${hymnCategories.where((c){return c.id == hymnSong.categoryId;}).first.nameFr}", style: const TextStyle(fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w400, color: Colors.black54)),
            ),
            trailing:IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert_outlined, size: 17,))
          ),

          Divider(color: const Color(0xFFf4f4f4).withOpacity(.5), thickness: 1),


        ],
      ),
    );
  }
}



class HymnItem2 extends StatefulWidget {
  const HymnItem2({super.key, required this.hymnSong});

  final HymnSong hymnSong;


  @override
  State<HymnItem2> createState() => _HymnItem2State();
}

class _HymnItem2State extends State<HymnItem2> {



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Divider(color: const Color(0xFFf4f4f4).withOpacity(.5), thickness: 1),

        ListTile(
          splashColor: Colors.transparent,
          onTap: (){
            FocusScope.of(context).unfocus();
            Navigator.push(context, MaterialPageRoute(builder: (context) => HymnSongDetailsPage(hymnSong:widget.hymnSong, songId: widget.hymnSong.id!,)));
          },
            leading: Container(
              width: 60,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: const Center(
                child: MyIcon(size: 20, icon: MyIcons.hymnIcon, color:Colors.white),
              ),
            ),

            title: Text(widget.hymnSong.title!, style: TextStyle(
              fontSize: fontSizes.font15(context.screenSize),
              fontFamily: 'Roboto',
            )),

            subtitle:Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text("${ widget.hymnSong.fileSize != null ? double.parse("${(widget.hymnSong.fileSize!)/(1024 * 1024)}").toStringAsFixed(2): 0.0 } mb | ${hymnCategories.where((c){return c.id == widget.hymnSong.categoryId;}).first.nameFr}",
                  style:  TextStyle(
                      fontSize: fontSizes.font12(context.screenSize),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Colors.black54
                  )
              ),
            ),

            trailing: widget.hymnSong.fileSize != null ?  Container(
              height: 7,
              width: 7,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(.6)
              ),
            ): const SizedBox()
        ),
      ],
    );
  }
}


