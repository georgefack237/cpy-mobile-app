import 'dart:convert';
import 'dart:io';
import 'package:cpy_app/features/home/pages/main_page.dart';
import 'package:cpy_app/features/strong/data/model/word_reference.dart';
import 'package:cpy_app/profile/providers/profile_provider.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../constants/globals.dart';
import '../../../core/notifications/fcm_tokens.dart';
import '../../../data/models/hymn_book_collection.dart';
import '../../../data/models/hymn_song.dart';
import '../../../data/models/poem_model.dart';
import '../../../utils/globals.dart';
import '../../../utils/icons/my_icons.dart';
import '../../../utils/permissions.dart';
import '../widgets/intro_button.dart';
import 'package:encrypt/encrypt.dart' as En;

class DownloadResourcesPage extends StatefulWidget {
  const DownloadResourcesPage({super.key});

  @override
  State<DownloadResourcesPage> createState() => _DownloadResourcesPageState();
}

class _DownloadResourcesPageState extends State<DownloadResourcesPage> {


  Future<void> _createUniqueFingerPrint(ProfileProvider provider) async{

    setState(() {
      loading = true;
    });

    final deviceInfoPlugin = DeviceInfoPlugin();

    ///todo Should fcmTokens be generated on every app launch, the life cycle of an android fmc token when to update it.
    String? fcmKey = await getFcmToken();

    saveShowIntro(false);

    bool showIntro = await showIntroScreenFunc();

    if(Platform.isAndroid) {

      final deviceInfo = await deviceInfoPlugin.androidInfo;
      final allInfo = deviceInfo.data;
      var fingerPrint = allInfo['fingerprint'];
      const key = "A9fP3nX7LGP2NdQ4";
      final plainText = fingerPrint.toString();
      En.Encrypted encrypted = helperFunctions.encrypt(key, plainText);

      await provider.addProfile(deviceId: encrypted.base64, notificationId: fcmKey!);

      logger.i(showIntro);
      Navigator.of(context).pushAndRemoveUntil(
          Platform.isAndroid
              ? MaterialPageRoute(builder: (context) => const MainAppScreen())
              : CupertinoPageRoute(builder: (context) => const MainAppScreen()),
              (route) => false);

    }

    setState(() {
      loading = false;
    });

  }


  double _progress = 0.0;
  bool _isDownloading = false;


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
    return "${directory!.path}/resources/books";
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
              data: ThemeData(canvasColor: Colors.orange, dialogTheme: const DialogThemeData(backgroundColor: Colors.white)),
              child: AlertDialog(

                titlePadding: const EdgeInsets.all(0),

                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                title: Container(
                  decoration: const BoxDecoration(
                      color: primary,
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
                content:  const Text("Cette permission permet à l'application de créer et d'enregistrer les fichiers téléchargés (cantiques, lexique)",
                    style: TextStyle(
                        color: dark,
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w400
                    )),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Pas maintenant",
                        style: TextStyle(
                            color: muted,
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),


                  TextButton(
                    child:  const Text("Accepter",
                        style: TextStyle(
                            color: primary,
                            fontFamily: "Poppins",
                            fontSize:15,
                            fontWeight: FontWeight.w700
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
                  data: ThemeData(canvasColor: Colors.orange, dialogTheme: const DialogThemeData(backgroundColor: Colors.white)),
                  child: AlertDialog(

                    titlePadding: const EdgeInsets.all(0),

                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    title: Container(
                      decoration: const BoxDecoration(
                          color: primary,
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
                    content:  const Text("Cette permission permet à l'application de créer et d'enregistrer les fichiers téléchargés (cantiques, lexique)",
                        style: TextStyle(
                            color: dark,
                            fontFamily: "Poppins",
                            fontSize: 13,
                            fontWeight: FontWeight.w400
                        )),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Pas maintenant",
                            style: TextStyle(
                                color: muted,
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),


                      TextButton(
                        child:  const Text("Accepter",
                            style: TextStyle(
                                color: primary,
                                fontFamily: "Poppins",
                                fontSize:15,
                                fontWeight: FontWeight.w700
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



  Future<dynamic> downloadAudioFile(String url) async {

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
        logger.i(url);

        String savePath = "$directoryPath/books.zip";

        await dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _progress = received / total;
                print(_progress);

                if(_progress == 1){
                  _isDownloading = false;
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



  @override
  void initState() {
    super.initState();
  }

  bool loading = false;
  String message = '';

  Future<void> importData(ProfileProvider provider) async {
    try {
      setState(() {
        loading = true;
        message = "Extracting files...";
      });

      // Step 1: Extract zip file
      await _extractZipFiles();

      // Step 2: Find and process JSON files
      await _processJsonFiles(provider);

      _processWordsFiles(provider);

      // Step 3: Create unique fingerprint
      await _createUniqueFingerPrint(provider);

    } catch (error, stackTrace) {
      logger.e('Error during import', error: error, stackTrace: stackTrace);
      setState(() {
        message = 'Import failed: ${error.toString()}';
      });
      rethrow;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _extractZipFiles() async {
    final directoryPath = await _getDownloadDirectory();
    final directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      throw Exception('Download directory does not exist');
    }

    final zipFile = File("${directory.path}/books.zip");

    if (!zipFile.existsSync()) {
      logger.i('No books.zip file found');
      return;
    }

    try {
      final destinationDir = Directory("${directory.path}/");
      await ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir
      );
      logger.i('Zip extraction completed successfully');
    } catch (e) {
      logger.e('Failed to extract zip file', error: e);
      throw Exception('Failed to extract zip file: $e');
    }
  }


  Future<void> _processWordsFiles(ProfileProvider provider) async {
    final directoryPath = await _getDownloadDirectory();
    final directory = Directory('$directoryPath');

    // Find all books.json files recursively
    final jsonFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('words.json'))
        .toList();

    logger.i('Found ${jsonFiles.length} JSON files: ${jsonFiles.map((f) => f.path)}');

    if (jsonFiles.isEmpty) {
      logger.i('No books.json files found');
      return;
    }
    for (final file in jsonFiles) {
      await _processSingleWordFile(file);
    }

    logger.i('All JSON files processed successfully');
  }

  Future<void> _processJsonFiles(ProfileProvider provider) async {
    final directoryPath = await _getDownloadDirectory();
    final directory = Directory('$directoryPath');

    // Find all books.json files recursively
    final jsonFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('books.json'))
        .toList();

    logger.i('Found ${jsonFiles.length} JSON files: ${jsonFiles.map((f) => f.path)}');

    if (jsonFiles.isEmpty) {
      logger.i('No books.json files found');
      return;
    }

    // Process each JSON file found
    for (final file in jsonFiles) {
      await _processSingleJsonFile(file);
    }

    logger.i('All JSON files processed successfully');
  }


  Future<void> _processSingleWordFile(File file) async {
    setState(() {
      message = "Processing ${file.path.split('/').last}";
    });

    try {
      final contents = await file.readAsString();
      final data = jsonDecode(contents);

      if (data is! List) {
        logger.w('Invalid JSON structure: expected List but got ${data.runtimeType}');
        return;
      }

      // Process each book in the JSON array
      for (final word in data) {
        final wordData = WordReference.fromJson(word);
        await databaseService.insertWord(wordData);
      }

      logger.i('Successfully processed file: ${file.path}');
    } catch (e, stackTrace) {
      logger.e('Error processing file ${file.path}', error: e, stackTrace: stackTrace);
      throw Exception('Failed to process ${file.path}: $e');
    }

  }

  Future<void> _processSingleJsonFile(File file) async {
    setState(() {
      message = "Processing ${file.path.split('/').last}";
    });

    try {
      final contents = await file.readAsString();
      final data = jsonDecode(contents);

      if (data is! List) {
        logger.w('Invalid JSON structure: expected List but got ${data.runtimeType}');
        return;
      }

      // Process each book in the JSON array
      for (final book in data) {
        await _processBook(book as Map<String, dynamic>);
      }

      logger.i('Successfully processed file: ${file.path}');
    } catch (e, stackTrace) {
      logger.e('Error processing file ${file.path}', error: e, stackTrace: stackTrace);
      throw Exception('Failed to process ${file.path}: $e');
    }
  }






  Future<void> _processBook(Map<String, dynamic> bookJson) async {
    // Insert hymn book
    final hymnBook = HymnBookCollection.fromJson(bookJson);
    await databaseService.insertHymnBook(hymnBook);

    // Process hymns
    final hymns = bookJson['hymns'] as List? ?? [];
    for (final hymnJson in hymns) {
      final hymnSong = HymnSong.fromJson(hymnJson);
      await databaseService.insertHymnSong(hymnSong);
    }

    // Process poems
    final poems = bookJson['poems'] as List? ?? [];
    for (final poemJson in poems) {
      final poem = PoemModel.fromJson(poemJson);
      await databaseService.insertHymnPoem(poem);
    }

    logger.i('Processed book: ${hymnBook.nameFr} with ${hymns.length} hymns and ${poems.length} poems');
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);


    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size(0,60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appPadding.padH16(context.screenSize)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      height: context.screenSize.height * .40,
                      width: context.screenSize.width,
                      color: Colors.white,
                      child: Image.asset(
                        'assets/images/intro_one.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        SizedBox(height: context.screenSize.height * .030),

                        const Divider(color: dividerColor, height: 1,),

                        SizedBox(height: context.screenSize.height * .030),

                        Text("Télécharger les ressources de l'application",
                            style: TextStyle(
                                fontSize: fontSizes.font20(context.screenSize),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.black87
                            )),


                        SizedBox(height: context.screenSize.height * .030),

                        SizedBox(
                          child: Text("Téléchargez le contenu de l'app (paroles, accords, poèmes, lexique) pour l'utiliser hors connexion.",
                              style: TextStyle(
                                  fontSize: fontSizes.font15(context.screenSize),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Poppins',
                                  color: const Color(0xFF454545)
                              ),
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),

                  ],
                ),



                SizedBox(height: context.screenSize.height * .030),


                _isDownloading ||  loading || profileProvider.isLoading ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SizedBox(
                        width:context.screenSize.width * .90,
                        child: const LinearProgressIndicator(color: Color(0xFFFFB61A), backgroundColor: Color(0x4AFFB61A),)),

                    const SizedBox(height: 17),

                    RichText(
                      textAlign: TextAlign.center,
                      selectionRegistrar: SelectionContainer.maybeOf(context),
                      text: const TextSpan(
                        text: "Téléchargement des données ...",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize:  12,
                            color: Colors.black87,
                            fontFamily: 'Poppins'),
                      ),
                    ),

                  ],
                ): IntroButton(
                  download: true,
                    onPressed:(){

                  //extract();
                  downloadAudioFile('https://chantpouryehoshoua.org/storage/exports/data.zip').then((value) {
                   importData(profileProvider);
                   });


                })
              ],
            ),
          ),
        )
    );
  }
}
