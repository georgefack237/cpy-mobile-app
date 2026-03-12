import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpy_app/data/models/affiche.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/api_constants.dart';
import '../../../utils/colors/light_colors.dart';

class VersePage extends StatefulWidget {
  const VersePage({super.key, required this.verse});

  final  PictureVerse verse;

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {


  String formatDateTime(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    } catch (e) {
      return 'Date invalide';
    }
  }

// Exemple : formatDateTime("2024-01-15T14:30:00Z")
// Résultat : "15/1/2024 14:30"


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: widget.verse.type != 'verse' ? ListView(

        children: [

          Container(
            decoration: const BoxDecoration(
                color: Colors.black54
            ),
            child: CachedNetworkImage(
              imageUrl: "${ApiConstants.storageUrl}${widget.verse.image}",
              imageBuilder: (context, imageProvider) => Container(
                height:  context.screenSize.height * .44,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                width:context.screenSize.height * .44,
                height: context.screenSize.height * .44,
                decoration: BoxDecoration(
                  color: tColorLight,
                  borderRadius: BorderRadius.circular(16),

                ),
              ),
              errorWidget: (context, url, error) =>Container(
                width: context.screenSize.height * .44,
                decoration: BoxDecoration(
                  color: tColorLight,
                  borderRadius: BorderRadius.circular(context.screenSize.width * .34/2),
                ),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                SizedBox(height: context.screenSize.width * .060),

                SizedBox(
                  width: context.screenSize.width * .85,
                  child: Text(widget.verse.verse,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fontSizes.font15(context.screenSize),
                          fontWeight: FontWeight.w600,
                          color: dark
                      )),
                ),



                SizedBox(height: context.screenSize.width * .025),

                SizedBox(
                  width: context.screenSize.width * .85,

                  child: Text(widget.verse.description,
                      textAlign: TextAlign.start,

                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fontSizes.font13(context.screenSize),
                          fontWeight: FontWeight.w400,
                          color: dark
                      )),
                ),


                if(widget.verse.location != null)
                Column(
                  children: [

                    SizedBox(height: context.screenSize.width * .065),

                    Row(
                      children: [

                        Icon(LucideIcons.locateFixed300),

                        SizedBox(width: context.screenSize.width * .025),


                        SizedBox(

                          child: Text(widget.verse.location ?? '',
                              textAlign: TextAlign.start,

                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: fontSizes.font13(context.screenSize),
                                  fontWeight: FontWeight.w400,
                                  color: dark
                              )),
                        ),
                      ],
                    ),



                    if(widget.verse.start != null || widget.verse.stop != null)
                      Column(
                        children: [

                          SizedBox(height: context.screenSize.width * .065),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              if(widget.verse.start != null)
                              Row(
                                children: [

                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: primarySoft,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: const Icon(LucideIcons.clock5300, color: Colors.white, size: 16,)
                                  ),
                                  SizedBox(width: context.screenSize.width * .025),


                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SizedBox(

                                        child: Text('Début',
                                            textAlign: TextAlign.start,

                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: fontSizes.font13(context.screenSize),
                                                fontWeight: FontWeight.w600,
                                                color: dark
                                            )),
                                      ),


                                      SizedBox(height: 5,),

                                      SizedBox(

                                        child: Text(formatDateTime(widget.verse.start!),
                                            textAlign: TextAlign.start,

                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: fontSizes.font13(context.screenSize),
                                                fontWeight: FontWeight.w400,
                                                color: dark
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),


                              if(widget.verse.stop != null)
                              Row(
                                children: [

                                  Container(
                                    padding: EdgeInsets.all(10),
                                     decoration: BoxDecoration(
                                       color: primarySoft,
                                       borderRadius: BorderRadius.circular(10)
                                     ),
                                      child: Icon(LucideIcons.clock5300, color: Colors.white, size: 16,)
                                  ),

                                  SizedBox(width: context.screenSize.width * .025),


                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SizedBox(

                                        child: Text('Fin',
                                            textAlign: TextAlign.start,

                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: fontSizes.font13(context.screenSize),
                                                fontWeight: FontWeight.w600,
                                                color: dark
                                            )),
                                      ),


                                      SizedBox(height: 5,),

                                      SizedBox(

                                        child: Text(formatDateTime(widget.verse.stop!),
                                            textAlign: TextAlign.start,

                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: fontSizes.font13(context.screenSize),
                                                fontWeight: FontWeight.w400,
                                                color: dark
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),


                        ],
                      )


                  ],
                )



              ],
            ),
          )



        ],
      ): Stack(
        children: [

          Container(

            child: CachedNetworkImage(
              imageUrl: "${ApiConstants.storageUrl}${widget.verse.image}",
              imageBuilder: (context, imageProvider) => Container(
                width: context.screenSize.width,
                height: context.screenSize.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                width: context.screenSize.width,
                height: context.screenSize.height,
                decoration: const BoxDecoration(
                  color: tColorLight,

                ),
              ),
              errorWidget: (context, url, error) =>Container(
                width: context.screenSize.width,
                height: context.screenSize.height,
                decoration: BoxDecoration(
                  color: tColorLight,
                ),
              ),
            ),
          ),


          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.55),
              ),
            ),
          ),




          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [



                    SizedBox(

                      width: context.screenSize.width * .60,
                      child: Text(
                        textAlign: TextAlign.center,
                        maxLines: 7,
                        widget.verse.description,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            overflow: TextOverflow.ellipsis,
                            fontSize: fontSizes.font15(context.screenSize),
                            fontWeight: FontWeight.w400,
                            color: Colors.white
                        ),
                      ),
                    ),

                    SizedBox(height: context.screenSize.width * .035,),

                    SizedBox(
                      width: context.screenSize.width * .60,

                      child: Text(
                        textAlign: TextAlign.center,
                        widget.verse.verse,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: fontSizes.font15(context.screenSize),
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      ),
                    ),


                  ],
                ),
              )
          ),



           Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 23)
            ),
          )
        ],
      )
    );
  }
}
