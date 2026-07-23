import 'package:cpy_app/constants/api_constants.dart';
import 'package:cpy_app/data/models/hymn_partition.dart';
import 'package:cpy_app/data/models/hymn_song.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/models/hymn_partition_type.dart';
import '../../../../data/test_data/hymn_test_data.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/icons/myIcon.dart';
import '../../../../utils/icons/my_icons.dart';
import '../../../font_settings/reading_settings.dart';
import '../../audio_player/audio_player_service.dart';
import '../../audio_player/mini_player.dart';
import '../../download_audio/download_controller.dart';
import '../../download_audio/hymn_download_sheet.dart';
import '../../providers/admin_hymn_book_provider.dart';
import 'chord_widget.dart';
import 'hymn_lyrics_item.dart';

class HymnSongDetailsPage extends StatefulWidget {
  const HymnSongDetailsPage({super.key, required this.hymnSong, required this.songId});

  final HymnSong hymnSong;
  final int songId;

  @override
  State<HymnSongDetailsPage> createState() => _HymnSongDetailsPageState();
}

class _HymnSongDetailsPageState extends State<HymnSongDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Audio playback now lives entirely in HymnAudioPlayerService. This
  // page just creates one instance, hands it to the mini player widget,
  // and reads its position/duration to drive lyric sync.
  final HymnAudioPlayerService _audioService = HymnAudioPlayerService();

  // Needed to compute sharePositionOrigin for the iOS/iPad share
  // popover — without it, Share.shareXFiles/Share.share throws a
  // PlatformException on iPad ("sharePositionOrigin: argument must be
  // set"), since iOS needs a screen anchor point for the popover.
  final GlobalKey _shareButtonKey = GlobalKey();

  late final AdminHymnBookProvider _provider;
  late final HymnAudioDownloadController _downloadController;

  ReadingSettings _readingSettings = const ReadingSettings(fontSize: 16);

  static const double _cardRadius = 24;

  @override
  void initState() {
    super.initState();
    ReadingSettingsStore.load().then((s) => setState(() => _readingSettings = s));

    _provider = Provider.of<AdminHymnBookProvider>(context, listen: false);
    _provider.getHymnSong(id: widget.songId);

    _downloadController = HymnAudioDownloadController(audioUrl: widget.hymnSong.audioUrl!);
    _downloadController.loadDownloadedFiles();

    fromKey = noteScales[widget.hymnSong!.scaleId! - 1];

    _tabController = TabController(length: 2, vsync: this);
    _loadSettings();
  }

  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    _downloadController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSizeGlobal = prefs.getDouble('fontSizeGlobal') ?? 1.0;
      fontFamilyGlobal = prefs.getString('fontFamilyGlobal') ?? 'Roboto';
      textOpacityGlobal = prefs.getDouble('textOpacityGlobal') ?? 1.0;
    });
  }

  String? fromKey;

  HymnPartitionType? getPartition(int id) {
    var l = partitionTypes.where((partition) {
      return partition.id == id;
    }).toList();
    if (l.isEmpty) {
      return null;
    } else {
      return l.first;
    }
  }

  int? find;

  void _openDownloadSheet(BuildContext context) {
    HymnDownloadActionsSheet.show(
      context: context,
      fileType: widget.hymnSong.audioUrl!.split('.').last,
      fileSizeMb: "${double.parse("${(widget.hymnSong.fileSize ?? 0) / (1024 * 1024)}").toStringAsFixed(2)} mb",
      onDownload: () {
        _downloadController.download(
          context: context,
          url: "${ApiConstants.storageUrl}${widget.hymnSong.audioUrl}",
        );
      },
    );
  }

  /// Computes the on-screen rect of the share button so iOS/iPad has a
  /// popover anchor point. Returns null (and lets share_plus fall back
  /// to its own default) if the render box isn't ready yet for some
  /// reason — safer than crashing.
  Rect? _shareOrigin() {
    final box = _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  /// Builds the shareable text block (title, lyrics, chords, contact
  /// link) once, so both share paths use the exact same content.
  String _buildShareText() {
    return '${widget.hymnSong.title}   \n  \n ${widget.hymnSong.partitions!.map((song) => "${getPartition(song.id)!.nameFr}\n ${song.lyrics} ${widget.hymnSong.hasOneProgression != 1 ? song.chordProgression!.map((chord) => "${chord.note}^${chord.duration}") : widget.hymnSong.singleChordProgression!.map((chord) => "${chord.note}^${chord.duration}")}\n \n")}  \n  \n chantpouryehoshoua.org';
  }

  Future<void> _shareLyrics(BuildContext sheetContext) async {
    Navigator.pop(sheetContext);
    final origin = _shareOrigin();
    await Share.share(
      _buildShareText(),
      subject: widget.hymnSong.title,
      sharePositionOrigin: origin,
    );
  }

  Future<void> _shareAudio(BuildContext sheetContext) async {
    Navigator.pop(sheetContext);
    final origin = _shareOrigin();
    // Sharing just the file (no accompanying text) — most share
    // targets drop a text/caption field for audio attachments anyway,
    // so asking the person to pick "lyrics" or "audio" up front is a
    // cleaner fix than fighting that per-app inconsistency.
    await Share.shareXFiles(
      [XFile(_downloadController.downloadedFiles[0].path)],
      subject: widget.hymnSong.title,
      sharePositionOrigin: origin,
    );
  }

  /// Share options sheet — same visual language as the actions sheet
  /// on media items and the download sheet: drag handle, title, rows
  /// with an icon in a soft primaryLight circle + label. Audio option
  /// only shows when a download actually exists.
  void _showShareSheet(BuildContext context) {
    final hasAudio = widget.hymnSong.fileSize != null && _downloadController.hasDownload;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Partager',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: fontSizes.font17(sheetContext.screenSize),
                color: black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasAudio ? 'Choisissez ce que vous voulez partager' : 'Partager les paroles de ce cantique',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fontSizes.font11(sheetContext.screenSize),
                color: dark.withOpacity(.6),
              ),
            ),
            const SizedBox(height: 14),
            _shareOptionRow(
              sheetContext,
              icon: Icons.article_outlined,
              label: 'Paroles',
              subtitle: 'Texte du cantique',
              onTap: () => _shareLyrics(sheetContext),
            ),
            if (hasAudio)
              _shareOptionRow(
                sheetContext,
                icon: Icons.audiotrack_rounded,
                label: 'Audio',
                subtitle: 'Fichier téléchargé',
                onTap: () => _shareAudio(sheetContext),
              ),
          ],
        ),
      ),
    );
  }

  Widget _shareOptionRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      splashColor: primarySoft.withOpacity(.2),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSizes.font15(context.screenSize),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: fontSizes.font11(context.screenSize),
                      fontFamily: 'Poppins',
                      color: dark.withOpacity(.55),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: dark.withOpacity(.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabToggle(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _tabPill(context, label: 'Paroles', index: 0),
          _tabPill(context, label: 'Accords', index: 1),
        ],
      ),
    );
  }

  Widget _tabPill(BuildContext context, {required String label, required int index}) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabController.animateTo(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fontSizes.font13(context.screenSize),
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : dark,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool useFrench = true;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 148),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 20),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              title: Text(
                widget.hymnSong.title!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizes.font17(context.screenSize),
                  color: black,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _buildTabToggle(context),
                ),
              ),
              actions: [
                ListenableBuilder(
                  listenable: _downloadController,
                  builder: (context, _) {
                    if (_downloadController.hasDownload || widget.hymnSong.fileSize == null) {
                      return const SizedBox.shrink();
                    }
                    if (!_downloadController.isDownloading) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () => _openDownloadSheet(context),
                        child: const MyIcon(size: 20, icon: MyIcons.download),
                      );
                    }
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator(
                            value: _downloadController.progress,
                            strokeWidth: 3,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(primaryDark),
                          ),
                        ),
                        Text(
                          '${(_downloadController.progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: fontSizes.font10(context.screenSize),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _downloadController,
                  builder: (context, _) {
                    return InkWell(
                      key: _shareButtonKey,
                      onTap: () => _showShareSheet(context),
                      splashColor: Colors.transparent,
                      child: const MyIcon(size: 20, icon: MyIcons.share),
                    );
                  },
                ),
                currentIndex == 0
                    ? IconButton(
                  onPressed: () async {
                    final result = await showReadingSettings(context: context, current: _readingSettings);
                    if (result != null) setState(() => _readingSettings = result);
                  },
                  icon: const Icon(Icons.font_download_outlined, size: 20),
                )
                    : PopupMenuButton<String>(
                  iconColor: primary,
                  iconSize: 28,
                  surfaceTintColor: Colors.transparent,
                  color: Colors.white,
                  onSelected: (value) {
                    setState(() {
                      fromKey = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return noteScales.map((String letter) {
                      return PopupMenuItem<String>(
                        value: letter,
                        child: Text(letter,
                            style: TextStyle(color: letter == fromKey ? primary : dark, fontWeight: letter == fromKey ? FontWeight.bold : FontWeight.normal)),
                      );
                    }).toList();
                  },
                  icon: const Icon(Icons.music_note_outlined, size: 20),
                ),
              ],
            ),
          ),
        ),
        body: buildHymnSongTab(useFrench: useFrench),
      ),
    );
  }

  Widget buildHymnSongTab({required bool useFrench}) {
    return Consumer<AdminHymnBookProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (provider.error != null) {}

      if (provider.hymnSong == null) {
        return provider.error != null ? Center(child: Text(provider.error!)) : const SizedBox();
      }

      return TabBarView(
        controller: _tabController,
        children: [
          Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(top: 20, bottom: 160),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.hymnSong!.partitions!.length,
                      itemBuilder: (context, index) {
                        final partition = provider.hymnSong!.partitions![index];
                        return _buildSongPartition(partition: partition, song: provider.hymnSong!, index: index);
                      },
                    ),
                  ],
                ),
              ),
              ListenableBuilder(
                listenable: _downloadController,
                builder: (context, _) {
                  if (!_downloadController.hasDownload) return const SizedBox.shrink();
                  return Positioned(
                    bottom: 10,
                    left: 5,
                    right: 5,
                    child: HymnAudioMiniPlayer(
                      service: _audioService,
                      file: _downloadController.downloadedFiles.last,
                      title: widget.hymnSong.title!,
                    ),
                  );
                },
              ),
            ],
          ),
          Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    provider.hymnSong!.hasOneProgression! != 1
                        ? ListView(
                      padding: const EdgeInsets.only(top: 20, bottom: 160),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: provider.hymnSong!.partitions!.map((song) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabelPill(context, getPartition(song.id)!.nameFr),
                                  ],
                                ),
                              ),
                              song.chordProgression!.length > 1
                                  ? SongChordsWidget(notes: song.chordProgression!, useFrench: useFrench, fromKey: fromKey!)
                                  : const SizedBox(),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelPill(context, "Couplet et refrain"),
                              ],
                            ),
                          ),
                          SongChordsWidget(notes: provider.hymnSong!.singleChordProgression!, useFrench: useFrench, fromKey: fromKey!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListenableBuilder(
                listenable: _downloadController,
                builder: (context, _) {
                  if (!_downloadController.hasDownload) return const SizedBox.shrink();
                  return Positioned(
                    bottom: 10,
                    left: 5,
                    right: 5,
                    child: HymnAudioMiniPlayer(
                      service: _audioService,
                      file: _downloadController.downloadedFiles.last,
                      title: widget.hymnSong.title!,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildSongPartition({required HymnPartition partition, required HymnSong song, required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabelPill(context, getPartition(partition.id)!.nameFr),
                SizedBox(height: context.screenSize.height * .035),
                HymnLyricsItem(
                  chordOverLyrics: song.hasChordOverLyrics!,
                  lyrics: partition.lyrics,
                  settings: _readingSettings,
                  staggerIndex: index,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Verse-type pill — same soft chip regardless of type (couplet vs.
  /// refrain no longer changes the fill color), with a small icon doing
  /// the job color used to do: a repeat glyph for refrain, a note for
  /// everything else. Matches the stat-chip language used on hymn/book
  /// cards elsewhere (soft primaryLight fill, primary icon + text).
  Widget _buildLabelPill(BuildContext context, String label) {
    final isRefrain = label.toLowerCase().contains('refrain');
    final icon = isRefrain ? Icons.repeat_rounded : Icons.music_note_rounded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: FontSizes().font12(context.screenSize),
              letterSpacing: 0.6,
              height: 1,
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}