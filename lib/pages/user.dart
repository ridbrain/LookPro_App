import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/record.dart';
import 'package:master/pages/records.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/link.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/user_reviews.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  UserPage({
    required this.masterUid,
    required this.user,
  });

  final String masterUid;
  final Customer user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Record> _records = [];
  bool _loading = true;

  List<Record> _filter(int status) {
    return _records.where((e) => e.status == status).toList();
  }

  void _loadRecords() async {
    setState(() {
      _loading = true;
    });

    var result = await NetHandler.getUserRecords(
      widget.masterUid,
      widget.user.userId.toString(),
    );

    setState(() {
      _records = result ?? [];
      _loading = false;
    });
  }

  String _getLastDate() {
    var date = ConvertDate(context).fromUnix(
      widget.user.lastDate,
      "dd.MM.yyyy",
    );

    return "Последняя запись: $date";
  }

  void _openWhatsApp() async {
    var result = await launch("whatsapp://send?phone=${widget.user.phone}");

    if (!result) {
      StandartSnackBar.show(
        context,
        "Для связи с клиентом установите WhatsApp",
        SnackBarStatus.warning(),
      );
    }
  }

  void _openRecords(int status, String title) {
    if (_filter(status).isNotEmpty) {
      MainRouter.nextPage(
        context,
        RecordsPage(
          records: _filter(status),
          title: title,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Клиент"),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 15, 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Constants.radius,
                      boxShadow: Constants.shadow,
                    ),
                    child: Icon(
                      LineIcons.user,
                      size: 50,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Всего записей: ${widget.user.recordsCount}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _getLastDate(),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          SliverToBoxAdapter(
            child: BigLink(
              icon: LineIcons.whatSApp,
              label: "WhatsApp",
              subLabel: widget.user.phone.getPhoneFormatedString(),
              loading: false,
              onTap: _openWhatsApp,
            ),
          ),
          SliverToBoxAdapter(
            child: RecordNote(
              masterUid: widget.masterUid,
              userId: widget.user.userId.toString(),
            ),
          ),
          SliverToBoxAdapter(
            child: UserReviews(
              masterUid: widget.masterUid,
              userId: widget.user.userId.toString(),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 15, top: 50),
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          SliverToBoxAdapter(
            child: BigLink(
              icon: LineIcons.arrowCircleRight,
              label: "Активные записи",
              subLabel: _filter(1).length.toString(),
              loading: _loading,
              onTap: () => _openRecords(1, "Активные"),
            ),
          ),
          SliverToBoxAdapter(
            child: BigLink(
              icon: LineIcons.wallet,
              label: "Записи к оплате",
              subLabel: _filter(2).length.toString(),
              loading: _loading,
              onTap: () => _openRecords(2, "К оплате"),
            ),
          ),
          SliverToBoxAdapter(
            child: BigLink(
              icon: LineIcons.checkCircle,
              label: "Выполненные записи",
              subLabel: _filter(3).length.toString(),
              loading: _loading,
              onTap: () => _openRecords(3, "Выполненные"),
            ),
          ),
          SliverToBoxAdapter(
            child: BigLink(
              icon: LineIcons.timesCircle,
              label: "Отменённые записи",
              subLabel: _filter(4).length.toString(),
              loading: _loading,
              onTap: () => _openRecords(4, "Отменённые"),
            ),
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
