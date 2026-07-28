import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/dimensions/fontsizes.dart';
import '../../../utils/globals.dart';
import '../../hymns/pages/hymn_books_page.dart'; // InternetScaffold

class LettreAuxLecteursPage extends StatelessWidget {
  const LettreAuxLecteursPage({super.key});

  @override
  Widget build(BuildContext context) {
    final body = ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      children: [
        _paragraph(
          context,
          "Dans ce vent de réforme que le Seigneur est en train de souffler en ces temps de la fin sur son Église, le domaine de la musique n'est pas moins concerné. En effet, dès l'abord, le constat est qu'il n'y a plus de véritables inspirations. La musique dans de nombreuses assemblées chrétiennes est de plus en plus influencée par des styles et genres musicaux en désaccord avec la Parole de Dieu (Hip hop, rap etc.). La sainteté dans ses divers aspects (notamment dans le vestimentaire, la gestuelle et le langage) n'est plus autant respectée.",
        ),
        _paragraph(
          context,
          "Ensuite, il est observé que dans le milieu dit « chrétien », le système qui régit le fonctionnement et la propagation de la musique et de ses acteurs est calqué du monde. Dès lors, le Seigneur Jésus qui est la Parole de Dieu, n'est plus pris comme modèle par excellence. Les chantres en général deviennent des artistes, la musique « chrétienne » est commercialisée... C'est la confusion !",
        ),
        _paragraph(
          context,
          "Dans cet état, le Saint-Esprit n'occupe qu'une place de figurant avant de se retirer complètement. Résultat, la stérilité et la mort s'installent. Les cœurs sont plus émus que convaincus de se repentir et/ou de s'attacher à Jésus.",
        ),
        _scripture(
          context,
          "« Car qui est-ce qui met de la différence entre toi et un autre ? Qu'as-tu que tu n'aies reçu ? Et si tu l'as reçu, pourquoi te glorifies-tu comme si tu ne l'avais pas reçu ? »",
          "1 Corinthiens 4 : 7",
        ),
        _scripture(
          context,
          "« Quelle récompense ai-je donc ? C'est qu'en évangélisant, je prêche l'Évangile de Christ GRATUITEMENT, sans abuser des droits que l'Évangile me donne. »",
          "1 Corinthiens 9 : 18",
        ),
        _paragraph(
          context,
          "Ayant reçu du Seigneur la charge de répandre avec fidélité et simplicité la Parole de Dieu et, de mettre en lumière ses desseins éternels à travers des psaumes et des cantiques qu'Il nous inspire, nous avons jugé opportun de rédiger ce recueil. Car, le Seigneur Jésus nous convainc de mettre par écrit ces chants et poèmes et de les propager GRATUITEMENT.",
        ),
        _scripture(
          context,
          "« Que la parole de Christ habite abondamment en vous en toute sagesse ; instruisez-vous et exhortez-vous les uns les autres par des psaumes, par des hymnes et des cantiques spirituels, chantant dans votre cœur au Seigneur avec reconnaissance »",
          "Colossiens 3 : 16",
        ),
        _paragraph(
          context,
          "Enfin, par la musique et notamment par ce recueil, nous voulons non pas impressionner les hommes, mais glorifier Dieu. Parce que toute chose existe par lui (Jésus-Christ) et pour lui. Et loin de prétendre être des spécialistes en la matière, nous voulons simplement nous acquitter de ce divin service avec humilité, répondant ainsi à la mission qu'il nous a confiée :",
        ),
        _paragraph(
          context,
          "« Je vous ai choisi pour révéler mon cœur aux nations ».",
          italic: true,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "L'équipe de rédaction",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              fontSize: fontSizes.font13(context.screenSize),
              color: dark.withOpacity(.75),
            ),
          ),
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
              "Lettre aux lecteurs",
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

  Widget _paragraph(BuildContext context, String text, {bool italic = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontSize: fontSizes.font13(context.screenSize),
          color: black,
          height: 1.65,
        ),
      ),
    );
  }

  /// Scripture reference pulled out of the body copy into its own
  /// soft accent card — same visual language as the label pills used
  /// elsewhere (primaryLight fill, primary-colored text), so it reads
  /// as a distinct, quotable block without needing a border or quote
  /// icon.
  Widget _scripture(BuildContext context, String verse, String reference) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            verse,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              fontSize: fontSizes.font13(context.screenSize),
              color: dark,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            reference,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: fontSizes.font12(context.screenSize),
              color: primary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}