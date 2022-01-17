import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/costs_selector.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';

class NewCostPage extends StatefulWidget {
  NewCostPage({
    required this.masterUid,
    this.cost,
  });

  final String masterUid;
  final Cost? cost;

  @override
  _NewCostPageState createState() => _NewCostPageState();
}

class _NewCostPageState extends State<NewCostPage> {
  var _dateController = TextEditingController();
  var _amountController = TextEditingController();
  var _descrController = TextEditingController();

  var _date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  var _groupId = 0;

  void _loadCost() {
    _date = widget.cost!.date;
    _groupId = widget.cost!.groupId;
    _amountController.text = "${widget.cost!.amount}";
    _descrController.text = widget.cost!.description;
  }

  void _save() {
    if (_groupId == 0) {
      StandartSnackBar.show(
        context,
        "Укажите категорию расхода",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_date == 0) {
      StandartSnackBar.show(
        context,
        "Укажите дату",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_amountController.text.length == 0) {
      StandartSnackBar.show(
        context,
        "Укажите cумму расхода",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_descrController.text.length == 0) {
      StandartSnackBar.show(
        context,
        "Добавьте описание",
        SnackBarStatus.warning(),
      );
      return;
    }

    if (widget.cost != null) {
      _editCost();
    } else {
      _saveCost();
    }
  }

  void _editCost() async {
    var result = await NetHandler.editCost(
      widget.masterUid,
      widget.cost!.costId.toString(),
      _groupId.toString(),
      _amountController.text,
      _descrController.text,
      _date.toString(),
    );

    if (result != null) {
      StandartSnackBar.show(
        context,
        result.message,
        result.error == 0 ? SnackBarStatus.success() : SnackBarStatus.warning(),
      );
    }
  }

  void _saveCost() async {
    var result = await NetHandler.addCost(
      widget.masterUid,
      _groupId.toString(),
      _amountController.text,
      _descrController.text,
      _date.toString(),
    );

    if (result != null) {
      StandartSnackBar.show(
        context,
        result.message,
        result.error == 0 ? SnackBarStatus.success() : SnackBarStatus.warning(),
      );
    }
  }

  void _delete() async {
    var result = await NetHandler.deleteCost(
      widget.masterUid,
      widget.cost!.costId.toString(),
    );

    StandartSnackBar.show(
      context,
      result ?? "Ошибка",
      result == null ? SnackBarStatus.warning() : SnackBarStatus.success(),
    );

    Navigator.pop(context);
  }

  Widget _getDelete() {
    if (widget.cost == null) {
      return SizedBox.shrink();
    } else {
      return StandartButton(
        label: "Удалить",
        onTap: _delete,
        color: Colors.red[700],
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.cost != null) {
      _loadCost();
    }
  }

  @override
  Widget build(BuildContext context) {
    _dateController.text = ConvertDate(context).fromUnix(_date, "dd.MM.yy");

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Расходный ордер"),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
              child: Text(
                "Все поля обязательны",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[900],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: TextFieldWidget(
                hint: "Дата",
                icon: LineIcons.calendar,
                readOnly: true,
                controller: _dateController,
                onTap: () {
                  DatePicker(
                    context: context,
                    yearBegin: DateTime.now().year - 1,
                    yearEnd: DateTime.now().year + 1,
                    onConfirm: (date) {
                      setState(() {
                        _date = ConvertDate(context).secondsFromDate(date);
                      });
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: CostsSelector(
                onSelect: (group) {
                  _groupId = group.groupId;
                },
                selected: _groupId,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: TextFieldWidget(
                hint: "Сумма в рублях",
                type: TextInputType.number,
                icon: LineIcons.wallet,
                controller: _amountController,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              height: 140,
              child: TextFieldWidget(
                hint: "Дополнительное описание",
                controller: _descrController,
                maxLines: 8,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              child: StandartButton(
                label: widget.cost == null ? "Добавить" : "Сохранить",
                onTap: _save,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 50),
              child: _getDelete(),
            ),
          ),
        ],
      ),
    );
  }
}
