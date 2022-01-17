import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/widgets/convert_date.dart';

class UserReview extends StatelessWidget {
  UserReview({
    required this.review,
    required this.full,
  });

  final Review review;
  final bool full;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: !full
            ? MediaQuery.of(context).size.width - 60
            : MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
              ),
              child: Row(
                children: [
                  Text(
                    review.stars.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      ConvertDate(context).fromUnix(
                        review.date!,
                        'dd.MM.yy',
                      ),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 15,
                right: 15,
              ),
              child: Text(
                review.message!.isEmpty ? "Оценка без отзыва" : review.message!,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
