import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';

class PriceCell extends StatelessWidget {
  PriceCell({
    required this.price,
    required this.last,
    this.onTap,
    this.delete,
    this.padding = 15,
  });

  final Price price;
  final Function()? onTap;
  final Function(DismissDirection direction)? delete;
  final bool last;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction:
          delete != null ? DismissDirection.endToStart : DismissDirection.none,
      onDismissed: delete,
      background: Container(
        child: Container(
          padding: EdgeInsets.only(right: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.red,
          ),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              padding,
                              10,
                              padding,
                              0,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              price.title.trim().capitalLetter(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              padding,
                              5,
                              padding,
                              10,
                            ),
                            child: Text(
                              "Длительность ${price.time.getTime()}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(right: padding),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          price.price.toString() + " ₽",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  height: last ? 0 : 1,
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
