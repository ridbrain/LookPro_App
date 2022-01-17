import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';

class PriceCellRecord extends StatefulWidget {
  PriceCellRecord({
    required this.price,
    this.onTap,
  });

  final Price price;
  final Function()? onTap;

  @override
  _PriceCellRecordState createState() => _PriceCellRecordState();
}

class _PriceCellRecordState extends State<PriceCellRecord> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.price.title.trim().capitalLetter(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.price.price.toString() + " ₽",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                height: 1,
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
