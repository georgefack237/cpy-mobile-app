import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/dimensions/fontsizes.dart';
import '../../../utils/globals.dart';
import '../../../utils/icons/myIcon.dart';
import '../../../utils/icons/my_icons.dart';
import '../../hymns/pages/hymn_books_page.dart'; // InternetScaffold

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final body = ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      children: [
        _header(context),
        _missionCard(context),
        const SizedBox(height: 36),
        _sectionTitle(context, "Comment l'application est organisée"),
        const SizedBox(height: 16),
        _StructureItem(
          icon: MyIcons.homeIcon,
          title: "Accueil",
          description: "Un point de départ vers les contenus récents et mis en avant.",
        ),
        _StructureItem(
          icon: MyIcons.bookNew,
          title: "Recueils",
          description: "L'ensemble des poèmes et cantiques, organisés par recueil et par catégorie.",
        ),
        _StructureItem(
          icon: MyIcons.fileIcon,
          title: "Médiathèque",
          description: "Des fichiers et des liens vers des ressources telles que des ouvrages, albums et formations.",
        ),
        _StructureItem(
          icon: MyIcons.strongIcon,
          title: "Lexique",
          description: "Un dictionnaire de mots liés à la louange et à l'adoration.",
        ),
        const SizedBox(height: 36),
        _sectionTitle(context, "Les recueils"),
        const SizedBox(height: 16),
        _paragraph(
          context,
          "L'application regroupe plusieurs recueils. Chaque recueil rassemble des poèmes et des cantiques, classés par catégories thématiques — célébration, reconnaissance, supplication, assurance, espérance, entre autres — afin que chacun puisse trouver un texte ou un chant en accord avec ce qu'il traverse ou souhaite exprimer devant Dieu.",
        ),
        _paragraph(
          context,
          "Les cantiques sont en outre accompagnés de leurs accords, afin de permettre à ceux qui savent jouer d'un instrument de les interpréter et d'en jouer la mélodie.",
        ),
      ],
    );

    return InternetScaffold(
      title: '',
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Container(
          padding: const EdgeInsets.only(top: 20, left: 6),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: const Text(
              "À propos de l'application",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
      body: body,
      offline: body,
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration:  BoxDecoration(
              color: primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.music_note_rounded, size: 28, color: primary),
          ),
          const SizedBox(height: 18),
          Text(
            "Chant Pour Yehoshoua",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: fontSizes.font16(context.screenSize),
              color: black,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Mission statement — mostly neutral surface (backgroundLight) with
  /// a single thin colored accent line above the text as the only
  /// touch of color, instead of tinting the whole card. Flat fills
  /// only, no opacity blending, so the color stays clean rather than
  /// washed out.
  Widget _missionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 28),
      decoration: BoxDecoration(
        color: backgroundLight,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 18),
          Text(
            "Chant Pour Yehoshoua est une plateforme d'édification, de formation ayant pour vocation de mettre le Seigneur au centre du chant et de la louange.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: fontSizes.font14(context.screenSize),
              color: dark,
              height: 1.75,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: fontSizes.font13(context.screenSize),
          color: muted,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _paragraph(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSizes.font13(context.screenSize),
          color: dark,
          height: 1.7,
        ),
      ),
    );
  }
}

/// Row describing one section of the app. Flat white card, flat
/// primaryLight icon circle (no opacity stacking), muted (not
/// opacity-dimmed) text tokens — every color here is a single flat
/// value straight from the design system.
class _StructureItem extends StatelessWidget {
  const _StructureItem({required this.icon, required this.title, required this.description});

  final String icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration:  BoxDecoration(
              color: primaryLight,
              shape: BoxShape.circle,
            ),
            child: Center(child: MyIcon(size: 17, icon: icon, color: primary)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: fontSizes.font13(context.screenSize),
                    color: black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fontSizes.font12(context.screenSize),
                    color: muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}