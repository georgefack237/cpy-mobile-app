/// Formats a byte count into a human-readable KB/MB/GB string.
///
/// Accepts whatever shape the backend sends `size` as — a num, a numeric
/// String, or null — instead of assuming it's always a cleanly-parseable
/// int the way `int.parse(size.toString())` did.
String formatFileSize(dynamic sizeInBytes) {
  final double bytes = sizeInBytes is num
      ? sizeInBytes.toDouble()
      : double.tryParse(sizeInBytes?.toString() ?? '') ?? 0;

  if (bytes <= 0) return '0 KB';

  const int kb = 1024;
  const int mb = kb * 1024;
  const int gb = mb * 1024;

  if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(2)} GB';
  if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(2)} MB';
  return '${(bytes / kb).toStringAsFixed(2)} KB';
}