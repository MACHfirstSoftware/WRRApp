// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:wisconsin_app/config.dart';
// import 'package:wisconsin_app/models/user.dart';
// import 'package:wisconsin_app/providers/user_provider.dart';
// import 'package:wisconsin_app/services/search_service.dart';
// import 'package:wisconsin_app/widgets/view_models.dart';

// class SearchHunters2 extends SearchDelegate {
//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     return ThemeData(
//       primarySwatch: const MaterialColor(0xFFF23A02, <int, Color>{
//         50: Color(0xFFF23A02),
//         100: Color(0xFFF23A02),
//         200: Color(0xFFF23A02),
//         300: Color(0xFFF23A02),
//         400: Color(0xFFF23A02),
//         500: Color(0xFFF23A02),
//         600: Color(0xFFF23A02),
//         700: Color(0xFFF23A02),
//         800: Color(0xFFF23A02),
//         900: Color(0xFFF23A02),
//       }),
//       brightness: Brightness.dark,
//     );
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//           onPressed: () {
//             query = '';
//           },
//           icon: const Icon(Icons.clear_rounded))
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow,
//           progress: transitionAnimation,
//         ));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     User _user = Provider.of<UserProvider>(context).user;
//     if (query.isEmpty) {
//       return const Center();
//     }
//     return FutureBuilder<List<User>>(
//       future: SearchService.searchPerson(_user.id, query, false),
//       builder: (context, snapshot) {
//         if (query.isEmpty) return buildNoSuggestions();

//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return ViewModels.postLoader();
//           default:
//             if (snapshot.hasError || snapshot.data!.isEmpty) {
//               return buildNoSuggestions();
//             } else {
//               return buildSuggestionsSuccess(snapshot.data!, _user.id);
//             }
//         }
//       },
//     );
//   }

//   Widget buildNoSuggestions() => Center(
//         child: Text(
//           'Nothing Found',
//           style: TextStyle(fontSize: 20.sp, color: Colors.white),
//         ),
//       );

//   buildSuggestionsSuccess(List<User> users, String personId) {
//     return ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (_, index) {
//           return ListTile(
//             title: Text(users[index].firstName + " " + users[index].lastName),
//             trailing: SizedBox(
//               height: 60.h,
//               width: 60.h,
//               child: IconButton(
//                   onPressed: () {
//                     _personFollow(personId, users[index].id, index, users);
//                   },
//                   icon: Icon(
//                     Icons.person_add_alt_rounded,
//                     size: 40.h,
//                     color: users[index].isFallowed
//                         ? AppColors.btnColor
//                         : Colors.grey[350],
//                   )),
//             ),
//           );
//         });
//   }

//   _personFollow(
//       String personId, String followerId, int index, List<User> users) async {
//     final res = await SearchService.personFollow(personId, followerId);
//     if (res) {
//       users[index].isFallowed = res;
//     }
//   }
// }
