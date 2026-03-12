import 'package:cpy_app/features/strong/data/model/word_reference.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class WordDetailsPage extends StatefulWidget {
  const WordDetailsPage({super.key, required this.wordReference});

  final WordReference wordReference;

  @override
  State<WordDetailsPage> createState() => _WordDetailsPageState();
}

class _WordDetailsPageState extends State<WordDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child:AppBar(
            centerTitle: false,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.wordReference.word,
              style:  TextStyle(
                  color:Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font20(context.screenSize),
                  fontWeight: FontWeight.w600),
              maxLines: 1,
            ),

            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_outlined, color:black, size: 25),
            ),


            actions: [


              InkWell(
                onTap:()async{
                  await Share.share('${widget.wordReference.word} \n  \n ${widget.wordReference.etymology}  \n  \n${widget.wordReference.definition}', subject: widget.wordReference.word);
                },
                splashColor: Colors.transparent,
                child: MyIcon(size: 23, icon: MyIcons.share, padding: EdgeInsets.only(right: 16, top: 10,bottom: 10),),
              )
            ],

          ),
        ),
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: appPadding.padH16(context.screenSize),
              vertical: appPadding.padH16(context.screenSize)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Étymologie", style: TextStyle(color: primary ,fontFamily: 'Roboto', fontSize: fontSizes.font17(context.screenSize), fontWeight: FontWeight.w600)),
              SizedBox(height: context.screenSize.height * .020),
              Text(
                  widget.wordReference.etymology ?? 'N/A',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: fontSizes.font15(context.screenSize))),


              SizedBox(height: context.screenSize.height * .035),



              Text("Définition", style: TextStyle(color: primary ,fontFamily: 'Roboto', fontSize: fontSizes.font17(context.screenSize), fontWeight: FontWeight.w600)),
              SizedBox(height: context.screenSize.height * .020),
              Text(
                  widget.wordReference.definition,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: fontSizes.font15(context.screenSize))),




            ],
          ),
        ),
      )



    );
  }
}
