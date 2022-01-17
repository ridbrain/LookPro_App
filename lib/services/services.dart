import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Entitlement { none, lite, base, pro, max }

class StandartShift {
  StandartShift(this.start, this.end);
  final int start;
  final int end;
}

class PrefsHandler {
  PrefsHandler(this._preferences);

  final SharedPreferences _preferences;

  final String _masterUid = "masterUid";
  final String _masterName = "masterName";
  final String _masterAbout = "masterAbout";
  final String _masterPhone = "masterPhone";
  final String _masterEmail = "masterEmail";
  final String _masterExperience = "masterExperience";
  final String _masterBirthday = "masterBirthday";
  final String _masterGroup = "masterGroup";
  final String _masterImage = "masterImage";

  final String _review = "reviewRequest";
  final String _firstEntry = "firstEntry";
  final String _lastNotification = "lastNotification";
  final String _startShift = "startShift";
  final String _endShift = "endShift";
  final String _showLink = "showLink";

  static Future<PrefsHandler> getInstance() async {
    var shared = await SharedPreferences.getInstance();
    return PrefsHandler(shared);
  }

  bool getReviewStatus() {
    return _preferences.getBool(_review) ?? true;
  }

  void setReviewRequest() {
    _preferences.setBool(_review, false);
  }

  bool getShowLink() {
    return _preferences.getBool(_showLink) ?? true;
  }

  void setShowLink() {
    _preferences.setBool(_showLink, false);
  }

  bool isFirstEntry() {
    var answer = _preferences.getBool(_firstEntry) ?? true;
    _preferences.setBool(_firstEntry, false);
    return answer;
  }

  void setMaster(Master master) {
    _preferences.setString(_masterUid, master.uid ?? "");
    _preferences.setString(_masterName, master.name ?? "");
    _preferences.setString(_masterAbout, master.about ?? "");
    _preferences.setString(_masterPhone, master.phone ?? "");
    _preferences.setString(_masterEmail, master.email ?? "");
    _preferences.setInt(_masterExperience, master.experience ?? 0);
    _preferences.setInt(_masterBirthday, master.birthday ?? 0);
    _preferences.setString(_masterGroup, master.group ?? "");
    _preferences.setString(_masterImage, master.imageUrl ?? "");
  }

  Master getMaster() {
    return Master(
      uid: _preferences.getString(_masterUid) ?? "",
      name: _preferences.getString(_masterName),
      about: _preferences.getString(_masterAbout),
      phone: _preferences.getString(_masterPhone),
      email: _preferences.getString(_masterEmail),
      experience: _preferences.getInt(_masterExperience),
      birthday: _preferences.getInt(_masterBirthday),
      group: _preferences.getString(_masterGroup),
      imageUrl: _preferences.getString(_masterImage),
    );
  }

  void setMasterAbout(String value) {
    _preferences.setString(_masterAbout, value);
  }

  void setMasterEmail(String value) {
    _preferences.setString(_masterEmail, value);
  }

  void setMasterImage(String value) {
    _preferences.setString(_masterImage, value);
  }

  void setMasterGroup(String value) {
    _preferences.setString(_masterGroup, value);
  }

  int getLastNotificationId() {
    return _preferences.getInt(_lastNotification) ?? 0;
  }

  void setLastNotificationId(int id) {
    _preferences.setInt(_lastNotification, id);
  }

  StandartShift getStandartShift() {
    var start = _preferences.getInt(_startShift) ?? 0;
    var end = _preferences.getInt(_endShift) ?? 0;
    return StandartShift(start, end);
  }

  void setStandartShift(int start, int end) {
    _preferences.setInt(_startShift, start);
    _preferences.setInt(_endShift, end);
  }
}

class MasterProvider extends ChangeNotifier {
  MasterProvider(
    this._master,
    this._subscribeInfo,
  ) {
    purchaserListener();
  }

  Master _master;
  SubscribeInfo _subscribeInfo;

  Master get master => _master;
  SubscribeInfo get subscribeInfo => _subscribeInfo;
  bool get hasMaster => _master.uid != "";

  static Future<MasterProvider> init() async {
    final prefs = await PrefsHandler.getInstance();
    final master = prefs.getMaster();

    await PurchaseApi.init();

    return MasterProvider(master, await getEntitlement());
  }

  void purchaserListener() {
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      updateStatus();
    });
  }

  void setMaster(Master master) {
    PrefsHandler.getInstance().then((value) => value.setMaster(master));
    PurchaseApi.setUID(master.uid!);
    _master = master;
    notifyListeners();
  }

  void setMasterAbout(String text) {
    PrefsHandler.getInstance().then((value) => value.setMasterAbout(text));
    _master.about = text;
    notifyListeners();
  }

  void setMasterEmail(String text) {
    PrefsHandler.getInstance().then((value) => value.setMasterEmail(text));
    _master.email = text;
    notifyListeners();
  }

  void setMasterImage(String text) {
    PrefsHandler.getInstance().then((value) => value.setMasterImage(text));
    _master.imageUrl = text;
    notifyListeners();
  }

  void setMasterGroup(String text) {
    PrefsHandler.getInstance().then((value) => value.setMasterGroup(text));
    _master.group = text;
    notifyListeners();
  }

  Future updateStatus() async {
    _subscribeInfo = await getEntitlement();
    notifyListeners();
  }

  static Future<SubscribeInfo> getEntitlement() async {
    final info = await Purchases.getPurchaserInfo();
    final entitlements = info.entitlements.active.values.toList();

    var entitlement = Entitlement.none;
    var store = Store.unknownStore;
    var url = info.managementURL ?? "";

    entitlements.forEach((active) {
      Entitlement.values.forEach((value) {
        if (active.identifier == value.getValue()) {
          entitlement = value;
          store = active.store;
        }
      });
    });

    return SubscribeInfo(entitlement, store, url);
  }
}

class SubscribeInfo {
  SubscribeInfo(
    this.entitlement,
    this.store,
    this.url,
  );

  Entitlement entitlement;
  Store store;
  String url;
}
