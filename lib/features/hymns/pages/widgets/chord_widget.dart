import 'package:cpy_app/data/test_data/hymn_test_data.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/Transposer.dart';
import '../../../../data/models/hymn_chord.dart';
import '../../../../utils/colors/light_colors.dart';

class SongChordsWidget extends StatefulWidget {
  const SongChordsWidget({super.key, required this.notes, required this.useFrench, required this.fromKey});

  final List<HymnChord> notes;
  final bool useFrench;
  final String fromKey;

  @override
  State<SongChordsWidget> createState() => _SongChordsWidgetState();
}

class _SongChordsWidgetState extends State<SongChordsWidget> {
  // Soft filled rounded chip — was a sharp-cornered outlined box in a
  // one-off blue (0xFF3B5898) that didn't match the rest of the app.
  Widget _chordChip(String duration, String note) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          duration,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, fontFamily: 'Poppins', color: muted),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            note,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'Poppins', color: primary),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> fromProgression = ChordTranspose.getChordProgression(
      widget.fromKey,
      widget.notes.map((e) => e.note).toList(),
      false,
      true,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Schéma indépendant", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, fontFamily: 'Poppins', color: black)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: widget.notes.map((label) {
              return _chordChip(label.duration.toString(), label.note.toString());
            }).toList(),
          ),
          const SizedBox(height: 36),
          Text(
            "Exemple en gamme de ${noteScalesFr[noteScales.indexOf(widget.fromKey)]}",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, fontFamily: 'Poppins', color: black),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: widget.notes.map((chord) {
              final progressionValue = fromProgression[widget.notes.indexOf(chord)];
              return _chordChip(chord.duration.toString(), progressionValue);
            }).toList(),
          ),
        ],
      ),
    );
  }
}