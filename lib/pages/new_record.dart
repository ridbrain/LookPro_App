import 'dart:async';
import 'dart:convert';

import 'package:animated_check/animated_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/contacts.dart';
import 'package:master/pages/record.dart';
import 'package:master/pages/record_price.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/formater.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/price_cell.dart';
import 'package:master/widgets/record_work_times.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';
import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:master/widgets/time_cell.dart';

class NewRecord extends StatefulWidget {
  NewRecord({
    required this.workShift,
    required this.masterUid,
  });

  final Workshift workShift;
  final String masterUid;

  @override
  _NewRecordState createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();

  var _succes = false;
  var _loading = false;

  var _index = 0;
  var _loadingTimes = true;
  var _firstSubTitle = "Укажите клиента";
  var _secondSubTitle = "Выберите услуги";
  var _thirdSubTitle = "Выберите время";
  var _placeSubTitle = "Обновление";

  var _titleStyle = const TextStyle(fontSize: 17);
  var _subTitleStyle = const TextStyle(fontSize: 15);

  List<Price> _selectedPrices = [];
  List<WorkTime> _workTimes = [];
  List<WorkTime> _allTimes = [];
  bool _showAllTimes = false;
  int? _selectedTime;
  Place? _selectedPlace;
  Timer? _timer;

  void _selectCustomer() async {
    FocusScope.of(context).unfocus();

    var user = await MainRouter.nextPage(
      context,
      ContactsPage(
        masterUid: widget.masterUid,
      ),
    ) as Customer?;

    if (user == null) return;

    setState(() {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
    });
  }

  void _addPrices() async {
    FocusScope.of(context).unfocus();
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RecordPricesPage(
            masterUid: widget.masterUid,
            count: _selectedPrices.length,
          );
        },
      ),
    ) as List<Price>;
    setState(() {
      for (var item in result) {
        _selectedPrices.add(item);
      }
    });

    _updateTimes();
  }

  void _updateTimes() async {
    setState(() {
      _workTimes = [];
      _allTimes = [];
      _loadingTimes = true;
    });

    var free = await NetHandler.getWorkTimes(
      widget.masterUid,
      widget.workShift.workshiftId.toString(),
      _selectedPrices.getLength().toString(),
    );

    free?.forEach((time) {
      _workTimes.add(WorkTime(time, true));
      _allTimes.add(WorkTime(time, true));
    });

    var busy = await NetHandler.getDontWorkTimes(
      widget.masterUid,
      widget.workShift.workshiftId.toString(),
      _selectedPrices.getLength().toString(),
    );

    busy?.forEach((time) {
      _allTimes.add(WorkTime(time, false));
    });

    setState(() {
      _workTimes.sort((a, b) => a.time.compareTo(b.time));
      _allTimes.sort((a, b) => a.time.compareTo(b.time));
      _loadingTimes = false;
    });
  }

  Widget _customer() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              child: TextFieldWidget(
                hint: "Имя",
                icon: LineIcons.user,
                controller: _nameController,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: _selectCustomer,
                borderRadius: Constants.radius,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueGrey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Stack(
          children: [
            Container(
              child: TextFieldWidget(
                hint: "Телефон",
                type: TextInputType.number,
                icon: LineIcons.phone,
                controller: _phoneController,
                formatter: [
                  MaskTextInputFormatter("+_ (___) ___-__-__"),
                  LengthLimitingTextInputFormatter(18),
                ],
                onTap: () {
                  if (_phoneController.text.length < 4) {
                    _phoneController.text = "+7 (";
                  }
                },
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: _openPhoneInfo,
                borderRadius: Constants.radius,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blueGrey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        StandartButton(
          label: "Далее",
          onTap: () {
            setState(() {
              _index++;
            });
          },
        ),
      ],
    );
  }

  Widget _prices() {
    return Column(
      children: [
        Container(
          height: _selectedPrices.length * 61,
          child: ListView.builder(
            itemCount: _selectedPrices.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var price = _selectedPrices[index];
              return PriceCell(
                price: price,
                padding: 5,
                delete: (dir) {
                  setState(() {
                    _selectedPrices.removeAt(index);
                  });
                  _updateTimes();
                },
                last: index == (_selectedPrices.length - 1),
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        StandartButton(
          label: "Добавить услуги",
          color: Colors.blueGrey,
          onTap: _addPrices,
        ),
        SizedBox(
          height: 15,
        ),
        StandartButton(
          label: "Далее",
          onTap: () {
            setState(() {
              _index++;
            });
          },
        ),
      ],
    );
  }

  void _getAddress() async {
    var places = await NetHandler.getPlaces(widget.masterUid);
    places?.forEach((element) {
      if (element.placeId == widget.workShift.placeId) {
        setState(() {
          _selectedPlace = element;
        });
      }
    });
  }

  void _makeRecord() async {
    if (_nameController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Укажите имя клиента",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_phoneController.text.length != 18) {
      StandartSnackBar.show(
        context,
        "Укажите корректный телефон клиента",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_selectedPrices.isEmpty) {
      StandartSnackBar.show(
        context,
        "Выберите услуги",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_selectedTime == null) {
      StandartSnackBar.show(
        context,
        "Выберите время",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_selectedPlace == null) {
      StandartSnackBar.show(
        context,
        "Ошибка",
        SnackBarStatus.warning(),
      );
      return;
    }

    for (var item in _workTimes) {
      if (item.time == _selectedTime) {
        _sendRecord(1);
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
              _sendRecord(0);
            },
          )
        ],
      ),
    );
  }

  void _sendRecord(int free) async {
    setState(() {
      _loading = true;
      _succes = true;
    });

    var result = await NetHandler.addRecord(
      widget.masterUid,
      _nameController.text,
      _phoneController.text.removeDecoration(),
      jsonEncode(_selectedPrices.encodeQuotes()),
      _selectedPlace!.placeId.toString(),
      _selectedTime.toString(),
      (_selectedTime! + _selectedPrices.getLength()).toString(),
      _selectedPrices.getAmount(),
      free,
    );

    if (result?.error == 0) {
      setState(() {
        _loading = false;
        _succes = true;
      });
    } else {
      if (result?.message != null) {
        StandartSnackBar.show(
          context,
          result!.message,
          SnackBarStatus.warning(),
        );
      } else {
        StandartSnackBar.show(
          context,
          "Ошибка",
          SnackBarStatus.warning(),
        );
      }

      setState(() {
        _loading = false;
        _succes = false;
      });
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
      label: "Сохранить запись",
      onTap: _makeRecord,
    );
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

  void _openPhoneInfo() {
    MainRouter.openBottomSheet(
      context: context,
      height: 250,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 40),
        child: Text(
          "Номер телефона используется для идентификации клиента в сервисе Look. Поменять его в будущем будет невозможно. Если номер указан некорректно, то доставка уведомлений будет невозможна.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _back() {
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
    _getAddress();
    _updateTimes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_nameController.text.isEmpty) {
      _firstSubTitle = "Укажите клиента";
    } else {
      _firstSubTitle = _nameController.text;
    }

    if (_selectedPrices.isEmpty) {
      _secondSubTitle = "Выберите услуги";
    } else {
      _secondSubTitle = _selectedPrices.getString();
    }

    if (_selectedTime == null) {
      _thirdSubTitle = "Выберите время";
    } else {
      _thirdSubTitle = ConvertDate(context).fromUnix(
        _selectedTime!,
        "dd MMMM в HH:mm",
      );
    }

    if (_selectedPlace == null) {
      _placeSubTitle = "Обновление";
    } else {
      _placeSubTitle = _selectedPlace!.address;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Новая запись"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            ListView(
              children: [
                EnhanceStepper(
                  physics: NeverScrollableScrollPhysics(),
                  stepIconSize: 30,
                  currentStep: _index,
                  onStepTapped: (index) {
                    if (!_succes) {
                      setState(() {
                        _index = index;
                      });
                    }
                  },
                  steps: [
                    EnhanceStep(
                      icon: Icon(
                        LineIcons.user,
                        color: Colors.blueGrey,
                      ),
                      title: Text("Клиент", style: _titleStyle),
                      subtitle: Text(_firstSubTitle, style: _subTitleStyle),
                      content: _customer(),
                    ),
                    EnhanceStep(
                      icon: Icon(
                        LineIcons.rubleSign,
                        color: Colors.blueGrey,
                      ),
                      title: Text("Услуги", style: _titleStyle),
                      subtitle: Text(_secondSubTitle, style: _subTitleStyle),
                      content: _prices(),
                    ),
                    EnhanceStep(
                      icon: Icon(
                        LineIcons.clock,
                        color: Colors.blueGrey,
                      ),
                      title: Text("Время", style: _titleStyle),
                      subtitle: Text(_thirdSubTitle, style: _subTitleStyle),
                      content: RecordWorkTimes(
                        times: _showAllTimes ? _allTimes : _workTimes,
                        loading: _loadingTimes,
                        all: _showAllTimes,
                        showAll: (value) {
                          setState(() {
                            _showAllTimes = value;
                          });
                        },
                        onSelect: (time) {
                          setState(() {
                            _selectedTime = time;
                            _index++;
                          });
                        },
                        selected: _selectedTime,
                      ),
                    ),
                    EnhanceStep(
                      icon: Icon(
                        LineIcons.mapPin,
                        color: Colors.blueGrey,
                      ),
                      title: Text("Адрес", style: _titleStyle),
                      subtitle: Text(_placeSubTitle, style: _subTitleStyle),
                      content: Container(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 150),
                  child: RecordTotal(
                    prices: int.parse(_selectedPrices.getAmount()),
                    time: _selectedPrices.getAllTime(),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).padding.bottom + 15,
              child: _getAddButton(),
            ),
            Center(
              child: _getSuccess(),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordDone extends StatefulWidget {
  @override
  _RecordDoneState createState() => _RecordDoneState();
}

class _RecordDoneState extends State<RecordDone>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCirc,
      ),
    );
    Timer(Duration(milliseconds: 500), () {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedCheck(
        color: Colors.white,
        progress: _animation,
        size: 150,
      ),
    );
  }
}
