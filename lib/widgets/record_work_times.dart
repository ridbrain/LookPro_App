import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/services/constants.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/time_cell.dart';

class RecordWorkTimes extends StatelessWidget {
  RecordWorkTimes({
    required this.times,
    required this.loading,
    required this.onSelect,
    required this.showAll,
    required this.selected,
    required this.all,
    this.column = 3,
  });

  final List<WorkTime> times;
  final Function(int time) onSelect;
  final Function(bool show) showAll;
  final int? selected;
  final bool all;
  final bool loading;
  final int column;

  Widget getTable(double height) {
    if (loading) {
      return Container(
        height: 100,
        child: CupertinoActivityIndicator(),
      );
    }
    if (times.isEmpty) {
      return EmptyBanner(
        description: "Времени для записи в этот день к сожалению нет",
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: ((times.length + 1) / column).round() * height,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: times.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: column,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return TimeCell(
            date: times[index],
            selected: selected == times[index].time,
            onSelect: () {
              onSelect(times[index].time);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 10;
    var height = (width / column / 2) + 10;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: Constants.radius,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Занятое время",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              CupertinoSwitch(
                value: all,
                activeColor: Colors.blueGrey,
                onChanged: showAll,
              ),
            ],
          ),
        ),
        getTable(height),
      ],
    );
  }
}
