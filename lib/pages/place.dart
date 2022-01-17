import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';

class PlacePage extends StatefulWidget {
  PlacePage({
    required this.masterUid,
    required this.place,
  });

  final String masterUid;
  final Place place;

  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  var _metroController = TextEditingController();
  var _togoController = TextEditingController();
  var _percentController = TextEditingController();
  var _rentController = TextEditingController();

  var _first = true;

  var _chargeIndex = 0;
  var _charges = ["Нет", "Процент", "Сумма"];

  Widget _getCell(int index) {
    return Expanded(
      flex: 1,
      child: Material(
        elevation: index == _chargeIndex ? 1 : 0,
        borderRadius: const BorderRadius.all(
          Radius.circular(11),
        ),
        color: index == _chargeIndex ? Colors.white : Colors.grey[100],
        child: InkWell(
          borderRadius: Constants.radius,
          child: Center(
            child: Text(
              _charges[index],
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          onTap: () => setState(() {
            _chargeIndex = index;
          }),
        ),
      ),
    );
  }

  Widget _getCharge() {
    if (_chargeIndex == 0) {
      return Container(
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 50),
        child: Text(
          "В данном случае в статистике не будут учитываться расходы на рабочее место.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else if (_chargeIndex == 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 50),
        child: TextFieldWidget(
          hint: "Укажите процент",
          icon: LineIcons.percent,
          type: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          formatter: [
            LengthLimitingTextInputFormatter(2),
          ],
          controller: _percentController,
        ),
      );
    } else if (_chargeIndex == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 50),
        child: TextFieldWidget(
          hint: "Укажите сумму",
          icon: LineIcons.rubleSign,
          type: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          formatter: [
            LengthLimitingTextInputFormatter(6),
          ],
          controller: _rentController,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getButton() {
    if (widget.place.placeId == 0) {
      return StandartButton(
        label: "Добавить",
        onTap: _addPlace,
      );
    } else {
      return Column(
        children: [
          StandartButton(
            label: "Сохранить",
            onTap: _savePlace,
          ),
          SizedBox(
            height: 15,
          ),
          StandartButton(
            label: "Удалить",
            color: Colors.red[700],
            onTap: _deletePlaceCheck,
          ),
        ],
      );
    }
  }

  bool _checkPlace() {
    if (_metroController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Ближайшая станция должна быть указана, если станция отсутствует, так и укажите.",
        SnackBarStatus.warning(),
      );
      return false;
    }
    if (_togoController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Время до ближайшей станции должно быть указано, если станция отсутствует, укажите, что расчёт невозможен.",
        SnackBarStatus.warning(),
      );
      return false;
    }
    if (_chargeIndex == 1 && _percentController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Поле регулярного расхода должно быть заполнено, если расходов нет выберите соответствующий пункт.",
        SnackBarStatus.warning(),
      );
      return false;
    }

    if (_chargeIndex == 2 && _rentController.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Поле регулярного расхода должно быть заполнено, если расходов нет выберите соответствующий пункт.",
        SnackBarStatus.warning(),
      );
      return false;
    }

    return true;
  }

  void _savePlace() async {
    if (_checkPlace()) {
      var message = await NetHandler.editPlace(
        widget.masterUid,
        widget.place.placeId.toString(),
        _metroController.text,
        _togoController.text,
        _chargeIndex == 1 ? _percentController.text : "",
        _chargeIndex == 2 ? _rentController.text : "",
      );

      if (message != null) {
        StandartSnackBar.show(
          context,
          message,
          SnackBarStatus.success(),
        );
      } else {
        StandartSnackBar.show(
          context,
          "Ошибка",
          SnackBarStatus.warning(),
        );
      }
    }
  }

  void _deletePlaceCheck() {
    MainRouter.openBottomSheet(
      context: context,
      height: MediaQuery.of(context).padding.bottom + 210,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            child: Text(
              "Обратите внимание, при удалении рабочего адреса все рабочие смены связанные с конкретным местом будут так же удалены. Точно удалить?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          StandartButton(
            label: "Удалить",
            color: Colors.red[700],
            onTap: () {
              Navigator.pop(context);
              _deletePlace();
            },
          ),
        ],
      ),
    );
  }

  void _deletePlace() async {
    var delete = await NetHandler.deletePlace(
      widget.masterUid,
      widget.place.placeId.toString(),
    );

    if (delete != null) {
      StandartSnackBar.show(
        context,
        delete,
        SnackBarStatus.success(),
      );
      Navigator.pop(context);
    } else {
      StandartSnackBar.show(
        context,
        "Ошибка",
        SnackBarStatus.warning(),
      );
    }
  }

  void _addPlace() async {
    if (_checkPlace()) {
      var result = await NetHandler.addPlace(
        widget.masterUid,
        widget.place.placeNumber,
        widget.place.address,
        widget.place.latitude.toString(),
        widget.place.longitude.toString(),
        _metroController.text,
        _togoController.text,
        _chargeIndex == 1 ? _percentController.text : "",
        _chargeIndex == 2 ? _rentController.text : "",
      );

      if (result != null) {
        StandartSnackBar.show(
          context,
          result,
          SnackBarStatus.success(),
        );
        Navigator.pop(context, true);
      } else {
        StandartSnackBar.show(
          context,
          "Ошибка",
          SnackBarStatus.warning(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_first) {
      _metroController.text = widget.place.metro;
      _togoController.text = widget.place.togo;

      if (widget.place.percent != 0) {
        _percentController.text = widget.place.percent.toString();
        _chargeIndex = 1;
      }

      if (widget.place.rent != 0) {
        _rentController.text = widget.place.rent.toString();
        _chargeIndex = 2;
      }

      _first = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: widget.place.placeId == 0
                ? Text("Новый адрес")
                : Text("Редактирование"),
          ),
          SliverToBoxAdapter(
            child: MapWidget(
              target: LatLng(
                widget.place.latitude,
                widget.place.longitude,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 25),
              child: Text(
                widget.place.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: TextFieldWidget(
                hint: "Ближайшая станция",
                icon: LineIcons.train,
                textCapitalization: TextCapitalization.words,
                controller: _metroController,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 2, 15, 20),
              child: TextFieldWidget(
                hint: "Минут до станции",
                icon: LineIcons.walking,
                textCapitalization: TextCapitalization.none,
                controller: _togoController,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                "Регулярные расходы",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Container(
                height: 50,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: Constants.radius,
                ),
                child: Row(
                  children: [
                    _getCell(0),
                    SizedBox(width: 3),
                    _getCell(1),
                    SizedBox(width: 3),
                    _getCell(2),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSizeAndFade(
              child: _getCharge(),
            ),
          ),
          SliverToBoxAdapter(
            child: _getButton(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  MapWidget({
    required this.target,
  });

  final LatLng target;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _controller;

  void initMap(GoogleMapController controller) {
    _controller = controller;
    _controller.setMapStyle(Constants.mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: Constants.radius,
        boxShadow: Constants.shadow,
      ),
      child: ClipRRect(
        borderRadius: Constants.radius,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: widget.target,
            zoom: 11,
          ),
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          buildingsEnabled: true,
          scrollGesturesEnabled: false,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: false,
          rotateGesturesEnabled: false,
          markers: {
            Marker(
              icon: BitmapDescriptor.defaultMarkerWithHue(200.0),
              markerId: MarkerId("place"),
              position: widget.target,
            ),
          },
          onMapCreated: initMap,
        ),
      ),
    );
  }
}
