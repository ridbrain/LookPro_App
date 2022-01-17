import 'package:flutter/material.dart';
import 'package:master/services/constants.dart';

class StandartButton extends StatelessWidget {
  StandartButton({
    required this.label,
    required this.onTap,
    this.color = Colors.black,
  });

  final String label;
  final Function() onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: Constants.radius,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: Constants.radius,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  RoundButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Function() onTap;

  final radius = const BorderRadius.all(
    Radius.circular(40),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                  width: 2.5,
                  color: Colors.blueGrey.withOpacity(0.25),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: Colors.grey[800],
                size: 45,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(label),
        )
      ],
    );
  }
}

class GroupLabel extends StatelessWidget {
  GroupLabel({
    required this.label,
    this.link,
    this.onTap,
  });

  final String label;
  final String? link;
  final Function()? onTap;

  Widget getLink() {
    if (link != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: Constants.radius,
          ),
          child: Container(
            height: 30,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  link!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.blueGrey,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 20, 10, 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          getLink(),
        ],
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  SmallButton({
    required this.label,
    required this.onTap,
    this.deselect = false,
  });

  final String label;
  final Function() onTap;
  final bool deselect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: deselect ? Colors.white : Colors.grey.shade200,
          borderRadius: Constants.radius,
          border: Border.all(
            width: 1,
            color: Colors.grey.shade200,
          ),
        ),
        child: Material(
          borderRadius: Constants.radius,
          color: Colors.transparent,
          child: InkWell(
            borderRadius: Constants.radius,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
