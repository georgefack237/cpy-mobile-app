import 'package:cpy_app/data/test_data/hymn_test_data.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/Transposer.dart';
import '../../../../data/models/hymn_chord.dart';

class SongChordsWidget extends StatefulWidget {
  const SongChordsWidget({super.key, required this.notes, required this.useFrench, required this.fromKey});

  final List<HymnChord> notes;
  final bool useFrench;
  final String fromKey;

  @override
  State<SongChordsWidget> createState() => _SongChordsWidgetState();
}

class _SongChordsWidgetState extends State<SongChordsWidget> {
  @override
  Widget build(BuildContext context) {

    List<String> fromProgression = ChordTranspose.getChordProgression(widget.fromKey, widget.notes.map((e) {return e.note;}).toList(), false, true);

    return  Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("Schéma indépendant", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, fontFamily: 'Poppins')),

          const SizedBox(height: 20),
          
          Wrap(
            spacing: -1.5,
            runSpacing: 12.0, // Space between rows
            children: widget.notes.map((label) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(label.duration.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Poppins')),
                  const SizedBox(height: 5),

                  SizedBox(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF3B5898), width: 1.5),
                          borderRadius: BorderRadius.circular(2)
                      ),
                      child:Text(label.note.toString(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'Poppins', color: Color(0xFF3B5898))),
                    ),
                  )
                ],
              );
            }).toList(),
          ),



          const SizedBox(height: 40),

           Text("Exemple en gamme de ${noteScalesFr[noteScales.indexOf(widget.fromKey)]}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, fontFamily: 'Poppins')),

          const SizedBox(height: 20),

          Wrap(
            spacing: -1.5,
            runSpacing: 12.0, // Space between rows
            children: widget.notes.map((chord){
              return Column(
                children: [
                  Text(chord.duration.toString(), style: const TextStyle(color: Colors.black, fontSize: 11)),
                  const SizedBox(height: 5,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF3B5898), width: 1.5),
                        borderRadius: BorderRadius.circular(2)
                    ),
                    child:Text(fromProgression[widget.notes.indexOf(chord)]),
                  )
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
