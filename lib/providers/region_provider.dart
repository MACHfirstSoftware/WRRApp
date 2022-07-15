import 'package:flutter/cupertino.dart';
import 'package:wisconsin_app/models/region.dart';

class RegionProvider with ChangeNotifier {
  final List<Region> _regions = [
    Region(id: 1, name: "Northwest"),
    Region(id: 2, name: "Northeast"),
    Region(id: 3, name: "West"),
    Region(id: 4, name: "Central"),
    Region(id: 5, name: "East"),
    Region(id: 6, name: "Southwest"),
    Region(id: 7, name: "Southeast")
  ];

  List<Region> get regions => _regions;
}
