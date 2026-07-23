import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/dimensions/fontsizes.dart';

// ── Reading settings state ─────────────────────────────────────────
class ReadingSettings {
  final double fontSize;       // multiplier: 0.8 – 2.0
  final double lineHeight;     // 1.2 – 2.4
  final String fontFamily;
  final ReadingTheme theme;

  const ReadingSettings({
    this.fontSize = 1.0,
    this.lineHeight = 1.7,
    this.fontFamily = 'Georgia',
    this.theme = ReadingTheme.light,
  });

  ReadingSettings copyWith({
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    ReadingTheme? theme,
  }) =>
      ReadingSettings(
        fontSize: fontSize ?? this.fontSize,
        lineHeight: lineHeight ?? this.lineHeight,
        fontFamily: fontFamily ?? this.fontFamily,
        theme: theme ?? this.theme,
      );
}

enum ReadingTheme { light, sepia, dark }

extension ReadingThemeX on ReadingTheme {
  Color get background => switch (this) {
    ReadingTheme.light => const Color(0xFFFFFFFF),
    ReadingTheme.sepia => const Color(0xFFF8F1E4),
    ReadingTheme.dark  => const Color(0xFF1A1A1A),
  };

  Color get text => switch (this) {
    ReadingTheme.light => const Color(0xFF1A1A1A),
    ReadingTheme.sepia => const Color(0xFF3D2B1F),
    ReadingTheme.dark  => const Color(0xFFE0DACE),
  };

  Color get surface => switch (this) {
    ReadingTheme.light => const Color(0xFFF5F5F5),
    ReadingTheme.sepia => const Color(0xFFEDE3D0),
    ReadingTheme.dark  => const Color(0xFF2C2C2C),
  };

  String get label => switch (this) {
    ReadingTheme.light => 'Clair',
    ReadingTheme.sepia => 'Sépia',
    ReadingTheme.dark  => 'Sombre',
  };
}

// ── Persistence ────────────────────────────────────────────────────
class ReadingSettingsStore {
  static const _keyFontSize   = 'rs_font_size';
  static const _keyLineHeight = 'rs_line_height';
  static const _keyFamily     = 'rs_font_family';
  static const _keyTheme      = 'rs_theme';

  static Future<ReadingSettings> load() async {
    final p = await SharedPreferences.getInstance();
    return ReadingSettings(
      fontSize:   p.getDouble(_keyFontSize)   ?? 1.0,
      lineHeight: p.getDouble(_keyLineHeight) ?? 1.7,
      fontFamily: p.getString(_keyFamily)     ?? 'Georgia',
      theme: ReadingTheme.values[p.getInt(_keyTheme) ?? 0],
    );
  }

  static Future<void> save(ReadingSettings s) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble(_keyFontSize,   s.fontSize);
    await p.setDouble(_keyLineHeight, s.lineHeight);
    await p.setString(_keyFamily,     s.fontFamily);
    await p.setInt(_keyTheme,         s.theme.index);
  }
}

// ── Bottom sheet entry point ───────────────────────────────────────
Future<ReadingSettings?> showReadingSettings({
  required BuildContext context,
  required ReadingSettings current,
}) {
  return showModalBottomSheet<ReadingSettings>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _ReadingSettingsSheet(initial: current),
  );
}

// ── Sheet UI ───────────────────────────────────────────────────────
class _ReadingSettingsSheet extends StatefulWidget {
  final ReadingSettings initial;
  const _ReadingSettingsSheet({required this.initial});

  @override
  State<_ReadingSettingsSheet> createState() => _ReadingSettingsSheetState();
}

class _ReadingSettingsSheetState extends State<_ReadingSettingsSheet> {
  late ReadingSettings _s;

  static const _families = ['Georgia', 'Poppins', 'Roboto', 'Courier New', 'Times New Roman'];

  @override
  void initState() {
    super.initState();
    _s = widget.initial;
  }

  void _update(ReadingSettings next) {
    setState(() => _s = next);
    ReadingSettingsStore.save(next);
  }

  @override
  Widget build(BuildContext context) {
    final bg = _s.theme.background;
    final tx = _s.theme.text;
    final sf = _s.theme.surface;

    // Same base reading size the lyrics screen itself uses, so the
    // "Aperçu" pill matches what you'll actually see, not a flat guess.
    final basePreviewSize = FontSizes().fontReading(context.screenSize) * 0.5;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 24)],
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // handle
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: tx.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // header
          Row(
            children: [
              Expanded(
                child: Text('Lecture', style: TextStyle(
                  fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                  fontSize: 18, color: tx,
                )),
              ),
              // live preview pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: sf, borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Aperçu',
                  style: TextStyle(
                    fontFamily: _s.fontFamily,
                    fontSize: basePreviewSize * _s.fontSize,
                    color: tx.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Font size ──────────────────────────────────────────
          _Label('Taille du texte', tx),
          const SizedBox(height: 10),
          Row(
            children: [
              _SizeButton(
                label: 'A',
                size: 13,
                color: tx,
                surface: sf,
                onTap: () => _update(_s.copyWith(fontSize: (_s.fontSize - 0.1).clamp(0.7, 2.0))),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    activeTrackColor: primary,
                    inactiveTrackColor: sf,
                    thumbColor: primary,
                    overlayColor: primary.withOpacity(0.1),
                  ),
                  child: Slider(
                    min: 0.7, max: 2.0,
                    value: _s.fontSize,
                    onChanged: (v) => _update(_s.copyWith(fontSize: v)),
                  ),
                ),
              ),
              _SizeButton(
                label: 'A',
                size: 20,
                color: tx,
                surface: sf,
                onTap: () => _update(_s.copyWith(fontSize: (_s.fontSize + 0.1).clamp(0.7, 2.0))),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Line height ────────────────────────────────────────
          _Label('Interligne', tx),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.format_line_spacing, size: 16, color: tx.withOpacity(0.4)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    activeTrackColor: primary,
                    inactiveTrackColor: sf,
                    thumbColor: primary,
                    overlayColor: primary.withOpacity(0.1),
                  ),
                  child: Slider(
                    min: 1.2, max: 2.4, divisions: 12,
                    value: _s.lineHeight,
                    onChanged: (v) => _update(_s.copyWith(lineHeight: v)),
                  ),
                ),
              ),
              Icon(Icons.format_line_spacing, size: 22, color: tx.withOpacity(0.4)),
            ],
          ),

          const SizedBox(height: 20),

          // ── Font family ────────────────────────────────────────
          _Label('Police', tx),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _families.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = _s.fontFamily == _families[i];
                return GestureDetector(
                  onTap: () => _update(_s.copyWith(fontFamily: _families[i])),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? primary : sf,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _families[i],
                      style: TextStyle(
                        fontFamily: _families[i],
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected ? Colors.white : tx.withOpacity(0.7),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ── Theme ──────────────────────────────────────────────
          _Label('Thème', tx),
          const SizedBox(height: 10),
          Row(
            children: ReadingTheme.values.map((t) {
              final selected = _s.theme == t;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _update(_s.copyWith(theme: t)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    height: 44,
                    decoration: BoxDecoration(
                      color: t.background,
                      border: Border.all(
                        color: selected ? primary : t.surface,
                        width: selected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        t.label,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: t.text,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // done button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context, _s),
              child: const Text('Terminé',
                  style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 14,
                    fontWeight: FontWeight.w500, color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final Color color;
  const _Label(this.text, this.color);

  @override
  Widget build(BuildContext context) => Text(text,
    style: TextStyle(
      fontFamily: 'Poppins', fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      color: color.withOpacity(0.4),
    ),
  );
}

class _SizeButton extends StatelessWidget {
  final String label;
  final double size;
  final Color color;
  final Color surface;
  final VoidCallback onTap;
  const _SizeButton({required this.label, required this.size,
    required this.color, required this.surface, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34, height: 34,
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(8)),
      child: Center(child: Text(label,
        style: TextStyle(fontFamily: 'Georgia', fontSize: size,
            fontWeight: FontWeight.w700, color: color),
      )),
    ),
  );
}