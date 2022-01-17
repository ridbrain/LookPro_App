import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';

class NewMaterialPage extends StatefulWidget {
  @override
  _NewMaterialPageState createState() => _NewMaterialPageState();
}

class _NewMaterialPageState extends State<NewMaterialPage> {
  var _amountController = TextEditingController();
  var _descrController = TextEditingController();

  void _addCost() {
    if (_amountController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Введите сумму",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_descrController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Заполгите описание",
        SnackBarStatus.warning(),
      );
      return;
    }
    Navigator.pop(
      context,
      Cost(
        costId: 0,
        groupId: 1,
        amount: int.parse(_amountController.text),
        date: ConvertDate.dayBeginInSeconds(),
        description: _descrController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Материал"),
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
                hint: "Описание",
                controller: _descrController,
                maxLines: 8,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              child: StandartButton(
                label: "Добавить",
                onTap: _addCost,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
