import 'package:cpy_app/features/media/data/models/media_file.dart';
import 'package:cpy_app/features/media/data/models/media_type.dart';
import 'package:cpy_app/features/media/providers/media_files_provider.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors/light_colors.dart';
import '../../hymns/pages/hymn_books_page.dart';
import '../widgets/media_file_item.dart';

// TODO: replace with your real tokens from light_colors.dart
const kPrimaryBlue = Color(0xFF3B6CB7);
const kAccentYellow = Color(0xFFE8A93B);
const kBackground = Color(0xFFFFFFFF);
const kCardBg = Color(0xFFFFFFFF);
const kTextPrimary = Color(0xFF1E1E1E);
const kTextMuted = Color(0xFF8A8880);
const kBorder = Color(0xFFE7E5E0);

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late MediaFilesProvider _provider;
  MediaType? selectedMediaType;
  List<MediaFile> selectedFiles = [];
  bool showOffline = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<MediaFilesProvider>(context, listen: false);
    _provider.getMediaFiles();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mediaTypes.isNotEmpty && mounted) {
        setState(() {
          selectedMediaType = mediaTypes[0];
          _updateSelectedFiles();
          if (showOffline) {
            _updateSelectedFilesLocal();
          }
        });
      }
    });
  }

  void _updateSelectedFiles() {
    if (_provider.files != null && selectedMediaType != null) {
      selectedFiles = _provider.files!
          .where((media) => media.mediaTypeId == selectedMediaType!.id)
          .toList();
    } else {
      selectedFiles = [];
    }
  }

  void _updateSelectedFilesLocal() {
    if (_provider.localFiles != null && selectedMediaType != null) {
      selectedFiles = _provider.localFiles!
          .where((media) => media.mediaTypeId == selectedMediaType!.id)
          .toList();
    } else {
      selectedFiles = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InternetScaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.screenSize.width, 76),
        child: Container(
          color: kBackground,
          margin: const EdgeInsets.only(top: 20),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: kBackground,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: Text(
              'Médiathèque',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: kTextPrimary,
              ) ??
                  const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary,
                  ),
            ),
          ),
        ),
      ),
      body: Container(
        color: kBackground,
        child: RefreshIndicator(
          strokeWidth: 1,
          color: kPrimaryBlue,
          backgroundColor: kCardBg,
          onRefresh: () async {
            _provider.getMediaFiles();
          },
          child: body(),
        ),
      ),
      title: '',
      offline: !showOffline ? _offlinePrompt() : buildOfflineContent(),
    );
  }

  Widget _offlinePrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 32, color: kTextMuted),
            const SizedBox(height: 12),
            const Text(
              'Pas de connexion Internet',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  _provider.getMediaFiles();
                },
                child: const Text('Réessayer'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  _provider.getLocalMediaFiles(context: context);
                  setState(() => showOffline = true);
                },
                child: const Text(
                  'Mode hors ligne',
                  style: TextStyle(color: kTextPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterRow({required bool offlineMode}) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mediaTypes.length,
        padding: const EdgeInsets.only(right: 16),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final type = mediaTypes[index];
          final isSelected = selectedMediaType == type;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    setState(() {
                      selectedMediaType = type;
                      offlineMode
                          ? _updateSelectedFilesLocal()
                          : _updateSelectedFiles();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: isSelected ? kPrimaryBlue : kCardBg,
                      border: Border.all(
                        color: isSelected ? kPrimaryBlue : kBorder,
                      ),
                    ),
                    child: Text(
                      type.nameFr,
                      style: TextStyle(
                        color: isSelected ? Colors.white : kTextPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open_rounded, size: 32, color: kTextMuted),
            const SizedBox(height: 12),
            Text(
              'Aucune donnée trouvée',
              style: TextStyle(
                fontSize: fontSizes.font15(context.screenSize),
                fontWeight: FontWeight.w500,
                color: kTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _staggeredList(List<MediaFile> files, {bool offline = false}) {
    return ListView.builder(
      itemCount: files.length,
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemBuilder: (context, index) {
        final file = files[index];
        final item = offline
            ? MediaFileItem(mediaFile: file)
            : ChangeNotifierProvider(
          create: (_) => RefreshNotifier(),
          child: Consumer<RefreshNotifier>(
            builder: (context, notifier, child) {
              return MediaFileItem(
                mediaFile: file,
                onRefreshRequested: () => notifier.refresh(),
              );
            },
          ),
        );
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 260 + (index * 30).clamp(0, 300)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 12),
                child: child,
              ),
            );
          },
          child: item,
        );
      },
    );
  }

  Widget buildOfflineContent() {
    return Consumer<MediaFilesProvider>(
      builder: (context, provider, child) {
        if (selectedMediaType != null && provider.localFiles != null) {
          _updateSelectedFilesLocal();
        }
        if (provider.error != null) {
          return Center(
              child: Text(provider.error!,
                  style: const TextStyle(color: kTextPrimary)));
        }
        return Container(
          color: kBackground,
          padding: EdgeInsets.symmetric(
            horizontal: appPadding.padH16(context.screenSize),
            vertical: appPadding.padV15(context.screenSize),
          ),
          child: Column(
            children: [
              _filterRow(offlineMode: true),
              const SizedBox(height: 16),
              if (provider.localFiles != null)
                Expanded(
                  child: selectedMediaType!.id == 0
                      ? _staggeredList(provider.localFiles!, offline: true)
                      : (selectedFiles.isNotEmpty
                      ? _staggeredList(selectedFiles, offline: true)
                      : _emptyState()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget body() {
    return Consumer<MediaFilesProvider>(
      builder: (context, provider, child) {
        if (selectedMediaType != null && provider.files != null) {
          _updateSelectedFiles();
        }

        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: kPrimaryBlue,
            ),
          );
        }

        if (provider.error != null) {
          return Center(
              child: Text(provider.error!,
                  style: const TextStyle(color: kTextPrimary)));
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appPadding.padH16(context.screenSize),
            vertical: appPadding.padV15(context.screenSize),
          ),
          child: Column(
            children: [
              _filterRow(offlineMode: false),
              const SizedBox(height: 16),
              if (provider.files != null)
                Expanded(
                  child: selectedMediaType!.id == 0
                      ? _staggeredList(provider.files!)
                      : (selectedFiles.isNotEmpty
                      ? _staggeredList(selectedFiles)
                      : _emptyState()),
                ),
            ],
          ),
        );
      },
    );
  }
}

class RefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}