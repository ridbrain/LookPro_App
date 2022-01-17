import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/shimmer.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({
    required this.masterUid,
    required this.userId,
  });

  final String masterUid;
  final String userId;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            StandartAppBar(
              title: Text(
                "Оставить отзыв",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            FutureBuilder(
              future: NetHandler.getReview(widget.masterUid, widget.userId),
              builder: (contetx, AsyncSnapshot<Result?> snap) {
                if (snap.hasData) {
                  return FullReview(
                    review: snap.data?.review,
                    masterUid: widget.masterUid,
                    userId: widget.userId,
                  );
                } else {
                  return LoadingReview();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FullReview extends StatefulWidget {
  FullReview({
    this.review,
    required this.masterUid,
    required this.userId,
  });

  final Review? review;
  final String masterUid;
  final String userId;

  @override
  _FullReviewState createState() => _FullReviewState();
}

class _FullReviewState extends State<FullReview> {
  var commentController = TextEditingController();
  late Review review;

  Widget getCell(int index) {
    return Expanded(
      flex: 2,
      child: Material(
        elevation: index == review.stars ? 1 : 0,
        borderRadius: Constants.radius,
        color: index == review.stars ? Colors.white : Colors.grey[100],
        child: InkWell(
          borderRadius: Constants.radius,
          child: Center(
            child: Text(
              index.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ),
          onTap: () {
            setState(() {
              review.stars = index.toDouble();
            });
          },
        ),
      ),
    );
  }

  void saveReview() async {
    NetHandler.saveReview(
      widget.masterUid,
      widget.userId,
      commentController.text,
      review.stars.toString(),
    ).then(
      (value) => {
        StandartSnackBar.show(
          context,
          value ?? "Что-то пошло не так...",
          SnackBarStatus.message(),
        ),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.review == null) {
      review = Review(stars: 5);
    } else {
      review = widget.review!;
      commentController.text = review.message!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          GroupLabel(
            label: 'Комментарий',
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            height: 140,
            child: TextFieldWidget(
              controller: commentController,
              maxLines: 8,
            ),
          ),
          GroupLabel(
            label: 'Оценка',
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Container(
              height: 50,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: Constants.radius,
              ),
              child: Row(
                children: [
                  getCell(1),
                  SizedBox(width: 3),
                  getCell(2),
                  SizedBox(width: 3),
                  getCell(3),
                  SizedBox(width: 3),
                  getCell(4),
                  SizedBox(width: 3),
                  getCell(5),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: StandartButton(
              label: 'Сохранить',
              onTap: saveReview,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Shimmer(
                width: 150,
                height: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Shimmer(
              height: 140,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Shimmer(
                width: 80,
                height: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Shimmer(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
