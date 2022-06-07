import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:wisconsin_app/models/Question.dart';
import 'package:wisconsin_app/services/questionnaire_service.dart';
import 'package:wisconsin_app/ui/landing/sign_up_page/sign_up_page.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  bool _isQuestionsGet = false;
  late List<Question>? _questions;
  int _currentIndex = 0;
  late PageController _pageController;
  List<Answer> _selectedAnswers = [];
  @override
  void initState() {
    _pageController = PageController();
    _getQuestionnaire();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _getQuestionnaire() async {
    final res = await QuestionnaireService.getQuestionnarie();
    if (res != null) {
      setState(() {
        _isQuestionsGet = true;
        _questions = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _isQuestionsGet
            ? Padding(
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
                              itemCount: _questions!.length,
                              itemBuilder: ((context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 9.w),
                                      child: Text(
                                        _questions![_currentIndex].prompt,
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
                                            for (Answer answer
                                                in _questions![_currentIndex]
                                                    .answer)
                                              _buildAnswer(
                                                  answer,
                                                  _selectedAnswers
                                                      .contains(answer))
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
                                          _pageController
                                              .jumpToPage(_currentIndex);
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
                              }))),
                    ]),
              )
            : Center(
                child: SizedBox(
                  height: 50.w,
                  width: 50.w,
                  child: const LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                      colors: [Colors.black],
                      strokeWidth: 2.0),
                ),
              ));
  }

  _buildAnswer(Answer answer, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (_currentIndex < _selectedAnswers.length) {
          _selectedAnswers.removeAt(_currentIndex);
        }
        _selectedAnswers.insert(_currentIndex, answer);
        if (_currentIndex < _questions!.length - 1) {
          _pageController.jumpToPage(_currentIndex);
          _currentIndex++;
        }
        setState(() {});

        if (_currentIndex == _questions!.length - 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const SignUpPage()));
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: (410.w - (_questions![_currentIndex].answer.length * 10.w)) / 3,
        width: (410.w - (_questions![_currentIndex].answer.length * 10.w)) / 3,
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
          itemCount: _questions!.length,
          itemBuilder: (_, index) {
            return Container(
              height: 1.h,
              width: (410.w - (_questions!.length * 10.w)) / _questions!.length,
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
