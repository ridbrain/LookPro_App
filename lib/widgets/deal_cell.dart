import 'package:flutter/material.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/purchase.dart';
import 'package:purchases_flutter/object_wrappers.dart';

class DealCell extends StatelessWidget {
  DealCell({
    required this.deal,
    required this.onTap,
  });

  final Package deal;
  final Function(Package package) onTap;

  @override
  Widget build(BuildContext context) {
    var functions = PurchaseDeals.getFunctions(deal.identifier);

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: Constants.radius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Constants.radius,
          onTap: () => onTap(deal),
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      PurchaseDeals.getIcon(deal.identifier),
                      color: Colors.blue,
                      size: 22,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        PurchaseDeals.getLabel(deal.identifier),
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${deal.product.price.toStringAsFixed(2)} ₽",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          " / месяц",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  color: Colors.black.withOpacity(0.1),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 8),
                  height: 1,
                ),
                Container(
                  height: functions.length * 25,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: functions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 25,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              functions[index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
