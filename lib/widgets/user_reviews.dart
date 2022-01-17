import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/user_reviews.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/link.dart';

class UserReviews extends StatefulWidget {
  UserReviews({
    required this.masterUid,
    required this.userId,
  });

  final String masterUid;
  final String userId;

  @override
  State<UserReviews> createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews> {
  List<Review> _reviews = [];

  var _subLabel = "Загрузка...";
  var _loading = true;

  void _update() async {
    setState(() {
      _loading = true;
    });

    var result = await NetHandler.getReviews(widget.masterUid, widget.userId);

    setState(() {
      _reviews = result ?? [];
      _subLabel = _reviews.isNotEmpty ? "${_reviews.length}" : "Нет отзывов";
      _loading = false;
    });
  }

  void _onTap(BuildContext context) {
    if (_reviews.isNotEmpty) {
      MainRouter.nextPage(
        context,
        UserReviewsPage(
          reviews: _reviews,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return BigLink(
      icon: LineIcons.comments,
      label: "Отзывы",
      subLabel: _subLabel,
      loading: _loading,
      onTap: _loading ? null : () => _onTap(context),
    );
  }
}
