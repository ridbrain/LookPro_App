import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class EmptyBanner extends StatelessWidget {
  EmptyBanner({
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Icon(
            LineIcons.infinity,
            color: Colors.blueGrey[800],
            size: 100,
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
