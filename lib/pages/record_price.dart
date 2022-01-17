import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:atob_animation/atob_animation.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/price_cell.dart';
import 'package:master/pages/price.dart';

class RecordPricesPage extends StatefulWidget {
  RecordPricesPage({
    required this.masterUid,
    required this.count,
  });

  final String masterUid;
  final int count;

  @override
  _RecordPriceState createState() => _RecordPriceState();
}

class _RecordPriceState extends State<RecordPricesPage> {
  List<Price> _selected = [];
  var _count = 0;

  GlobalKey _targetkey = GlobalKey();
  GlobalKey _startkey = GlobalKey();

  late Offset _endOffset;
  late Offset _startOffset;

  _incrementCart() {
    var _overlayEntry = OverlayEntry(
      builder: (_) {
        return AtoBAnimation(
          startPosition: _startOffset,
          endPosition: _endOffset,
          dxCurveAnimation: 0,
          dyCurveAnimation: 0,
          duration: Duration(milliseconds: 400),
          opacity: 0.7,
          child: Container(
            margin: EdgeInsets.only(right: 15),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade600,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  width: 6,
                  height: 6,
                ),
              ),
            ),
          ),
        );
      },
    );
    // Show Overlay
    Overlay.of(context)!.insert(_overlayEntry);
    // wait for the animation to end
    Future.delayed(Duration(milliseconds: 400), () {
      _overlayEntry.remove();
    });
  }

  @override
  void initState() {
    super.initState();
    _count = widget.count;
    WidgetsBinding.instance!.addPostFrameCallback((c) {
      _endOffset = (_targetkey.currentContext!.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);
      _startOffset = (_startkey.currentContext!.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
          _selected,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                StandartAppBar(
                  title: Text(
                    "Выберите услуги",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            key: _targetkey,
                            margin: EdgeInsets.only(right: 15),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _count.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                FutureBuilder(
                  future: NetHandler.getPrices(widget.masterUid),
                  builder: (context, AsyncSnapshot<List<Price>?> snap) {
                    if (snap.hasData) {
                      if (snap.data!.isNotEmpty) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return PriceCell(
                                price: snap.data![index],
                                onTap: () => setState(() {
                                  _incrementCart();
                                  setState(() {
                                    _selected.add(snap.data![index]);
                                    _count++;
                                  });
                                }),
                                last: index == (snap.data!.length - 1),
                              );
                            },
                            childCount: snap.data!.length,
                          ),
                        );
                      } else {
                        return SliverToBoxAdapter(
                          child: EmptyBanner(
                            description:
                                "У Вас ещё не создано ни одной услуги. Для создания нажмите '+' внизу экрана.",
                          ),
                        );
                      }
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
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 80,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 60,
              right: 15,
              child: SafeArea(
                child: Container(
                  key: _startkey,
                  height: 25,
                  width: 25,
                ),
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).padding.bottom + 15,
              child: StandartButton(
                label: "Добавить услугу",
                onTap: () => MainRouter.nextPage(
                  context,
                  PricePage(
                    masterUid: widget.masterUid,
                  ),
                ).then(
                  (value) => setState(() {}),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
