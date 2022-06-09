import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:wisconsin_app/models/country.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/question.dart';
import 'package:wisconsin_app/models/region.dart';
import 'package:wisconsin_app/services/questionnaire_service.dart';
import 'package:wisconsin_app/ui/landing/sign_up_page/sign_up_page.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  late bool _isInitialing;
  late List<Question>? _questions;
  int _currentIndex = 0;
  late PageController _pageController;
  List<Answer> _selectedAnswers = [];

  List<Country> countries = [];
  List<Region> regions = [];
  List<County> counties = [];

  Country? _selectedCountry;
  Region? _selectedRegion;
  County? _selectedCounty;

  @override
  void initState() {
    _isInitialing = true;
    _pageController = PageController();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _init() async {
    countries = await QuestionnaireService.getCountries();
    // if (countries.isNotEmpty) {
    //   regions = await QuestionnaireService.getRegions(1);
    // }
    // if (regions.isNotEmpty) {
    //   counties = await QuestionnaireService.getCounties(1, regions[0].id);
    // }
    if (countries.isNotEmpty) {
      final questionsResponse = await QuestionnaireService.getQuestionnarie();
      if (questionsResponse != null) {
        setState(() {
          _isInitialing = false;
          _questions = questionsResponse;
        });
      }
    }
  }

  _changeCountry(Country country) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    PageLoader.showLoader(context);
    final regionsResponse = await QuestionnaireService.getRegions(1);
    Navigator.pop(context);
    if (regionsResponse.isNotEmpty) {
      regions = regionsResponse;
      setState(() {});
    } else {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Unable to load data!",
          type: SnackBarType.error));
    }
  }

  _changeRegion(Region region) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    PageLoader.showLoader(context);
    final countiesResponse =
        await QuestionnaireService.getCounties(1, region.id);
    Navigator.pop(context);
    if (countiesResponse.isNotEmpty) {
      counties = countiesResponse;
      setState(() {});
    } else {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Unable to load data!",
          type: SnackBarType.error));
    }
  }

  _validateFirstPageValues() {
    if (_selectedCountry == null) {
      return false;
    }
    if (_selectedRegion == null) {
      return false;
    }
    if (_selectedCounty == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _isInitialing
            ? Center(
                child: SizedBox(
                  height: 50.w,
                  width: 50.w,
                  child: const LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                      colors: [Colors.black],
                      strokeWidth: 2.0),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 9.w),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 56.h,
                        width: 428.w,
                      ),
                      _buildStepper(),
                      SizedBox(
                        height: 56.h,
                      ),
                      Expanded(
                          child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        itemCount: _questions!.length + 1,
                        itemBuilder: (_, index) {
                          if (_currentIndex == 0) {
                            return _buildFirstPage();
                          }
                          return _buildQuestionPage();
                        },
                      )),
                    ]),
              ));
  }

  _buildFirstPage() {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: 410.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        // unselectedWidgetColor: Colors.white
                      ),
                      child: ExpansionTile(
                        title: Text(
                          _selectedCountry?.name ?? "Country",
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        children: [
                          ...countries.map((country) => ListTile(
                                title: Text(
                                  country.name,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                                trailing: _selectedCountry == country
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Icon(
                                          Icons.check,
                                          color: const Color(0xFFF23A02),
                                          size: 25.h,
                                        ),
                                      )
                                    : null,
                                onTap: () {
                                  if (_selectedCountry != country) {
                                    _selectedCounty = null;
                                    _selectedRegion = null;
                                    setState(() {
                                      _selectedCountry = country;
                                    });
                                    _changeCountry(country);
                                  }
                                },
                              ))
                        ],
                      )),
                  Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          _selectedRegion?.name ?? "Region",
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        children: [
                          ...regions.map((region) => ListTile(
                                title: Text(
                                  region.name,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                                trailing: _selectedRegion == region
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Icon(
                                          Icons.check,
                                          color: const Color(0xFFF23A02),
                                          size: 25.h,
                                        ),
                                      )
                                    : null,
                                onTap: () {
                                  if (_selectedRegion != region) {
                                    _selectedCounty = null;
                                    setState(() {
                                      _selectedRegion = region;
                                      _changeRegion(region);
                                    });
                                  }
                                },
                              ))
                        ],
                      )),
                  Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        // unselectedWidgetColor: Colors.white
                      ),
                      child: ExpansionTile(
                        title: Text(
                          _selectedCounty?.name ?? "County",
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        children: [
                          ...counties.map((county) => ListTile(
                                title: Text(
                                  county.name,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                                trailing: _selectedCounty == county
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Icon(
                                          Icons.check,
                                          color: const Color(0xFFF23A02),
                                          size: 25.h,
                                        ),
                                      )
                                    : null,
                                onTap: () {
                                  setState(() {
                                    _selectedCounty = county;
                                  });
                                },
                              ))
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 36.h,
        ),
        GestureDetector(
          onTap: () {
            if (_validateFirstPageValues()) {
              _pageController.jumpToPage(_currentIndex);
              setState(() {
                _currentIndex++;
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 50.h,
            width: 192.w,
            decoration: BoxDecoration(
                color: _validateFirstPageValues()
                    ? const Color(0xFFF23A02)
                    : Colors.grey[600],
                borderRadius: BorderRadius.circular(5.w)),
            child: Text(
              "CONTINUE",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 36.h,
        ),
      ],
    );
  }

  _buildQuestionPage() {
    int index = 0;
    if (_currentIndex > 0) {
      index = _currentIndex - 1;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 9.w),
          child: Text(
            _questions![index].prompt,
            style: TextStyle(
                fontSize: 30.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 36.h,
        ),
        Expanded(
          child: SizedBox(
            width: 410.w,
            child: SingleChildScrollView(
              child: Wrap(children: [
                for (Answer answer in _questions![index].answer)
                  _buildAnswer(index, answer, _selectedAnswers.contains(answer))
              ]),
            ),
          ),
        ),
        SizedBox(
          height: 36.h,
        ),
        if (_currentIndex != 0)
          GestureDetector(
            onTap: () {
              _pageController.jumpToPage(_currentIndex);
              setState(() {
                _currentIndex--;
              });
            },
            child: Center(
              child: Text(
                "Back",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        SizedBox(
          height: 36.h,
        ),
      ],
    );
  }

  _buildAnswer(int index, Answer answer, bool isSelected) {
    // print(index);
    // print(_questions!.length);
    return GestureDetector(
      onTap: () async {
        if (index < _selectedAnswers.length) {
          // print("Remove call");
          _selectedAnswers.removeAt(index);
        }
        _selectedAnswers.insert(index, answer);
        if (index < _questions!.length - 1) {
          PageLoader.showTransparentLoader(context);
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pop(context);
          // print("Next call");
          _pageController.jumpToPage(_currentIndex);
          _currentIndex++;
        }
        setState(() {});

        if (index == _questions!.length - 1) {
          // print("Navigate call");
          PageLoader.showTransparentLoader(context);
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => SignUpPage(
                      country: _selectedCountry!,
                      region: _selectedRegion!,
                      county: _selectedCounty!)));
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: (410.w - (_questions![index].answer.length * 10.w)) / 3,
        width: (410.w - (_questions![index].answer.length * 10.w)) / 3,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected
                    ? const Color(0xFFF23A02)
                    : Colors.black.withOpacity(.2),
                width: 3.w),
            color: isSelected ? const Color(0xFFF23A02) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.w)),
        child: Text(
          answer.optionValue,
          style: TextStyle(
              fontSize: 20.sp,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  _buildStepper() {
    return SizedBox(
      height: 6.h,
      width: 410.w,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _questions!.length + 1,
          itemBuilder: (_, index) {
            // print("$index , $_currentIndex");
            return Container(
              height: 1.h,
              width: (410.w - ((_questions!.length + 1) * 10.w)) /
                  (_questions!.length + 1),
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                  color: index <= _currentIndex
                      ? const Color(0xFFF23A02)
                      : Colors.black.withOpacity(.2),
                  borderRadius: BorderRadius.circular(2.w)),
            );
          }),
    );
  }
}
