import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/main.dart';
import 'package:master/services/auth.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/purchase.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/deals_table.dart';
import 'package:master/widgets/pdf.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class OfferingsPage extends StatefulWidget {
  OfferingsPage({
    this.first = false,
  });

  final bool first;

  @override
  _OfferingsPageState createState() => _OfferingsPageState();
}

class _OfferingsPageState extends State<OfferingsPage> {
  static const _style = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  var _loading = false;

  List<Widget>? _getActions() {
    if (widget.first) {
      return [
        IconButton(
          icon: Icon(LineIcons.alternateSignOut),
          onPressed: () => AuthService().signOut(context),
        ),
      ];
    }
  }

  Widget _getDescription() {
    if (widget.first) {
      return Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 20),
        child: Column(
          children: [
            Text(
              "Ой! Пробная неделя закончилась.",
              textAlign: TextAlign.center,
              style: _style,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Не переживайте, все записи сохранены и если остались записи на будущее, клиенты будут уведомлены. Но для продолжения работы необходимо выбрать подписку.",
              textAlign: TextAlign.center,
              style: _style,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Подписку можно будет поменять в любое время или вовсе отказаться от регулярных списаний в настройках приложения.",
              textAlign: TextAlign.center,
              style: _style,
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
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
                  widget.first ? "Выберите подписку" : "Варианты подписок",
                ),
                actions: _getActions(),
              ),
              SliverToBoxAdapter(
                child: _getDescription(),
              ),
              OffersTable(
                onTap: (deal) {
                  setState(() {
                    _loading = true;
                  });
                  PurchaseApi.purchasePackage(deal).then((v) {
                    setState(() {
                      _loading = false;
                    });
                    if (v) {
                      MainRouter.changeMainPage(context, LoadingApp());
                    }
                  });
                },
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => MainRouter.nextPage(
                          context,
                          PDFPages(
                            title: "Договор-оферта",
                            pdfUrl:
                                "https://server.confeta.app/docs/license.pdf",
                          ),
                        ),
                        borderRadius: Constants.radius,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                          child: Text(
                            "Условия использования",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      InkWell(
                        onTap: () async {
                          try {
                            await Purchases.restoreTransactions();
                          } on PlatformException catch (e) {
                            print(e.toString());
                          }
                        },
                        borderRadius: Constants.radius,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                          child: Text(
                            "Восстановить покупки",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                ),
              ),
            ],
          ),
          Center(
            child: _loading
                ? Container(
                    width: 150,
                    height: 150,
                    child: CupertinoActivityIndicator(),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: Constants.radius,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
