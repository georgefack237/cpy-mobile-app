import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:flutter/material.dart';

import '../../../../utils/dimensions/fontsizes.dart';
import '../../../../utils/globals.dart';

class HymnLyricsItem extends StatelessWidget {
  const HymnLyricsItem({super.key, required this.chordOverLyrics, required this.lyrics});

  final int chordOverLyrics;
  final String lyrics;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: lyrics.split('|').map((line){
        return chordOverLyrics == 0 ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
              line,
              style: TextStyle(
                  fontFamily: fontFamilyGlobal
                  ,fontSize: FontSizes().fontReading(context.screenSize),
                  letterSpacing: 1.0,
                  color: Colors.black.withOpacity(textOpacityGlobal),
                  fontWeight: FontWeight.w300,
                  height: 1.6
              )),
        ): Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ChordLyricWidget(input: line)
        );
      }).toList(),
    );
  }
}

class ChordLyricWidget extends StatelessWidget {
  final String input;

  const ChordLyricWidget({super.key, required this.input});

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];

    final regex = RegExp(r'(\[\d+\])?([^\[\]\s]+[\s,"]*)');
    final matches = regex.allMatches(input);

    for (final match in matches) {
      final chord = match.group(1); // e.g. [1]
      final word = match.group(2);  // e.g. prophecy or spoken

      if (chord != null) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Wrap(
            spacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: [

             Text(chord.split('[').last.split("]").first, style: TextStyle(fontFamily: fontFamilyGlobal,fontSize: FontSizes().fontReadingSmall(context.screenSize), letterSpacing: 1.2, color: primary.withOpacity(textOpacityGlobal), fontWeight: FontWeight.w300)),
             Text(word!, style: TextStyle(fontFamily: fontFamilyGlobal,fontSize: FontSizes().fontReading(context.screenSize), letterSpacing: 1.2, color: black.withOpacity(textOpacityGlobal), fontWeight: FontWeight.w300)),

            ],
          ),
        ));
      } else {
        // Plain word without a chord
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Text(word!, style: TextStyle(fontFamily: fontFamilyGlobal,fontSize: FontSizes().fontReading(context.screenSize), letterSpacing: 1.2, color: black.withOpacity(textOpacityGlobal), fontWeight: FontWeight.w300)),

        ));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
