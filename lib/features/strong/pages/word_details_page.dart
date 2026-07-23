import 'package:cpy_app/features/strong/data/model/word_reference.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class WordDetailsPage extends StatefulWidget {
  const WordDetailsPage({super.key, required this.wordReference});

  final WordReference wordReference;

  @override
  State<WordDetailsPage> createState() => _WordDetailsPageState();
}

class _WordDetailsPageState extends State<WordDetailsPage> {
  // Same card language as HymnItem / HymnBookItem / WordItem.
  static const double _cardRadius = 24;
  static const double _tileRadius = 16;

  // Needed to compute sharePositionOrigin for the iOS/iPad share
  // popover — without it, Share.share throws a PlatformException on
  // iPad ("sharePositionOrigin: argument must be set"), since iOS
  // needs a screen anchor point for the popover.
  final GlobalKey _shareButtonKey = GlobalKey();

  /// Computes the on-screen rect of the share button so iOS/iPad has a
  /// popover anchor point. Returns null (letting share_plus fall back
  /// to its own default) if the render box isn't ready for some reason
  /// — safer than crashing.
  Rect? _shareOrigin() {
    final box = _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  /// Soft circle icon button — same treatment as the trailing "more" button
  /// used throughout the redesigned list items, reused here for back/share.
  Widget _circleIconButton({
    Key? key,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: key,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primarySoft.withOpacity(.10),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, size: 18, color: dark),
        ),
      ),
    );
  }

  /// Small section label — same pill shape as HymnBookItem's category badge,
  /// but now takes a color so Étymologie (blue) and Définition (gold) echo
  /// the Cantiques/Poèmes pairing on Home instead of both being blue.
  Widget _sectionLabel(BuildContext context, String label, Color tint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tint.withOpacity(.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSizes.font11(context.screenSize),
          fontWeight: FontWeight.w600,
          color: tint,
          letterSpacing: .2,
        ),
      ),
    );
  }

  /// A section as its own soft card — matches the white/shadow/rounded
  /// language of the list items instead of bare text on the page background.
  Widget _sectionCard({
    required BuildContext context,
    required String label,
    required String body,
    required Color tint,
    required int delayMs,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + delayMs),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.035),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _sectionLabel(context, label, tint),

            const SizedBox(height: 14),
            Text(
              body,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fontSizes.font15(context.screenSize),
                height: 1.55,
                color: black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22, top: 4),
      child: Row(
        children: [
          // Solid blue badge, same weight as the bell icon on Home —
          // one confident color note rather than a tinted block.
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(_tileRadius),
            ),
            child: Center(
              child: Text(
                widget.wordReference.word[0].toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font17(context.screenSize),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              widget.wordReference.word,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fontSizes.font20(context.screenSize),
                fontWeight: FontWeight.w600,
                color: black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child:AppBar(
            centerTitle: false,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Lexique",
              style:  TextStyle(
                  color:Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: fontSizes.font20(context.screenSize),
                  fontWeight: FontWeight.w600),
              maxLines: 1,
            ),

            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_outlined, color:black, size: 25),
            ),


            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _circleIconButton(
                  key: _shareButtonKey,
                  icon: Icons.ios_share_outlined,
                  onTap: () async {
                    await Share.share(
                      '${widget.wordReference.word} \n  \n ${widget.wordReference.etymology}  \n  \n${widget.wordReference.definition}',
                      subject: widget.wordReference.word,
                      sharePositionOrigin: _shareOrigin(),
                    );
                  },
                ),
              ),
            ],


          ),
        ),
      ),





      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appPadding.padH16(context.screenSize),
            vertical: appPadding.padH16(context.screenSize),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              _sectionCard(
                context: context,
                label: 'ÉTYMOLOGIE',
                body: widget.wordReference.etymology ?? 'N/A',
                tint: primary,
                delayMs: 0,
              ),
              _sectionCard(
                context: context,
                label: 'DÉFINITION',
                body: widget.wordReference.definition,
                tint: accent,
                delayMs: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}