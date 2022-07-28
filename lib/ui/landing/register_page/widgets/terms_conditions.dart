// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wisconsin_app/config.dart';

// class TermsConditions extends StatelessWidget {
//   const TermsConditions({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Material(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(10.w),
//           child: GestureDetector(
//             onTap: (() => Navigator.pop(context)),
//             child: Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.symmetric(horizontal: 10.w),
//               padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 20.h),
//               decoration: BoxDecoration(
//                   color: AppColors.popBGColor,
//                   borderRadius: BorderRadius.circular(10.w)),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     // color: Colors.blue,
//                     height: 50.h,
//                     width: 400.w,
//                     child: Stack(
//                       children: [
//                         IconButton(
//                             iconSize: 25.h,
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(
//                               Icons.close_rounded,
//                               color: Colors.white,
//                             )),
//                         Align(
//                           alignment: Alignment.center,
//                           child: SizedBox(
//                               // color: Colors.amber,
//                               width: 250.w,
//                               height: 25.h,
//                               child: FittedBox(
//                                   fit: BoxFit.scaleDown,
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     "Terms & Conditions",
//                                     style: TextStyle(
//                                         fontSize: 18.sp,
//                                         color: AppColors.btnColor,
//                                         fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.center,
//                                   ))),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 400.h,
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: Text(
//                           "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
//                           style:
//                               TextStyle(color: Colors.grey, fontSize: 14.sp)),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
