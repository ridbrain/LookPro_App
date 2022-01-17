import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/pages/price.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/price_cell.dart';

class PricesPage extends StatefulWidget {
  PricesPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _PricesPageState createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  List<Price> _prices = [];
  bool _loading = true;

  void _updatePrices() async {
    setState(() {
      _loading = true;
    });

    var prices = await NetHandler.getPrices(widget.masterUid);

    setState(() {
      _prices = prices ?? [];
      _loading = false;
    });
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
      if (_prices.isEmpty) {
        return SliverToBoxAdapter(
          child: EmptyBanner(
            description: "У Вас ещё не добавлено ни одной услуги",
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var price = _prices[index];
              return PriceCell(
                price: price,
                last: index == (_prices.length - 1),
                onTap: () => MainRouter.nextPage(
                  context,
                  PricePage(
                    masterUid: widget.masterUid,
                    price: price,
                  ),
                ).then(
                  (value) => _updatePrices(),
                ),
              );
            },
            childCount: _prices.length,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updatePrices();
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
                title: Text("Услуги и цены"),
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
              label: "Добавить услугу",
              onTap: () => MainRouter.nextPage(
                context,
                PricePage(
                  masterUid: widget.masterUid,
                ),
              ).then(
                (value) => _updatePrices(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
