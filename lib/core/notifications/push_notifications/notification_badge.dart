import 'package:flutter/cupertino.dart';

import '../../../utils/colors/light_colors.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({Key? key, required this.totalNotifications}) : super(key: key);

  final int totalNotifications;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Text(totalNotifications.toString(), style: const TextStyle(color: whiteColor, fontSize: 17, fontFamily: 'Poppins')),
        ),
      ),
    );
  }
}
