import 'dart:io';

import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/features/home/pages/whatsapp_link_card.dart';
import 'package:cpy_app/features/home/provider/picture_verse_provider.dart';
import 'package:cpy_app/features/hymns/pages/home_poems_page.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart' as En;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/notifications/fcm_tokens.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../hymns/pages/home_hymn_page.dart';
import '../../hymns/providers/local_hymn_book_provider.dart';
import '../../notifications/pages/notifications_page.dart';
import '../widgets/bible_verse_carousel.dart';
import '../widgets/book_option_item.dart';


const String kJsbWhatsAppChannelUrl = 'https://whatsapp.com/channel/0029VaP8sbR35fM0axRgsn07';
const String kCpyWhatsAppChannelUrl = 'https://whatsapp.com/channel/0029VbBfynlIXnlnxiZ4iT17';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int totalSong = 0;
  int totalPoems = 0;
  bool loading = false;

  late final PictureVerseProvider _provider;

  @override
  void initState() {
    _provider = Provider.of<PictureVerseProvider>(context, listen: false);
    var provider = Provider.of<ProfileProvider>(context, listen: false);
    _provider.getVerses(context: context);
    shouldUpdateDatabase();
    _createUniqueFingerPrint(provider);
    super.initState();
  }

  Future<void> _createUniqueFingerPrint(ProfileProvider provider) async {
    setState(() {
      loading = true;
    });

    final deviceInfoPlugin = DeviceInfoPlugin();

    ///todo Should fcmTokens be generated on every app launch, the life cycle of an android fmc token when to update it.
    String? fcmKey = await getFcmToken();

    saveShowIntro(false);

    bool showIntro = await showIntroScreenFunc();

    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      final allInfo = deviceInfo.data;
      var fingerPrint = allInfo['fingerprint'];
      const key = "A9fP3nX7LGP2NdQ4";
      final plainText = fingerPrint.toString();
      En.Encrypted encrypted = helperFunctions.encrypt(key, plainText);

      await provider.addProfile(deviceId: encrypted.base64, notificationId: fcmKey!);

      logger.i(fcmKey);
    }

    setState(() {
      loading = false;
    });
  }

  void shouldUpdateDatabase() async {
    setState(() {
      loading = true;
    });

    final provider = Provider.of<LocalHymnBookProvider>(context, listen: false);
    await provider.getAllSongs();
    await provider.getAllPoems();

    logger.i('No need to run update');
    totalPoems = provider.allPoems ?? 0;
    totalSong = provider.allSongs ?? 0;

    setState(() {
      loading = false;
    });
  }

  /// Opens a WhatsApp channel link. Channel links are plain https URLs
  /// (unlike the wa.me chat deep link used for direct support below),
  /// so no platform branching is needed — the OS hands off to the
  /// WhatsApp app if installed, or the browser otherwise.
  Future<void> _openWhatsAppChannel(String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le canal WhatsApp.")),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        strokeWidth: 1,
        color: primaryDark,
        backgroundColor: Colors.white,
        onRefresh: () async {
          _provider.getVerses(context: context);
        },
        child: Padding(
          padding: EdgeInsets.zero,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: appPadding.padH16(context.screenSize),
                  vertical: appPadding.padV30(context.screenSize),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shalom!",
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Poppins',
                            fontSize: fontSizes.font24(context.screenSize),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WhatsAppChannelsCta(
                          channels: const [
                            WhatsAppChannelLink(name: 'JSB - JESUS SOURCE DE BÉNÉDICTIONS', url: kJsbWhatsAppChannelUrl),
                            WhatsAppChannelLink(name: 'PLATEFORME CHANT POUR YEHOSHOUA', url: kCpyWhatsAppChannelUrl),
                          ],
                          onChannelTap: (channel) => _openWhatsAppChannel(channel.url),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
                            child: MyIcon(
                              size: context.screenSize.width * .055,
                              icon: MyIcons.notificationIcon,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: appPadding.padH16(context.screenSize)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(context, "Tableau d'affichage"),
                    buildOfflineContent(),
                  ],
                ),
              ),

              // ---- Contact card, restyled to match the white-card +
              // soft-shadow language used elsewhere (MediaFileItem,
              // HymnBookItem) instead of its previous bordered outline.
              Container(
                margin: EdgeInsets.only(
                  left: appPadding.padH16(context.screenSize),
                  right: appPadding.padH16(context.screenSize),
                  top: appPadding.padH16(context.screenSize),
                ),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [primary, primarySoft]),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.messageCircle, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: appPadding.padH16(context.screenSize)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Besoin d'aide ?",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: fontSizes.font13(context.screenSize),
                                color: black,
                              ),
                            ),
                            Text(
                              'Écrivez-nous',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: fontSizes.font11(context.screenSize),
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        var contact = '+24166757476';
                        var message = "Hello";

                        if (Platform.isAndroid) {
                          launchUrl(Uri.parse('https://wa.me/$contact?text=Bonjour!'),
                              mode: LaunchMode.externalApplication);
                        } else {
                          launchUrl(Uri.parse('whatsapp://wa.me/$contact/?text=${Uri.encodeFull(message)}'),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(color: primaryLight, shape: BoxShape.circle),
                        child: Icon(LucideIcons.send, color: primaryDark, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: appPadding.padV30(context.screenSize)),

              // ---- Ressources ----
              Padding(
                padding: EdgeInsets.symmetric(horizontal: appPadding.padH16(context.screenSize)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(context, "Ressources"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeHymnBookPage()));
                          },
                          child: BookOptionItem(
                            icon: MyIcons.hymnIcon,
                            title: 'Cantiques',
                            stats: totalSong.toString(),
                            bgColor: [primary, primarySoft],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePoemsPage()));
                          },
                          child: BookOptionItem(
                            icon: MyIcons.poemIcon,
                            title: 'Poèmes',
                            stats: totalPoems.toString(),
                            bgColor: const [aColor, aColorLight],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: appPadding.padV30(context.screenSize)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(
        left: appPadding.padH8(context.screenSize),
        bottom: appPadding.padV15(context.screenSize),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: fontSizes.font17(context.screenSize),
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget buildOfflineContent() {
    return Consumer<PictureVerseProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: context.screenSize.height * .44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
          ),
        );
      }

      if (provider.error != null) {}

      return provider.verses != null
          ? BibleVerseCarousel(verses: provider.verses ?? [])
          : provider.isLoading
          ? Expanded(
        child: Container(
          height: context.screenSize.height * .44,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.grey),
        ),
      )
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: context.screenSize.height * .44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
        ),
      );
    });
  }
}