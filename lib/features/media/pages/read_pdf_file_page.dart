
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/globals.dart';
import '../data/models/media_file.dart';

class ReadPdfFilePage extends StatelessWidget {
  final String filePath;
  final MediaFile mediaFile;


  const ReadPdfFilePage({super.key, required this.filePath, required this.mediaFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child:AppBar(
            centerTitle: false,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              mediaFile.name,
              style:  TextStyle(
                  color:Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font20(context.screenSize),
                  fontWeight: FontWeight.w600),
              maxLines: 1,
            ),

            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_outlined, color:black, size: 25),
            ),

          ),
        ),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
