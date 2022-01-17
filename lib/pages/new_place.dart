import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/place.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/place_cell.dart';
import 'package:master/widgets/text_field.dart';

class NewPlacePage extends StatefulWidget {
  NewPlacePage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _NewPlacePageState createState() => _NewPlacePageState();
}

class _NewPlacePageState extends State<NewPlacePage> {
  final _addressController = TextEditingController();

  List<Place> _places = [];
  bool _loading = false;

  void _searchPlace() async {
    if (_addressController.text.isEmpty) {
      return;
    }

    setState(() {
      _loading = true;
    });

    var places = await NetHandler.searchPlace(
      widget.masterUid,
      _addressController.text,
    );

    setState(() {
      _places = places ?? [];
      _loading = false;
    });
  }

  Widget _getList() {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Container(),
      );
    } else {
      if (_places.isEmpty) {
        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "После нажатия кнопки 'Поиск' выберите адрес из предложенных вариантов. Если список пуст, то скорее всего такого адреса не существует или допущена ошибка при вводе.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var place = _places[index];
              return PlaceCell(
                place: place,
                onTap: () => MainRouter.nextPage(
                  context,
                  PlacePage(
                    masterUid: widget.masterUid,
                    place: place,
                  ),
                ).then((value) {
                  if (value is bool) {
                    if (value) {
                      Navigator.pop(context);
                    }
                  }
                }),
              );
            },
            childCount: _places.length,
          ),
        );
      }
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
              title: Text("Новый адрес"),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Введите полный адрес",
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
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: TextFieldWidget(
                  hint: "Москва, Солнечная 6",
                  icon: LineIcons.mapPin,
                  textCapitalization: TextCapitalization.words,
                  controller: _addressController,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSizeAndFade(
                child: Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 25),
                  child: !_loading
                      ? StandartButton(
                          label: "Поиск",
                          onTap: _searchPlace,
                        )
                      : Center(
                          child: CupertinoActivityIndicator(),
                        ),
                ),
              ),
            ),
            _getList(),
          ],
        ),
      ),
    );
  }
}
