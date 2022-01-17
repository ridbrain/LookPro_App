import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';

class PlaceCell extends StatelessWidget {
  PlaceCell({
    required this.place,
    required this.onTap,
  });

  final Place place;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LineIcons.mapMarked,
                        color: Colors.blueGrey[700],
                        size: 22,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        place.address,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15),
                height: 1,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
