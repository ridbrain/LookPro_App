import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/network.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/shimmer.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';

class ShiftSettingsPage extends StatefulWidget {
  ShiftSettingsPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _ShiftSettingsPageState createState() => _ShiftSettingsPageState();
}

class _ShiftSettingsPageState extends State<ShiftSettingsPage> {
  var _timeController = TextEditingController();
  var _fixShift = false;
  var _loading = true;
  var _saving = false;

  var _standartShift = false;
  var _startController = TextEditingController();
  var _endController = TextEditingController();

  var _date = ConvertDate.dayBegin();
  var _start = 0;
  var _end = 0;

  void _update() async {
    var interval = await NetHandler.getShiftInterval(widget.masterUid);
    if (interval == null) return;

    setState(() {
      if (interval == 0) {
        _fixShift = false;
      } else {
        _fixShift = true;
        _timeController.text = interval.toString();
      }

      _loading = false;
      _saving = false;
    });
  }

  void _save() async {
    if (_saving) return;

    if (_fixShift && _timeController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Укажите интервал",
        SnackBarStatus.warning(),
      );
      return;
    }

    if (_fixShift && int.parse(_timeController.text) < 5) {
      StandartSnackBar.show(
        context,
        "Укажите интервал не менее 5 минут",
        SnackBarStatus.warning(),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    var prefs = await PrefsHandler.getInstance();
    var time = _date.millisecondsSinceEpoch ~/ 1000;

    if (_standartShift) {
      prefs.setStandartShift(_start - time, _end - time);
    } else {
      prefs.setStandartShift(0, 0);
    }

    var answer = await NetHandler.saveShiftInterval(
      widget.masterUid,
      _fixShift ? _timeController.text : "0",
    );

    setState(() {
      _saving = false;
    });

    if (answer == null) {
      StandartSnackBar.show(
        context,
        "Произошла ошибка",
        SnackBarStatus.success(),
      );
    }

    StandartSnackBar.show(
      context,
      "Настройки сохранены",
      SnackBarStatus.success(),
    );
  }

  Widget _getStandartShift() {
    if (_loading) {
      return Container(
        child: Shimmer(
          height: 50,
        ),
      );
    } else {
      return Column(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: Constants.radius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Стандартная смена",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                CupertinoSwitch(
                  value: _standartShift,
                  activeColor: Colors.blueGrey,
                  onChanged: (onChanged) {
                    setState(() {
                      _standartShift = onChanged;
                    });
                  },
                ),
              ],
            ),
          ),
          AnimatedSizeAndFade(
            child: _standartShift
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
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
                  )
                : Container(),
          )
        ],
      );
    }
  }

  Widget _getInterval() {
    if (_loading) {
      return Container(
        child: Shimmer(
          height: 50,
        ),
      );
    } else {
      return Column(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: Constants.radius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Свой интервал",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                CupertinoSwitch(
                  value: _fixShift,
                  activeColor: Colors.blueGrey,
                  onChanged: (onChanged) {
                    setState(() {
                      _fixShift = onChanged;
                    });
                  },
                ),
              ],
            ),
          ),
          AnimatedSizeAndFade(
            child: _fixShift
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextFieldWidget(
                      hint: "Укажите интервал в минутах",
                      icon: Icons.lock_clock,
                      type: TextInputType.number,
                      controller: _timeController,
                    ),
                  )
                : Container(),
          )
        ],
      );
    }
  }

  void _setStart(int hours, int minutes) {
    var date = _date.add(
      Duration(hours: hours, minutes: minutes),
    );

    setState(() {
      _start = ConvertDate(context).secondsFromDate(date);
    });
  }

  void _setEnd(int hours, int minutes) {
    var date = _date.add(
      Duration(hours: hours, minutes: minutes),
    );

    setState(() {
      _end = ConvertDate(context).secondsFromDate(date);
    });
  }

  void _setStandartShift() async {
    var prefs = await PrefsHandler.getInstance();
    var shift = prefs.getStandartShift();

    if (shift.start != 0 || shift.end != 0) {
      var start = _date.add(Duration(seconds: shift.start));
      var end = _date.add(Duration(seconds: shift.end));

      setState(() {
        _standartShift = true;
        _start = ConvertDate(context).secondsFromDate(start);
        _end = ConvertDate(context).secondsFromDate(end);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _update();
    _setStandartShift();
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            StandartAppBar(
              title: Text("Настройки смен"),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: _getStandartShift(),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  "Для быстрого создания смен укажите стандартные значения времени начала и завершения смены.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: _getInterval(),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  "Стандартный интервал предлагаемых окон записи 15 минут. Вы можете указать свой в зависимости от Вашей специфики работы.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSizeAndFade(
                child: !_saving
                    ? StandartButton(
                        label: "Сохранить",
                        onTap: _save,
                      )
                    : Container(
                        child: CupertinoActivityIndicator(),
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
