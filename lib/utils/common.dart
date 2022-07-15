import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // print("Utils ${DateTime.parse(DateTime.now().toUtc()}");

    // final date = DateFormat("MM/dd/yyyy hh:mm:s a").format(DateTime.now());
    // print("Utils $date");
    return DateFormat("MM/dd/yyyy")
        .add_jms()
        .parse(DateFormat("MM/dd/yyyy hh:mm:s a").format(DateTime.now()));
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

class StoreUtils {
  static Future<void> saveUser(Map<String, dynamic> userCredintials) async {
    String _userData = json.encode(userCredintials);
    log(_userData);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("USER", _userData);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? _user = prefs.getString("USER");
    if (_user == null) {
      return null;
    } else {
      log(_user);
      Map<String, dynamic> _userData = json.decode(_user);
      return _userData;
    }
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("USER");
  }
}
