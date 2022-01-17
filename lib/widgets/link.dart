import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StandartLink extends StatelessWidget {
  StandartLink({
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final Function() onTap;

  Widget _getIcon() {
    if (icon == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Icon(
        icon,
        size: 20,
        color: Colors.blueGrey[600],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                _getIcon(),
                Expanded(
                  child: Text(
                    label,
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
    );
  }
}

class BigLink extends StatelessWidget {
  BigLink({
    required this.icon,
    required this.label,
    required this.subLabel,
    this.loading,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subLabel;
  final bool? loading;
  final Function()? onTap;

  Widget _getLoading() {
    if (loading == null) {
      return SizedBox.shrink();
    }
    if (loading!) {
      return CupertinoActivityIndicator();
    } else {
      return Icon(Icons.arrow_forward_ios);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        subLabel,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSizeAndFade(
                  child: _getLoading(),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          margin: const EdgeInsets.only(left: 15),
          color: Colors.black.withOpacity(0.1),
        ),
      ],
    );
  }
}
