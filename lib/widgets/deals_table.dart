import 'dart:async';
import 'package:animated_check/animated_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/purchase.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/deal_cell.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class DealsTable extends StatefulWidget {
  @override
  _DealsTableState createState() => _DealsTableState();
}

class _DealsTableState extends State<DealsTable> {
  var loading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 100;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          LineIcons.dollarSign,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      child: Text(
                        "Выберите подходящий Вам период и сумму.",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            OffersTable(onTap: (deal) {
              setState(() {
                loading = true;
              });
              PurchaseApi.purchasePackage(deal).then((v) {
                setState(() {
                  loading = false;
                });
                if (v) {
                  Navigator.pop(context);
                }
              });
            }),
          ],
        ),
        Center(
          child: loading
              ? Container(
                  width: 80,
                  height: 80,
                  child: CupertinoActivityIndicator(),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }
}

class OffersTable extends StatefulWidget {
  OffersTable({
    required this.onTap,
  });

  final Function(Package deal) onTap;

  @override
  _OffersTableState createState() => _OffersTableState();
}

class _OffersTableState extends State<OffersTable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PurchaseApi.getOffers(),
      builder: (context, AsyncSnapshot<List<Offering>> snap) {
        if (snap.hasData) {
          var list = snap.data!
              .map((e) => e.availablePackages)
              .expand((element) => element)
              .toList();

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  child: DealCell(
                    deal: list[index],
                    onTap: (deal) => widget.onTap(deal),
                  ),
                );
              },
              childCount: list.length,
            ),
          );
        } else {
          return SliverToBoxAdapter(
            child: Container(
              height: 300,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

class RecordDone extends StatefulWidget {
  @override
  _RecordDoneState createState() => _RecordDoneState();
}

class _RecordDoneState extends State<RecordDone>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = new Tween<double>(begin: 0, end: 1).animate(
      new CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCirc,
      ),
    );
    Timer(Duration(milliseconds: 500), () {
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCheck(
          color: Colors.green,
          progress: animation,
          size: 170,
        ),
        Text(
          "Оплата прошла успешно!",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        StandartButton(
          label: "Готово",
          onTap: () => Navigator.pop(context),
        )
      ],
    );
  }
}
