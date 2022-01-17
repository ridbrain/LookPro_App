import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/offerings.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/purchase.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/link.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/entitlement_info_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageSubscribePage extends StatefulWidget {
  @override
  _ManageSubscribePageState createState() => _ManageSubscribePageState();
}

class _ManageSubscribePageState extends State<ManageSubscribePage> {
  String _getDescription(SubscribeInfo subscribeInfo) {
    if (subscribeInfo.entitlement == Entitlement.none) {
      return "Бесплатный период длится неделю, после чего необходимо будет выбрать один из вариантов подписки.";
    }
    if (subscribeInfo.store == Store.appStore) {
      return "У Вас действует подписка, оформленная через сервис подписок Apple. Подписка продлевается автоматически, средства списываются с карты привязанной к Apple ID.";
    }
    if (subscribeInfo.store == Store.playStore) {
      return "У Вас действует подписка, оформленная через сервис подписок Google. Подписка продлевается автоматически, средства списываются с карты привязанной к Google Account.";
    }
    if (subscribeInfo.store == Store.promotional) {
      return "Вам предоставлен промо доступ, за дополнительной информацией обратитесь в службу поддержки.";
    }
    return "Ошибка";
  }

  Widget _getStore(SubscribeInfo subscribeInfo) {
    if (subscribeInfo.store == Store.appStore) {
      return StandartLink(
        label: "App Store",
        onTap: () => launch(subscribeInfo.url),
      );
    }
    if (subscribeInfo.store == Store.playStore) {
      return StandartLink(
        label: "Google Play",
        onTap: () => launch(subscribeInfo.url),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MasterProvider>(context);
    var identifier = PurchaseDeals.getIdentifier(
      provider.subscribeInfo.entitlement,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Подписка"),
          ),
          SliverToBoxAdapter(
            child: SubscribeStatus(
              icon: PurchaseDeals.getIcon(identifier),
              label: PurchaseDeals.getLabel(identifier),
              description: _getDescription(provider.subscribeInfo),
              fuctions: PurchaseDeals.getFunctions(identifier),
            ),
          ),
          SliverToBoxAdapter(
            child: FuncStatus(
              label: "Записи",
              description:
                  "Ведение учёта Ваших записей. Есть возможность отмечать записи как «Выполненные, Оплаченные, Отменённые»",
              entitlements: [
                Entitlement.none,
                Entitlement.lite,
                Entitlement.base,
                Entitlement.pro,
                Entitlement.max,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: FuncStatus(
              label: "Расходы",
              description:
                  "Ведение учёта Ваших расходов. Добавляйте расходы, распределяйте по категориям и выявляйте слабые места.",
              entitlements: [
                Entitlement.none,
                Entitlement.base,
                Entitlement.pro,
                Entitlement.max,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: FuncStatus(
              label: "Статистика",
              description:
                  "Отображение статистики с учётом выполненных услуг, расходов и скидок. Вывод топ 5 услуг за месяц.",
              entitlements: [
                Entitlement.none,
                Entitlement.base,
                Entitlement.pro,
                Entitlement.max,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: FuncStatus(
              label: "Онлайн запись",
              description:
                  "Отображение в списке мастеров онлайн сервиса LOOK, где клиенты будут записываться к Вам онлайн 24/7, без отрыва Вас от работы или отдыха.",
              entitlements: [
                Entitlement.none,
                Entitlement.pro,
                Entitlement.max,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: FuncStatus(
              label: "Напоминания клиентам",
              description:
                  "Напоминания клиентам отправляются за день до записи в 20:00, если у клиента установлено приложение LOOK то ему придёт PUSH уведомление, если нет - придёт SMS или поступит звонок, в зависимости от подписки.",
              entitlements: [
                Entitlement.none,
                Entitlement.pro,
                Entitlement.max,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 40, 20, 40),
              child: Text(
                "Если Вас не устраивает текущий функционал, подписку всегда можно поменять.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 14,
                ),
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
            child: StandartLink(
              label: "Варианты подписок",
              onTap: () => MainRouter.nextPage(
                context,
                OfferingsPage(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _getStore(provider.subscribeInfo),
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

class SubscribeStatus extends StatelessWidget {
  SubscribeStatus({
    required this.icon,
    required this.label,
    required this.description,
    required this.fuctions,
  });

  final IconData icon;
  final String label;
  final String description;
  final List<String> fuctions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: Constants.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.green,
                size: 22,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          // Container(
          //   color: Colors.black.withOpacity(0.1),
          //   margin: const EdgeInsets.fromLTRB(0, 10, 0, 8),
          //   height: 1,
          // ),
          // Container(
          //   height: fuctions.length * 25,
          //   child: ListView.builder(
          //     padding: const EdgeInsets.all(0),
          //     physics: NeverScrollableScrollPhysics(),
          //     itemCount: fuctions.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         height: 25,
          //         child: Row(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Container(
          //               width: 7,
          //               height: 7,
          //               decoration: BoxDecoration(
          //                 color: Colors.green,
          //                 shape: BoxShape.circle,
          //               ),
          //             ),
          //             SizedBox(
          //               width: 10,
          //             ),
          //             Text(
          //               fuctions[index],
          //               overflow: TextOverflow.ellipsis,
          //               style: TextStyle(
          //                 fontSize: 14,
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
          Container(
            color: Colors.black.withOpacity(0.1),
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 10),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FuncStatus extends StatelessWidget {
  FuncStatus({
    required this.label,
    required this.description,
    required this.entitlements,
  });

  final String label;
  final String description;
  final List<Entitlement> entitlements;

  bool _getStatus(Entitlement status) {
    var result = false;

    entitlements.forEach((element) {
      if (element == status) {
        result = true;
      }
    });

    return result;
  }

  Widget _getIcon(Entitlement status) {
    if (_getStatus(status)) {
      return Icon(
        LineIcons.check,
        color: Colors.green,
        size: 22,
      );
    } else {
      return Icon(
        LineIcons.times,
        color: Colors.red,
        size: 22,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MasterProvider>(context);
    var status = provider.subscribeInfo.entitlement;

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: Constants.radius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Constants.radius,
          child: Container(
            height: 45,
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              children: [
                _getIcon(status),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  LineIcons.infoCircle,
                  color: Colors.black,
                  size: 22,
                ),
              ],
            ),
          ),
          onTap: () => MainRouter.openBottomSheet(
            height: 250,
            context: context,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              alignment: Alignment.center,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
