import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/review.dart';

class UserReviewsPage extends StatefulWidget {
  UserReviewsPage({
    required this.reviews,
  });

  final List<Review> reviews;

  @override
  _UserReviewsPageState createState() => _UserReviewsPageState();
}

class _UserReviewsPageState extends State<UserReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Отзывы"),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10, right: 15),
                  child: UserReview(
                    review: widget.reviews[index],
                    full: false,
                  ),
                );
              },
              childCount: widget.reviews.length,
            ),
          ),
        ],
      ),
    );
  }
}
