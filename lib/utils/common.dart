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

  static DateTime getDateTimeNow() {
    return DateFormat("MM/dd/yyyy").add_jms().parse(formatDate(DateTime.now()));
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat("MM/dd/yyyy").add_jms().format(dateTime);
  }

  static String getTimeString(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  static DateTime getDatefromString(String value) {
    // print("VALUE : $value");
    return DateFormat("MM/dd/yyyy").add_jms().parse(value);
    // return DateFormat.M().add_d().add_y().add_jms().parse(value);
  }
}
