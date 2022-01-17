import 'package:flutter/material.dart';
import 'package:master/widgets/buttons.dart';

class CategorySelector extends StatefulWidget {
  CategorySelector({
    required this.categies,
    required this.badges,
    required this.onTap,
  });

  final List<String> categies;
  final List<int> badges;
  final Function(int index) onTap;

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;

  Widget _getBadge(int index) {
    var show = false;

    widget.badges.forEach((element) {
      if (element == index) {
        show = true;
      }
    });

    if (show) {
      return Positioned(
        top: 0.0,
        right: 0.0,
        child: Icon(
          Icons.brightness_1,
          size: 8.0,
          color: Colors.red,
        ),
      );
    }

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: ListView.builder(
        padding: const EdgeInsets.only(right: 15),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Stack(
              children: [
                SmallButton(
                  label: widget.categies[index],
                  deselect: selectedIndex != index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onTap(index);
                  },
                ),
                _getBadge(index),
              ],
            ),
          );
        },
      ),
    );
  }
}
