import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constants/api_constants.dart';
import '../../../constants/format_utils.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/globals.dart';
import '../../../utils/icons/my_icons.dart';
import '../../../utils/widgets/storage_permission_dialog.dart';
import '../../download_app_resources/storage_permission.dart';
import '../data/models/media_file.dart';
import '../pages/media_link_page.dart';
import '../pages/media_page.dart';
import '../pages/read_pdf_file_page.dart';

class MediaFileItem extends StatefulWidget {
  const MediaFileItem({super.key, required this.mediaFile, this.onRefreshRequested});
  final MediaFile mediaFile;
  final Function? onRefreshRequested;

  @override
  State<MediaFileItem> createState() => _MediaFileItemState();
}

class _MediaFileItemState extends State<MediaFileItem> {
  // ----------------------------------------------------------------------
  // Design tokens for the new card look. Tweak these to taste / theme.
  // ----------------------------------------------------------------------
  static const double _cardRadius = 20;
  static const double _thumbRadius = 16;
  static const Color _accent = Color(0xFF3D6BF0); // swap for your brand blue
  static final Color _accentSoft = _accent.withOpacity(.10);

  // Needed to compute sharePositionOrigin for the iOS/iPad share popover
  // — without it, Share.shareXFiles/Share.share throws a
  // PlatformException on iPad ("sharePositionOrigin: argument must be
  // set"). Anchored to the "Partager" row inside the sheet itself,
  // since that's the tappable element actually on screen when the
  // share call fires.
  final GlobalKey _shareRowKey = GlobalKey();

  @override
  void initState() {
    _loadDownloadedFiles();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _loadDownloadedFiles();
    super.didChangeDependencies();
  }

  List<FileSystemEntity> _downloadedFiles = [];
  bool _isDownloading = false;
  double _progress = 0.0;

  bool get _isPdf => widget.mediaFile.mediaTypeId == 1;
  bool get _isDownloaded => _downloadedFiles.isNotEmpty;

  // ----------------------------------------------------------------------
  // File system / download
  // ----------------------------------------------------------------------

  Future<String> _getDownloadDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return "${directory!.path}/DownloadedFiles";
  }

  Future<void> _loadDownloadedFiles() async {
    String directoryPath = await _getDownloadDirectory();
    Directory directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      setState(() {});
      return;
    }

    setState(() {
      if (widget.mediaFile.path != null) {
        _downloadedFiles = directory
            .listSync()
            .where((file) => widget.mediaFile.path!.split('/').last == file.path.split('/').last)
            .toList();
      }
    });
  }

  Future<void> refreshFiles() async {
    await _loadDownloadedFiles();
  }

  // Call this from parent if needed
  void requestRefresh() {
    widget.onRefreshRequested?.call();
  }

  /// Checks the current storage permission and, if needed, shows the
  /// rationale dialog. Returns whether we're clear to download.
  ///
  /// This replaces the old implementation, which on iOS scheduled the
  /// dialog with `addPostFrameCallback` and then returned `false`
  /// immediately on the next line — before the dialog had even appeared,
  /// let alone before the person responded. Net effect: downloads were
  /// permanently broken on iOS regardless of what was tapped.
  /// `StoragePermissionService` already knows iOS doesn't need this
  /// permission at all for the app's own sandboxed directory, so this
  /// resolves instantly and correctly there.
  Future<bool> _ensureStoragePermission() async {
    var result = await StoragePermissionService().check();

    if (result == StoragePermissionResult.denied) {
      if (!mounted) return false;
      result = await showStoragePermissionDialog(context);
    }

    if (result == StoragePermissionResult.permanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return result == StoragePermissionResult.granted;
  }

  Future<void> downloadAudioFile({required String name, required String url}) async {
    final hasPermission = await _ensureStoragePermission();
    if (!hasPermission) {
      if (kDebugMode) print("Permission denied!");
      return;
    }

    final dio = Dio();
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    try {
      final directoryPath = await _getDownloadDirectory();
      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final fileName = url.split('/').last;
      final savePath = "$directoryPath/$fileName";

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total == -1) return;
          setState(() => _progress = received / total);
          if (_progress == 1) _loadDownloadedFiles();
        },
      );
    } catch (e) {
      if (kDebugMode) print("Error: $e");
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  /// Computes the on-screen rect of the "Partager" row so iOS/iPad has
  /// a popover anchor point. Returns null (letting share_plus fall back
  /// to its own default) if the render box isn't ready for some reason
  /// — safer than crashing.
  Rect? _shareOrigin() {
    final box = _shareRowKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  // ----------------------------------------------------------------------
  // Bottom sheet
  // ----------------------------------------------------------------------

  void _modalBottomSheetMenu({required BuildContext context, required String name, FileSystemEntity? file}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.screenSize.width * .07, vertical: context.screenSize.width * .07),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E4E4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text('Actions',
                      style: TextStyle(
                          fontSize: fontSizes.font20(context.screenSize),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: black)),
                  const SizedBox(height: 18),
                  if (file == null && _isPdf)
                    _sheetAction(
                      context: context,
                      icon: MyIcons.download,
                      label: 'Télécharger',
                      onTap: () {
                        downloadAudioFile(
                            url: "${ApiConstants.storageUrl}${widget.mediaFile.path}", name: widget.mediaFile.name);
                        logger.i("${ApiConstants.storageUrl}${widget.mediaFile.path}");
                        Navigator.pop(context);
                      },
                    ),
                  if (file != null || !_isPdf)
                    _sheetAction(
                      key: _shareRowKey,
                      context: context,
                      icon: MyIcons.share,
                      label: 'Partager',
                      onTap: () async {
                        final origin = _shareOrigin();
                        if (file != null) {
                          await Share.shareXFiles(
                            [XFile(file.path)],
                            subject: widget.mediaFile.name,
                            text: 'chantpouryehoshoua.org',
                            sharePositionOrigin: origin,
                          );
                          Navigator.pop(context);
                        } else {
                          await Share.share(
                            "${widget.mediaFile.name} \n \n ${widget.mediaFile.link}",
                            subject: widget.mediaFile.name,
                            sharePositionOrigin: origin,
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// One row inside the actions bottom sheet — icon in a soft rounded
  /// swatch + label, matching the card's visual language.
  Widget _sheetAction({
    Key? key,
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: key,
      borderRadius: BorderRadius.circular(14),
      splashColor: _accentSoft,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _accentSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: MyIcon(icon: icon, size: 18, color: _accent),
            ),
            const SizedBox(width: 16),
            Text(label,
                style: TextStyle(
                    fontSize: fontSizes.font15(context.screenSize),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: tColorLight)),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // Presentational helpers
  // ----------------------------------------------------------------------

  /// "PDF" / "LIEN" pill shown under the title.
  Widget _typeBadge(BuildContext context) {
    final String label = _isPdf ? 'PDF' : 'LIEN';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _accentSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSizes.font11(context.screenSize) * .85,
          fontWeight: FontWeight.w600,
          color: _accent,
          letterSpacing: .4,
        ),
      ),
    );
  }

  /// Thumbnail with rounded corners + a tiny type icon chip floating on
  /// its bottom-right corner. For a PDF that isn't downloaded yet, this
  /// badge is a real download button (it visually promises exactly that,
  /// so it should act like one) — tapping it reuses the same
  /// downloadAudioFile() call as the "Télécharger" action in the sheet.
  /// Once a PDF is downloaded, the badge is hidden entirely (see
  /// `showBadge`); for links it stays purely informational.
  Widget _thumbnail(BuildContext context) {
    final double size = context.screenSize.width * .19;
    final bool showBadge = !_isPdf || !_isDownloaded;
    final bool badgeIsDownloadAction = _isPdf && !_isDownloaded && !_isDownloading;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CachedNetworkImage(
          imageUrl: "${ApiConstants.storageUrl}${widget.mediaFile.placeHolderImage}",
          imageBuilder: (context, imageProvider) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_thumbRadius),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: _accentSoft, borderRadius: BorderRadius.circular(_thumbRadius)),
          ),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: _accentSoft, borderRadius: BorderRadius.circular(_thumbRadius)),
          ),
        ),
        if (showBadge)
          Positioned(
            bottom: -6,
            right: -6,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: Colors.black.withOpacity(.08),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: badgeIsDownloadAction
                    ? () => downloadAudioFile(
                  url: "${ApiConstants.storageUrl}${widget.mediaFile.path}",
                  name: widget.mediaFile.name,
                )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: MyIcon(
                    icon: _isPdf ? MyIcons.download : MyIcons.link,
                    size: 12,
                    color: _accent,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Trailing action button. Shows a circular progress ring while a
  /// download is in flight, otherwise a soft rounded icon button.
  Widget _trailingAction(BuildContext context) {
    if (_isDownloading) {
      return SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 3,
                backgroundColor: _accentSoft,
                valueColor: AlwaysStoppedAnimation(_accent),
              ),
            ),
            Text(
              '${(_progress * 100).toStringAsFixed(0)}',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _accent, fontFamily: 'Poppins'),
            ),
          ],
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: _accentSoft,
      onTap: () => _modalBottomSheetMenu(
        context: context,
        name: widget.mediaFile.name,
        file: _isDownloaded ? _downloadedFiles.first : null,
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: _accentSoft, shape: BoxShape.circle),
        child: Center(
          child: MyIcon(
            size: 18,
            color: _accent,
            // Simplified from a three-branch ternary that always resolved
            // to the same two outcomes: PDFs show the actions menu, links
            // show the link icon.
            icon: _isPdf ? MyIcons.moreVert : MyIcons.link,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<RefreshNotifier>();

    return InkWell(
      borderRadius: BorderRadius.circular(_cardRadius),
      splashColor: _accentSoft,
      onTap: () {
        if (_isPdf) {
          widget.onRefreshRequested?.call();
          logger.i(widget.mediaFile.path);
          if (_isDownloaded) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReadPdfFilePage(filePath: _downloadedFiles.first.path, mediaFile: widget.mediaFile)));
          }
        } else {
          logger.i(widget.mediaFile.toJson());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MediaLinkPage(webLink: widget.mediaFile.link.toString(), name: widget.mediaFile.name)));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: EdgeInsets.symmetric(
          horizontal: context.screenSize.width * .035,
          vertical: context.screenSize.width * .03,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 14, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _thumbnail(context),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.mediaFile.name.toString(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isPdf ? formatFileSize(widget.mediaFile.size) : widget.mediaFile.link ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSizes.font11(context.screenSize),
                      color: muted,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _typeBadge(context),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _trailingAction(context),
          ],
        ),
      ),
    );
  }
}