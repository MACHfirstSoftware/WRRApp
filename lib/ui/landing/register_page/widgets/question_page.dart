import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/question.dart';
import 'package:wisconsin_app/providers/register_provider.dart';

class QuestionPage extends StatefulWidget {
  final Question question;
  const QuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(builder: (context, provider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.w),
            child: Text(
              widget.question.prompt,
              style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 36.h,
          ),
          Expanded(
            child: SizedBox(
              width: 428.w,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 9.w),
                child: Wrap(alignment: WrapAlignment.center, children: [
                  for (Answer answer in widget.question.answer)
                    _buildAnswer(widget.question.answer.length,
                        widget.question.id, answer, provider)
                ]),
              ),
            ),
          ),
        ],
      );
    });
  }

  _buildAnswer(int length, int questionId, Answer answer,
      RegisterProvider registerProvider) {
    bool _isSelected = registerProvider.selectedAnswers
        .any((element) => element["answerId"] == answer.id);
    return GestureDetector(
      onTap: () async {
        registerProvider.addAnswer({
          "personId": "",
          "questionId": questionId,
          "answerId": answer.id,
          "answerComment": ""
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: (410.w - (length * 10.w)) / length,
        width: (410.w - (length * 10.w)) / length,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        decoration: BoxDecoration(
            border: Border.all(
                color: _isSelected ? AppColors.btnColor : Colors.grey[300]!,
                width: 3.w),
            color: _isSelected ? AppColors.btnColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10.w)),
        child: Text(
          answer.optionValue,
          style: TextStyle(
              fontSize: 20.sp,
              color: _isSelected ? Colors.white : Colors.grey[300],
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
