import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/dimensions/fontsizes.dart';
import '../../../font_settings/reading_settings.dart';

/// Same lyrics rendering as before, now wrapped in a [SelectionArea] so
/// the person can select, copy, or share any portion of the text.
///
/// [SelectionArea] makes ordinary [Text]/[RichText] descendants
/// selectable automatically — including the chord/word pairs built as
/// [WidgetSpan]s inside [ChordLyricWidget] — with no changes needed to
/// how the lines themselves are built. The only addition is a custom
/// long-press/right-click toolbar (`contextMenuBuilder`) that appends
/// a "Partager" button next to the built-in Copy/Select all, wired to
/// whatever text is currently selected.
///
/// Note: this widget is instantiated once per verse/partition, so
/// selection and "Partager" are scoped to that partition's text, not
/// the whole song. If you want selection to span the entire song at
/// once, the SelectionArea would need to move up to wrap the whole
/// lyrics tab in the parent page instead — happy to do that as a
/// follow-up if it's what you want.
class HymnLyricsItem extends StatefulWidget {
  const HymnLyricsItem({
    super.key,
    required this.chordOverLyrics,
    required this.lyrics,
    required this.settings,
    this.staggerIndex = 0,
  });

  final int chordOverLyrics;
  final String lyrics;
  final ReadingSettings settings;

  /// Index of this verse/partition within the song — offsets the
  /// entrance animation slightly per verse so they don't all pop in
  /// at once.
  final int staggerIndex;

  @override
  State<HymnLyricsItem> createState() => _HymnLyricsItemState();
}

class _HymnLyricsItemState extends State<HymnLyricsItem> {
  String _selectedText = '';

  @override
  Widget build(BuildContext context) {
    final lines = widget.lyrics.split('|');

    return SelectionArea(
      onSelectionChanged: (SelectedContent? content) {
        _selectedText = content?.plainText ?? '';
      },
      contextMenuBuilder: (context, selectableRegionState) {
        final items = List<ContextMenuButtonItem>.of(selectableRegionState.contextMenuButtonItems);
        items.add(
          ContextMenuButtonItem(
            label: 'Partager',
            onPressed: () {
              final text = _selectedText.trim();
              selectableRegionState.hideToolbar();
              if (text.isNotEmpty) {
                Share.share(text);
              }
            },
          ),
        );
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: selectableRegionState.contextMenuAnchors,
          buttonItems: items,
        );
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lines.length,
        itemBuilder: (context, i) {
          final line = lines[i];
          final child = widget.chordOverLyrics == 0
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              line,
              style: TextStyle(
                fontFamily: widget.settings.fontFamily,
                // Bug fix: the old global fontSizeGlobal was tracked by
                // the slider but never multiplied into this fontSize —
                // dragging "Taille du texte" had no visible effect.
                fontSize: FontSizes().fontReading(context.screenSize) * widget.settings.fontSize,
                color: widget.settings.theme.text,
                fontWeight: FontWeight.w300,
                height: widget.settings.lineHeight,
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ChordLyricWidget(input: line, settings: widget.settings),
          );

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 260 + ((widget.staggerIndex * 60) + (i * 25)).clamp(0, 400)),
            curve: Curves.easeOut,
            builder: (context, value, animatedChild) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 8),
                  child: animatedChild,
                ),
              );
            },
            child: child,
          );
        },
      ),
    );
  }
}

class ChordLyricWidget extends StatelessWidget {
  const ChordLyricWidget({super.key, required this.input, required this.settings});

  final String input;
  final ReadingSettings settings;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];

    final regex = RegExp(r'(\[\d+\])?([^\[\]\s]+[\s,"]*)');
    final matches = regex.allMatches(input);

    for (final match in matches) {
      final chord = match.group(1); // e.g. [1]
      final word = match.group(2); // e.g. prophecy or spoken

      if (chord != null) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Wrap(
            spacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                chord.split('[').last.split("]").first,
                style: TextStyle(
                  fontFamily: settings.fontFamily,
                  fontSize: FontSizes().fontReadingSmall(context.screenSize) * settings.fontSize,
                  color: primary,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                word!,
                style: TextStyle(
                  fontFamily: settings.fontFamily,
                  fontSize: FontSizes().fontReading(context.screenSize) * settings.fontSize,
                  color: settings.theme.text,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ));
      } else {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Text(
            word!,
            style: TextStyle(
              fontFamily: settings.fontFamily,
              fontSize: FontSizes().fontReading(context.screenSize) * settings.fontSize,
              color: settings.theme.text,
              fontWeight: FontWeight.w300,
            ),
          ),
        ));
      }
    }

    return RichText(text: TextSpan(children: spans));
  }
}