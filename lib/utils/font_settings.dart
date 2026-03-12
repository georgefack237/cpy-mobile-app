import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSettings extends ChangeNotifier {


  double get fontSize => fontSizeGlobal;
  String get fontFamily => fontFamilyGlobal;

  FontSettings() {
    _loadSettings();
  }

  void setFontSize(double size) {
    fontSizeGlobal = size;
    notifyListeners();
    _saveSettings();
  }

  void setFontFamily(String family) {
    fontFamilyGlobal = family;
    notifyListeners();
    _saveSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    fontSizeGlobal = prefs.getDouble('fontSize') ?? 1.0;
    fontFamilyGlobal = prefs.getString('fontFamily') ?? 'Roboto';
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSizeGlobal);
    await prefs.setString('fontFamily', fontFamilyGlobal);
  }
}
