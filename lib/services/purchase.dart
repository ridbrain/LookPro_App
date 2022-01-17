import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static Future init() async {
    await Purchases.setup(Constants.purchaseKey);
  }

  static Future setUID(String masterUid) async {
    await Purchases.setup(Constants.purchaseKey, appUserId: masterUid);
  }

  static Future logOut() async {
    await Purchases.logOut();
  }

  static Future<List<Offering>> getOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

class PurchaseDeals {
  static String getIdentifier(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.none:
        return "trial";
      case Entitlement.lite:
        return "lite_month";
      case Entitlement.base:
        return "base_month";
      case Entitlement.pro:
        return "pro_month";
      case Entitlement.max:
        return "max_month";
      default:
        return "";
    }
  }

  static IconData getIcon(String identifier) {
    switch (identifier) {
      case "trial":
        return LineIcons.clock;
      case "lite_month":
        return LineIcons.walking;
      case "base_month":
        return LineIcons.bicycle;
      case "pro_month":
        return LineIcons.car;
      case "max_month":
        return LineIcons.rocket;
      default:
        return LineIcons.exclamation;
    }
  }

  static String getLabel(String identifier) {
    switch (identifier) {
      case "trial":
        return "Пробный период";
      case "lite_month":
        return "Lite";
      case "base_month":
        return "Base";
      case "pro_month":
        return "Pro";
      case "max_month":
        return "Max";
      default:
        return "Ошибка";
    }
  }

  static List<String> getFunctions(String identifier) {
    switch (identifier) {
      case "trial":
        return [
          "Учёт записей",
          "Учёт расходов",
          "Полный учёт клиентов",
          "Отображение статистики",
          "Онлайн запись для клиентов",
          "Напоминания клиентам (Push/Звонок)",
        ];
      case "lite_month":
        return [
          "Учёт записей",
          "Частичный учёт клиентов",
        ];
      case "base_month":
        return [
          "Учёт записей",
          "Учёт расходов",
          "Полный учёт клиентов",
          "Отображение статистики",
        ];
      case "pro_month":
        return [
          "Учёт записей",
          "Учёт расходов",
          "Полный учёт клиентов",
          "Отображение статистики",
          "Онлайн запись для клиентов",
          "Напоминания клиентам (Push/Звонок)",
        ];
      case "max_month":
        return [
          "Учёт записей",
          "Учёт расходов",
          "Полный учёт клиентов",
          "Отображение статистики",
          "Онлайн запись для клиентов",
          "Напоминания клиентам (Push/SMS)",
        ];
      default:
        return ["Нет информации"];
    }
  }
}
