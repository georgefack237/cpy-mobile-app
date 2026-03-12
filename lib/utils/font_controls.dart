import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dimensions/fontsizes.dart';
import 'globals.dart';




class FontControls extends StatefulWidget {
  const FontControls({super.key});

  @override
  State<FontControls> createState() => _MyAppState();
}

class _MyAppState extends State<FontControls> {
  final FontSizes fontSizes = FontSizes();

  @override
  void initState() {
    super.initState();
    _loadFontSizeGlobal();
  }

  Future<void> _loadFontSizeGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSizeGlobal = prefs.getDouble('fontSizeGlobal') ?? 1.0;
    });
  }

  Future<void> _saveFontSizeGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizeGlobal', fontSizeGlobal);
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Adjust Font Size Multiplier", style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  min: 0.5,
                  max: 5.0,
                  divisions: 15,
                  value: fontSizeGlobal,
                  label: fontSizeGlobal.toStringAsFixed(2),
                  onChanged: (value) {
                    setModalState(() => fontSizeGlobal = value);
                    setState(() {});
                    _saveFontSizeGlobal();
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  "Sample Text",
                  style: TextStyle(fontSize: fontSizes.font13(MediaQuery.of(context).size)),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Font Size Example")),
        body: Center(
          child: Text(
            "Hello, world!",
            style: TextStyle(fontSize: fontSizes.font13(size)),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showFontSizeDialog,
          child: const Icon(Icons.text_fields),
        ),
      ),
    );
  }
}
