import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/cupertino.dart';

class FontSizes{

  /// Text sizes

  double fontReading(Size size){

    if(size.width < 340){
      return 16.0 * fontSizeGlobal;

    }else if(size.width > 340 && size.width < 600){

      return 16.8  * fontSizeGlobal;

    } else{
      return 18  * fontSizeGlobal;
    }

  }


  double fontReadingSmall(Size size){

    if(size.width < 340){
      return 6 * fontSizeGlobal;

    }else if(size.width > 340 && size.width < 600){

      return 8  * fontSizeGlobal;

    } else{
      return 10  * fontSizeGlobal;
    }

  }



  double font13(Size size){

    if(size.width < 340){
      return 12.0;

    }else if(size.width > 340 && size.width < 600){

      return 12.8;

    } else{
      return 15;
    }

  }

  double font40(Size size){

    if(size.width < 340){
      return 34.0;

    }else if(size.width > 340 && size.width < 600){

      return 37.0;

    } else{
      return 45;
    }

  }


  double font28(Size size){

    if(size.width < 340){
      return 24.0;

    }else if(size.width > 340 && size.width < 600){

      return 28;

    } else{
      return 34;
    }
  }


  double font34(Size size){

    if(size.width < 340){
      return 34.0;

    }else if(size.width > 340 && size.width < 600){

      return 40;

    } else{
      return 44;
    }
  }



  double font11(Size size){

    if(size.width < 340){
      return 10.0;

    }else if(size.width > 340 && size.width < 600){

      return 11.0;

    } else{
      return 13;
    }

  }


  double font10(Size size){

    if(size.width < 340){
      return 9.0;

    }else if(size.width > 340 && size.width < 600){

      return 10.0;

    } else{
      return 12;
    }

  }



  double font17(Size size){

    if(size.width < 340){
      return 15.0;

    }else if(size.width > 340 && size.width < 600){

      return 17.0;

    } else{
      return 22;
    }

  }


  double font16(Size size){

    if(size.width < 340){
      return 14.0;

    }else if(size.width > 340 && size.width < 600){

      return 16.0;

    } else{
      return 20;
    }

  }


  double font22(Size size){

    if(size.width < 340){
      return 18.0;

    }else if(size.width > 340 && size.width < 600){

      return 22.0;

    } else{
      return 27;
    }

  }


  double font20(Size size){

    if(size.width < 340){
      return 16.0;

    }else if(size.width > 340 && size.width < 600){

      return 20.0;

    } else{
      return 25;
    }

  }




  double font24(Size size){

    if(size.width < 340){
      return 20.0;

    }else if(size.width > 340 && size.width < 600){

      return 24.0;

    } else{
      return 32;
    }

  }




  double font15(Size size){

    if(size.width < 340){
      return 13.5;

    }else if(size.width > 340 && size.width < 600){

      return 15.0;

    } else{
      return 17;
    }
  }


  double font12(Size size){

    if(size.width < 340){
      return 11.0;

    }else if(size.width > 340 && size.width < 600){

      return 12.0;

    } else{
      return 15;
    }
  }


  double font14(Size size){

    if(size.width < 340){
      return 13.0;

    }else if(size.width > 340 && size.width < 600){

      return 14.0;

    } else{
      return 16;
    }
  }





  /// Spacing

  double spacingButton(Size size){
    if(size.width > size.height){
      return size.width * .05;
    }else{
      return size.height * .045;
    }
  }

  double spacingItemMin(Size size){

    if(size.width > size.height){
      return size.width * .010;
    }else{
      return size.height * .015;
    }
  }




  double spacingItem3(Size size){

    if(size.width > size.height){
      return size.width * .03;
    }else{
      return size.height * .010;
    }
  }





  double spacingItemSmall(Size size){

    if(size.width > size.height){
      return size.width * .015;
    }else{
      return size.height * .020;
    }
  }

  double spacingItem(Size size){

    if(size.width > size.height){
      return size.width * .035;
    }else{
      return size.height * .035;
    }
  }




  double spacingItems(Size size){

    if(size.width > size.height){
      return size.width * .050;
    }else{
      return size.height * .04;
    }
  }



  double textFieldPadding(Size size){

    if(size.width > size.height){
      return size.width * .022;
    }else{
      return size.height * .022;
    }

  }


}


extension ContextExtension on BuildContext{
  MediaQueryData get _mediaQueryData => MediaQuery.of(this);

  Size get screenSize => _mediaQueryData.size;
  double get width => _mediaQueryData.size.width;

  double get height => _mediaQueryData.size.height;


}

