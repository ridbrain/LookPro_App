import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/widgets/convert_date.dart';

class WorkshiftCell extends StatelessWidget {
  WorkshiftCell({
    required this.workshift,
    required this.onTap,
    required this.last,
  });

  final Workshift workshift;
  final bool last;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ConvertDate(context).fromUnix(
                          workshift.start,
                          "HH:mm - ",
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ConvertDate(context).fromUnix(
                          workshift.end,
                          "HH:mm",
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    child: Text(
                      workshift.address,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
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
