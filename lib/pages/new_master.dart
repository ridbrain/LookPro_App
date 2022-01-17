import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/main.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/groups_selector.dart';
import 'package:master/widgets/photo.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';
import 'package:provider/provider.dart';

class NewMasterPage extends StatefulWidget {
  @override
  _NewMasterPageState createState() => _NewMasterPageState();
}

class _NewMasterPageState extends State<NewMasterPage> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _birthdayController = TextEditingController();
  var _experienceController = TextEditingController();

  String? _image;
  int? _birthday;
  int? _experience;
  String? _groupId;

  var _loading = false;

  void _checkFields() {
    if (_image == null) {
      StandartSnackBar.show(
        context,
        "Не выбрано Ваше фото.",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_nameController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Не указаны Имя Фамилия.",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_birthday == null) {
      StandartSnackBar.show(
        context,
        "Не указана дата рождения.",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_emailController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Не указан E-Mail.",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_groupId == null) {
      StandartSnackBar.show(
        context,
        "Не выбрана группа услуг.",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_experience == null) {
      StandartSnackBar.show(
        context,
        "Не указан опыт работы.",
        SnackBarStatus.warning(),
      );
      return;
    }

    _saveChanges();
  }

  void _saveChanges() async {
    var provider = Provider.of<MasterProvider>(context);
    var photoString = _image!;
    var name = _nameController.text;
    var email = _emailController.text;

    setState(() {
      _loading = true;
    });

    NetHandler.setProfile(
      provider.master.uid!,
      _groupId.toString(),
      name,
      _birthday.toString(),
      email,
      _experience.toString(),
      photoString,
    ).then((value) {
      if (value?.error == 0) {
        provider.setMaster(value!.result!.master!);
        MainRouter.changeMainPage(
          context,
          LoadingApp(),
        );
      } else {
        StandartSnackBar.show(
          context,
          "Произошла ошибка, попробуйте ещё раз.",
          SnackBarStatus.warning(),
        );
        setState(() {
          _loading = false;
        });
      }
    });
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
              title: Text("Регистрация"),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 25),
                child: Photo(
                  newImage: (String image) {
                    _image = image;
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: TextFieldWidget(
                  hint: "Имя Фамилия",
                  icon: LineIcons.user,
                  textCapitalization: TextCapitalization.words,
                  controller: _nameController,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: TextFieldWidget(
                  hint: "Дата рождения",
                  icon: LineIcons.calendar,
                  readOnly: true,
                  controller: _birthdayController,
                  onTap: () {
                    DatePicker(
                      context: context,
                      yearBegin: DateTime.now().year - 60,
                      yearEnd: DateTime.now().year,
                      onConfirm: (date) {
                        _birthdayController.text =
                            "${date.day}.${date.month}.${date.year}";
                        _birthday = date.millisecondsSinceEpoch ~/ 1000;
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: TextFieldWidget(
                  hint: "E-Mail",
                  icon: LineIcons.envelope,
                  textCapitalization: TextCapitalization.none,
                  controller: _emailController,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: GroupsSelector(
                  selected: "",
                  onSelect: (select) {
                    _groupId = select.groupId.toString();
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: TextFieldWidget(
                  hint: "Опыт работы с",
                  icon: LineIcons.calendar,
                  readOnly: true,
                  controller: _experienceController,
                  onTap: () {
                    DatePicker(
                      context: context,
                      yearBegin: DateTime.now().year - 40,
                      yearEnd: DateTime.now().year,
                      onConfirm: (date) {
                        _experienceController.text =
                            "С ${date.year.toString()} года";
                        _experience = date.millisecondsSinceEpoch ~/ 1000;
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                child: Text(
                  "Пожалуйста заполните все поля и выбирите Ваше фото.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 25),
                child: !_loading
                    ? StandartButton(
                        label: "Сохранить",
                        onTap: _checkFields,
                      )
                    : CupertinoActivityIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
