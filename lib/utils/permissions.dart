import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyPermissionHandler {
  static Future<bool> checkPermission(BuildContext context, {
    String permissionName = 'gallery',
  }) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      if (sdkInt < 33 && permissionName == 'gallery') {
        return true;
      }
    }

    Map<Permission, PermissionStatus> statues;
    switch (permissionName) {
      case 'camera':
        {
          statues = await [Permission.camera].request();
          PermissionStatus? statusCamera = statues[Permission.camera];
          if (statusCamera == PermissionStatus.granted) {
            return true;
          } else if (statusCamera == PermissionStatus.permanentlyDenied) {
            return false;
          } else {
            return false;
          }
        }
      case 'gallery':
        {

          try{

            statues = await [Permission.photos].request();
            PermissionStatus? statusPhotos = statues[Permission.photos];
            if (statusPhotos == PermissionStatus.granted) {

              if (kDebugMode) {
                print("Permission Accepted");
              }
              return true;
            } else if (statusPhotos == PermissionStatus.permanentlyDenied) {
              if (kDebugMode) {
                print("Permission Denied  galery");
              }
              return false;
            } else if (statusPhotos == PermissionStatus.limited) {
              if (kDebugMode) {
                print("Permission Limited");
              }

              return false;
            } else {
              return false;
            }
          }catch(error){
            if (kDebugMode) {
              print(error);
            }
          }


        }
    }
    return false;
  }



  static Future<bool>notificationPermission(BuildContext context, {
    String permissionName = 'notification',
  }) async {


    Map<Permission, PermissionStatus> statues;
    switch (permissionName) {

      case 'notification':
        {
          try{
            statues = await [Permission.notification].request();
            PermissionStatus? statusLocation = statues[Permission.notification];
            if (statusLocation == PermissionStatus.granted) {

              if (kDebugMode) {
                print("Permission Accepted");
              }
              return true;
            } else if (statusLocation == PermissionStatus.permanentlyDenied) {
              if (kDebugMode) {
                print("Permission Denied notifications");
              }
              return false;
            } else if (statusLocation == PermissionStatus.limited) {
              if (kDebugMode) {
                print("Permission Limited");
              }

              return false;
            } else {
              return false;
            }
          }catch(error){
            if (kDebugMode) {
              print(error);
            }
          }


        }
    }
    return false;
  }



  static Future<bool> requestLocationPermission() async {
    final foregroundStatus = await Permission.locationWhenInUse.request();

    if (foregroundStatus == PermissionStatus.granted) {
      // Request background location permission
      final backgroundStatus = await Permission.locationAlways.request();

      if (backgroundStatus == PermissionStatus.granted) {
        print("Background location permission granted!");
      } else {
      }

      return true;
    } else {
      print("Foreground location permission denied.");
      return false;
    }
  }

  static Future<bool>locationPermissionAlways(BuildContext context, {
    String permissionName = 'location',
  }) async {
    Map<Permission, PermissionStatus> statues;
    try{
      statues = await [Permission.locationAlways].request();
      PermissionStatus? statusLocation = statues[Permission.locationAlways];
      if (statusLocation == PermissionStatus.granted) {

        if (kDebugMode) {
          print("Permission Accepted");
        }
        return true;
      } else if (statusLocation == PermissionStatus.permanentlyDenied) {
        if (kDebugMode) {
          print("Permission Denied location");
        }
        return false;
      } else if (statusLocation == PermissionStatus.limited) {
        if (kDebugMode) {
          print("Permission Limited");
        }

        return false;
      } else {
        return false;
      }
    }catch(error){
      if (kDebugMode) {
        print(error);
      }
    }
    return false;
  }



  static Future<bool>locationPermission(BuildContext context, {
    String permissionName = 'location',
  }) async {


    Map<Permission, PermissionStatus> statues;
    switch (permissionName) {

      case 'location':
        {
          try{
            statues = await [Permission.location].request();
            PermissionStatus? statusLocation = statues[Permission.location];
            if (statusLocation == PermissionStatus.granted) {

              if (kDebugMode) {
                print("Permission Accepted");
              }
              return true;
            } else if (statusLocation == PermissionStatus.permanentlyDenied) {
              if (kDebugMode) {
                print("Permission Denied location");
              }
              return false;
            } else if (statusLocation == PermissionStatus.limited) {
              if (kDebugMode) {
                print("Permission Limited");
              }

              return false;
            } else {
              return false;
            }
          }catch(error){
            if (kDebugMode) {
              print(error);
            }
          }


        }
    }
    return false;
  }



  static Future<bool>storagePermission(BuildContext context, {
    String permissionName = 'storage',
  }) async {

    Map<Permission, PermissionStatus> statues;
    switch (permissionName) {

      case 'storage':
        {
          try{
            statues = await [Permission.storage].request();
            PermissionStatus? statusLocation = statues[Permission.storage];
            if (statusLocation == PermissionStatus.granted) {

              if (kDebugMode) {
                print("Permission Accepted");
              }
              return true;
            } else if (statusLocation == PermissionStatus.permanentlyDenied) {
              if (kDebugMode) {
                print("Permission Denied storage");
              }
              return false;
            } else if (statusLocation == PermissionStatus.limited) {
              if (kDebugMode) {
                print("Permission Limited");
              }

              return false;
            } else {
              return false;
            }
          }catch(error){
            if (kDebugMode) {
              print(error);
            }
          }


        }
    }
    return false;
  }




  static Future<bool>contactsPermission(BuildContext context, {
    String permissionName = 'contacts',
  }) async {

    Map<Permission, PermissionStatus> statues;
    switch (permissionName) {

      case 'contacts':
        {
          try{
            statues = await [Permission.contacts].request();
            PermissionStatus? statusLocation = statues[Permission.contacts];
            if (statusLocation == PermissionStatus.granted) {

              if (kDebugMode) {
                print("Permission Accepted");
              }
              return true;
            } else if (statusLocation == PermissionStatus.permanentlyDenied) {
              if (kDebugMode) {
                print("Permission Denied contacts");
              }
              return false;
            } else if (statusLocation == PermissionStatus.limited) {
              if (kDebugMode) {
                print("Permission Limited");
              }

              return false;
            } else {
              return false;
            }
          }catch(error){
            if (kDebugMode) {
              print(error);
            }
          }


        }
    }
    return false;
  }



}