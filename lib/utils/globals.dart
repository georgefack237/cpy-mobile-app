import 'dart:io';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/dimensions/padding.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> initGlobals() async {
  globalPrefs = await SharedPreferences.getInstance();
}


FontSizes fontSizes =FontSizes();
AppPadding appPadding = AppPadding();

double fontSizeGlobal = 1.0;
String fontFamilyGlobal = 'Roboto';
double textOpacityGlobal = 1.0; // Range: 0.0 - 1.0


late SharedPreferences sharedPreferences;

String? countryCode;
String policyData = "";
bool hasLoadedCountries = false;
bool hasLoadedCities= false;
bool? internet;

Future<bool> checkConnection() async{
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }else{
      return false;

    }
  } on SocketException catch (_) {
    return false;
  }
}


double rangeDefault = 0.021;
String dateFormat = "yyyy-MM-dd HH:mm:ss";
String baseDateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssssZ";
String timeFormat = "HH:mm:ss";

String alarmDirectory = "/storage/emulated/0/Download";
String notificationDirectory= "/storage/emulated/0/Download";
String systemLocale = Platform.localeName.split('_').first.toString();

String showIntro = "show_intro_screen";


Future<bool> showIntroScreenFunc() async {
  return globalPrefs.getBool(showIntro) ?? true;
}

void saveShowIntro(bool value) {
  globalPrefs.setBool(showIntro, value);
  print('THE SHOW INTRO FUNCTION RETURNS THIS VALUE ::::::::::::::::::::::  $value');

}


late SharedPreferences globalPrefs;
