import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/dimensions/fontsizes.dart';
import '../../../utils/globals.dart';
import 'audio_player_service.dart';

/// Audio player for the hymn detail page. Collapsed, it's a slim pill
/// (title hidden, just transport + scrub). Tapping it expands into the
/// fuller "now playing" card with skip ±15s and time labels; tapping
/// the chevron on the card collapses it back down.
class HymnAudioMiniPlayer extends StatefulWidget {
  const HymnAudioMiniPlayer({
    super.key,
    required this.service,
    required this.file,
    required this.title,
    this.initiallyExpanded = false,
  });

  final HymnAudioPlayerService service;
  final FileSystemEntity file;
  final String title;
  final bool initiallyExpanded;

  @override
  State<HymnAudioMiniPlayer> createState() => _HymnAudioMiniPlayerState();
}

class _HymnAudioMiniPlayerState extends State<HymnAudioMiniPlayer> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() => setState(() => _expanded = !_expanded);

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  String _speedLabel(double speed) {
    final trimmed = speed == speed.roundToDouble() ? speed.toInt().toString() : speed.toString();
    return '${trimmed}x';
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_expanded ? 20 : 28),
              border: Border.all(color: const Color(0xFFF0EFEC), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _expanded ? _buildExpanded(context, service) : _buildCollapsed(context, service),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---- Collapsed: pill (design A) ----------------------------------

  Widget _buildCollapsed(BuildContext context, HymnAudioPlayerService service) {
    return Padding(
      key: const ValueKey('collapsed'),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: GestureDetector(
        onTap: _toggle,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            _PlayButton(
              size: 38,
              iconSize: 16,
              isPlaying: service.isPlaying,
              onTap: () => service.togglePlayPause(widget.file),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ScrubTrack(
                service: service,
                height: 3,
                trackColor: accent,
              ),
            ),
            const SizedBox(width: 10),
            _SpeedChip(
              label: _speedLabel(service.speed),
              onTap: service.cycleSpeed,
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_up_rounded, size: 20, color: dark.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  // ---- Expanded: now-playing card (design B) ------------------------

  Widget _buildExpanded(BuildContext context, HymnAudioPlayerService service) {
    final remaining = service.duration - service.position;
    return Padding(
      key: const ValueKey('expanded'),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.music_note_rounded, color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: fontSizes.font13(context.screenSize),
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatDuration(remaining)} restant \u00b7 ${_formatDuration(service.duration)}',
                      style: TextStyle(
                        fontSize: fontSizes.font10(context.screenSize),
                        color: dark.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _toggle,
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.keyboard_arrow_down_rounded, size: 22, color: dark.withOpacity(0.5)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ScrubTrack(service: service, height: 4, trackColor: black),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SpeedChip(label: _speedLabel(service.speed), onTap: service.cycleSpeed),
              Row(
                children: [
                  _SkipButton(icon: Icons.replay_10_rounded, onTap: service.skipBackward),
                  const SizedBox(width: 18),
                  _PlayButton(
                    size: 46,
                    iconSize: 22,
                    isPlaying: service.isPlaying,
                    onTap: () => service.togglePlayPause(widget.file),
                  ),
                  const SizedBox(width: 18),
                  _SkipButton(icon: Icons.forward_10_rounded, onTap: service.skipForward),
                ],
              ),
              const SizedBox(width: 44),
            ],
          ),
        ],
      ),
    );
  }
}

/// Draggable scrub bar shared by both the collapsed and expanded
/// layouts — only height and fill color differ between them.
class _ScrubTrack extends StatelessWidget {
  const _ScrubTrack({required this.service, required this.height, required this.trackColor});

  final HymnAudioPlayerService service;
  final double height;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        void seekAt(double dx) {
          final fraction = (dx / width).clamp(0.0, 1.0);
          service.seekFraction(fraction);
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) => seekAt(details.localPosition.dx),
          onTapUp: (details) => seekAt(details.localPosition.dx),
          child: SizedBox(
            height: 16,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: service.progress,
                  child: Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: trackColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.isPlaying,
    required this.onTap,
    required this.size,
    required this.iconSize,
  });

  final bool isPlaying;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      splashColor: Colors.transparent,
      child: Container(
        width: size,
        height: size,
        decoration:  BoxDecoration(shape: BoxShape.circle, color: primaryDarkest),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 22, color: dark.withOpacity(0.7)),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      splashColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F3),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: fontSizes.font10(context.screenSize),
            color: dark,
          ),
        ),
      ),
    );
  }
}