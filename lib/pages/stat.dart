import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/all_records.dart';
import 'package:master/pages/all_reviews.dart';
import 'package:master/pages/all_shifts.dart';
import 'package:master/pages/costs.dart';
import 'package:master/pages/statistics.dart';
import 'package:master/pages/users.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/link.dart';
import 'package:master/widgets/master_rating.dart';
import 'package:provider/provider.dart';

class StatPage extends StatefulWidget {
  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MasterProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Статистика"),
          ),
          SliverToBoxAdapter(
            child: MasterRatingBuilder(
              masterUid: provider.master.uid!,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 15, top: 15),
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Сводный отчёт",
              icon: LineIcons.barChartAlt,
              onTap: () => MainRouter.nextPage(
                context,
                Statistics(
                  masterUid: provider.master.uid!,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Расходы",
              icon: LineIcons.minusCircle,
              onTap: () => MainRouter.nextPage(
                context,
                CostsPage(
                  masterUid: provider.master.uid!,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 15, top: 50),
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Клиенты",
              icon: LineIcons.user,
              onTap: () => MainRouter.nextPage(
                context,
                UsersPage(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Записи",
              icon: LineIcons.recordVinyl,
              onTap: () => MainRouter.nextPage(
                context,
                AllRecordsPage(
                  masterUid: provider.master.uid!,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Смены",
              icon: LineIcons.calendar,
              onTap: () => MainRouter.nextPage(
                context,
                AllShiftsPage(
                  masterUid: provider.master.uid!,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Отзывы",
              icon: LineIcons.comment,
              onTap: () => MainRouter.nextPage(
                context,
                AllReviewsPage(
                  masterUid: provider.master.uid!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
