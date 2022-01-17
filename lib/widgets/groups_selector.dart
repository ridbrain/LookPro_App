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

class GroupsSelector extends StatefulWidget {
  GroupsSelector({
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final Function(Group group) onSelect;

  @override
  _GroupsSelectorState createState() => _GroupsSelectorState();
}

class _GroupsSelectorState extends State<GroupsSelector> {
  var controller = TextEditingController();
  var _first = true;

  List<String> _getStrings(List<Group> groups) {
    List<String> strings = [];
    for (Group item in groups) {
      strings.add(item.groupLabel);
    }
    return strings;
  }

  Future<List<Group>?> _getGroups(String masterUid) async {
    var groups = await NetHandler.getGroups(masterUid);
    if (_first) {
      _setGroup(groups);
    }

    return groups;
  }

  void _setGroup(List<Group>? groups) async {
    await Future.delayed(Duration(milliseconds: 250));
    groups?.forEach((element) {
      if (element.masterLabel == widget.selected) {
        setState(() {
          controller.text = element.groupLabel;
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
      builder: (BuildContext context, AsyncSnapshot<List<Group>?> snap) {
        if (snap.hasData) {
          return TextFieldWidget(
            hint: "Группа услуг",
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
                    controller.text = snap.data![index].groupLabel;
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
