import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';

/// One channel entry shown inside the bottom sheet.
class WhatsAppChannelLink {
  const WhatsAppChannelLink({required this.name, required this.url});
  final String name;
  final String url;
}

/// Opens the WhatsApp channels bottom sheet. Pulled out as a standalone
/// function (rather than tied to one trigger widget) so any button —
/// the header pill below, or something else later — can open the same
/// sheet without duplicating its layout.
void showWhatsAppChannelsSheet(
    BuildContext context, {
      required List<WhatsAppChannelLink> channels,
      required void Function(WhatsAppChannelLink channel) onChannelTap,
    }) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sheetContext.screenSize.width * .07,
          vertical: sheetContext.screenSize.width * .07,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Text(
              'Nos chaînes WhatsApp',
              style: TextStyle(
                fontSize: fontSizes.font20(sheetContext.screenSize),
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choisissez une chaîne à rejoindre',
              style: TextStyle(
                fontSize: fontSizes.font12(sheetContext.screenSize),
                fontFamily: 'Poppins',
                color: muted,
              ),
            ),
            const SizedBox(height: 14),
            ...channels.map((channel) => _ChannelRow(channel: channel, onTap: onChannelTap)),
          ],
        ),
      ),
    ),
  );
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({required this.channel, required this.onTap});

  final WhatsAppChannelLink channel;
  final void Function(WhatsAppChannelLink channel) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      splashColor: primaryLight,
      onTap: () {
        Navigator.pop(context);
        onTap(channel);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(LucideIcons.messageCircle, size: 18, color: primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                channel.name,
                style: TextStyle(
                  fontSize: fontSizes.font15(context.screenSize),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: black,
                ),
              ),
            ),
            Icon(LucideIcons.arrowUpRight, size: 16, color: muted),
          ],
        ),
      ),
    );
  }
}

/// Compact icon button for opening the channels sheet. Deliberately
/// matches the notification button's size/shape (44x44, rounded) so
/// the two sit as a visually consistent pair in the header — the only
/// difference is icon and the softer, tinted fill instead of a solid
/// block, which is the "soft" language used for icon buttons elsewhere
/// in the app (see the trailing action circles on media/hymn cards).
class WhatsAppChannelsCta extends StatelessWidget {
  const WhatsAppChannelsCta({
    super.key,
    required this.channels,
    required this.onChannelTap,
    this.size = 44,
  });

  final List<WhatsAppChannelLink> channels;
  final void Function(WhatsAppChannelLink channel) onChannelTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      splashColor: primary.withOpacity(.12),
      onTap: () => showWhatsAppChannelsSheet(context, channels: channels, onChannelTap: onChannelTap),
      child: Container(
        height: size,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [

            Icon(LucideIcons.megaphone, color: primaryDark, size: size * .45),
            SizedBox(width:5),

            Text("Nos chaînes"),
          ],
        ),
      ),
    );
  }
}