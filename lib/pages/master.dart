import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/network.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/groups_selector.dart';
import 'package:master/widgets/photo.dart';
import 'package:master/widgets/shimmer.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';
import 'package:provider/provider.dart';

class MasterPage extends StatefulWidget {
  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _aboutController = TextEditingController();

  var _groupId = 0;
  var _first = true;

  String? _image;

  void _saveProfile(String masterUid) async {
    if (_nameController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Укажите Ваше имя",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_emailController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Укажите Ваш E-Mail",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_groupId == 0) {
      StandartSnackBar.show(
        context,
        "Выбирите группу услуг",
        SnackBarStatus.warning(),
      );
      return;
    }
    if (_aboutController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Заполните описание",
        SnackBarStatus.warning(),
      );
      return;
    }

    var master = await NetHandler.editMasterInfo(
      masterUid,
      _nameController.text,
      _emailController.text,
      _groupId.toString(),
      _aboutController.text,
      _image == null ? "" : _image!,
    );

    if (master == null) {
      StandartSnackBar.show(
        context,
        "Ошибка. Изменения не сохранены.",
        SnackBarStatus.warning(),
      );
      return;
    }

    StandartSnackBar.show(
      context,
      "Изменения сохранены!",
      SnackBarStatus.success(),
    );

    var userProvider = Provider.of<MasterProvider>(context, listen: false);
    userProvider.setMaster(master);
  }

  Widget _getButton(String masterUid) {
    return FutureBuilder(
      future: NetHandler.getStatusProfile(masterUid),
      builder: (context, AsyncSnapshot<int?> snap) {
        if (snap.hasData) {
          if (snap.data! < 2) {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: StandartButton(
                label: "Отключить профиль",
                color: Colors.red[700],
                onTap: () =>
                    NetHandler.changeProfileStatus(masterUid, "2").then(
                  (value) => setState(() {
                    StandartSnackBar.show(
                      context,
                      value ?? "Ошибка",
                      SnackBarStatus.message(),
                    );
                  }),
                ),
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: StandartButton(
                label: "Активировать профиль",
                color: Colors.green[700],
                onTap: () =>
                    NetHandler.changeProfileStatus(masterUid, "0").then(
                  (value) => setState(() {
                    StandartSnackBar.show(
                      context,
                      value ?? "Ошибка",
                      SnackBarStatus.message(),
                    );
                  }),
                ),
              ),
            );
          }
        } else {
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Shimmer(
              height: 45,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var master = Provider.of<MasterProvider>(context).master;

    if (_first) {
      _nameController.text = master.name!;
      _emailController.text = master.email!;
      _aboutController.text = master.about!;
      _first = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            StandartAppBar(
              title: Text("Профиль"),
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
                padding: const EdgeInsets.fromLTRB(15, 2, 15, 20),
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
                  selected: master.group!,
                  onSelect: (select) {
                    _groupId = select.groupId;
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 140,
                child: TextFieldWidget(
                  hint: "Расскажите о себе",
                  controller: _aboutController,
                  maxLines: 8,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: StandartButton(
                  label: "Сохранить",
                  onTap: () => _saveProfile(master.uid!),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _getButton(master.uid!),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
