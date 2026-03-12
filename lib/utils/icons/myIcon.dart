import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class MyIcon extends StatelessWidget {
  const MyIcon({super.key, required this.size,  this.color, required this.icon, this.padding});

  final double size;
  final Color? color;
  final String icon;
  final EdgeInsets? padding;


  /// Creates a new [Duration] object whose value
  /// is the sum of all individual parts.
  ///
  /// Individual parts can be larger than the number of those
  /// parts in the next larger unit.
  /// For example, [hours] can be greater than 23.
  /// If this happens, the value overflows into the next larger
  /// unit, so 26 [hours] is the same as 2 [hours] and
  /// one more [days].
  /// Likewise, values can be negative, in which case they
  /// underflow and subtract from the next larger unit.
  ///
  /// If the total number of microseconds cannot be represented
  /// as an integer value, the number of microseconds might overflow
  /// and be truncated to a smaller number of bits,
  /// or it might lose precision.
  ///
  /// All arguments are 0 by default.
  /// ```dart
  /// const duration = Duration(days: 1, hours: 8, minutes: 56, seconds: 59,
  ///   milliseconds: 30, microseconds: 10);
  /// print(duration); // 32:56:59.030010
  /// ```

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding ?? const EdgeInsets.all(10),
      height: size,
      width: size,
      child: SvgPicture.asset(
        icon,
        colorFilter:   color != null ? ColorFilter.mode(color!, BlendMode.srcIn):null,
      ),
    );
  }
}
