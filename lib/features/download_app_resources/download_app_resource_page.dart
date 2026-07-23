import 'dart:io';

import 'package:cpy_app/features/download_app_resources/storage_permission.dart';
import 'package:cpy_app/features/home/pages/main_page.dart';
import 'package:cpy_app/profile/providers/profile_provider.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../utils/globals.dart';

import '../../utils/widgets/storage_permission_dialog.dart';
import '../introduction/widgets/intro_button.dart';
import 'download_resource_service.dart';

class DownloadResourcesPage extends StatefulWidget {
  const DownloadResourcesPage({super.key});

  @override
  State<DownloadResourcesPage> createState() => _DownloadResourcesPageState();
}

class _DownloadResourcesPageState extends State<DownloadResourcesPage> {
  static const String _resourcesUrl = 'https://chantpouryehoshoua.org/storage/exports/data.zip';

  final AppResourceImportService _importService = AppResourceImportService();

  @override
  void dispose() {
    _importService.dispose();
    super.dispose();
  }

  Future<void> _startDownload() async {
    final permission = await StoragePermissionService().check();

    StoragePermissionResult result = permission;
    if (permission == StoragePermissionResult.denied) {
      if (!mounted) return;
      result = await showStoragePermissionDialog(context);
    }

    if (result == StoragePermissionResult.permanentlyDenied) {
      await openAppSettings();
      return;
    }
    if (result != StoragePermissionResult.granted) return;

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await _importService.run(zipUrl: _resourcesUrl, profileProvider: profileProvider);

    if (_importService.phase == ImportPhase.completed) {
      _navigateToMain();
    }
  }

  Future<void> _retry() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await _importService.retry(profileProvider: profileProvider);
    if (_importService.phase == ImportPhase.completed) {
      _navigateToMain();
    }
  }

  void _navigateToMain() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      Platform.isAndroid
          ? MaterialPageRoute(builder: (context) => const MainAppScreen())
          : CupertinoPageRoute(builder: (context) => const MainAppScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size(0, 60),
        child: AppBar(backgroundColor: Colors.white, elevation: 0),
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
                    child: Image.asset('assets/images/intro_one.png', fit: BoxFit.contain),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.screenSize.height * .030),
                      const Divider(color: dividerColor, height: 1),
                      SizedBox(height: context.screenSize.height * .030),
                      Text(
                        "Télécharger les ressources de l'application",
                        style: TextStyle(
                          fontSize: fontSizes.font20(context.screenSize),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: black,
                        ),
                      ),
                      SizedBox(height: context.screenSize.height * .030),
                      Text(
                        "Téléchargez le contenu de l'app (paroles, accords, poèmes, lexique) pour l'utiliser hors connexion.",
                        style: TextStyle(
                          fontSize: fontSizes.font15(context.screenSize),
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Poppins',
                          color: muted,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: context.screenSize.height * .030),
              ListenableBuilder(
                listenable: _importService,
                builder: (context, _) => _buildActionArea(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionArea(BuildContext context) {
    switch (_importService.phase) {
      case ImportPhase.idle:
        return IntroButton(download: true, onPressed: _startDownload);

      case ImportPhase.failed:
        return _ErrorState(onRetry: _retry);

      case ImportPhase.completed:
      // Navigation already fires the moment this phase is reached; this
      // is just a harmless frame of "done" before the route changes.
        return const SizedBox(height: 60);

      default:
        return _ProgressState(
          progress: _importService.downloadProgress,
          message: _importService.statusMessage,
          showPercentage: _importService.phase == ImportPhase.downloading,
        );
    }
  }
}

/// Soft, app-consistent progress indicator with a dynamic status line per
/// pipeline phase — replaces the old flat amber bar and static caption.
class _ProgressState extends StatelessWidget {
  const _ProgressState({required this.progress, required this.message, required this.showPercentage});

  final double progress;
  final String message;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: context.screenSize.width * .90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: showPercentage && progress > 0 ? progress : null,
              color: primary,
              backgroundColor: primarySoft.withOpacity(.18),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          showPercentage && progress > 0 ? '$message (${(progress * 100).toInt()}%)' : message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: fontSizes.font12(context.screenSize),
            color: dark,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

/// Friendly failure state with a retry action — the old version just
/// silently stopped and left the person staring at the intro button again
/// with no explanation.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFDECEC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Color(0xFFD64545), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Le téléchargement a échoué. Vérifiez votre connexion et réessayez.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fontSizes.font12(context.screenSize),
                    color: const Color(0xFF8A2E2E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        IntroButton(download: true, onPressed: onRetry),
      ],
    );
  }
}