import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/pages/new_cost.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/cost_cell.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/picker.dart';

class CostsPage extends StatefulWidget {
  CostsPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _CostsPageState createState() => _CostsPageState();
}

class _CostsPageState extends State<CostsPage> {
  static final _init = ConvertDate.dayBegin();
  var _firstDay = DateTime(_init.year, _init.month - 2, 1, 0);
  var _lastDay = DateTime(_init.year, _init.month + 2, 0);

  List<Cost> _costs = [];
  List<CostGroup> _groups = [];

  var _today = ConvertDate.dayBegin();
  var _selectedDate = _init;
  var _loading = true;

  void _updateList() async {
    setState(() {
      _loading = true;
    });

    var start = ConvertDate(context).secondsFromDate(_firstDay).toString();
    var end = ConvertDate(context).secondsFromDate(_lastDay).toString();
    var result = await NetHandler.getCosts(widget.masterUid, start, end);
    var groups = await NetHandler.getCostsGroups(widget.masterUid);

    setState(() {
      _costs = result ?? [];
      _groups = groups ?? [];
      _loading = false;
    });
  }

  String _getGroup(int id) {
    var group = "Другое";

    _groups.forEach((element) {
      if (element.groupId == id) {
        group = element.label;
      }
    });

    return group;
  }

  Widget _getList() {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      );
    } else {
      if (_costs.forDate(_selectedDate).isEmpty) {
        return SliverToBoxAdapter(
          child: EmptyBanner(
            description: "В этот день нет ни одного расходного ордера",
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var cost = _costs.forDate(_selectedDate)[index];
              return CostCell(
                cost: cost,
                group: _getGroup(cost.groupId),
                last: (index + 1) == _costs.forDate(_selectedDate).length,
                onTap: () => MainRouter.nextPage(
                  context,
                  NewCostPage(
                    masterUid: widget.masterUid,
                    cost: cost,
                  ),
                ).then(
                  (value) => _updateList(),
                ),
              );
            },
            childCount: _costs.forDate(_selectedDate).length,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              StandartAppBar(
                title: Text(
                  ConvertDate(context).fromDate(_today, "MMMM").capitalLetter(),
                ),
              ),
              SliverToBoxAdapter(
                child: CalendarPicker(
                  eventLoader: _costs.forDate,
                  selectDate: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  focusDate: (date) {
                    setState(() {
                      _today = date;
                    });
                  },
                ),
              ),
              _getList(),
              SliverToBoxAdapter(
                child: Container(
                  height: 120,
                ),
              ),
            ],
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).padding.bottom + 15,
            child: StandartButton(
              label: "Добавить расходный ордер",
              onTap: () => MainRouter.nextPage(
                context,
                NewCostPage(
                  masterUid: widget.masterUid,
                ),
              ).then(
                (value) => _updateList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
