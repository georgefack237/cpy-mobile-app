import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpy_app/data/models/affiche.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';

import '../../../constants/api_constants.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/globals.dart';
import '../pages/verse_page.dart';

class AnnounceCard extends StatelessWidget {
  const AnnounceCard({super.key, required this.data});

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

            child:  Stack(
              children: [


                Container(
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(
                          16
                      ),
                      color: Colors.black54
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


                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      color: Colors.black.withOpacity(.8),

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(data.verse,
                            style:  TextStyle(
                                color: Colors.white,
                                fontWeight:  FontWeight.bold,
                                fontSize: fontSizes.font12(context.screenSize),
                                fontFamily: 'Poppins')),

                        SizedBox(height: context.screenSize.width * .022),

                        Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            data.description,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight:  FontWeight.w400,
                                fontSize: fontSizes.font12(context.screenSize),
                                fontFamily: 'Poppins'
                            ))

                      ],
                    ),
                  ),
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
                      'Annonce',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSizes.font12(context.screenSize),
                          fontFamily: 'Roboto'
                      ),
                    ),
                  ),
                ),

              ],
            ),

          ),
        ),
      ],
    );
  }
}
