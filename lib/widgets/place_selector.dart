import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/new_place.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/shimmer.dart';
import 'package:master/widgets/text_field.dart';

class PlaceSelector extends StatefulWidget {
  PlaceSelector({
    required this.masterUid,
    required this.select,
  });

  final String masterUid;
  final Function(Place place) select;

  @override
  _PlaceSelectorState createState() => _PlaceSelectorState();
}

class _PlaceSelectorState extends State<PlaceSelector> {
  var controller = TextEditingController();
  var first = true;

  List<String> _getStrings(List<Place> places) {
    List<String> strings = [];
    for (Place item in places) {
      strings.add(item.address);
    }
    return strings;
  }

  Future<List<Place>?> _getPlaces() async {
    var places = await NetHandler.getPlaces(widget.masterUid);
    _selectPlace(places ?? []);
    return places;
  }

  void _selectPlace(List<Place> places) async {
    if (places.isNotEmpty && first) {
      await Future.delayed(Duration(milliseconds: 250));
      if (places.length == 1) {
        setState(() {
          controller.text = places.first.address;
          widget.select(places.first);
        });
      }
      first = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPlaces(),
      builder: (BuildContext context, AsyncSnapshot<List<Place>?> snap) {
        if (snap.hasData) {
          if (snap.data!.isEmpty) {
            return TextFieldWidget(
              hint: "Добавить рабочий адрес",
              icon: LineIcons.mapPin,
              readOnly: true,
              onTap: () => MainRouter.nextPage(
                context,
                NewPlacePage(
                  masterUid: widget.masterUid,
                ),
              ).then((value) => setState(() {})),
            );
          } else {
            return TextFieldWidget(
              hint: "Выберите адрес",
              icon: LineIcons.mapPin,
              readOnly: true,
              controller: controller,
              onTap: () {
                ValuePicker(
                  context: context,
                  adapter: PickerDataAdapter<String>(
                    pickerdata: _getStrings(snap.data!),
                  ),
                  onConfirm: (index) {
                    setState(
                      () => controller.text = snap.data![index].address,
                    );
                    widget.select(snap.data![index]);
                  },
                );
              },
            );
          }
        }
        return Shimmer(
          height: 55,
        );
      },
    );
  }
}
