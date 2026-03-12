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


class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}
class _MediaPageState extends State<MediaPage> with AutomaticKeepAliveClientMixin {



  @override
  bool get wantKeepAlive => true;
  late MediaFilesProvider _provider;
  MediaType? selectedMediaType;
  List<MediaFile> selectedFiles = [];

  bool showOffline = false;

  @override
  void initState() {
    super.initState();
    // Don't access context here
  }




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<MediaFilesProvider>(context, listen: false);
    _provider.getMediaFiles();
    // Initialize selectedMediaType after provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mediaTypes.isNotEmpty && mounted) {
        setState(() {
          selectedMediaType = mediaTypes[0];
          _updateSelectedFiles();
          if(showOffline) {
            _updateSelectedFilesLocal();
          }
        });
      }
    });
  }

  void _updateSelectedFiles() {
    if (_provider.files != null && selectedMediaType != null) {
      selectedFiles = _provider.files!.where((media) {
        return media.mediaTypeId == selectedMediaType!.id;
      }).toList();
    } else {
      selectedFiles = [];
    }
  }



  void _updateSelectedFilesLocal() {
    if (_provider.localFiles != null && selectedMediaType != null) {
      selectedFiles = _provider.localFiles!.where((media) {
        return media.mediaTypeId == selectedMediaType!.id;
      }).toList();
    } else {
      selectedFiles = [];
    }
  }

  @override
  Widget build(BuildContext context) {


    super.build(context);
    return InternetScaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.screenSize.width, 80),
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 20),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark
            ),
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: const Text(
              'Médiathèque',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.black87
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
          strokeWidth: 1,
          color:  primaryDark,
          backgroundColor: Colors.white,
          onRefresh: ()async{
            _provider.getMediaFiles();
          },
          child: body()
      ),
      title: '',
      offline: !showOffline ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Pas de connexion Internet!'),

              const SizedBox(height: 15),

              FilledButton.tonal(onPressed: () async {
                _provider.getMediaFiles();
              }, child: const Text('Réessayer')),

              FilledButton.tonal(onPressed: () async {
                _provider.getLocalMediaFiles(context: context);
                setState(() {
                  showOffline = true;
                });

              }, child: Text('Mode hors ligne'))
            ],
          )): buildOfflineContent(),
    );

  }


  Widget buildOfflineContent(){
    return
      Consumer<MediaFilesProvider>(
        builder: (context, provider, child) {
          // Update selected files when provider data changes
          if (selectedMediaType != null && provider.localFiles != null) {
            _updateSelectedFilesLocal();
          }

          if (provider.loadingLocal) {
          //  return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appPadding.padH16(context.screenSize),
              vertical: appPadding.padV15(context.screenSize),
            ),
            child: Column(
              children: [
                // Media type filter buttons
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mediaTypes.length,
                    padding: const EdgeInsets.only(right: 25, left: 10),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            selectedMediaType = mediaTypes[index];
                            _updateSelectedFilesLocal();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              color: selectedMediaType == mediaTypes[index]
                                  ? const Color(0xFF60C1C4)
                                  : const Color(0xFFF1F1F1).withOpacity(0.3),
                              border: Border.all(
                                  color: selectedMediaType == mediaTypes[index]
                                      ? const Color(0xFF60C1C4)
                                      : const Color(0xFFF1F1F1).withOpacity(0.7)
                              )
                          ),
                          child: Center(
                            child: Text(
                              mediaTypes[index].nameFr,
                              style: TextStyle(
                                color: selectedMediaType == mediaTypes[index]
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Display the filtered media files
                if (provider.localFiles != null)
                  selectedMediaType!.id == 0 ? Expanded(
                      child: ListView.builder(
                          itemCount: provider.localFiles!.length,
                          itemBuilder: (context, index){
                            var file = provider.localFiles![index];
                            return MediaFileItem(mediaFile: file);
                          }
                      )
                  ): Expanded(
                      child: selectedFiles.isNotEmpty ? ListView.builder(
                          itemCount: selectedFiles.length,
                          itemBuilder: (context, index){
                            var file = selectedFiles[index];
                            return ChangeNotifierProvider(
                              create: (_) => RefreshNotifier(),
                              child: Column(
                                children: [
                                  Consumer<RefreshNotifier>(
                                    builder: (context, notifier, child) {
                                      return MediaFileItem(mediaFile: file, onRefreshRequested: (){notifier.refresh();},);
                                    },
                                  ),

                                ],
                              ),
                            );

                          }
                      ): Center(
                          child: Text('Aucune donnée trouvée!',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: fontSizes.font15(context.screenSize)
                              )
                          )
                      )
                  ),
              ],
            ),
          );

        },
      );
  }



  Widget body(){
    return
      Consumer<MediaFilesProvider>(
        builder: (context, provider, child) {
          // Update selected files when provider data changes
          if (selectedMediaType != null && provider.files != null) {
            _updateSelectedFiles();
          }

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appPadding.padH16(context.screenSize),
              vertical: appPadding.padV15(context.screenSize),
            ),
            child: Column(
              children: [
                // Media type filter buttons
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mediaTypes.length,
                    padding: const EdgeInsets.only(right: 25, left: 10),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            selectedMediaType = mediaTypes[index];
                            _updateSelectedFiles();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              color: selectedMediaType == mediaTypes[index]
                                  ? const Color(0xFF60C1C4)
                                  : const Color(0xFFF1F1F1).withOpacity(0.3),
                              border: Border.all(
                                  color: selectedMediaType == mediaTypes[index]
                                      ? const Color(0xFF60C1C4)
                                      : const Color(0xFFF1F1F1).withOpacity(0.7)
                              )
                          ),
                          child: Center(
                            child: Text(
                              mediaTypes[index].nameFr,
                              style: TextStyle(
                                color: selectedMediaType == mediaTypes[index]
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Display the filtered media files
                if (provider.files != null)
                  selectedMediaType!.id == 0 ? Expanded(
                      child: ListView.builder(
                          itemCount: provider.files!.length,
                          itemBuilder: (context, index){
                            var file = provider.files![index];
                            return MediaFileItem(mediaFile: file);
                          }
                      )
                  ): Expanded(
                      child: selectedFiles.isNotEmpty ? ListView.builder(
                          itemCount: selectedFiles.length,
                          itemBuilder: (context, index){
                            var file = selectedFiles[index];
                            return ChangeNotifierProvider(
                              create: (_) => RefreshNotifier(),
                              child: Column(
                                children: [
                                  Consumer<RefreshNotifier>(
                                    builder: (context, notifier, child) {
                                      return MediaFileItem(mediaFile: file, onRefreshRequested: (){notifier.refresh();},);
                                    },
                                  ),

                                ],
                              ),
                            );

                          }
                      ): Center(
                          child: Text('Aucune donnée trouvée!',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: fontSizes.font15(context.screenSize)
                              )
                          )
                      )
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