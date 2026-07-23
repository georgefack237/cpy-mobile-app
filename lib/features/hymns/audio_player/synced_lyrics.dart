import 'package:flutter/material.dart';
import '../../../../data/models/hymn_partition.dart';
import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/dimensions/fontsizes.dart';
import '../../../utils/globals.dart';
import '../../font_settings/reading_settings.dart';

/// A single displayable line of lyrics, tagged with which partition it
/// came from and an *estimated* start time as a fraction (0.0–1.0) of
/// the total audio duration.
///
/// NOTE ON ACCURACY: there is no per-line timestamp data in the hymn
/// model today, so `startFraction` is estimated by cumulative character
/// count across all partitions. It tracks reasonably well for songs
/// without long instrumental intros/outros, but it is an approximation,
/// not a transcript-level sync. If real timestamps become available per
/// line (or per partition), replace `_buildTimeline` below with a
/// direct lookup and everything downstream keeps working unchanged.
class _LyricLine {
  _LyricLine({
    required this.partitionIndex,
    required this.text,
    required this.startFraction,
    required this.isPartitionStart,
  });

  final int partitionIndex;
  final String text;
  final double startFraction;
  final bool isPartitionStart;
}

class SyncedLyricsView extends StatefulWidget {
  const SyncedLyricsView({
    super.key,
    required this.partitions,
    required this.partitionLabel,
    required this.position,
    required this.duration,
    required this.isActive,
    this.settings = const ReadingSettings(),
  });

  /// Ordered list of song partitions (verses, chorus, etc.) exactly as
  /// they appear in the song.
  final List<HymnPartition> partitions;

  /// Returns the display label (e.g. "Couplet 1") for the partition at
  /// the given list index.
  final String Function(int index) partitionLabel;

  final Duration position;
  final Duration duration;

  /// Whether audio is actually loaded/playing. When false, no line is
  /// highlighted and the view behaves like a plain static lyrics list.
  final bool isActive;

  final ReadingSettings settings;

  @override
  State<SyncedLyricsView> createState() => _SyncedLyricsViewState();
}

class _SyncedLyricsViewState extends State<SyncedLyricsView> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _lineKeys = {};
  late List<_LyricLine> _timeline;
  int _lastActiveIndex = -1;

  @override
  void initState() {
    super.initState();
    _timeline = _buildTimeline(widget.partitions);
  }

  @override
  void didUpdateWidget(covariant SyncedLyricsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.partitions != widget.partitions) {
      _timeline = _buildTimeline(widget.partitions);
      _lineKeys.clear();
    }
    if (widget.isActive && widget.duration.inMilliseconds > 0) {
      _maybeAutoScroll();
    }
  }

  /// Flattens every partition's lyrics into ordered lines and assigns
  /// each an estimated start fraction proportional to how many
  /// characters of lyrics precede it.
  List<_LyricLine> _buildTimeline(List<HymnPartition> partitions) {
    final rawLines = <_LyricLine>[];
    final charCounts = <int>[];
    int totalChars = 0;

    for (var i = 0; i < partitions.length; i++) {
      final lines = partitions[i].lyrics.split('\n').where((l) => l.trim().isNotEmpty).toList();
      for (var j = 0; j < lines.length; j++) {
        rawLines.add(_LyricLine(
          partitionIndex: i,
          text: lines[j],
          startFraction: 0, // filled below
          isPartitionStart: j == 0,
        ));
        charCounts.add(lines[j].length + 1);
        totalChars += lines[j].length + 1;
      }
    }

    if (totalChars == 0) return rawLines;

    int cumulative = 0;
    final timed = <_LyricLine>[];
    for (var i = 0; i < rawLines.length; i++) {
      final fraction = cumulative / totalChars;
      timed.add(_LyricLine(
        partitionIndex: rawLines[i].partitionIndex,
        text: rawLines[i].text,
        startFraction: fraction,
        isPartitionStart: rawLines[i].isPartitionStart,
      ));
      cumulative += charCounts[i];
    }
    return timed;
  }

  int _activeLineIndex() {
    if (!widget.isActive || widget.duration.inMilliseconds == 0 || _timeline.isEmpty) return -1;
    final posFraction = widget.position.inMilliseconds / widget.duration.inMilliseconds;
    var active = 0;
    for (var i = 0; i < _timeline.length; i++) {
      if (_timeline[i].startFraction <= posFraction) {
        active = i;
      } else {
        break;
      }
    }
    return active;
  }

  void _maybeAutoScroll() {
    final activeIndex = _activeLineIndex();
    if (activeIndex == -1 || activeIndex == _lastActiveIndex) return;
    _lastActiveIndex = activeIndex;

    final key = _lineKeys[activeIndex];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        alignment: 0.35,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _activeLineIndex();
    // NOTE: `font15` and the ReadingSettings field names below
    // (fontScale/fontFamily/textOpacity) are assumptions based on how
    // _readingSettings/fontSizes were used in the original page — check
    // these against your actual FontSizes and ReadingSettings classes
    // and adjust if the names differ.
    final fontSize = fontSizes.font13(context.screenSize);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 20, bottom: 160),
      itemCount: _timeline.length,
      itemBuilder: (context, index) {
        final line = _timeline[index];
        _lineKeys.putIfAbsent(index, () => GlobalKey());
        final isActive = index == activeIndex;
        final isPast = widget.isActive && index < activeIndex;

        return Padding(
          key: _lineKeys[index],
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: line.isPartitionStart ? 10 : 4,
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontFamily: widget.settings.fontFamily,
              fontSize: fontSize,
              height: 1.5,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive
                  ? primary
                  : isPast
                  ? dark.withOpacity(0.35)
                  : dark.withOpacity(0.35),
            ),
            child: Text(line.text),
          ),
        );
      },
    );
  }
}