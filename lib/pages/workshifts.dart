import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/place_selector.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';

class EditWorkshift extends StatefulWidget {
  EditWorkshift({
    required this.masterUid,
    required this.workshift,
    required this.update,
  });

  final String masterUid;
  final Workshift workshift;
  final Function() update;

  @override
  _EditWorkshiftState createState() => _EditWorkshiftState();
}

class _EditWorkshiftState extends State<EditWorkshift> {
  var _startController = TextEditingController();
  var _endController = TextEditingController();

  var _start = 0;
  var _end = 0;

  DateTime _date() {
    var date = ConvertDate.dateFromSeconds(_start);
    return date.add(Duration(hours: -date.hour, minutes: -date.minute));
  }

  void _setStart(int hours, int minutes) {
    var date = _date().add(
      Duration(hours: hours, minutes: minutes),
    );

    setState(() {
      _start = ConvertDate(context).secondsFromDate(date);
    });
  }

  void _setEnd(int hours, int minutes) {
    var date = _date().add(
      Duration(hours: hours, minutes: minutes),
    );

    setState(() {
      _end = ConvertDate(context).secondsFromDate(date);
    });
  }

  @override
  void initState() {
    super.initState();
    _start = widget.workshift.start;
    _end = widget.workshift.end;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (_start > _end) {
      _end = _start;
    }
  }

  @override
  Widget build(BuildContext context) {
    _startController.text = ConvertDate(context).fromUnix(
      _start,
      "HH:mm",
    );
    _endController.text = ConvertDate(context).fromUnix(
      _end,
      "HH:mm",
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Text(
              "Изменить смену ${ConvertDate(context).fromUnix(widget.workshift.start, 'dd MMMM')}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    hint: "Начало",
                    icon: LineIcons.clock,
                    readOnly: true,
                    controller: _startController,
                    onTap: () {
                      TimePicker(
                        context: context,
                        date: ConvertDate.dateFromSeconds(_start),
                        onConfirm: _setStart,
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text("-"),
                ),
                Expanded(
                  child: TextFieldWidget(
                    hint: "Конец",
                    icon: LineIcons.clock,
                    readOnly: true,
                    controller: _endController,
                    onTap: () {
                      TimePicker(
                        context: context,
                        date: ConvertDate.dateFromSeconds(_end),
                        onConfirm: _setEnd,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 20),
            child: StandartButton(
              label: "Сохранить",
              onTap: () {
                NetHandler.editWorkshift(
                  widget.masterUid,
                  widget.workshift.workshiftId.toString(),
                  _start.toString(),
                  _end.toString(),
                ).then(
                  (value) {
                    widget.update();
                    Navigator.pop(context);
                    StandartSnackBar.show(
                      context,
                      value!,
                      SnackBarStatus.success(),
                    );
                  },
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 25),
            child: StandartButton(
              label: "Удалить",
              color: Colors.red[700],
              onTap: () {
                NetHandler.deleteWorkshift(
                  widget.masterUid,
                  widget.workshift.workshiftId.toString(),
                ).then(
                  (value) {
                    widget.update();
                    Navigator.pop(context);
                    StandartSnackBar.show(
                      context,
                      value!,
                      SnackBarStatus.success(),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class AddWorkshift extends StatefulWidget {
  AddWorkshift({
    required this.masterUid,
    required this.start,
    required this.update,
  });

  final String masterUid;
  final DateTime start;
  final Function() update;

  @override
  _AddWorkshiftState createState() => _AddWorkshiftState();
}

class _AddWorkshiftState extends State<AddWorkshift> {
  var _startController = TextEditingController();
  var _endController = TextEditingController();

  var _placeId = 0;
  var _start = 0;
  var _end = 0;

  void initShift() async {
    var prefs = await PrefsHandler.getInstance();
    var shift = prefs.getStandartShift();

    var start = widget.start.add(Duration(seconds: shift.start));
    var end = widget.start.add(Duration(seconds: shift.end));

    setState(() {
      _start = ConvertDate(context).secondsFromDate(start);
      _end = ConvertDate(context).secondsFromDate(end);
    });
  }

  @override
  void initState() {
    super.initState();
    initShift();
  }

  void _saveWork() async {
    if (_placeId == 0) {
      StandartSnackBar.show(
        context,
        "Укажите рабочий адрес",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_start == 0) {
      StandartSnackBar.show(
        context,
        "Укажите начало смены",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_start >= _end) {
      StandartSnackBar.show(
        context,
        "Конец смены не может быть раньше или равен началу",
        SnackBarStatus.warning(),
      );
      return;
    }

    var result = await NetHandler.addWorkshift(
      widget.masterUid,
      _placeId.toString(),
      _start.toString(),
      _end.toString(),
    );

    if (result?.error == 0) {
      StandartSnackBar.show(
        context,
        result?.message ?? "Успешно",
        SnackBarStatus.success(),
      );
    } else {
      StandartSnackBar.show(
        context,
        result?.message ?? "Ошибка",
        SnackBarStatus.warning(),
      );
    }

    widget.update();
    Navigator.pop(context);
  }

  void _setStart(int hours, int minutes) {
    var date = widget.start.add(
      Duration(hours: hours, minutes: minutes),
    );

    setState(() {
      _start = ConvertDate(context).secondsFromDate(date);
    });
  }

  void _setEnd(int hours, int minutes) {
    var date = widget.start.add(
      Duration(hours: hours, minutes: minutes),
    );

    setState(() {
      _end = ConvertDate(context).secondsFromDate(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_start > _end) {
      _end = _start;
    }

    _startController.text = ConvertDate(context).fromUnix(
      _start,
      "HH:mm",
    );
    _endController.text = ConvertDate(context).fromUnix(
      _end,
      "HH:mm",
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Text(
              "Добавить смену ${ConvertDate(context).fromDate(widget.start, 'dd MMMM')}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: PlaceSelector(
              masterUid: widget.masterUid,
              select: (place) {
                _placeId = place.placeId;
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    hint: "Начало",
                    icon: LineIcons.clock,
                    readOnly: true,
                    controller: _startController,
                    onTap: () {
                      TimePicker(
                        context: context,
                        date: ConvertDate.dateFromSeconds(_start),
                        onConfirm: _setStart,
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text("-"),
                ),
                Expanded(
                  child: TextFieldWidget(
                    hint: "Конец",
                    icon: LineIcons.clock,
                    readOnly: true,
                    controller: _endController,
                    onTap: () {
                      TimePicker(
                        context: context,
                        date: ConvertDate.dateFromSeconds(_end),
                        onConfirm: _setEnd,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 25),
            child: StandartButton(
              label: "Добавить",
              onTap: _saveWork,
            ),
          ),
        ),
      ],
    );
  }
}
