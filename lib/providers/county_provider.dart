import 'package:flutter/cupertino.dart';
import 'package:wisconsin_app/models/county.dart';

class CountyProvider with ChangeNotifier {
  CountyProvider(List<County> listOfCounties) {
    _counties = listOfCounties;
  }
  List<County> _counties = [];

  List<County> get counties => _counties;
  // void setCounties(List<County> countyList) {
  //   _counties = countyList;
  // }
  // Future<void> getAllCounties() async {
  //   // List<Region> regions = await QuestionnaireService.getRegions(1);
  //   // if (regions.isNotEmpty) {
  //   //   List<County> list = [];
  //   //   for (Region region in regions) {
  //   //     list.addAll(await QuestionnaireService.getCounties(-1));
  //   //   }
  //   //   _counties = list;
  //   // }
  //   _counties = await QuestionnaireService.getCounties(-1);
  // }
}
