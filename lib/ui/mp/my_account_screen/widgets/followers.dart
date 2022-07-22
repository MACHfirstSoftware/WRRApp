import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisconsin_app/enum/api_status.dart';
import 'package:wisconsin_app/models/county.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/models/user.dart';
import 'package:wisconsin_app/providers/county_provider.dart';
import 'package:wisconsin_app/providers/user_provider.dart';
import 'package:wisconsin_app/services/search_service.dart';
import 'package:wisconsin_app/services/user_service.dart';
import 'package:wisconsin_app/utils/common.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';
import 'package:wisconsin_app/widgets/page_loader.dart';
import 'package:wisconsin_app/widgets/snackbar.dart';
import 'package:wisconsin_app/widgets/user_card_widget.dart';
import 'package:wisconsin_app/widgets/view_models.dart';

class Followers extends StatefulWidget {
  const Followers({Key? key}) : super(key: key);

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  late ApiStatus _apiStatus;
  List<User> followers = [];
  late List<County> _counties;
  late User _user;
  String errorMessage = '';
  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _counties = Provider.of<CountyProvider>(context, listen: false).counties;
    _init();
    super.initState();
  }

  void _init() async {
    setState(() {
      _apiStatus = ApiStatus.isBusy;
    });
    final res = await UserService.getFollowers(_user.id);
    res.when(success: (List<User> users) {
      setState(() {
        _apiStatus = ApiStatus.isIdle;
        errorMessage = '';
        followers = users;
      });
    }, failure: (NetworkExceptions error) {
      setState(() {
        _apiStatus = ApiStatus.isError;
        errorMessage = NetworkExceptions.getErrorMessage(error);
        followers = [];
      });
    }, responseError: (ResponseError error) {
      setState(() {
        _apiStatus = ApiStatus.isError;
        errorMessage = error.error;
        followers = [];
      });
    });
  }

  _personFollow(int index) async {
    PageLoader.showLoader(context);
    final res = await SearchService.personFollow(
      _user.id,
      followers[index].id,
    );
    Navigator.pop(context);
    if (res) {
      setState(() {
        followers.removeAt(index);
      });
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Successfully followed",
          type: SnackBarType.success));
    } else {
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(customSnackBar(
          context: context,
          messageText: "Unable to follow",
          type: SnackBarType.error));
    }
  }

  // _personUnfollow(int index) async {
  //   PageLoader.showLoader(context);
  //   final res = await SearchService.personUnfollow(
  //     _user.id,
  //     followers[index].id,
  //   );
  //   Navigator.pop(context);
  //   if (res) {
  //     setState(() {
  //       followers[index].isFollowed = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_apiStatus == ApiStatus.isBusy) {
      return ViewModels.buildLoader();
    }
    if (_apiStatus == ApiStatus.isError) {
      return ViewModels.buildErrorWidget(errorMessage, () => _init());
    }
    if (followers.isEmpty) {
      return ViewModels.postEmply();
    }
    return ListView.separated(
        padding: EdgeInsets.only(top: 5.h),
        itemBuilder: (_, index) {
          return UserCard(
            name: followers[index].firstName + " " + followers[index].lastName,
            personCode: followers[index].code,
            county: CountyUtil.getCountyNameById(
                counties: _counties, countyId: followers[index].countyId),
            profileImageUrl: followers[index].profileImageUrl,
            onTap: () {
              // followers[index].isFollowed
              //     ? _personUnfollow(index)
              //     :
              _personFollow(index);
            },
            isFollowed: followers[index].isFollowed,
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(
            height: 5.h,
          );
        },
        itemCount: followers.length);
  }
}
