import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constants/api_constants.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/globals.dart';
import '../../../utils/icons/my_icons.dart';
import '../../../utils/permissions.dart';
import '../data/models/media_file.dart';
import '../pages/media_link_page.dart';
import '../pages/media_page.dart';
import '../pages/read_pdf_file_page.dart';


class MediaFileItem extends StatefulWidget {
  const MediaFileItem({super.key, required this.mediaFile,  this.onRefreshRequested});
  final MediaFile mediaFile;
  final Function? onRefreshRequested;

  @override
  State<MediaFileItem> createState() => _MediaFileItemState();
}

class _MediaFileItemState extends State<MediaFileItem> {

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }


  void _modalBottomSheetMenu({required BuildContext context, required String name,  FileSystemEntity? file}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,

        isScrollControlled: true,
        builder: (context) => Wrap(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom:50),
                child: Container(
                  padding:  EdgeInsets.symmetric(horizontal: context.screenSize.width * .07, vertical: context.screenSize.width * .07),
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

                      const SizedBox(height: 15),

                    file == null  && widget.mediaFile.mediaTypeId == 1 ?  InkWell(
                      splashColor: Colors.transparent,
                      onTap: (){
                        downloadAudioFile(url: "${ApiConstants.storageUrl}${widget.mediaFile.path}", name: widget.mediaFile.name);
                        Logger().i("${ApiConstants.storageUrl}${widget.mediaFile.path}");
                        Navigator.pop(context);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            const MyIcon(
                              icon: MyIcons.download,
                              size: 20,
                            ),

                            const SizedBox(width: 20),

                            Text('Télécharger',
                                style: TextStyle(
                                    fontSize: fontSizes.font15(context.screenSize),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: tColorLight)),

                          ],
                        ),
                    ): SizedBox(),

                  file != null  || widget.mediaFile.mediaTypeId != 1 ?  InkWell(
                      splashColor: Colors.transparent,
                      onTap: () async {

                        if(file != null){

                          await Share.shareXFiles([XFile(file.path)], subject: widget.mediaFile.name,
                              text: 'chantpouryehoshoua.org');
                          Navigator.pop(context);
                        }else{

                          await Share.share("${widget.mediaFile.name} \n \n ${widget.mediaFile.link}", subject: widget.mediaFile.name);
                          Navigator.pop(context);
                        }

                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                             const MyIcon(
                              icon: MyIcons.share,
                               size: 20,
                            ),

                            SizedBox(width: 20),

                            Text('Partager',
                                style: TextStyle(
                                    fontSize: fontSizes.font15(context.screenSize),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: tColorLight)),

                          ],
                        ),
                    ): SizedBox()


                    ],
                  ),
                ))
          ],
        )).then((value) {

    });
  }


  @override
  void initState() {
    _loadDownloadedFiles();
    super.initState();
  }


  List<FileSystemEntity> _downloadedFiles = [];

  Future<String> _getDownloadDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return "${directory!.path}/DownloadedFiles";
  }





  Future<dynamic> _loadDownloadedFiles() async {
    String directoryPath = await _getDownloadDirectory();
    Directory directory = Directory(directoryPath);

    if (directory.existsSync()) {
      setState(() {

        if(widget.mediaFile.path != null){
          _downloadedFiles = directory.listSync().where((file){return widget.mediaFile.path!.split('/').last == file.path.split('/').last;}).toList();

          logger.i(_downloadedFiles);
        }
      });

      return _downloadedFiles;
    }else{

      setState(() {

      });
      return 'nothing';

    }
  }


  Future<void> refreshFiles() async {
    await _loadDownloadedFiles();
  }

  // Call this from parent if needed
  void requestRefresh() {
    widget.onRefreshRequested?.call();
  }

  @override
  void didChangeDependencies() {
    _loadDownloadedFiles();
    super.didChangeDependencies();
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
                  height: MediaQuery.of(context).size.height * .21,
                  width: MediaQuery.of(context).size.width,
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

  bool _isDownloading = false;
  double _progress = 0.0;

  Future<void> downloadAudioFile({required String name ,required String url}) async {
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

        String fileName = url.split('/').last;
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



  @override
  Widget build(BuildContext context) {

    context.watch<RefreshNotifier>();

    return  InkWell(
      splashColor: Colors.transparent,
      onTap: () async {

        if(widget.mediaFile.mediaTypeId == 1){
          widget.onRefreshRequested;
          logger.i(widget.mediaFile.path);
          if(_downloadedFiles.isNotEmpty){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ReadPdfFilePage(filePath: _downloadedFiles[0].path, mediaFile: widget.mediaFile)));
          }
        }else{
          logger.i(widget.mediaFile.toJson());
          Navigator.push(context, MaterialPageRoute(builder: (context)=> MediaLinkPage(webLink: widget.mediaFile.link.toString(), name:  widget.mediaFile.name,)));
        }

      },
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric( horizontal: context.screenSize.width * .010),
              margin: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: "${ApiConstants.storageUrl}${widget.mediaFile.placeHolderImage}",
                        imageBuilder: (context, imageProvider) => Container(
                          width: context.screenSize.width * .125,
                          height: context.screenSize.width * .125,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(context.screenSize.width * .34/2),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          width:context.screenSize.width * .125,
                          height: context.screenSize.width * .125,
                          decoration: BoxDecoration(
                            color: tColorLight,
                            borderRadius: BorderRadius.circular(context.screenSize.width * .34/2),

                          ),
                        ),
                        errorWidget: (context, url, error) =>Container(
                          width: context.screenSize.width * .125,
                          height: context.screenSize.width * .125,
                          decoration: BoxDecoration(
                            color: tColorLight,
                            borderRadius: BorderRadius.circular(context.screenSize.width * .34/2),

                          ),
                        ),
                      ),



                      const SizedBox(width: 15),


                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            width: context.screenSize.width * .45,
                            child: Text(widget.mediaFile.name.toString(),
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.normal),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 2),

                          SizedBox(
                            width: context.screenSize.width * .45,
                            child: Text( widget.mediaFile.mediaTypeId == 1 ? "${double.parse("${int.parse(widget.mediaFile.size.toString() ?? '0') / 1024}").toStringAsFixed(2)} kb": widget.mediaFile.link ?? 'N/A',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: fontSizes.font11(context.screenSize),
                                    color: muted,
                                    fontWeight: FontWeight.w300,
                                ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),


                        ],
                      )

                    ],
                  ),

                  _isDownloading ? Center(child: CircularProgressIndicator(value: _progress,)):
                  InkWell(
                    splashColor: Colors.transparent,
                      onTap: (){

                    if(_downloadedFiles.isEmpty){

                      _modalBottomSheetMenu(context: context, name:  widget.mediaFile.name, file: null);

                    }else{


                      _modalBottomSheetMenu(context: context, name:  widget.mediaFile.name, file: _downloadedFiles[0]);


                    }

                  }, child: MyIcon(
                     size: 20,
                     icon: _downloadedFiles.isEmpty && widget.mediaFile.mediaTypeId == 1
                          ? MyIcons.moreVert:
                      widget.mediaFile.mediaTypeId != 1 ?
                      MyIcons.link:  MyIcons.moreVert)
                  )
                ],
              )
          ),

          Divider(color: const Color(0xFFf4f4f4).withOpacity(.5), thickness: 1),



        ],
      ),
    );
  }
}
