import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/search_service.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class SearchHunters extends StatefulWidget {
  const SearchHunters({Key? key}) : super(key: key);

  @override
  State<SearchHunters> createState() => _SearchHuntersState();
}

class _SearchHuntersState extends State<SearchHunters> {
  late TextEditingController _searchController;
  late User _user;
  bool isSearching = false;
  bool isFollowing = false;
  List<User> users = [];
  @override
  void initState() {
    _searchController = TextEditingController();
    _user = Provider.of<UserProvider>(context, listen: false).user;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _searching() async {
    setState(() {
      isSearching = true;
    });
    users = await SearchService.searchPerson(
        _user.id, _searchController.text, false);
    setState(() {
      isSearching = false;
    });
  }

  _personFollow(String followerId, int index) async {
    setState(() {
      isFollowing = true;
    });
    final res = await SearchService.personFollow(_user.id, followerId);
    if (res) {
      setState(() {
        users[index].isFollowed = true;
        isFollowing = false;
      });
    } else {
      setState(() {
        isFollowing = false;
      });
    }
  }

  _personUnfollow(String unFollowerId, int index) async {
    setState(() {
      isFollowing = true;
    });
    final res = await SearchService.personUnfollow(_user.id, unFollowerId);
    if (res) {
      setState(() {
        users[index].isFollowed = false;
        isFollowing = false;
      });
    } else {
      setState(() {
        isFollowing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            title: _buildSearchField(),
            actions: [
              IconButton(
                  iconSize: 25.h,
                  onPressed: () {
                    _searchController.clear();
                    users = [];
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Colors.white,
                  ))
            ]),
        body: isSearching
            ? ViewModels.postLoader()
            : _searchController.text.length < 3
                ? _buildMessage("Search for Hunters")
                : users.isEmpty
                    ? _buildMessage('Nothing Found')
                    : _buildSearchSuccess());
  }

  _buildSearchField() {
    return SizedBox(
      height: 40.h,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            decoration: TextDecoration.none),
        textAlignVertical: TextAlignVertical.center,
        cursorColor: AppColors.btnColor,
        keyboardType: TextInputType.text,
        onChanged: (String value) {
          if (value.length > 2) {
            _searching();
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          fillColor: Colors.transparent,
          filled: true,
          hintText: "Name or Handle",
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            color: Colors.grey[200],
            fontSize: 16.sp,
            decoration: TextDecoration.none,
          ),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.w)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.btnColor),
              borderRadius: BorderRadius.circular(5.w)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.w)),
        ),
      ),
    );
  }

  _buildSearchSuccess() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 10.h),
      itemCount: users.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Material(
            color: AppColors.secondaryColor,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 35.w, right: 15.w),
              title: Text(
                users[index].firstName + " " + users[index].lastName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: SizedBox(
                height: 60.h,
                width: 60.h,
                child: IconButton(
                    onPressed: !isFollowing
                        ? () {
                            if (!users[index].isFollowed) {
                              _personFollow(users[index].id, index);
                            } else {
                              _personUnfollow(users[index].id, index);
                            }
                          }
                        : null,
                    icon: Icon(
                      Icons.person_add_alt_rounded,
                      size: 40.h,
                      color: users[index].isFollowed
                          ? AppColors.btnColor
                          : Colors.grey[350],
                    )),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, index) {
        return Container(
          // color: Colors.grey[200],
          height: 5.h,
        );
      },
    );
  }

  _buildMessage(String message) => Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 20.sp, color: Colors.white),
        ),
      );
}
