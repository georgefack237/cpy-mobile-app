import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/dimensions/fontsizes.dart';
import '../../../utils/globals.dart';
import '../../../utils/icons/myIcon.dart';
import '../../../utils/icons/my_icons.dart';
import '../../hymns/pages/hymn_books_page.dart'; // InternetScaffold
import '../widgets/guide_section.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final body = ListView(
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      children: [
        GuideSection(
          stepNumber: 1,
          title: "La page d'un cantique",
          description:
          "En haut de chaque cantique se trouve la bascule Paroles / Accords, ainsi que les icônes d'action : téléchargement, partage, et réglages (police ou tonalité selon l'onglet actif).",
          mockup: _AppBarMockup(),
          legend: [
            "Bascule Paroles / Accords — touchez pour changer d'affichage.",
            "Icône de téléchargement — visible tant que l'audio n'est pas encore téléchargé. Elle disparaît une fois le téléchargement terminé et laisse place au mini-lecteur en bas de l'écran.",
            "Icône de partage — ouvre la feuille de partage (paroles ou fichier audio).",
            "Icône de réglages — sur l'onglet Paroles elle ouvre les réglages de lecture (police, taille du texte) ; sur l'onglet Accords elle devient une icône ♪ pour choisir la tonalité de départ affichée.",
          ],
        ),
        GuideSection(
          stepNumber: 2,
          title: "Les partitions : couplets et refrain",
          description:
          "Sur l'onglet Paroles, le cantique est découpé en partitions (couplets, refrain...). Chacune est précédée d'une étiquette qui indique de quelle partie il s'agit.",
          mockup: _PartitionMockup(),
          legend: [
            "Étiquette de couplet — annonce le début d'un couplet.",
            "Étiquette de refrain — porte une icône de répétition ↻ pour rappeler qu'il revient entre les couplets.",
          ],
        ),
        GuideSection(
          stepNumber: 3,
          title: "Les accords et leur durée",
          description:
          "Un « temps » est l'unité de base qui mesure combien de temps un accord doit être tenu — comme le tic régulier d'un métronome. Une mesure regroupe plusieurs temps (généralement 4). Le petit texte au-dessus de chaque accord (ex. « 4 temps », « 2 temps ») indique combien de temps le tenir avant de passer au suivant : un accord marqué 4 temps occupe toute la mesure, tandis que deux accords marqués 2 temps se partagent la même mesure.",
          mockup: _ChordMockup(),
          legend: [
            "« Schéma indépendant » — la suite d'accords en degrés (1, 4, 6...), valable quelle que soit la tonalité.",
            "« Exemple en gamme de [tonalité] » — la même suite transposée dans la tonalité actuellement sélectionnée, prête à être jouée telle quelle.",
            "Sélecteur de tonalité (icône ♪ dans la barre du haut) — change la gamme utilisée pour cet exemple.",
          ],
        ),

        GuideSection(
          stepNumber: 4,
          title: "Comprendre les cases musicales",
          description:
          "Un son a quatre caractéristiques : la hauteur, la longueur, l'intensité et le timbre. C'est la longueur qui nous intéresse ici — elle indique combien de temps dure un son, et se mesure en « temps », comme les battements d'un métronome : une durée constante entre chaque tic. Un accord peut ainsi durer un, deux ou plusieurs temps. Afin de répartir ces temps de façon équitable dans un chant, on les regroupe en mesures — le plus souvent de 4 temps, parfois 2, 3 ou 5. C'est ce regroupement qui donne au chant son rythme régulier, et c'est exactement ce que représente le chiffre au-dessus de chaque accord : le nombre de temps de la mesure qu'il occupe.",
          mockup: _ChordMockup(),
          legend: [],
        ),

        GuideSection(
          stepNumber: 5,
          title: "Télécharger l'audio",
          description:
          "Chaque cantique disposant d'un enregistrement peut être téléchargé pour être écouté hors connexion.",
          mockup: _DownloadMockup(),
          legend: [
            "Tant que le cantique n'est pas téléchargé, l'icône de téléchargement apparaît dans la barre du haut.",
            "Une feuille s'ouvre avec la taille du fichier ; toucher « Télécharger » lance l'enregistrement sur l'appareil.",
            "Un anneau de progression avec le pourcentage remplace l'icône pendant le téléchargement. Une fois terminé, le mini-lecteur audio apparaît en bas de l'écran.",
          ],
        ),
        GuideSection(
          stepNumber: 6,
          title: "Réglages de lecture",
          description:
          "Sur l'onglet Paroles, l'icône de police ouvre un panneau pour adapter le confort de lecture à vos préférences.",
          mockup: _FontSettingsMockup(),
          legend: [
            "Icône de réglages de lecture, dans la barre du haut.",
            "Curseur de taille du texte.",
            "Choix de la police d'écriture parmi celles proposées.",
          ],
        ),
        GuideSection(
          stepNumber: 7,
          title: "Le lecteur audio",
          description:
          "Une fois l'audio téléchargé, un lecteur compact apparaît en bas de l'écran. Touchez-le pour l'agrandir et accéder à plus de contrôles.",
          mockup: _PlayerMockup(),
          legend: [
            "Lecture / pause.",
            "Barre de défilement — touchez ou glissez pour avancer/reculer dans le morceau.",
            "Vitesse de lecture — touchez pour alterner entre 1x, 1.25x, 1.5x...",
            "Touchez la carte pour l'agrandir et voir le titre, le temps restant, et les boutons ⏪10s / ⏩10s.",
          ],
        ),
        GuideSection(
          stepNumber: 8,
          title: "Partager",
          description:
          "L'icône de partage propose deux options. Vous pouvez aussi sélectionner un passage précis des paroles par un appui long et le partager directement depuis le menu qui apparaît.",
          mockup: _ShareMockup(),
          legend: [
            "« Paroles » envoie le texte complet (couplets, refrain, accords, lien du site) via WhatsApp, Messages, e-mail...",
            "« Audio » n'apparaît que si le fichier a déjà été téléchargé, et partage directement le mp3.",
          ],
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
              "Comment utiliser l'application",
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
}

// ---------------------------------------------------------------------
// Mockups — small, self-contained reproductions of real UI pieces.
// ---------------------------------------------------------------------

class _AppBarMockup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Sur les ailes de la foi',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizes.font14(context.screenSize),
                  color: black,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Badged(number: 2, child: const MyIcon(size: 18, icon: MyIcons.download)),
            const SizedBox(width: 16),
            Badged(number: 3, child: const MyIcon(size: 18, icon: MyIcons.share)),
            const SizedBox(width: 16),
            Badged(number: 4, child: const Icon(Icons.font_download_outlined, size: 18)),
          ],
        ),
        const SizedBox(height: 18),
        Badged(
          number: 1,
          child: Container(
            height: 38,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: const Color(0xFFF5F5F3), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(16)),
                    child: const Text('Paroles',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Accords', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: dark)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PartitionMockup extends StatelessWidget {
  Widget _pill(BuildContext context, {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: primary),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(fontFamily: 'Poppins', fontSize: fontSizes.font12(context.screenSize), color: primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Badged(number: 1, child: _pill(context, icon: Icons.music_note_rounded, label: 'Couplet 1')),
        const SizedBox(height: 16),
        Badged(number: 2, child: _pill(context, icon: Icons.repeat_rounded, label: 'Refrain')),
      ],
    );
  }
}

class _ChordMockup extends StatelessWidget {
  Widget _chip(String duration, String note) {
    return Column(
      children: [
        Text(duration, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11, fontFamily: 'Poppins', color: muted)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(12)),
          child: Text(note, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, fontFamily: 'Poppins', color: primary)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Schéma indépendant', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Poppins', color: black)),
        const SizedBox(height: 10),
        Badged(
          number: 1,
          child: Wrap(spacing: 10, runSpacing: 10, children: [_chip('4 temps', '1'), _chip('2 temps', '4'), _chip('2 temps', '5')]),
        ),
        const SizedBox(height: 24),
        Text('Exemple en gamme de Do', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Poppins', color: black)),
        const SizedBox(height: 10),
        Badged(
          number: 2,
          child: Wrap(spacing: 10, runSpacing: 10, children: [_chip('4 temps', 'Do'), _chip('2 temps', 'Fa'), _chip('2 temps', 'Sol')]),
        ),
        const SizedBox(height: 22),
        Badged(
          number: 3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.music_note_outlined, size: 18, color: dark),
              const SizedBox(width: 6),
              Text('Do ▾', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: dark)),
            ],
          ),
        ),
      ],
    );
  }
}

class _DownloadMockup extends StatelessWidget {
  Widget _row({required IconData icon, required String label, required String subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 18, color: primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 13, color: black)),
              Text(subtitle, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: dark.withOpacity(.55))),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Badged(number: 1, child: _row(icon: Icons.download_rounded, label: "Toucher l'icône de téléchargement", subtitle: 'Ouvre la feuille de téléchargement')),
        const SizedBox(height: 18),
        Badged(number: 2, child: _row(icon: Icons.sd_card_outlined, label: 'Télécharger', subtitle: 'Confirme et lance le téléchargement du fichier audio')),
        const SizedBox(height: 18),
        Row(
          children: [
            Badged(
              number: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      value: .65,
                      strokeWidth: 3,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(primaryDark),
                    ),
                  ),
                  const Text('65%', style: TextStyle(fontSize: 9, fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text('Téléchargement en cours...', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: dark.withOpacity(.7)))),
          ],
        ),
      ],
    );
  }
}

class _FontSettingsMockup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Badged(
          number: 1,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.font_download_outlined, size: 18),
            const SizedBox(width: 8),
            Text('Réglages de lecture', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: dark)),
          ]),
        ),
        const SizedBox(height: 18),
        Badged(
          number: 2,
          child: Row(
            children: [
              Text('A', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: dark)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(trackHeight: 3),
                  child: Slider(value: .6, onChanged: null, activeColor: primary, inactiveColor: primaryLight),
                ),
              ),
              Text('A', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: dark)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Badged(
          number: 3,
          child: Wrap(
            spacing: 8,
            children: ['Roboto', 'Poppins', 'Merriweather'].map((f) {
              final selected = f == 'Poppins';
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: selected ? primary : primaryLight, borderRadius: BorderRadius.circular(14)),
                child: Text(f, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: selected ? Colors.white : dark)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PlayerMockup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF0EFEC)),
      ),
      child: Row(
        children: [
          Badged(
            number: 1,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryDarkest),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Badged(
              number: 2,
              child: Container(height: 3, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4))),
            ),
          ),
          const SizedBox(width: 14),
          Badged(
            number: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F3), borderRadius: BorderRadius.circular(14)),
              child: const Text('1x', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 10),
          Badged(number: 4, child: Icon(Icons.keyboard_arrow_up_rounded, size: 18, color: dark.withOpacity(.5))),
        ],
      ),
    );
  }
}

class _ShareMockup extends StatelessWidget {
  Widget _row({required IconData icon, required String label, required String subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 18, color: primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 13, color: black)),
              Text(subtitle, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: dark.withOpacity(.55))),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, size: 18, color: dark.withOpacity(.4)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Badged(number: 1, child: _row(icon: Icons.article_outlined, label: 'Paroles', subtitle: 'Texte du cantique')),
        const SizedBox(height: 16),
        Badged(number: 2, child: _row(icon: Icons.audiotrack_rounded, label: 'Audio', subtitle: 'Fichier téléchargé')),
      ],
    );
  }
}