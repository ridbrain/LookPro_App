import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';
import 'package:master/widgets/shimmer.dart';

import 'convert_date.dart';

class RecordCell extends StatelessWidget {
  RecordCell({
    required this.record,
    required this.number,
    required this.last,
    required this.onTap,
  });

  final Record record;
  final String number;
  final bool last;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ConvertDate(context).fromUnix(
                        record.start,
                        "HH:mm",
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      ConvertDate(context).fromUnix(
                        record.end,
                        "HH:mm",
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.name.capitalLetter(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        record.prices.getString().capitalLetter(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 70),
              height: last ? 0 : 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class LoadingRecordCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          child: Shimmer(
            width: 40,
            height: 40,
          ),
        ),
        Column(
          children: [
            Shimmer(
              width: 50,
              height: 15,
            ),
            SizedBox(
              height: 4,
            ),
            Shimmer(
              width: 50,
              height: 15,
            ),
          ],
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer(
              width: 70,
              height: 15,
            ),
            SizedBox(
              height: 4,
            ),
            Shimmer(
              width: 150,
              height: 15,
            ),
          ],
        ),
      ],
    );
  }
}
