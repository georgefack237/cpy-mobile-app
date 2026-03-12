import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cpy_app/constants/api_constants.dart';
import 'package:cpy_app/data/models/hymn_partition.dart';
import 'package:cpy_app/data/models/hymn_song.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/models/hymn_partition_type.dart';
import '../../../../data/test_data/hymn_test_data.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/icons/myIcon.dart';
import '../../../../utils/icons/my_icons.dart';
import '../../../../utils/permissions.dart';
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

class _HymnSongDetailsPageState extends State<HymnSongDetailsPage> with SingleTickerProviderStateMixin{



 late  TabController _tabController;
  double _progress = 0.0;
  bool _isDownloading = false;
  List<FileSystemEntity> _downloadedFiles = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;





 late final AdminHymnBookProvider _provider;



  @override
  void initState() {
    super.initState();
    _provider = Provider.of<AdminHymnBookProvider>(context, listen: false);
    _provider.getHymnSong(id: widget.songId);
    _loadDownloadedFiles();

    fromKey = noteScales[widget.hymnSong!.scaleId! - 1];

    _tabController = TabController(length: 2, vsync: this);
    _loadSettings();

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<String> _getDownloadDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return "${directory!.path}/DownloadedAudios";
  }



  Future<bool> storagePermission() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    var storagePermission = await Permission.storage.status;


    if (Platform.isIOS) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          barrierDismissible: false,

          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(canvasColor: Colors.orange,
                  dialogBackgroundColor: Colors.white),
              child: AlertDialog(

                titlePadding: const EdgeInsets.all(0),

                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                title: Container(
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16)
                      )
                  ),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .21,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: const Center(
                    child: MyIcon(color: Colors.white,
                        icon: MyIcons.downloadIcon,
                        size: 50),
                  ),
                ),
                content: const Text("get permission",
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w400
                    )),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Not now",
                        style: TextStyle(
                            color: Colors.blue,
                            fontFamily: "Poppins",
                            fontSize: 17,
                            fontWeight: FontWeight.w600
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),


                  TextButton(
                    child: const Text("continue",
                        style: TextStyle(
                            color: Colors.blue,
                            fontFamily: "Poppins",
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                        )),
                    onPressed: () async {
                      if (storagePermission.isDenied) {
                        Navigator.of(context).pop();
                        await MyPermissionHandler.storagePermission(context);
                      } else if (storagePermission.isPermanentlyDenied) {
                        Navigator.of(context).pop();
                        openAppSettings().whenComplete(() {
                          setState(() {

                          });
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      });

      return false;
    } else {
      if (deviceInfo.version.sdkInt > 30) {
        if (1 == 1) {
          return true;
        } else {
          return false;
        }
      } else {
        if (storagePermission.isGranted) {
          return true;
        } else {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            await showDialog(
              barrierDismissible: false,

              context: context,
              builder: (BuildContext context) {
                return Theme(
                  data: ThemeData(canvasColor: Colors.orange,
                      dialogBackgroundColor: Colors.white),
                  child: AlertDialog(

                    titlePadding: const EdgeInsets.all(0),

                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    title: Container(
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16)
                          )
                      ),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .21,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: const Center(
                        child: MyIcon(color: Colors.white,
                            icon: MyIcons.downloadIcon,
                            size: 50),
                      ),
                    ),
                    content: const Text("storage permission",
                        style: TextStyle(
                            color: Colors.black45,
                            fontFamily: "Poppins",
                            fontSize: 13,
                            fontWeight: FontWeight.w400
                        )),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("not now",
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Poppins",
                                fontSize: 17,
                                fontWeight: FontWeight.w600
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),


                      TextButton(
                        child: const Text("Continue",
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Poppins",
                                fontSize:15,
                                fontWeight: FontWeight.w500
                            )),
                        onPressed: () async {
                          if (storagePermission.isDenied) {
                            Navigator.of(context).pop();
                            await MyPermissionHandler.storagePermission(
                                context);
                          } else if (storagePermission.isPermanentlyDenied) {
                            Navigator.of(context).pop();
                            openAppSettings().whenComplete(() {
                              setState(() {});
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          });

          return false;
        }
      }
    }
  }


  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController.addListener((){
      if(!_tabController.indexIsChanging){
        setState(() {
          currentIndex = _tabController.index;
        });
      }
    });
  }

  Future<void> downloadAudioFile(String url) async {
    bool hasPermission = await storagePermission();
    if (!hasPermission) {
      if (kDebugMode) {
        print("Permission denied!");
      }
      return;
    }

    Dio dio = Dio();
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    if(await storagePermission()){
      try {
        String directoryPath = await _getDownloadDirectory();
        Directory directory = Directory(directoryPath);
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        String fileName = widget.hymnSong.audioUrl!.split('/').last;
        String savePath = "$directoryPath/$fileName";

        await dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _progress = received / total;
                print(_progress);

                if(_progress == 1){
                  setState(() {
                    _loadDownloadedFiles();

                  });
                }
              });
            }
          },
        );

        setState(() {
          _isDownloading = false;
        });

      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
        setState(() {
          _isDownloading = false;
        });
      }
    }

  }

  Future<void> _loadDownloadedFiles() async {

    String directoryPath = await _getDownloadDirectory();
    Directory directory = Directory(directoryPath);

    if (directory.existsSync()) {
      setState(() {
        _downloadedFiles = directory.listSync().where((audio){return widget.hymnSong.audioUrl!.split('/').last == audio.path.split('/').last;}).toList();
      });
    }else{
      setState(() {

      });
    }
  }



  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }


 void _playPause(FileSystemEntity file) async {
   if (_isPlaying) {
     await _audioPlayer.pause();
     setState(() {
       _isPlaying = false;
     });
   } else {
     await _audioPlayer.play(DeviceFileSource(file.path));
     setState(() {
       _isPlaying = true;
     });
   }
 }

 String _formatDuration(Duration duration) {
   String twoDigits(int n) => n.toString().padLeft(2, '0');
   final minutes = twoDigits(duration.inMinutes);
   final seconds = twoDigits(duration.inSeconds.remainder(60));
   return '$minutes:$seconds';
 }


  final List<String> fontFamilies = [
    'Roboto',
    'Poppins',
    'Courier New',
    'Georgia',
    'Times New Roman',
  ];



  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSizeGlobal = prefs.getDouble('fontSizeGlobal') ?? 1.0;
      fontFamilyGlobal = prefs.getString('fontFamilyGlobal') ?? 'Roboto';
      textOpacityGlobal = prefs.getDouble('textOpacityGlobal') ?? 1.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizeGlobal', fontSizeGlobal);
    await prefs.setString('fontFamilyGlobal', fontFamilyGlobal);
    await prefs.setDouble('textOpacityGlobal', textOpacityGlobal);
  }

  void _showFontSettingsDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.3,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(
                                "Paramètres de police",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    fontSize: fontSizes.font20(context.screenSize)
                                )
                            ),


                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: const Icon(Icons.close))
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            "Ajuster la taille de la police",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              fontSize: fontSizes.font17(context.screenSize)
                            )),
                      ),
                      Slider(
                        min: 0.5,
                        max: 5.0,
                        value: fontSizeGlobal,
                        activeColor: primarySoft,
                        label: fontSizeGlobal.toStringAsFixed(2),
                        onChanged: (value) {
                          setModalState(() => fontSizeGlobal = value);
                          setState(() {});
                          _saveSettings();
                        },
                      ),


                      const SizedBox(height: 25),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            "Opacité du texte",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: fontSizes.font17(context.screenSize)
                            )
                        ),
                      ),
                      Slider(
                        activeColor: primarySoft,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        value: textOpacityGlobal,
                        label: textOpacityGlobal.toStringAsFixed(1),
                        onChanged: (value) {
                          setModalState(() => textOpacityGlobal = value);
                          setState(() {});
                          _saveSettings();
                        },
                      ),


                      const SizedBox(height: 25),



                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            "Famille de polices",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: fontSizes.font17(context.screenSize)
                            )
                        ),
                      ),

                      const SizedBox(height: 8),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: fontFamilyGlobal,
                          isExpanded: true,
                          items: fontFamilies.map((font) {
                            return DropdownMenuItem(
                              value: font,
                              child: Text(font, style: TextStyle(fontFamily: font)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() => fontFamilyGlobal = value);
                              setState(() {});
                              _saveSettings();
                            }
                          },
                        ),
                      ),


                      const SizedBox(height: 25),




                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Que tout ce qui respire loue Yah ! Allélou-Yah !",
                          style: TextStyle(
                            fontSize: FontSizes().fontReading(MediaQuery.of(context).size),
                            fontFamily: fontFamilyGlobal,
                            fontWeight: FontWeight.w300,
                            color: Colors.black.withOpacity(textOpacityGlobal),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }



 Widget _buildAudioControls() {
   return Container(
     margin: EdgeInsets.all(16),
     padding: EdgeInsets.all(16),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.circular(20),
       boxShadow: [
         BoxShadow(
           color: Colors.black.withOpacity(0.1),
           blurRadius: 15,
           offset: Offset(0, 5),
         ),
       ],
     ),
     child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
         // Progress bar
         SliderTheme(
           data: const SliderThemeData(
             trackHeight: 3,
             thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
             overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
           ),
           child: Slider(
             value: _position.inSeconds.toDouble(),
             min: 0,
             max: _duration.inSeconds.toDouble(),
             activeColor: primarySoft,
             inactiveColor: Colors.grey.withOpacity(0.2),
             onChanged: (value) {
               _audioPlayer.seek(Duration(seconds: value.toInt()));
             },
           ),
         ),

         SizedBox(height: 8),

         // Controls and time
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
               _formatDuration(_position),
               style: TextStyle(fontSize: 12, color: dark),
             ),

             Container(
               decoration: const BoxDecoration(
                 shape: BoxShape.circle,
                 color: accent,
               ),
               child: IconButton(
                 onPressed: () => _playPause(_downloadedFiles.last),
                 icon: Icon(
                   _isPlaying ? Icons.pause : Icons.play_arrow,
                   color: Colors.white,
                   size: 24,
                 ),
                 padding: EdgeInsets.all(8),
               ),
             ),

             Text(
               _formatDuration(_duration),
               style: TextStyle(fontSize: 12, color: dark),
             ),
           ],
         ),
       ],
     ),
   );
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

 void _downloadAudioModal({required BuildContext context}) {
   showModalBottomSheet(
       context: context,
       backgroundColor: Colors.white,

       isScrollControlled: true,
       builder: (context) => Wrap(
         children: [
           SafeArea(
             child: Padding(
                 padding: const EdgeInsets.only(),
                 child: Container(
                   padding:  EdgeInsets.symmetric(
                       horizontal: context.screenSize.width * .07,
                       vertical: context.screenSize.width * .03
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
             
                       Text('Actions',
                           style: TextStyle(
                               fontSize: fontSizes.font20(context.screenSize),
                               fontWeight: FontWeight.normal,
                               fontFamily: 'Poppins',
                               color: black)),
             
             
             
                       const SizedBox(height: 35),
             
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
             
                           Text('Type du fichier', style: TextStyle(
                             fontFamily: 'Poppins',
                             color: dark,
                             fontSize: fontSizes.font13(context.screenSize),
             
                           )),
                           Text(widget.hymnSong.audioUrl!.split('.').last)
                         ],
                       ),
             
             
                       SizedBox(height: 25),
             
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
             
                           Text('Taille du fichier', style: TextStyle(
                             fontFamily: 'Poppins',
                             color: dark,
                             fontSize: fontSizes.font13(context.screenSize),
                           )),
             
                           Text("${double.parse("${(widget.hymnSong.fileSize ?? 0)/(1024 * 1024)}").toStringAsFixed(2)} mb")
                         ],
                       ),
             
             
             
                       const SizedBox(height: 35),
             
                        InkWell(
                         splashColor: Colors.transparent,
                         onTap: (){
                           downloadAudioFile("${ApiConstants.storageUrl}${widget.hymnSong.audioUrl}");
                           Navigator.pop(context);
                         },
                         child: Container(
                           padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                           decoration:  BoxDecoration(
                           gradient: const LinearGradient(colors: [accent, lightGradientOrange]),
                             borderRadius: BorderRadius.circular(40)
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
             
                                const MyIcon(
                                 icon: MyIcons.download,
                                 size: 20,
                                 color: Colors.white,
                               ),
             
             
                               Text('Télécharger',
                                   style: TextStyle(
                                       fontSize: fontSizes.font15(context.screenSize),
                                       fontWeight: FontWeight.w400,
                                       fontFamily: 'Poppins',
                                       color: Colors.white)),
                             ],
                           ),
                         ),
                       )
             
                     ],
                   ),
                 )),
           )
         ],
       )).then((value) {

   });
 }




 @override
  Widget build(BuildContext context) {

    bool isMinor = false; // False = major scale, true = minor scale
    bool useFrench = true; // True = French notation, False = English


    return DefaultTabController(
      length: 2,

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 135),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 20),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              title: Text(widget.hymnSong.title!),
              bottom: TabBar(
                controller: _tabController,
                onTap: (value){

                },
                tabs: const [
                  Tab(text: 'Paroles'),
                  Tab(text: 'Accords'),
                ],
              ),

              actions: [


                if(_downloadedFiles.isEmpty && widget.hymnSong.fileSize != null)

                  !_isDownloading ? InkWell(
                      splashColor: Colors.transparent,
                      onTap: (){
                        _downloadAudioModal(context: context);
                      },
                      child: const MyIcon(size: 20, icon: MyIcons.download)
                  ): Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryDark
                          ),
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style:TextStyle(
                          fontSize: fontSizes.font10(context.screenSize),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),


                InkWell(
                  onTap:()async{

                    if(widget.hymnSong.fileSize != null && _downloadedFiles.isNotEmpty){

                      await Share.shareXFiles([XFile(_downloadedFiles[0].path)],subject: '${widget.hymnSong.title}', text: '${widget.hymnSong.title}   \n  \n ${widget.hymnSong.partitions!.map((song)=> "${getPartition(song.id)!.nameFr}\n ${song.lyrics} ${widget.hymnSong.hasOneProgression != 1  ?  song.chordProgression!.map((chord)=> "${chord.note}^${chord.duration}"): widget.hymnSong.singleChordProgression!.map((chord)=> "${chord.note}^${chord.duration}")}\n \n")}  \n  \n chantpouryehoshoua.org');

                    }else{
                      await Share.share('${widget.hymnSong.title}   \n  \n ${widget.hymnSong.partitions!.map((song)=> "${getPartition(song.id)!.nameFr}\n ${song.lyrics} ${widget.hymnSong.hasOneProgression != 1  ?  song.chordProgression!.map((chord)=> "${chord.note}^${chord.duration}"): widget.hymnSong.singleChordProgression!.map((chord)=> "${chord.note}^${chord.duration}")}\n \n")}  \n  \n chantpouryehoshoua.org', subject: widget.hymnSong.title);
                    }
                  },
                  splashColor: Colors.transparent,
                  child: const MyIcon(size: 20, icon: MyIcons.share),
                ),




                currentIndex == 0 ?  IconButton(onPressed: (){
                  _showFontSettingsDialog();
                }, icon: const Icon(Icons.font_download_outlined, size: 20)) :

                PopupMenuButton<String>(
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
                        child: Text(letter, style: TextStyle(color: letter == fromKey ? primary: dark, fontWeight: letter == fromKey ? FontWeight.bold:FontWeight.normal)),
                      );
                    }).toList();
                  },
                  icon: const Icon(Icons.music_note_outlined, size: 20),
                ),

              ],

            ),
          ),
        ),
        body: buildHymnSongTab(useFrench: useFrench)

      ),
    );
  }



 Widget buildHymnSongTab({required bool useFrench}) {
   return Consumer<AdminHymnBookProvider>(

       builder: (context, provider, child) {

         if (provider.isLoading) {
           return const Center(child: CircularProgressIndicator());
         }

         if (provider.error != null) {

         }

         return provider.hymnSong != null ?
         TabBarView(
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
                           return _buildSongPartition(partition:partition, song: provider.hymnSong!);
                         },
                       ),
                     ],
                   ),
                 ),

                 if(_downloadedFiles.isNotEmpty)

                   Positioned(
                       bottom: 10,
                       left: 5,
                       right: 5,
                       child: _buildAudioControls()
                   )

               ],
             ),


             Stack(
               children: [
                 SingleChildScrollView(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                       provider.hymnSong!.hasOneProgression! != 1 ? ListView(
                           padding: const EdgeInsets.only(top: 20, bottom: 160),

                           physics: const NeverScrollableScrollPhysics(),
                           shrinkWrap: true,
                           children:  provider.hymnSong!.partitions!.map((song) {


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


                                         Container(
                                           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                           decoration: BoxDecoration(
                                               gradient: const LinearGradient(colors: [Color(0xFF60C1C4), Color(0xFF088f97)]),
                                               borderRadius: BorderRadius.circular(20)
                                           ),
                                           child: Text(
                                               getPartition(song.id)!.nameFr,
                                               style:TextStyle(fontFamily: 'Poppins',
                                                   fontSize: FontSizes().font12(context.screenSize),
                                                   letterSpacing: 1.2,
                                                   height: 1, color: Colors.white,
                                                   fontWeight: FontWeight.w500
                                               )),
                                         ),

                                       ],
                                     ),
                                   ),

                                   song.chordProgression!.length > 1 ? SongChordsWidget(notes: song.chordProgression!, useFrench: useFrench,fromKey: fromKey!) : const SizedBox(),
                                 ],
                               ),
                             );

                           }).toList()): Padding(
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


                                   Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                     decoration: BoxDecoration(
                                       //  color: const Color(0xFF60C1C4),
                                         gradient: const LinearGradient(colors: [Color(0xFF60C1C4), Color(0xFF088f97)]),
                                         borderRadius: BorderRadius.circular(20)
                                     ),
                                     child: Text("Couplet et refrain",
                                         style:TextStyle(
                                             fontFamily: 'Poppins',
                                             fontSize: FontSizes().font12(context.screenSize),
                                             //letterSpacing: 1,
                                             //height: 1,
                                             color: Colors.white,
                                             fontWeight: FontWeight.w500)
                                     ),
                                   ),

                                 ],
                               ),
                             ),


                             SongChordsWidget(notes:  provider.hymnSong!.singleChordProgression!, useFrench: useFrench,fromKey: fromKey!)

                           ],
                         ),
                       ),

                     ],
                   ),
                 ),

                 if(_downloadedFiles.isNotEmpty)
                   Positioned(
                       bottom: 10,
                       left: 5,
                       right: 5,
                       child: _buildAudioControls()
                   )

               ],
             ),
           ],
         ):provider.isLoading ? const Expanded(child: Center(child: CircularProgressIndicator()))

             : provider.error != null ? Center(child: Text(provider.error!)): const SizedBox();
       });
 }






 Widget _buildSongPartition({required HymnPartition partition, required HymnSong song}) {

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
               _buildSectionHeader(partition),
               SizedBox(height: context.screenSize.height * .035),
               HymnLyricsItem(
                 chordOverLyrics: song.hasChordOverLyrics!,
                 lyrics: partition.lyrics,
               ),
             ],
           ),
         ),
       ],
     ),
   );
 }

 Widget _buildSectionHeader(song) {
   return Container(
     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
     decoration: BoxDecoration(
       color: primaryDark,
       borderRadius: BorderRadius.circular(20),
     ),
     child: Text(
       getPartition(song.id)!.nameFr,
       style: TextStyle(
         fontFamily: 'Poppins',
         fontSize: FontSizes().font12(context.screenSize),
         letterSpacing: 1.2,
         height: 1,
         color: Colors.white,
         fontWeight: FontWeight.w500,
       ),
     ),
   );
 }

}




