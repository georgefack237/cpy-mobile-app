import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpy_app/data/models/affiche.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/api_constants.dart';
import '../../../utils/colors/light_colors.dart';

class VersePage extends StatefulWidget {
  const VersePage({super.key, required this.verse});

  final PictureVerse verse;

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  String formatDateTime(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} • ${dateTime.hour.toString().padLeft(2, '0')}h${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Date invalide';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFullImage = widget.verse.type == 'verse';

    return Scaffold(
      backgroundColor: Colors.white,
      body: isFullImage ? _buildFullImageLayout(context) : _buildDetailLayout(context),
    );
  }

  // ---------------------------------------------------------------------
  // Layout for affiche/event-style verses: AppBar + card content, matching
  // the NotificationsPage app bar (white, Poppins 20, flat, black back arrow).
  // ---------------------------------------------------------------------
  Widget _buildDetailLayout(BuildContext context) {
    return Column(
      children: [
        PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 80),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: AppBar(
              centerTitle: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Détails',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font20(context.screenSize),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
              ),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_outlined, color: black, size: 25),
              ),
            ),
          ),
        ),
        Expanded(
          child: SafeArea(
            top: false,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: appPadding.padH16(context.screenSize)),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: "${ApiConstants.storageUrl}${widget.verse.image}",
                    imageBuilder: (context, imageProvider) => Container(
                      height: context.screenSize.height * .38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      height: context.screenSize.height * .38,
                      width: double.infinity,
                      color: tColorLight,
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: context.screenSize.height * .38,
                      width: double.infinity,
                      color: tColorLight,
                    ),
                  ),
                ),

                SizedBox(height: context.screenSize.width * .06),

                Text(
                  widget.verse.verse,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fontSizes.font17(context.screenSize),
                    fontWeight: FontWeight.w600,
                    color: dark,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: context.screenSize.width * .03),

                Text(
                  widget.verse.description,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fontSizes.font13(context.screenSize),
                    fontWeight: FontWeight.w400,
                    color: dark.withOpacity(.75),
                    height: 1.5,
                  ),
                ),

                if (widget.verse.location != null) ...[
                  SizedBox(height: context.screenSize.width * .06),
                  _InfoRow(
                    icon: LucideIcons.locateFixed300,
                    label: 'Lieu',
                    value: widget.verse.location ?? '',
                    screenSize: context.screenSize,
                  ),
                ],

                if (widget.verse.start != null || widget.verse.stop != null) ...[
                  SizedBox(height: context.screenSize.width * .04),
                  if (widget.verse.start != null)
                    _InfoRow(
                      icon: LucideIcons.clock5300,
                      label: 'Début',
                      value: formatDateTime(widget.verse.start!),
                      screenSize: context.screenSize,
                    ),
                  if (widget.verse.start != null && widget.verse.stop != null)
                    SizedBox(height: context.screenSize.width * .03),
                  if (widget.verse.stop != null)
                    _InfoRow(
                      icon: LucideIcons.clock5300,
                      label: 'Fin',
                      value: formatDateTime(widget.verse.stop!),
                      screenSize: context.screenSize,
                    ),
                ],

                SizedBox(height: context.screenSize.width * .08),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Layout for pure "verse" images: full-bleed image with legible gradient
  // overlay (replaces the previous flat 55% black scrim).
  // ---------------------------------------------------------------------
  Widget _buildFullImageLayout(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: "${ApiConstants.storageUrl}${widget.verse.image}",
          imageBuilder: (context, imageProvider) => Container(
            width: context.screenSize.width,
            height: context.screenSize.height,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => Container(
            width: context.screenSize.width,
            height: context.screenSize.height,
            color: tColorLight,
          ),
          errorWidget: (context, url, error) => Container(
            width: context.screenSize.width,
            height: context.screenSize.height,
            color: tColorLight,
          ),
        ),

        // Gradient scrim: transparent at top so the image reads clearly,
        // darkening toward the bottom where the text sits.
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.05),
                  Colors.black.withOpacity(.15),
                  Colors.black.withOpacity(.70),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          left: 24,
          right: 24,
          bottom: context.screenSize.height * .08,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.verse.description,
                textAlign: TextAlign.center,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: fontSizes.font15(context.screenSize),
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              SizedBox(height: context.screenSize.width * .035),
              Text(
                widget.verse.verse,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font15(context.screenSize),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 8),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 23),
            ),
          ),
        ),
      ],
    );
  }
}

/// Icon-label-value row used for location/start/stop, matching the rounded
/// primarySoft icon-chip style already established in this screen.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.screenSize,
  });

  final IconData icon;
  final String label;
  final String value;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        SizedBox(width: screenSize.width * .03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font13(screenSize),
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font13(screenSize),
                  fontWeight: FontWeight.w400,
                  color: dark.withOpacity(.75),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}