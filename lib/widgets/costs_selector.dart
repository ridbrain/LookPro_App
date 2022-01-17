import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/shimmer.dart';
import 'package:master/widgets/text_field.dart';
import 'package:provider/provider.dart';

class CostsSelector extends StatefulWidget {
  CostsSelector({
    required this.selected,
    required this.onSelect,
  });

  final int selected;
  final Function(CostGroup group) onSelect;

  @override
  _CostsSelectorState createState() => _CostsSelectorState();
}

class _CostsSelectorState extends State<CostsSelector> {
  var controller = TextEditingController();
  var _first = true;

  List<String> _getStrings(List<CostGroup> groups) {
    List<String> strings = [];
    for (CostGroup item in groups) {
      strings.add(item.label);
    }
    return strings;
  }

  Future<List<CostGroup>?> _getGroups(String masterUid) async {
    var groups = await NetHandler.getCostsGroups(masterUid);
    if (_first) {
      _setGroup(groups);
    }

    return groups;
  }

  void _setGroup(List<CostGroup>? groups) async {
    await Future.delayed(Duration(milliseconds: 250));
    groups?.forEach((element) {
      if (element.groupId == widget.selected) {
        setState(() {
          controller.text = element.label;
          widget.onSelect(element);
        });
      }
    });
    _first = false;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MasterProvider>(context);

    return FutureBuilder(
      future: _getGroups(provider.master.uid!),
      builder: (BuildContext context, AsyncSnapshot<List<CostGroup>?> snap) {
        if (snap.hasData) {
          return TextFieldWidget(
            hint: "Группа расходов",
            icon: LineIcons.stream,
            readOnly: true,
            controller: controller,
            onTap: () {
              ValuePicker(
                context: context,
                adapter: PickerDataAdapter<String>(
                  pickerdata: _getStrings(snap.data!),
                ),
                onConfirm: (index) {
                  setState(() {
                    controller.text = snap.data![index].label;
                    widget.onSelect(snap.data![index]);
                  });
                },
              );
            },
          );
        }
        return Shimmer(
          height: 55,
        );
      },
    );
  }
}
