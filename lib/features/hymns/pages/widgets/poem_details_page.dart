import 'package:cpy_app/data/models/poem_model.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/icons/myIcon.dart';
import '../../../../utils/icons/my_icons.dart';

class PoemDetailsPage extends StatefulWidget {
  const PoemDetailsPage({super.key, required this.poem});

  final PoemModel poem;

  @override
  State<PoemDetailsPage> createState() => _PoemDetailsPageState();
}

class _PoemDetailsPageState extends State<PoemDetailsPage> {


  @override
  void initState() {
    _loadSettings();
    super.initState();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child:AppBar(
            centerTitle: false,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.poem.title,
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


            actions: [
              InkWell(
                onTap:()async{
                  await Share.share('${widget.poem.title} \n  \n ${widget.poem.paroles}  \n  \n chantpouryehoshoua.org', subject: widget.poem.title);
                },
                splashColor: Colors.transparent,
                child: const MyIcon(size: 23, icon: MyIcons.share),
              ),

              InkWell(
                onTap:()async{
                  _showFontSettingsDialog();
                },
                splashColor: Colors.transparent,
                child: const MyIcon(size: 23, icon: MyIcons.font),
              ),

            ],

          ),
        ),
      ),


      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: appPadding.padH16(context.screenSize), 
            vertical: appPadding.padV15(context.screenSize)),
        child:SingleChildScrollView(
          child: Text(widget.poem.paroles,
              style: TextStyle(
                  fontFamily: fontFamilyGlobal,
                  fontSize: FontSizes().fontReading(context.screenSize),
                  letterSpacing: 1.2,
                  color: black.withOpacity(textOpacityGlobal),
                  fontWeight: FontWeight.w300
              )),
        ),
          
      )
    );
  }
}

