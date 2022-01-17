import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';

class PricePage extends StatefulWidget {
  PricePage({
    required this.masterUid,
    this.price,
  });

  final String masterUid;
  final Price? price;

  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _timeController = TextEditingController();
  var _priceController = TextEditingController();

  void _loadPrice() {
    _titleController.text = widget.price!.title;
    _descriptionController.text = widget.price!.description;
    _timeController.text = (widget.price!.time ~/ 60).toString();
    _priceController.text = widget.price!.price.toString();
  }

  void _saveNewPrice() async {
    var answer = await NetHandler.addPrice(
      widget.masterUid,
      _titleController.text,
      _priceController.text,
      (int.parse(_timeController.text) * 60).toString(),
      _descriptionController.text,
    );

    if (answer == null) {
      StandartSnackBar.show(
        context,
        "Ошибка",
        SnackBarStatus.warning(),
      );
    } else {
      StandartSnackBar.show(
        context,
        answer,
        SnackBarStatus.success(),
      );
      Navigator.pop(context);
    }
  }

  void _editPrice() async {
    var answer = await NetHandler.editPrice(
      widget.masterUid,
      widget.price!.priceId.toString(),
      _titleController.text,
      _priceController.text,
      (int.parse(_timeController.text) * 60).toString(),
      _descriptionController.text,
    );

    if (answer == null) {
      StandartSnackBar.show(
        context,
        "Ошибка",
        SnackBarStatus.warning(),
      );
    } else {
      StandartSnackBar.show(
        context,
        answer,
        SnackBarStatus.success(),
      );
      Navigator.pop(context);
    }
  }

  void _save() {
    if (_titleController.text.length == 0) {
      StandartSnackBar.show(
        context,
        "Укажите название услуги",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_timeController.text.length == 0) {
      StandartSnackBar.show(
        context,
        "Укажите продолжительность услуги",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_priceController.text.length == 0) {
      StandartSnackBar.show(
        context,
        "Укажите цену услуги",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_descriptionController.text.length == 0) {
      StandartSnackBar.show(
        context,
        "Укажите описание услуги",
        SnackBarStatus.warning(),
      );
      return;
    }

    if (widget.price != null) {
      _editPrice();
    } else {
      _saveNewPrice();
    }
  }

  void _deletePrice() async {
    var price = widget.price;
    if (price == null) return;

    var answer = await NetHandler.deletePrice(
      widget.masterUid,
      price.priceId.toString(),
    );

    if (answer == null) {
      StandartSnackBar.show(
        context,
        "Ошибка",
        SnackBarStatus.warning(),
      );
    } else {
      StandartSnackBar.show(
        context,
        answer,
        SnackBarStatus.success(),
      );
      Navigator.pop(context);
    }
  }

  Widget _getDelete() {
    if (widget.price == null) {
      return Container();
    } else {
      return StandartButton(
        label: "Удалить",
        onTap: _deletePrice,
        color: Colors.red[700],
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.price != null) {
      _loadPrice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            StandartAppBar(
              title: widget.price != null
                  ? Text("Редактирование")
                  : Text("Новая услуга"),
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
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                child: TextFieldWidget(
                  hint: "Название с категорией",
                  icon: LineIcons.tag,
                  controller: _titleController,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                child: TextFieldWidget(
                  hint: "Продолжительность в минутах",
                  type: TextInputType.number,
                  icon: LineIcons.clock,
                  controller: _timeController,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                child: TextFieldWidget(
                  hint: "Цена в рублях",
                  type: TextInputType.number,
                  icon: LineIcons.wallet,
                  controller: _priceController,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                height: 140,
                child: TextFieldWidget(
                  hint: "Краткое описание",
                  controller: _descriptionController,
                  formatter: [
                    LengthLimitingTextInputFormatter(200),
                  ],
                  maxLines: 8,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 25),
                child: StandartButton(
                  label: "Сохранить",
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
      ),
    );
  }
}
