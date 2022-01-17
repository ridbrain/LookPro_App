import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';

class CostCell extends StatelessWidget {
  CostCell({
    required this.cost,
    required this.group,
    required this.last,
    required this.onTap,
  });

  final Cost cost;
  final String group;
  final bool last;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
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
                    child: Icon(
                      LineIcons.minusCircle,
                      size: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        cost.description,
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
                Text(
                  "${cost.amount} ₽",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 15,
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
