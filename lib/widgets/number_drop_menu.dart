import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';

class NumberDropMenu extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChange;
  const NumberDropMenu({
    Key? key,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        height: 40.h,
        width: 100.w,
        color: Colors.transparent,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                      fontSize: 15.sp,
                      // color: AppColors.btnColor,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.btnColor,
              ),
            ]),
      ),
      color: AppColors.popBGColor,
      itemBuilder: (context) => [
        ...[for (int i = 0; i <= 100; i++) i]
            .map((number) => PopupMenuItem<int>(
                value: number,
                child: SizedBox(
                  width: 80.w,
                  child: ListTile(
                    trailing: number == value
                        ? const Icon(
                            Icons.check,
                            color: AppColors.btnColor,
                          )
                        : null,
                    title: Text(
                      number.toString(),
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                    ),
                  ),
                )))
      ],
      onSelected: (int selection) {
        onChange(selection);
      },
    );
  }
}
