import 'package:cpy_app/features/introduction/widgets/skip_button.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/globals.dart';
import '../../download_app_resources/download_app_resource_page.dart';
import '../widgets/intro_button.dart';



class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  final controller = PageController(viewportFraction: 1, keepPage: true);
  static const _kDuration = Duration(milliseconds: 400);
  static const _kCurve = Curves.ease;

  @override
  Widget build(BuildContext context) {

    Widget indicatorWidget(){
      return SmoothPageIndicator(
        controller: controller,
        count: 3,
        effect: const WormEffect(
            dotHeight: 10,
            dotWidth: 10,
            type: WormType.thinUnderground,
            dotColor: Colors.grey,
            activeDotColor: Colors.orange
        ),
      );
    }


    final List<Widget> list=<Widget>[

      IntroScreenItem(
          next: (){
            controller.nextPage(duration: _kDuration, curve: _kCurve);
          },
          image: 'assets/images/bg.jpg',
          title: 'Application Androïd Chant Pour Yehoshoua',
          description: "Une application mobile pratique pour l'édification des saints, idéal pour ceux qui souhaitent louer le Seigneur avec leur instrument.",
          indicator: indicatorWidget()
      ),


      IntroScreenItem(
          next: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const DownloadResourcesPage()));
          },
          image: 'assets/images/bg2.jpg',
          title: 'Télécharger vos cantiques facilement',
          description: "Vous avez la possibilité de consulter, d'écouter et aussi de télécharger les fichiers ou les cantiques.",
          indicator: indicatorWidget()
      ),






    ];


    return Scaffold(
        backgroundColor: Colors.white,


        body:  Column(
          children: [

            Expanded(
              child: PageView.builder(
                onPageChanged: (page){

                  setState(() {

                  });
                },
                controller: controller,
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return list[index % list.length];
                },
              ),
            ),

          ],
        ));
  }
}



class IntroScreenItem extends StatelessWidget {
  const IntroScreenItem({super.key, required this.image, required this.title, required this.description, required this.indicator, required this.next});

  final String image;
  final String title;
  final String description;
  final Widget indicator;
  final Function next;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Stack(

        children: [

          Container(
            height: context.screenSize.height,
            width: context.screenSize.width,
            color: Colors.white,

          ),




          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: context.screenSize.height * .48,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(200),
                  bottomLeft: Radius.circular(200)
                ),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                  image,
                ))
              ),
            ),
          ),


          Positioned(
            top: 55,
            right: 20,
            child: SkipButton(onPressed: (){})
          ),



          Positioned(
            bottom: 20,
            left: 5,
            right: 5,
            child: Padding(
              padding:EdgeInsets.symmetric(
                  horizontal: appPadding.padH16(context.screenSize),
                  vertical: appPadding.padV15(context.screenSize)
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  SizedBox(height: context.screenSize.height * .030),


                  SizedBox(height:context.screenSize.height * .030),


                  Text(title,
                      style: TextStyle(
                          fontSize: fontSizes.font22(context.screenSize),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: black
                      )),


                  SizedBox(height: context.screenSize.height * .030),


                  SizedBox(
                    child: Text(description,
                        style: TextStyle(
                            fontSize: fontSizes.font15(context.screenSize),
                            fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            color: Colors.black45
                        ),
                        textAlign: TextAlign.start),
                  ),


                  SizedBox(height: context.screenSize.height * .030),


                  indicator,


                  SizedBox(height: context.screenSize.height * .030),


                  IntroButton(onPressed:(){
                    next();
                  })

                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
