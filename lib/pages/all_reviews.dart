import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/review.dart';

class AllReviewsPage extends StatefulWidget {
  AllReviewsPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _AllReviewsPageState createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  List<Review> _list = [];
  bool _loading = true;

  void _updateList() async {
    setState(() {
      _loading = true;
    });

    var result = await NetHandler.getMasterReviews(widget.masterUid);

    setState(() {
      _list = result ?? [];
      _loading = false;
    });
  }

  Widget _getList() {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      );
    } else {
      if (_list.isEmpty) {
        return SliverToBoxAdapter(
          child: EmptyBanner(
            description: "Отзывов ещё нет",
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, right: 15),
                child: UserReview(
                  review: _list[index],
                  full: false,
                ),
              );
            },
            childCount: _list.length,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Отзывы"),
          ),
          _getList(),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}
