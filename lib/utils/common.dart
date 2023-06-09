import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/region.dart';

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

  static String toAgoShortForm(String value) {
    if (value == "Just Now") {
      return value;
    } else {
      List<String> temp = value.split(" ");
      return temp[0] + " " + temp[1].substring(0, 1);
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
    return DateFormat("MM/dd/yyyy").add_jm().format(dateTime);
  }

  static String getTimeString(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  static DateTime getDatefromString(String value) {
    // print("VALUE : $value");
    return DateFormat("MM/dd/yyyy").add_jms().parse(value);
    // return DateFormat.M().add_d().add_y().add_jms().parse(value);
  }

  static String getWeatherHourlyTime(String value) {
    final date = DateFormat("yyyy-MM-dd HH:mm").parse(value);
    return DateFormat("hh:mm a").format(date);
  }

  static String getDate(String value, {int forecastDay = 0}) {
    DateTime date = DateTime.parse(value.substring(0, 10) + " 00:00:00.000");
    return DateFormat("MMM dd, yyyy")
        .format(date.add(Duration(days: forecastDay)));
  }

  static void launchAnUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      uri = Uri.parse("https://" + url);
    }
    if (!await launchUrl(
      uri,
    )) {
      if (kDebugMode) {
        print("Couldn't launch");
      }
    }
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

class ImageUtil {
  static String getImageName(String str) {
    str = str.replaceAll('.jpg', '');
    str = str.replaceAll('.png', '');
    str = str.replaceAll('.jpeg', '');
    return str;
  }

  static String getImageExtension(String str) {
    if (str.contains(".jpeg")) {
      return ".jpeg";
    }
    if (str.contains(".png")) {
      return ".png";
    }
    return ".jpg";
  }

  static String getBase64Image(String path) {
    final bytes = File(path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    return img64;
  }
}

class CountyUtil {
  static String getCountyNameById(
      {required List<County> counties, required int countyId}) {
    // print(countyId);
    String countyName = '';
    for (final county in counties) {
      if (county.id == countyId) {
        // print(county.id);
        // print(county.name);
        countyName = county.name;
        break;
      }
    }
    return countyName;
  }

  static String getRegionNameById(
      {required List<Region> regions, required int regionId}) {
    String regionName = '';
    for (final region in regions) {
      if (region.id == regionId) {
        // print(region.id);
        // print(region.name);
        regionName = region.name;
        break;
      }
    }
    return regionName;
  }
}

class VideoUtil {
  static Future<Uint8List?> generateThumbnail(
      {required String filePath}) async {
    final thumsBytes = await VideoCompress.getByteThumbnail(filePath);
    return thumsBytes;
  }

  // static Future<MediaInfo?> compressVideo({required String filePath}) async {
  //   try {
  //     await VideoCompress.setLogLevel(0);
  //     return VideoCompress.compressVideo(filePath,
  //         quality: VideoQuality.DefaultQuality, includeAudio: true);
  //   } catch (e) {
  //     VideoCompress.cancelCompression();
  //     return null;
  //   }
  // }
}
