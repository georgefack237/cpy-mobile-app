import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpy_app/data/models/affiche.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';

import '../../../constants/api_constants.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/globals.dart';
import '../pages/verse_page.dart';

class VerseCard extends StatelessWidget {
  const VerseCard({super.key, required this.data});

  final PictureVerse data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> VersePage(verse: data)));

          },
          child: Container(
            height: context.screenSize.height * .44,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: double.infinity,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),

            child: Stack(
                children: [

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(20),
                    ),

                    child: CachedNetworkImage(
                      imageUrl: "${ApiConstants.storageUrl}${data.image}",
                      imageBuilder: (context, imageProvider) => Container(
                        height:  context.screenSize.height * .44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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
                            borderRadius: BorderRadius.circular(16)
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




                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.55),
                        borderRadius: BorderRadius.circular(20),
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
                                data.description,
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
                                data.verse,
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
                    top: 30,
                    left: 25,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: primarySoft,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(
                         'Verset',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSizes.font12(context.screenSize),
                          fontFamily: 'Roboto'
                        ),
                      ),
                    ),
                  ),




                ]),






          ),
        ),
      ],
    );
  }
}


