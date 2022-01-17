import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/places.dart';
import 'package:master/pages/prices.dart';
import 'package:master/pages/record.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/category_selector.dart';
import 'package:master/widgets/convert_date.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/qr_code.dart';
import 'package:master/widgets/record_cell.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({
    required this.masterUid,
    required this.entitlement,
  });

  final String masterUid;
  final Entitlement entitlement;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Record> _records = [];
  List<Notifications> _notifications = [];
  List<int> _badges = [];

  var _loading = true;
  var _index = 0;

  var _place = false;
  var _price = false;
  var _link = false;

  void _update() async {
    setState(() {
      _loading = true;
    });

    var notifications = await NetHandler.getNotifications(widget.masterUid);
    var records = await NetHandler.getRecords(widget.masterUid, "0");

    setState(() {
      _notifications = notifications ?? [];
      _records = records ?? [];
      _loading = false;
    });
  }

  void _updateLastId(String masterUid) async {
    var id = await NetHandler.getLastNotificationId(masterUid);
    (await PrefsHandler.getInstance()).setLastNotificationId(id);

    setState(() {
      _badges.remove(1);
    });
  }

  void _checkNotifications() async {
    var id = await NetHandler.getLastNotificationId(widget.masterUid);
    var last = (await PrefsHandler.getInstance()).getLastNotificationId();

    if (last < id) {
      setState(() {
        _badges.add(1);
      });
    }
  }

  Widget _getEmptyBanner() {
    if (_index == 0) {
      if (!_place && !_price && !_link) {
        return SliverToBoxAdapter(
          child: EmptyBanner(description: "Новых записей пока нет"),
        );
      } else {
        return SliverToBoxAdapter(
          child: SizedBox.shrink(),
        );
      }
    } else {
      return SliverToBoxAdapter(
        child: EmptyBanner(description: "У Вас ещё нет уведомлений"),
      );
    }
  }

  Widget _getPage(String masterUid) {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      );
    }
    if (_index == 0) {
      if (_records.isNotEmpty) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return RecordCell(
                record: _records[index],
                number: (index + 1).toString(),
                last: false,
                onTap: () => MainRouter.nextPage(
                  context,
                  RecordPage(record: _records[index]),
                ).then(
                  (value) => _update(),
                ),
              );
            },
            childCount: _records.length,
          ),
        );
      } else {
        return _getEmptyBanner();
      }
    } else {
      _updateLastId(masterUid);
      if (_notifications.isNotEmpty) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return NotificationCell(
                notification: _notifications[index],
              );
            },
            childCount: _notifications.length,
          ),
        );
      } else {
        return _getEmptyBanner();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkNotifications();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("События"),
          ),
          SliverToBoxAdapter(
            child: CategorySelector(
              onTap: (index) => setState(() {
                _index = index;
              }),
              badges: _badges,
              categies: [
                "Ожидают действия",
                "Уведомления",
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _index == 0
                ? CheckPlacesLink(
                    masterUid: widget.masterUid,
                    update: (show) => setState(() {
                      _place = show;
                    }),
                  )
                : SizedBox.shrink(),
          ),
          SliverToBoxAdapter(
            child: _index == 0
                ? CheckPricesLink(
                    masterUid: widget.masterUid,
                    update: (show) => setState(() {
                      _price = show;
                    }),
                  )
                : SizedBox.shrink(),
          ),
          SliverToBoxAdapter(
            child: _index == 0
                ? CheckUrlLink(
                    masterUid: widget.masterUid,
                    entitlement: widget.entitlement,
                    update: (show) => setState(() {
                      _link = show;
                    }),
                  )
                : SizedBox.shrink(),
          ),
          _getPage(widget.masterUid),
          SliverToBoxAdapter(
            child: Container(height: 50),
          ),
        ],
      ),
    );
  }
}

class CheckPlacesLink extends StatefulWidget {
  CheckPlacesLink({
    required this.masterUid,
    required this.update,
  });

  final String masterUid;
  final Function(bool show) update;

  @override
  _CheckPlacesLinkState createState() => _CheckPlacesLinkState();
}

class _CheckPlacesLinkState extends State<CheckPlacesLink> {
  var _show = false;

  void _update() async {
    var prices = (await NetHandler.getPlaces(widget.masterUid))?.length ?? 0;

    setState(() {
      _show = prices == 0;
    });

    widget.update(_show);
  }

  Widget _getLink() {
    return CheckLink(
      label: "Добавьте рабочий адрес",
      description: "Необходимо для активации профиля",
      icon: LineIcons.mapMarked,
      onTap: () => MainRouter.nextPage(
        context,
        PlacesPage(),
      ).then(
        (value) => _update(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade(
      child: _show ? _getLink() : SizedBox.shrink(),
    );
  }
}

class CheckPricesLink extends StatefulWidget {
  CheckPricesLink({
    required this.masterUid,
    required this.update,
  });

  final String masterUid;
  final Function(bool show) update;

  @override
  _CheckPricesLinkState createState() => _CheckPricesLinkState();
}

class _CheckPricesLinkState extends State<CheckPricesLink> {
  var _show = false;

  void _update() async {
    var prices = (await NetHandler.getPrices(widget.masterUid))?.length ?? 0;

    setState(() {
      _show = prices == 0;
    });

    widget.update(_show);
  }

  Widget _getLink() {
    return CheckLink(
      label: "Добавьте услуги",
      description: "Необходимо для активации профиля",
      icon: LineIcons.rubleSign,
      onTap: () => MainRouter.nextPage(
        context,
        PricesPage(
          masterUid: widget.masterUid,
        ),
      ).then(
        (value) => _update(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade(
      child: _show ? _getLink() : SizedBox.shrink(),
    );
  }
}

class CheckUrlLink extends StatefulWidget {
  CheckUrlLink({
    required this.masterUid,
    required this.entitlement,
    required this.update,
  });

  final String masterUid;
  final Entitlement entitlement;
  final Function(bool show) update;

  @override
  _CheckUrlLinkState createState() => _CheckUrlLinkState();
}

class _CheckUrlLinkState extends State<CheckUrlLink> {
  var _show = false;

  void _update() async {
    if (_ckeckLink()) {
      var prefs = await PrefsHandler.getInstance();

      setState(() {
        _show = prefs.getShowLink();
      });

      widget.update(_show);
    }
  }

  bool _ckeckLink() {
    switch (widget.entitlement) {
      case Entitlement.none:
        return true;
      case Entitlement.lite:
        return false;
      case Entitlement.base:
        return false;
      case Entitlement.pro:
        return true;
      case Entitlement.max:
        return true;
      default:
        return true;
    }
  }

  Widget _getLink() {
    return CheckLink(
      label: "Поделитесь ссылкой",
      description: "Клиенты смогут записываться самостоятельно",
      icon: LineIcons.qrcode,
      onTap: () => MainRouter.nextPage(
        context,
        QrCodeLook(
          masterUid: widget.masterUid,
        ),
      ).then(
        (value) => _update(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade(
      child: _show ? _getLink() : SizedBox.shrink(),
    );
  }
}

class NotificationCell extends StatelessWidget {
  NotificationCell({
    required this.notification,
  });

  final Notifications notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: Constants.radius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LineIcons.bell,
            color: Colors.blueGrey,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ConvertDate(context).fromUnix(
                    notification.date,
                    "dd MMMM в HH:mm",
                  ),
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckLink extends StatelessWidget {
  CheckLink({
    required this.label,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String description;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          description,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 70),
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
