import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/pages/record.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/category_selector.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/record_cell.dart';

class AllRecordsPage extends StatefulWidget {
  AllRecordsPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _AllRecordsPageState createState() => _AllRecordsPageState();
}

class _AllRecordsPageState extends State<AllRecordsPage> {
  static final _init = ConvertDate.dayBegin();
  var _firstDay = DateTime(_init.year, _init.month, 1, 0);
  var _lastDay = DateTime(_init.year, _init.month + 1, 0, 0);

  List<Record> _records = [];
  var _loading = true;
  var _index = 0;

  void _updateList() async {
    setState(() {
      _loading = true;
    });

    var result = await NetHandler.getRecordsInterval(
      widget.masterUid,
      _index == 0 ? "3" : "4",
      ConvertDate(context).secondsFromDate(_firstDay).toString(),
      ConvertDate(context).secondsFromDate(_lastDay).toString(),
    );

    setState(() {
      _records = result ?? [];
      _loading = false;
    });
  }

  Widget _getList() {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    if (_records.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyBanner(description: "Записей по таким параметрам нет"),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var record = _records[index];
          return RecordCell(
            record: record,
            number: (index + 1).toString(),
            last: (index + 1) == _records.length,
            onTap: () => MainRouter.nextPage(
              context,
              RecordPage(record: record),
            ),
          );
        },
        childCount: _records.length,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Записи"),
          ),
          SliverToBoxAdapter(
            child: CategorySelector(
              categies: [
                "Выполненные",
                "Отменённые",
              ],
              badges: [],
              onTap: (index) {
                _index = index;
                _updateList();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: IntervalSelector(
              first: _firstDay,
              last: _lastDay,
              select: (first, last) {
                _firstDay = first;
                _lastDay = last;
                _updateList();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 15,
            ),
          ),
          _getList(),
          SliverToBoxAdapter(
            child: Container(
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}
