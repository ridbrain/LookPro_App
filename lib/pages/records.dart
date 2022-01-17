import 'package:flutter/material.dart';
import 'package:master/pages/record.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/record_cell.dart';

class RecordsPage extends StatefulWidget {
  RecordsPage({
    required this.title,
    required this.records,
  });

  final String title;
  final List<Record> records;

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(widget.title),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var record = widget.records[index];
                return RecordCell(
                  record: record,
                  number: (index + 1).toString(),
                  last: (index + 1) == widget.records.length,
                  onTap: () => MainRouter.nextPage(
                    context,
                    RecordPage(record: record),
                  ),
                );
              },
              childCount: widget.records.length,
            ),
          ),
        ],
      ),
    );
  }
}
