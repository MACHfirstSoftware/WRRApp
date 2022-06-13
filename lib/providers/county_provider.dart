import 'package:flutter/cupertino.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/services/questionnaire_service.dart';

class CountyProvider with ChangeNotifier {
  late List<County> _counties;

  List<County> get counties => _counties;

  Future<void> getAllCounties() async {
    print("counties get call");
    // List<Region> regions = await QuestionnaireService.getRegions(1);
    // if (regions.isNotEmpty) {
    //   List<County> list = [];
    //   for (Region region in regions) {
    //     list.addAll(await QuestionnaireService.getCounties(-1));
    //   }
    //   _counties = list;
    // }
    _counties = await QuestionnaireService.getCounties(-1);
  }
}
