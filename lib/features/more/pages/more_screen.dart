import 'package:flutter/material.dart';

import '../../hymns/pages/hymn_books_page.dart';
import '../widgets/menu_card.dart';
import 'about_page.dart';
import 'how_to_use_page.dart';
import 'letter_to_reader_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      children: [
        MenuItemCard(
          icon: Icons.menu_book_rounded,
          title: "Comment utiliser l'application",
          subtitle: "Guide de prise en main rapide",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HowToUsePage()),
          ),
        ),
        MenuItemCard(
          icon: Icons.mail_outline_rounded,
          title: "Lettre aux lecteurs",
          subtitle: "Le mot de l'équipe de rédaction",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LettreAuxLecteursPage()),
          ),
        ),
        MenuItemCard(
          icon: Icons.info_outline_rounded,
          title: "À propos de l'application",
          subtitle: "Version, mission et informations",
           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()),),
        ),
        // Drop more MenuItemCard entries here, e.g.:
        // "Contactez-nous", "Politique de confidentialité",
        // "Partager l'application", "Noter l'application"
      ],
    );

    return InternetScaffold(
      title: 'Plus',
      body: content,
      // Static content — no network call needed, so show the same list offline.
      offline: content,
    );
  }
}