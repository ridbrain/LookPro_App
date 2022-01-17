import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/workshift_cell.dart';

class AllShiftsPage extends StatefulWidget {
  AllShiftsPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _AllShiftsPageState createState() => _AllShiftsPageState();
}

class _AllShiftsPageState extends State<AllShiftsPage> {
  static final _init = ConvertDate.dayBegin();
  var _firstDay = DateTime(_init.year, _init.month - 2, 1, 0);
  var _lastDay = DateTime(_init.year, _init.month + 2, 0);

  var _today = _init;
  var _selectedDate = _init;

  List<Workshift> _shifts = [];
  bool _loading = true;

  void _updateList() async {
    setState(() {
      _loading = true;
    });

    var result = await NetHandler.getWorkshiftsCalendar(
      widget.masterUid,
      ConvertDate(context).secondsFromDate(_firstDay).toString(),
      ConvertDate(context).secondsFromDate(_lastDay).toString(),
    );

    setState(() {
      _shifts = result ?? [];
      _loading = false;
    });
  }

  Widget _getList() {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      );
    } else {
      if (_shifts.forDate(_selectedDate).isEmpty) {
        return SliverToBoxAdapter(
          child: EmptyBanner(
            description: "В этот день нет рабочих смен",
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var shift = _shifts.forDate(_selectedDate)[index];
              return WorkshiftCell(
                workshift: shift,
                onTap: () {},
                last: false,
              );
            },
            childCount: _shifts.forDate(_selectedDate).length,
          ),
        );
      }
    }
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
            title: Text(
              ConvertDate(context).fromDate(_today, "MMMM").capitalLetter(),
            ),
          ),
          SliverToBoxAdapter(
            child: CalendarPicker(
              eventLoader: _shifts.forDate,
              selectDate: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              focusDate: (date) {
                setState(() {
                  _today = date;
                });
              },
            ),
          ),
          _getList(),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}
