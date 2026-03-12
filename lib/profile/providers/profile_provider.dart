import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/profile/model/profile.dart';
import 'package:cpy_app/profile/network/profile_services.dart';
import 'package:flutter/material.dart';

import '../../data/local/database_services.dart';

class ProfileProvider extends ChangeNotifier {

  final ProfileServices?  profileServices;
  final DatabaseService?  databaseService;

  ProfileProvider({this.databaseService, this.profileServices});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;


  Profile? _addedProfile;
  Profile? get addedProfile => _addedProfile;


  Future<void> addProfile({
    required String deviceId,
    required String notificationId,
  }) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {

      final response = await  profileServices!.addProfile(
        deviceId: deviceId,
        notificationId: notificationId,
      );

      if (response.error == null) {

        logger.i(response.data);

        _addedProfile = response.data;
        databaseService!.insertProfile(_addedProfile!);

        logger.i(_addedProfile!.toJson());

      } else {
        _error = response.error;
        logger.i(response.error);
      }
    } catch (e) {
      logger.i(e);

      _error = "Unexpected error: $e";
    }

    _setLoading(false);
  }




  Future<void> getProfile(int id) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {

      final response = await databaseService!.getProfile(id);
      _addedProfile = response;

    } catch (e) {
      _error = "Unexpected error: $e";
    }
    _setLoading(false);
  }


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetError() {
    _error = null;
  }

  void resetState() {
    _addedProfile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }


}
