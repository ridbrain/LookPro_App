import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/new_material.dart';
import 'package:master/services/answers.dart';
import 'package:master/widgets/buttons.dart';

class RecordCosts extends StatefulWidget {
  RecordCosts({
    required this.masterUid,
    required this.costs,
    required this.addCosts,
    required this.removeCost,
    required this.save,
    required this.edit,
  });

  final String masterUid;
  final List<Cost> costs;
  final bool edit;

  final Function(Cost cost) addCosts;
  final Function(Cost cost) removeCost;
  final Function() save;

  @override
  _RecordCostsState createState() => _RecordCostsState();
}

class _RecordCostsState extends State<RecordCosts> {
  bool _edit = false;

  void _addCost() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NewMaterialPage();
        },
      ),
    ) as Cost;

    widget.addCosts(result);
  }

  Widget? _getButtons() {
    if (widget.edit) {
      if (_edit) {
        return Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: StandartButton(
                label: "Добавить",
                color: Colors.blueGrey,
                onTap: _addCost,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: StandartButton(
                label: "Сохранить",
                onTap: () => setState(() {
                  widget.save();
                  _edit = false;
                }),
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        );
      }
      return StandartButton(
        label: "Изменить материалы",
        color: Colors.blueGrey[400],
        onTap: () => setState(() {
          _edit = true;
        }),
      );
    }
  }

  Widget _getBanner() {
    if (widget.costs.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(15, 20, 0, 20),
        alignment: Alignment.centerLeft,
        child: Text(
          "Материалы не добавлены",
          style: TextStyle(fontSize: 15),
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15, top: 0),
          height: 1,
          color: Colors.black.withOpacity(0.1),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                child: Icon(
                  LineIcons.box,
                  size: 40,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: widget.costs.length * 60,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.costs.length,
                        itemBuilder: (context, index) {
                          return CostCell(
                            cost: widget.costs[index],
                            delete: (_) => widget.removeCost(
                              widget.costs[index],
                            ),
                            last: index == (widget.costs.length - 1),
                          );
                        },
                      ),
                    ),
                    _getBanner(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, bottom: 15),
          height: 1,
          color: Colors.black.withOpacity(0.1),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
          child: _getButtons(),
        ),
      ],
    );
  }
}

class CostCell extends StatelessWidget {
  CostCell({
    required this.cost,
    required this.last,
    this.onTap,
    this.delete,
  });

  final Cost cost;
  final Function()? onTap;
  final Function(DismissDirection direction)? delete;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction:
          delete != null ? DismissDirection.endToStart : DismissDirection.none,
      onDismissed: delete,
      background: Container(
        child: Container(
          padding: EdgeInsets.only(right: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.red,
          ),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          cost.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(right: 15),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          cost.amount.toString() + " ₽",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  height: last ? 0 : 1,
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
