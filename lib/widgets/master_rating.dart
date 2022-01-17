import 'package:flutter/cupertino.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';

class MasterRatingBuilder extends StatefulWidget {
  MasterRatingBuilder({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _MasterRatingBuilderState createState() => _MasterRatingBuilderState();
}

class _MasterRatingBuilderState extends State<MasterRatingBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NetHandler.getMasterRating(widget.masterUid),
      builder: (context, AsyncSnapshot<MasterRating?> snap) {
        if (snap.hasData) {
          return MasterRatingBlock(
            masterRating: snap.data!,
          );
        }
        return Container(
          height: 80,
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}

class MasterRatingBlock extends StatelessWidget {
  MasterRatingBlock({
    required this.masterRating,
  });

  final MasterRating masterRating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  masterRating.reviews.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Отзывы",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  masterRating.rating.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Рейтинг",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  masterRating.customers.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Клиенты",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
