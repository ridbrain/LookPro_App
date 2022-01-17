import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/pages/new_record.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/record_work_times.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/time_cell.dart';
import 'package:table_calendar/table_calendar.dart';

class RecordMovePage extends StatefulWidget {
  RecordMovePage({
    required this.workShifts,
    required this.masterUid,
    required this.placeId,
    required this.recordId,
    required this.length,
    required this.date,
  });

  final List<Workshift> workShifts;
  final String masterUid;
  final String placeId;
  final String recordId;
  final String length;
  final int date;

  @override
  _RecordMovePageState createState() => _RecordMovePageState();
}

class _RecordMovePageState extends State<RecordMovePage> {
  static final _today = ConvertDate.dayBegin();
  static final _firstDay = DateTime(_today.year, _today.month, _today.day - 1);
  static final _lastDay = DateTime(_today.year, _today.month + 3, _today.day);

  DateTime _focusedDay = _today;
  DateTime _selectedDay = _today;

  List<WorkTime> _workTimes = [];
  List<WorkTime> _allTimes = [];
  bool _showAllTimes = false;
  bool _loadingTimes = true;
  int? _selectedTime;
  Timer? _timer;

  var _succes = false;
  var _loading = false;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _updateTimes();
    }
  }

  void _updateTimes() async {
    setState(() {
      _workTimes = [];
      _allTimes = [];
      _loadingTimes = true;
    });

    widget.workShifts.forDate(_selectedDay).forEach((element) async {
      var free = await NetHandler.getWorkTimes(
        widget.masterUid,
        element.workshiftId.toString(),
        widget.length,
      );

      free?.forEach((time) {
        _workTimes.add(WorkTime(time, true));
        _allTimes.add(WorkTime(time, true));
      });

      var busy = await NetHandler.getDontWorkTimes(
        widget.masterUid,
        element.workshiftId.toString(),
        widget.length,
      );

      busy?.forEach((time) {
        _allTimes.add(WorkTime(time, false));
      });

      setState(() {
        _workTimes.sort((a, b) => a.time.compareTo(b.time));
        _allTimes.sort((a, b) => a.time.compareTo(b.time));
        _loadingTimes = false;
      });
    });

    if (widget.workShifts.forDate(_selectedDay).isEmpty) {
      setState(() {
        _loadingTimes = false;
      });
    }
  }

  void _setToday() {
    setState(() {
      _selectedDay = ConvertDate.dayBeginFrom(widget.date);
      _focusedDay = ConvertDate.dayBeginFrom(widget.date);
    });
  }

  Widget _getSuccess() {
    if (!_loading && _succes) {
      _back();
      return Container(
        width: 150,
        height: 150,
        margin: const EdgeInsets.only(bottom: 100),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.8),
          borderRadius: Constants.radius,
        ),
        child: RecordDone(),
      );
    } else {
      return Container();
    }
  }

  Widget _getAddButton() {
    if (_loading && _succes) {
      return Container(
        height: 45,
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    if (_succes) {
      return Container();
    }
    return StandartButton(
      label: "Перенести запись",
      onTap: _saveTime,
    );
  }

  void _saveTime() {
    if (_selectedTime == null) {
      StandartSnackBar.show(
        context,
        "Выберите время",
        SnackBarStatus.warning(),
      );
      return;
    }

    for (var item in _workTimes) {
      if (item.time == _selectedTime) {
        _saveRecord(1);
        return;
      }
    }

    MainRouter.openBottomSheet(
      context: context,
      height: 220,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            child: Text(
              "Вы выбрали время которое занято другой записью. Вы уверенны, что хотите создать несколько записей на одно время?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          StandartButton(
            label: "Да",
            onTap: () {
              Navigator.pop(context);
              _saveRecord(0);
            },
          )
        ],
      ),
    );
  }

  void _saveRecord(int free) async {
    setState(() {
      _loading = true;
      _succes = true;
    });

    var result = await NetHandler.changeRecordTime(
      widget.masterUid,
      widget.recordId,
      _selectedTime!.toString(),
      widget.length,
      free,
    );

    setState(() {
      _loading = false;
      _succes = true;
    });

    if (result?.error == 0) {
      setState(() {
        _loading = false;
        _succes = true;
      });
    } else {
      StandartSnackBar.show(
        context,
        result?.message ?? "Ошибка",
        SnackBarStatus.warning(),
      );

      setState(() {
        _loading = false;
        _succes = false;
      });
    }
  }

  void _back() {
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
    _setToday();
    _updateTimes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              StandartAppBar(
                title: Text(
                  ConvertDate(context)
                      .fromDate(_focusedDay, "MMMM")
                      .capitalLetter(),
                ),
              ),
              SliverToBoxAdapter(
                child: TableCalendar<Workshift>(
                  locale: "ru",
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  headerVisible: false,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.twoWeeks,
                  eventLoader: widget.workShifts.forDate,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: _onDaySelected,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, items) {
                      if (items.isNotEmpty) {
                        return Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                        );
                      }
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    todayTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                  ),
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  height: 1,
                  color: Colors.grey[200],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RecordWorkTimes(
                    times: _showAllTimes ? _allTimes : _workTimes,
                    loading: _loadingTimes,
                    all: _showAllTimes,
                    showAll: (value) {
                      setState(() {
                        _showAllTimes = value;
                      });
                    },
                    selected: _selectedTime,
                    column: 4,
                    onSelect: (time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                ),
              ),
            ],
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            child: _getAddButton(),
          ),
          Center(
            child: _getSuccess(),
          ),
        ],
      ),
    );
  }
}
