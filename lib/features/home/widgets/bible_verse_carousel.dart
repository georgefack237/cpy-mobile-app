import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cpy_app/data/models/affiche.dart';
import 'package:cpy_app/features/home/widgets/announce_card.dart';
import 'package:cpy_app/features/home/widgets/verse_card.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import '../../../constants/api_constants.dart';
import '../../../utils/icons/myIcon.dart';
import '../../../utils/icons/my_icons.dart';
import '../pages/verse_page.dart';

class BibleVerseCarousel extends StatefulWidget {
  const BibleVerseCarousel({super.key, required this.verses});

  final List<PictureVerse> verses;

  @override
  State<BibleVerseCarousel> createState() => _BibleVerseCarouselState();
}

class _BibleVerseCarouselState extends State<BibleVerseCarousel> {

  CarouselSliderController carouselController = CarouselSliderController();

  int _currentIndex = 1;

  void _goToPage(int index) {
    if (index >= 0 && index < widget.verses.length) {
      carouselController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
            carouselController: carouselController,
            items: widget.verses.map((pack) {


              if(pack.type == 'verse'){
                return VerseCard(data: pack);
              } else{
                return AnnounceCard(data: pack);
              }

            }).toList(),
              options: CarouselOptions(
              initialPage: _currentIndex,
              autoPlay: false, // Enable
              height: context.screenSize.height * .44,
              enlargeCenterPage: false, // Increase the size of the center item
              enableInfiniteScroll: false,
              viewportFraction: 1, // Enable infinite scroll
              onPageChanged: (index, reason) {
                setState((){
                  _currentIndex = index;

                });

              },
            ),
          );
  }



  Widget carr(){
    return  CarouselSlider(
      carouselController: carouselController,
      items: widget.verses.map((pack) => Column()).toList(),
      options: CarouselOptions(
        initialPage: _currentIndex,
        autoPlay: false, // Enable
        height: context.screenSize.height * .316,
        enlargeCenterPage: false, // Increase the size of the center item
        enableInfiniteScroll: false,
        viewportFraction: 1, // Enable infinite scroll
        onPageChanged: (index, reason) {

          setState((){

          });

        },
      ),
    );
  }
}
