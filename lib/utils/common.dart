import 'package:intl/intl.dart';

class UtilCommon {
  static String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }

  static String convertToAgoShort(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} d';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} h';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} m';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} s';
    } else {
      return 'just now';
    }
  }

  static String getDateTimeNow() {
    final now = DateTime.now();
    return DateFormat('MM/dd/yyyy HH:mm:ss a').format(now);
  }
}
