import 'package:flutter/material.dart';
import 'package:master/pages/record.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/record_cell.dart';

class UserRecords extends StatefulWidget {
  UserRecords({
    required this.records,
  });

  final List<Record> records;

  @override
  _UserRecordsState createState() => _UserRecordsState();
}

class _UserRecordsState extends State<UserRecords> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return RecordCell(
            record: widget.records[index],
            number: (index + 1).toString(),
            last: false,
            onTap: () {
              MainRouter.nextPage(
                context,
                RecordPage(record: widget.records[index]),
              );
            },
          );
        },
        childCount: widget.records.length,
      ),
    );
  }
}
