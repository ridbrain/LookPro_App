import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/picker.dart';
import 'package:master/widgets/shimmer.dart';

class Statistics extends StatefulWidget {
  Statistics({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  static final _init = ConvertDate.dayBegin();
  var _firstDay = DateTime(_init.year, _init.month, 1, 0);
  var _lastDay = DateTime(_init.year, _init.month + 1, 0, 0);

  bool _loading = true;
  Stats? _stats;

  void _updateStat() async {
    setState(() {
      _loading = true;
    });

    var resuilt = await NetHandler.getStats(
      widget.masterUid,
      ConvertDate(context).secondsFromDate(_firstDay).toString(),
      ConvertDate(context).secondsFromDate(_lastDay).toString(),
    );

    setState(() {
      _stats = resuilt;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateStat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Сводный отчёт"),
          ),
          SliverToBoxAdapter(
            child: IntervalSelector(
              first: _firstDay,
              last: _lastDay,
              select: (first, last) {
                _firstDay = first;
                _lastDay = last;
                _updateStat();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: StatCard(
              stats: _stats,
              loading: _loading,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  StatCard({
    required this.stats,
    required this.loading,
  });

  final Stats? stats;
  final bool loading;

  String getTitle(int index) {
    if (stats == null) {
      return "-";
    } else {
      if (stats!.prices!.length >= index + 1) {
        return stats!.prices![index].title.capitalLetter();
      } else {
        return "-";
      }
    }
  }

  String getCount(int index) {
    if (stats == null) {
      return "-";
    } else {
      if (stats!.prices!.length >= index + 1) {
        return stats!.prices![index].count.toString();
      } else {
        return "-";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardView(
          children: [
            StatItem(
              label: "Прибыль",
              value: stats?.profit ?? "",
              icon: LineIcons.plusCircle,
              color: Colors.green,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: "Расходы",
              value: stats?.costs ?? "",
              icon: LineIcons.minusCircle,
              color: Colors.red,
              loading: loading,
            ),
          ],
        ),
        CardView(
          children: [
            StatItem(
              label: "Выручка",
              value: stats?.amount ?? "",
              icon: LineIcons.coins,
              color: Colors.green,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: "Прогноз",
              value: stats?.estimation ?? "",
              icon: LineIcons.barChartAlt,
              color: Colors.blue,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: "Сумма скидок",
              value: stats?.discount ?? "",
              icon: LineIcons.percent,
              color: Colors.orange,
              loading: loading,
            ),
          ],
        ),
        CardView(
          children: [
            StatItem(
              label: "Выполнено услуг",
              value: stats?.priceCount ?? "",
              icon: LineIcons.checkCircle,
              color: Colors.green,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: "Проработано часов",
              value: stats?.hours ?? "",
              icon: LineIcons.history,
              color: Colors.orange,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: "Средняя прибыль в час",
              value: stats?.perHour ?? "",
              icon: LineIcons.wallet,
              color: Colors.blue,
              loading: loading,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
          child: Text(
            "Топ 5 услуг",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CardView(
          children: [
            StatItem(
              label: getTitle(0),
              value: getCount(0),
              icon: LineIcons.plusCircle,
              color: Colors.blueGrey,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: getTitle(1),
              value: getCount(1),
              icon: LineIcons.plusCircle,
              color: Colors.blueGrey,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: getTitle(2),
              value: getCount(2),
              icon: LineIcons.plusCircle,
              color: Colors.blueGrey,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: getTitle(3),
              value: getCount(3),
              icon: LineIcons.plusCircle,
              color: Colors.blueGrey,
              loading: loading,
            ),
            StatSeparatot(),
            StatItem(
              label: getTitle(4),
              value: getCount(4),
              icon: LineIcons.plusCircle,
              color: Colors.blueGrey,
              loading: loading,
            ),
          ],
        )
      ],
    );
  }
}

class StatSeparatot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.fromLTRB(42, 0, 10, 0),
      color: Colors.grey.withOpacity(0.3),
    );
  }
}

class StatItem extends StatelessWidget {
  StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.loading,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(12, 0, 15, 0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            child: loading
                ? Shimmer(
                    width: 45,
                    height: 15,
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  CardView({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: Constants.radius,
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
