import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/new_record.dart';
import 'package:master/pages/record.dart';
import 'package:master/pages/workshifts.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/category_selector.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/record_cell.dart';
import 'package:master/widgets/workshift_cell.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static final _today = ConvertDate.dayBegin();
  static final _firstDay = DateTime(_today.year, _today.month, _today.day - 1);
  static final _lastDay = DateTime(_today.year, _today.month + 3, _today.day);
  late PageController _controller;

  DateTime _focusedDay = _today;
  DateTime _selectedDay = _today;

  List<Workshift> workshifts = [];
  List<Record> records = [];
  bool loading = true;

  int _index = 0;
  String addRecord = "Добавить запись";
  String addShift = "Добавить смену";

  void _reviewRequest() async {
    if (records.forDate(_selectedDay).length > 2) {
      PrefsHandler.getInstance().then((prefs) async {
        if (prefs.getReviewStatus()) {
          final InAppReview inAppReview = InAppReview.instance;
          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
            prefs.setReviewRequest();
          }
        }
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    var select = selectedDay.toLocal().add(
          Duration(
            hours: -selectedDay.toLocal().hour,
            minutes: -selectedDay.toLocal().minute,
          ),
        );
    var focused = focusedDay.toLocal().add(
          Duration(
            hours: -focusedDay.toLocal().hour,
            minutes: -focusedDay.toLocal().minute,
          ),
        );

    if (!isSameDay(_selectedDay, select)) {
      setState(() {
        _selectedDay = select;
        _focusedDay = focused;
      });
    }

    _reviewRequest();
  }

  Future _updateRecords() async {
    setState(() {
      loading = true;
    });

    var value = await NetHandler.getRecords(widget.masterUid, '1');
    var shifts = await NetHandler.getWorkshifts(widget.masterUid);

    setState(() {
      workshifts = shifts ?? [];
      records = value ?? [];
      loading = false;
    });
  }

  Future _updateShifts() async {
    setState(() {
      loading = true;
    });

    var shifts = await NetHandler.getWorkshifts(widget.masterUid);

    setState(() {
      workshifts = shifts ?? [];
      loading = false;
    });

    _beforeAddRecord();
  }

  void _setListener() {
    FirebaseMessaging.onMessage.listen((message) => _updateRecords());
  }

  Widget _getList() {
    if (loading) {
      return SliverToBoxAdapter(
        child: Column(
          children: [
            LoadingRecordCell(),
            LoadingRecordCell(),
            LoadingRecordCell(),
          ],
        ),
      );
    } else {
      if (_index == 0) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var record = records.forDate(_selectedDay)[index];
              return RecordCell(
                record: record,
                number: (index + 1).toString(),
                last: (index + 1) == records.forDate(_selectedDay).length,
                onTap: () => MainRouter.nextPage(
                  context,
                  RecordPage(record: record),
                ).then(
                  (value) => _updateRecords(),
                ),
              );
            },
            childCount: records.forDate(_selectedDay).length,
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var workshift = workshifts.forDate(_selectedDay)[index];
              return WorkshiftCell(
                workshift: workshift,
                last: (index + 1) == workshifts.forDate(_selectedDay).length,
                onTap: () => MainRouter.openBottomSheet(
                  context: context,
                  child: EditWorkshift(
                    masterUid: widget.masterUid,
                    workshift: workshift,
                    update: _updateRecords,
                  ),
                ),
              );
            },
            childCount: workshifts.forDate(_selectedDay).length,
          ),
        );
      }
    }
  }

  Widget _getBanner() {
    if (!loading) {
      if (_index == 0) {
        if (records.forDate(_selectedDay).length == 0) {
          return SliverToBoxAdapter(
            child: Column(
              children: [
                EmptyBanner(
                  description: "Записей в этот день нет",
                ),
              ],
            ),
          );
        }
      } else {
        if (workshifts.forDate(_selectedDay).length == 0) {
          return SliverToBoxAdapter(
            child: Column(
              children: [
                EmptyBanner(
                  description: "Смен в этот день нет",
                ),
              ],
            ),
          );
        }
      }
    }
    return SliverToBoxAdapter(
      child: Container(
        height: 70,
      ),
    );
  }

  void _newRecord(Workshift workShift) {
    MainRouter.nextPage(
      context,
      NewRecord(
        workShift: workShift,
        masterUid: widget.masterUid,
      ),
    ).then(
      (value) => _updateRecords(),
    );
  }

  void _beforeAddRecord() {
    var shifts = workshifts.forDate(_selectedDay);

    if (shifts.length == 1) {
      _newRecord(shifts.first);
    } else if (shifts.length > 1) {
      MainRouter.openBottomSheet(
        context: context,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Выберите рабочую смену",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var workshift = shifts[index];
                  return WorkshiftCell(
                    workshift: workshift,
                    last: (index + 1) == shifts.length,
                    onTap: () => _newRecord(workshift),
                  );
                },
                childCount: workshifts.forDate(_selectedDay).length,
              ),
            ),
          ],
        ),
      );
    } else {
      MainRouter.openBottomSheet(
        context: context,
        height: MediaQuery.of(context).padding.bottom + 190,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "В этот день отсутствует рабочая смена.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            StandartButton(
              label: "Добавить смену",
              onTap: () => MainRouter.openBottomSheet(
                context: context,
                child: AddWorkshift(
                  masterUid: widget.masterUid,
                  start: _selectedDay.toLocal(),
                  update: _updateShifts,
                ),
              ).then((value) {
                Navigator.pop(context);
              }),
            ),
          ],
        ),
      );
    }
  }

  void _addButton() {
    if (_index == 0) {
      _beforeAddRecord();
    } else {
      MainRouter.openBottomSheet(
        context: context,
        child: AddWorkshift(
          masterUid: widget.masterUid,
          start: _selectedDay.toLocal(),
          update: _updateRecords,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _updateRecords();
    _setListener();
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
              CupertinoSliverRefreshControl(
                refreshTriggerPullDistance: 120.0,
                refreshIndicatorExtent: 50.0,
                onRefresh: _updateRecords,
              ),
              SliverToBoxAdapter(
                child: CategorySelector(
                  onTap: (index) => setState(() {
                    _index = index;
                  }),
                  badges: [],
                  categies: [
                    "Записи",
                    "Рабочие смены",
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: TableCalendar<Object>(
                    locale: "ru",
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    headerVisible: false,
                    onCalendarCreated: (controller) {
                      _controller = controller;
                    },
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: CalendarFormat.twoWeeks,
                    eventLoader:
                        _index == 0 ? records.forDate : workshifts.forDate,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: _onDaySelected,
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, items) {
                        if (date.day == _selectedDay.day) {
                          return Container();
                        }
                        if (_index == 1 && items.isNotEmpty) {
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
                      markerSize: 7,
                      markersMaxCount: 3,
                      markerMargin: const EdgeInsets.all(0.8),
                      markerDecoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
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
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: Constants.radius,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(LineIcons.arrowCircleLeft),
                        onPressed: () => _controller.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            ConvertDate(context)
                                .fromDate(_selectedDay, "EEEE, d MMMM")
                                .capitalLetter(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(LineIcons.arrowCircleRight),
                        onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _getList(),
              _getBanner(),
              SliverToBoxAdapter(
                child: Container(
                  height: 75,
                ),
              ),
            ],
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: 15,
            child: StandartButton(
              label: _index == 0 ? addRecord : addShift,
              onTap: _addButton,
            ),
          ),
        ],
      ),
    );
  }
}
