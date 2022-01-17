import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/note.dart';
import 'package:master/pages/record_move.dart';
import 'package:master/pages/record_price.dart';
import 'package:master/pages/review.dart';
import 'package:master/pages/user.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/link.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/price_cell.dart';
import 'package:master/widgets/record_costs.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';
import 'package:provider/provider.dart';

class RecordPage extends StatefulWidget {
  RecordPage({
    required this.record,
  });

  final Record record;

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late Record record;

  void _showAnswer(Answer? result) {
    if (result?.error == 0) {
      StandartSnackBar.show(
        context,
        result!.message,
        SnackBarStatus.success(),
      );
    } else {
      StandartSnackBar.show(
        context,
        result?.message ?? "Ошибка",
        SnackBarStatus.warning(),
      );
    }
  }

  void _updeteRecord(String masterUid) async {
    var result = await NetHandler.getRecord(
      masterUid,
      widget.record.recordId.toString(),
    );

    setState(() {
      record = result ?? widget.record;
    });
  }

  void _savePrices(String masterUid) async {
    var result = await NetHandler.changeRecordPrices(
      masterUid,
      record.recordId.toString(),
      jsonEncode(record.prices.encodeQuotes()),
      record.getAmount(),
      record.prices.getLength().toString(),
    );

    _updeteRecord(masterUid);
    _showAnswer(result);
  }

  void _saveCosts(String masterUid) async {
    var result = await NetHandler.changeRecordCosts(
      masterUid,
      record.recordId.toString(),
      jsonEncode(record.costs.encodeQuotes()),
      record.getAmount(),
    );

    _updeteRecord(masterUid);
    _showAnswer(result);
  }

  void _pressSuccess(String masterUid) async {
    MainRouter.openBottomSheet(
      context: context,
      child: SuccessRecord(
        total: record.total,
        save: (discount) => _successRecord(masterUid, discount),
      ),
    );
  }

  void _approveRecord(String masterUid) async {
    var result = await NetHandler.changeRecordStatus(
      masterUid: masterUid,
      recordId: record.recordId,
      status: 1,
    );

    _updeteRecord(masterUid);
    _showAnswer(result);
  }

  void _successRecord(String masterUid, int discount) async {
    var result = await NetHandler.changeRecordStatus(
      masterUid: masterUid,
      recordId: record.recordId,
      status: 2,
      discount: discount,
    );

    _updeteRecord(masterUid);
    _showAnswer(result);
  }

  void _payedRecord(String masterUid) async {
    var result = await NetHandler.changeRecordStatus(
      masterUid: masterUid,
      recordId: record.recordId,
      status: 3,
    );

    _updeteRecord(masterUid);
    _showAnswer(result);
  }

  void _cancelRecord(String masterUid) async {
    var result = await NetHandler.changeRecordStatus(
      masterUid: masterUid,
      recordId: record.recordId,
      status: 4,
    );

    _updeteRecord(masterUid);
    _showAnswer(result);
  }

  Widget _getApprove(String masterUid) {
    if (record.status == 0) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.smilingFace,
          label: "Подтвердить",
          onTap: () => _approveRecord(masterUid),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _getSuccess(String masterUid) {
    if (record.status == 1) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.checkCircle,
          label: "Выполнена",
          onTap: () => _pressSuccess(masterUid),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _getPayed(String masterUid) {
    if (record.status == 2) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.wallet,
          label: "Оплачена",
          onTap: () => _payedRecord(masterUid),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _getReview(String masterUid) {
    if (record.status > 1) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.thumbsUp,
          label: "Оценить",
          onTap: () => MainRouter.nextPage(
            context,
            ReviewPage(
              masterUid: masterUid,
              userId: record.userId.toString(),
            ),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _getCancel(String masterUid) {
    if (record.status <= 1) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.frowningFace,
          label: "Отменить",
          onTap: () => _cancelRecord(masterUid),
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  void initState() {
    super.initState();
    record = widget.record;
  }

  @override
  Widget build(BuildContext context) {
    var master = Provider.of<MasterProvider>(context).master;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(
              ConvertDate(context).fromUnix(
                record.start,
                "dd MMMM, yyyy",
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: RecordInfo(
              name: record.name,
              address: record.place.address,
              userId: record.userId.toString(),
              masterUid: master.uid!,
            ),
          ),
          SliverToBoxAdapter(
            child: RecordTimeLink(
              start: record.start,
              lenght: record.prices.getLength(),
              placeId: record.place.placeId.toString(),
              masterUid: master.uid!,
              recordId: record.recordId.toString(),
              update: () => _updeteRecord(master.uid!),
              edit: record.status <= 1,
            ),
          ),
          SliverToBoxAdapter(
            child: RecordNote(
              masterUid: master.uid!,
              userId: record.userId.toString(),
            ),
          ),
          SliverToBoxAdapter(
            child: RecordPrices(
              masterUid: master.uid!,
              prices: record.prices,
              edit: record.status <= 1,
              addPrices: (prices) {
                setState(() {
                  prices.forEach((element) {
                    record.prices.add(element);
                  });
                });
              },
              removePrice: (price) {
                setState(() {
                  record.prices.remove(price);
                });
              },
              save: () => _savePrices(master.uid!),
            ),
          ),
          SliverToBoxAdapter(
            child: RecordCosts(
              masterUid: master.uid!,
              costs: record.costs,
              addCosts: (cost) {
                setState(() {
                  record.costs.add(cost);
                });
              },
              removeCost: (cost) {
                setState(() {
                  record.costs.remove(cost);
                });
              },
              save: () => _saveCosts(master.uid!),
              edit: record.status <= 1,
            ),
          ),
          SliverToBoxAdapter(
            child: RecordTotal(
              prices: int.parse(record.prices.getAmount()),
              costs: int.parse(record.costs.getAmount()),
              discount: record.discount,
              time: record.prices.getAllTime(),
              recordId: record.recordId.toString(),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 100),
              child: Row(
                children: [
                  _getApprove(master.uid!),
                  _getSuccess(master.uid!),
                  _getCancel(master.uid!),
                  _getPayed(master.uid!),
                  _getReview(master.uid!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecordTimeLink extends StatefulWidget {
  RecordTimeLink({
    required this.start,
    required this.lenght,
    required this.placeId,
    required this.masterUid,
    required this.recordId,
    required this.update,
    required this.edit,
  });

  final int start;
  final int lenght;
  final String placeId;
  final String recordId;
  final String masterUid;
  final bool edit;

  final Function() update;

  @override
  State<RecordTimeLink> createState() => _RecordTimeLinkState();
}

class _RecordTimeLinkState extends State<RecordTimeLink> {
  List<Workshift> _list = [];
  var _loading = true;

  void _updateShifts() async {
    setState(() {
      _loading = true;
    });

    var shifts = await NetHandler.getWorkshiftsForPlace(
      widget.masterUid,
      widget.placeId,
    );

    setState(() {
      _list = shifts ?? [];
      _loading = false;
    });
  }

  void _changeTime() async {
    await MainRouter.nextPage(
      context,
      RecordMovePage(
        workShifts: _list,
        masterUid: widget.masterUid,
        placeId: widget.placeId,
        recordId: widget.recordId,
        length: widget.lenght.toString(),
        date: widget.start,
      ),
    );

    widget.update();
  }

  String _getDay(BuildContext context) {
    return ConvertDate(context).fromUnix(widget.start, "EEEE").capitalLetter();
  }

  String _getInterval(BuildContext context) {
    var begin = ConvertDate(context).fromUnix(widget.start, "HH:mm");
    var end =
        ConvertDate(context).fromUnix(widget.start + widget.lenght, "HH:mm");
    return "$begin - $end";
  }

  @override
  void initState() {
    super.initState();
    _updateShifts();
  }

  @override
  Widget build(BuildContext context) {
    return BigLink(
      icon: LineIcons.clock,
      label: _getDay(context),
      subLabel: _getInterval(context),
      loading: widget.edit ? _loading : null,
      onTap: widget.edit
          ? _loading
              ? null
              : () => _changeTime()
          : null,
    );
  }
}

class RecordInfo extends StatefulWidget {
  RecordInfo({
    required this.name,
    required this.address,
    required this.userId,
    required this.masterUid,
  });

  final String name;
  final String address;
  final String userId;
  final String masterUid;

  @override
  State<RecordInfo> createState() => _RecordInfoState();
}

class _RecordInfoState extends State<RecordInfo> {
  Customer? _customer;
  var _loading = true;

  void _update() async {
    setState(() {
      _loading = true;
    });

    var result = await NetHandler.getUser(widget.masterUid, widget.userId);

    if (result == null) return;

    setState(() {
      _customer = result;
      _loading = false;
    });
  }

  void _onTap(BuildContext context) {
    if (_customer == null) return;

    MainRouter.nextPage(
      context,
      UserPage(
        masterUid: widget.masterUid,
        user: _customer!,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return BigLink(
      icon: LineIcons.user,
      label: widget.name,
      subLabel: widget.address,
      loading: _loading,
      onTap: _loading ? null : () => _onTap(context),
    );
  }
}

class RecordPrices extends StatefulWidget {
  RecordPrices({
    required this.masterUid,
    required this.prices,
    required this.addPrices,
    required this.removePrice,
    required this.save,
    required this.edit,
  });

  final String masterUid;
  final List<Price> prices;
  final bool edit;

  final Function(List<Price> prices) addPrices;
  final Function(Price price) removePrice;
  final Function() save;

  @override
  _RecordPricesState createState() => _RecordPricesState();
}

class _RecordPricesState extends State<RecordPrices> {
  bool _edit = false;

  void _addPrices() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RecordPricesPage(
            masterUid: widget.masterUid,
            count: widget.prices.length,
          );
        },
      ),
    ) as List<Price>;

    widget.addPrices(result);
  }

  _getButtons() {
    if (widget.edit) {
      if (_edit) {
        return Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: StandartButton(
                label: "Добавить",
                color: Colors.blueGrey,
                onTap: _addPrices,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: StandartButton(
                label: "Сохранить",
                onTap: () => setState(() {
                  widget.save();
                  _edit = false;
                }),
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        );
      }
      return StandartButton(
        label: "Изменить услуги",
        color: Colors.blueGrey[400],
        onTap: () => setState(() {
          _edit = true;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15, top: 50),
          height: 1,
          color: Colors.black.withOpacity(0.1),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                child: Icon(
                  LineIcons.rubleSign,
                  size: 40,
                ),
              ),
              Expanded(
                child: Container(
                  height: widget.prices.length * 60,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.prices.length,
                    itemBuilder: (context, index) {
                      return PriceCell(
                        price: widget.prices[index],
                        last: index == (widget.prices.length - 1),
                        delete: _edit
                            ? (dir) {
                                widget.removePrice(widget.prices[index]);
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, bottom: 15),
          height: 1,
          color: Colors.black.withOpacity(0.1),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
          child: _getButtons(),
        ),
      ],
    );
  }
}

class RecordNote extends StatefulWidget {
  RecordNote({
    required this.masterUid,
    required this.userId,
  });

  final String masterUid;
  final String userId;

  @override
  State<RecordNote> createState() => _RecordNoteState();
}

class _RecordNoteState extends State<RecordNote> {
  var _note = "Загрузка...";
  var _loading = true;

  void _update() async {
    setState(() {
      _loading = true;
    });

    var result = await NetHandler.getUserNote(widget.masterUid, widget.userId);

    setState(() {
      _note = result;
      _loading = false;
    });
  }

  void _onTap(BuildContext context) async {
    await MainRouter.nextPage(
      context,
      NotePage(
        masterUid: widget.masterUid,
        userId: widget.userId,
        note: _note,
      ),
    );

    _update();
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return BigLink(
      icon: LineIcons.clipboard,
      label: "Заметка",
      subLabel: _note,
      loading: _loading,
      onTap: _loading ? null : () => _onTap(context),
    );
  }
}

class RecordTotal extends StatelessWidget {
  RecordTotal({
    required this.prices,
    required this.time,
    this.costs = 0,
    this.discount = 0,
    this.recordId,
  });

  final int prices;
  final int costs;
  final int discount;
  final String time;
  final String? recordId;

  int _getSum() {
    return prices + costs - discount;
  }

  Widget _getDiscount() {
    if (discount == 0) {
      return SizedBox.shrink();
    } else {
      return Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "СКИДКА",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "$discount ₽",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _getRecordId() {
    if (recordId == null) {
      return SizedBox.shrink();
    } else {
      return Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "RECORD ID",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                recordId!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _getServices() {
    if (costs == 0) {
      return SizedBox.shrink();
    } else {
      return Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "УСЛУГИ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "$prices ₽",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _getCosts() {
    if (costs == 0) {
      return SizedBox.shrink();
    } else {
      return Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "МАТЕРИАЛЫ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "$costs ₽",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          DottedLine(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "ИТОГО",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "${_getSum()} ₽",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          _getDiscount(),
          _getServices(),
          _getCosts(),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "ОБЩЕЕ ВРЕМЯ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          _getRecordId(),
        ],
      ),
    );
  }
}

class SuccessRecord extends StatefulWidget {
  SuccessRecord({
    required this.total,
    required this.save,
  });

  final int total;

  final Function(int discount) save;

  @override
  _SuccessRecordState createState() => _SuccessRecordState();
}

class _SuccessRecordState extends State<SuccessRecord> {
  var _percentController = TextEditingController();
  var _sumController = TextEditingController();

  var _percents = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
  var _sums = [100, 200, 300, 400, 500, 1000, 2000, 3000, 4000, 5000];

  var _discount = 0;

  List<String> _getStrings(List<int> values, String after) {
    List<String> strings = [];
    for (int item in values) {
      strings.add(item.toString() + after);
    }
    return strings;
  }

  void _setPercent(int index) {
    var percent = _percents[index];
    var sum = (widget.total / 100 * percent).toInt();

    setState(() {
      _discount = sum;
      _percentController.text = percent.toString();
      _sumController.text = sum.toString();
    });
  }

  void _setSum(int index) {
    var sum = _sums[index];
    var percent = sum ~/ (widget.total / 100);

    setState(() {
      _discount = sum;
      _percentController.text = percent.toString();
      _sumController.text = sum.toString();
    });
  }

  void _saveDiscount() {
    if ((_discount * 2) <= widget.total) {
      widget.save(_discount);
      Navigator.pop(context);
    } else {
      StandartSnackBar.show(
        context,
        "Скидка не может быть более 50%.",
        SnackBarStatus.warning(),
      );
    }
  }

  void _withoutDiscount() {
    widget.save(0);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Text(
            "Укажите скидку?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextFieldWidget(
                hint: "Сумма",
                icon: LineIcons.rubleSign,
                readOnly: true,
                controller: _sumController,
                onTap: () => ValuePicker(
                  context: context,
                  adapter: PickerDataAdapter<String>(
                    pickerdata: _getStrings(_sums, "₽"),
                  ),
                  onConfirm: _setSum,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextFieldWidget(
                hint: "Процент",
                icon: LineIcons.percent,
                readOnly: true,
                controller: _percentController,
                onTap: () => ValuePicker(
                  context: context,
                  adapter: PickerDataAdapter<String>(
                    pickerdata: _getStrings(_percents, "%"),
                  ),
                  onConfirm: _setPercent,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        StandartButton(
          label: "Сохранить",
          color: Colors.blueGrey[400],
          onTap: _saveDiscount,
        ),
        SizedBox(
          height: 15,
        ),
        StandartButton(
          label: "Без скидки",
          onTap: _withoutDiscount,
        ),
      ],
    );
  }
}
