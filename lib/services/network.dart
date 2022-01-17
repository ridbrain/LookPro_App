import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:path_provider/path_provider.dart';

class NetHandler {
  static Future<String?> request({
    required String url,
    Map<String, String>? params,
  }) async {
    var response = await http.post(
      Uri.parse(Constants().apiUrl + url),
      body: params,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  static Future<Answer?> getAuth(
    String phone,
  ) async {
    var address = 'getAuth.php';

    var data = await request(url: address, params: {
      "phone": phone,
    });

    if (data != null) {
      return answerFromJsonText(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> confirmAuth(
    String verification,
    String code,
    String token,
    String os,
  ) async {
    var address = 'confirmAuth.php';

    var data = await request(url: address, params: {
      "verification": verification,
      "code": code,
      "token": token,
      "os": os,
    });

    if (data != null) {
      return answerFromJsonMaster(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> confirmFirebaseAuth(
    String idToken,
    String token,
    String os,
  ) async {
    var address = 'confirmFirebaseAuth.php';

    var data = await request(url: address, params: {
      "id_token": idToken,
      "token": token,
      "os": os,
    });

    if (data != null) {
      return answerFromJsonMaster(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> setProfile(
    String masterUid,
    String groupId,
    String name,
    String birthday,
    String email,
    String experience,
    String photo,
  ) async {
    var address = 'setMasterProfile.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "group_id": groupId,
      "name": name,
      "birthday": birthday,
      "email": email,
      "experience": experience,
      "photo": photo,
    });

    if (data != null) {
      return answerFromJsonMaster(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> checkProfile(String masterUid) async {
    var address = 'checkProfile.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    if (data != null) {
      return answerFromJsonText(data);
    }
  }

  static Future<Answer?> checkTrial(String masterUid) async {
    var address = 'checkTrial.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    if (data != null) {
      return answerFromJsonText(data);
    }
  }

  static Future<List<Group>?> getGroups(String masterUid) async {
    var address = 'getGroups.php';
    var file = await CashHandler.getFile(address);
    var cash = await CashHandler.getCash(file, 10);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonGrops(cash).result?.groups;
    } else {
      var data = await request(url: address, params: {
        "master_uid": masterUid,
      });

      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonGrops(data).result?.groups;
      } else {
        if (cash != null) {
          return answerFromJsonGrops(cash).result?.groups;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<CostGroup>?> getCostsGroups(String masterUid) async {
    var address = 'getCostsGroups.php';
    var file = await CashHandler.getFile(address);
    var cash = await CashHandler.getCash(file, 10);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonCostsGroups(cash).result?.costsGroups;
    } else {
      var data = await request(url: address, params: {
        "master_uid": masterUid,
      });

      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonCostsGroups(data).result?.costsGroups;
      } else {
        if (cash != null) {
          return answerFromJsonCostsGroups(cash).result?.costsGroups;
        } else {
          return null;
        }
      }
    }
  }

  static Future<String?> getMasterPhoto(String masterUid) async {
    var address = 'getMasterPhoto.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonText(data).result?.text;
    } else {
      return null;
    }
  }

  static Future<String> getUserNote(String masterUid, String userId) async {
    var address = 'getNote.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "user_id": userId,
    });

    // await Future.delayed(Duration(seconds: 5));

    if (data != null) {
      return answerFromJsonText(data).result?.text ?? "Заметки нет";
    } else {
      return "Заметки нет";
    }
  }

  static Future<String?> addPhoto(
    String masterUid,
    String photo,
  ) async {
    var address = 'addPhoto.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "photo": photo,
    });

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> deleteCost(
    String masterUid,
    String costId,
  ) async {
    var address = 'deleteCost.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "cost_id": costId,
    });

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> deletePhoto(
    String masterUid,
    String photoId,
  ) async {
    var address = 'deletePhoto.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "photo_id": photoId,
    });

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<MasterRating?> getMasterRating(String masterUid) async {
    var address = 'getMasterRating.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonMasterRating(data).result?.masterRating;
    } else {
      return null;
    }
  }

  static Future<int?> getStatusProfile(String masterUid) async {
    var address = 'getStatusProfile.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 2));

    if (data != null) {
      return answerFromJsonNumber(data).result?.number;
    } else {
      return null;
    }
  }

  static Future<Master?> editMasterInfo(
    String masterUid,
    String name,
    String email,
    String groupId,
    String about,
    String photo,
  ) async {
    var address = 'editMasterInfo.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "name": name,
      "group_id": groupId,
      "email": email,
      "about": about,
      "photo": photo,
    });

    if (data != null) {
      return answerFromJsonMaster(data).result?.master;
    } else {
      return null;
    }
  }

  static Future<List<Record>?> getRecords(
    String masterUid,
    String status,
  ) async {
    var address = 'getRecords.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "status": status,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonRecords(data).result?.records;
    } else {
      return null;
    }
  }

  static Future<List<Record>?> getRecordsInterval(
    String masterUid,
    String status,
    String start,
    String end,
  ) async {
    var address = 'getRecordsInterval.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "status": status,
      "start": start,
      "end": end,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonRecords(data).result?.records;
    } else {
      return null;
    }
  }

  static Future<List<Record>?> getUserRecords(
    String masterUid,
    String userId,
  ) async {
    var address = 'getUserRecords.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "user_id": userId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonRecords(data).result?.records;
    } else {
      return null;
    }
  }

  static Future<List<Customer>?> getContacts(
    String masterUid,
  ) async {
    var address = 'getContacts.php';
    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    if (data != null) {
      return answerFromJsonCustomers(data).result?.customers;
    } else {
      return null;
    }
  }

  static Future<Customer?> getUser(String masterUid, String userId) async {
    var address = 'getUser.php';
    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "user_id": userId,
    });

    if (data != null) {
      return answerFromJsonUser(data).result?.customer;
    } else {
      return null;
    }
  }

  static Future<List<Place>?> getPlaces(String masterUid) async {
    var address = 'getPlaces.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonPlaces(data).result?.places;
    } else {
      return null;
    }
  }

  static Future<List<Price>?> getPrices(String masterUid) async {
    var address = 'getPrices.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonPrices(data).result?.prices;
    } else {
      return null;
    }
  }

  static Future<List<Photo>?> getPhotos(String masterUid) async {
    var address = 'getPhotos.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonPhotos(data).result?.photos;
    } else {
      return null;
    }
  }

  static Future<List<Workshift>?> getWorkshifts(String masterUid) async {
    var address = 'getWorkshifts.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonWorkshifts(data).result?.workshifts;
    } else {
      return null;
    }
  }

  static Future<List<Workshift>?> getWorkshiftsForPlace(
    String masterUid,
    String placeId,
  ) async {
    var address = 'getWorkshiftsForPlace.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "place_id": placeId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonWorkshifts(data).result?.workshifts;
    } else {
      return null;
    }
  }

  static Future<int?> getShiftInterval(String masterUid) async {
    var address = 'getShiftInterval.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonNumber(data).result?.number;
    } else {
      return null;
    }
  }

  static Future<List<Cost>?> getCosts(
    String masterUid,
    String start,
    String end,
  ) async {
    var address = 'getCosts.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "start": start,
      "end": end,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonCosts(data).result?.costs;
    } else {
      return null;
    }
  }

  static Future<Answer?> saveShiftInterval(
    String masterUid,
    String interval,
  ) async {
    var address = 'saveShiftInterval.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "interval": interval,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<Workshift>?> getWorkshiftsCalendar(
    String masterUid,
    String start,
    String end,
  ) async {
    var address = 'getWorkshiftsCalendar.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "start": start,
      "end": end,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonWorkshifts(data).result?.workshifts;
    } else {
      return null;
    }
  }

  static Future<List<Place>?> searchPlace(
    String masterUid,
    String address,
  ) async {
    var url = 'searchPlace.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "address": address,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonPlaces(data).result?.places;
    } else {
      return null;
    }
  }

  static Future<String?> addPlace(
    String masterUid,
    String placeNumber,
    String address,
    String latitude,
    String longitude,
    String metro,
    String togo,
    String percent,
    String rent,
  ) async {
    var url = 'addPlace.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "place_number": placeNumber,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "metro": metro,
      "togo": togo,
      "percent": percent,
      "rent": rent,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> editPlace(
    String masterUid,
    String placeId,
    String metro,
    String togo,
    String percent,
    String rent,
  ) async {
    var url = 'editPlace.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "place_id": placeId,
      "metro": metro,
      "togo": togo,
      "percent": percent,
      "rent": rent,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> deletePlace(
    String masterUid,
    String placeId,
  ) async {
    var url = 'deletePlace.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "place_id": placeId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> deleteWorkshift(
    String masterUid,
    String workshiftId,
  ) async {
    var url = 'deleteWorkshift.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "workshift_id": workshiftId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<Answer?> addWorkshift(
    String masterUid,
    String placeId,
    String start,
    String end,
  ) async {
    var url = 'addWorkshift.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "place_id": placeId,
      "start": start,
      "end": end,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<String?> editWorkshift(
    String masterUid,
    String workshiftId,
    String start,
    String end,
  ) async {
    var url = 'editWorkshift.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "workshift_id": workshiftId,
      "start": start,
      "end": end,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> addPrice(
    String masterUid,
    String title,
    String price,
    String time,
    String description,
  ) async {
    var url = 'addPrice.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "title": title,
      "price": price,
      "time": time,
      "description": description,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<Answer?> addCost(
    String masterUid,
    String groupId,
    String amount,
    String description,
    String date,
  ) async {
    var url = 'addCost.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "group_id": groupId,
      "amount": amount,
      "date": date,
      "description": description,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> editCost(
    String masterUid,
    String costId,
    String groupId,
    String amount,
    String description,
    String date,
  ) async {
    var url = 'editCost.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "cost_id": costId,
      "group_id": groupId,
      "amount": amount,
      "date": date,
      "description": description,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<String?> editPrice(
    String masterUid,
    String priceId,
    String title,
    String price,
    String time,
    String description,
  ) async {
    var url = 'editPrice.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "price_id": priceId,
      "title": title,
      "price": price,
      "time": time,
      "description": description,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> deletePrice(
    String masterUid,
    String priceId,
  ) async {
    var url = 'deletePrice.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "price_id": priceId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<Answer?> changeRecordStatus({
    required String masterUid,
    required int recordId,
    required int status,
    int discount = 0,
  }) async {
    var address = 'changeRecordStatus.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "record_id": recordId.toString(),
      "status": status.toString(),
      "discount": discount.toString(),
    });

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<Record?> getRecord(
    String masterUid,
    String recordId,
  ) async {
    var address = 'getRecord.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "record_id": recordId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonRecord(data).result?.record;
    } else {
      return null;
    }
  }

  static Future<Answer?> changeRecordPrices(
    String masterUid,
    String recordId,
    String prices,
    String total,
    String length,
  ) async {
    var address = 'changeRecordPrices.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "record_id": recordId,
      "prices": prices,
      "total": total,
      "length": length,
    });

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> changeRecordCosts(
    String masterUid,
    String recordId,
    String costs,
    String total,
  ) async {
    var address = 'changeRecordCosts.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "record_id": recordId,
      "costs": costs,
      "total": total,
    });

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<String?> saveNote(
    String masterUid,
    String userId,
    String note,
  ) async {
    var address = 'saveNote.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "user_id": userId,
      "note": note,
    });

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> saveReview(
    String masterUid,
    String userId,
    String message,
    String stars,
  ) async {
    var address = 'saveReview.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "user_id": userId,
      "message": message,
      "stars": stars,
    });

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<Result?> getReview(String masterUid, String userId) async {
    var address = 'getReview.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "user_id": userId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonReview(data).result;
    } else {
      return null;
    }
  }

  static Future<List<Review>?> getReviews(
      String masterUid, String userId) async {
    var address = 'getReviews.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "user_id": userId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonReviews(data).result?.reviews;
    } else {
      return null;
    }
  }

  static Future<List<Review>?> getMasterReviews(String masterUid) async {
    var address = 'getMasterReviews.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonReviews(data).result?.reviews;
    } else {
      return null;
    }
  }

  static Future<List<Notifications>?> getNotifications(String masterUid) async {
    var address = 'getMasterNotifications.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonNotifications(data).result?.notifications;
    } else {
      return null;
    }
  }

  static Future<List<int>?> getWorkTimes(
    String masterUid,
    String workShiftId,
    String length,
  ) async {
    var address = 'getWorkTimes.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "work_shift_id": workShiftId,
      "length": length,
    });

    if (data != null) {
      return answerFromJsonWorkTimes(data).result?.workTimes;
    } else {
      return null;
    }
  }

  static Future<List<int>?> getDontWorkTimes(
    String masterUid,
    String workShiftId,
    String length,
  ) async {
    var address = 'getDontWorkTimes.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "work_shift_id": workShiftId,
      "length": length,
    });

    if (data != null) {
      return answerFromJsonWorkTimes(data).result?.workTimes;
    } else {
      return null;
    }
  }

  static Future<Answer?> addRecord(
    String masterUid,
    String name,
    String phone,
    String prices,
    String placeId,
    String start,
    String end,
    String total,
    int free,
  ) async {
    var address = 'addRecord.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "name": name,
      "phone": phone,
      "prices": prices,
      "place_id": placeId,
      "start": start,
      "end": end,
      "total": total,
      "free": free.toString(),
    });

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> changeRecordTime(
    String masterUid,
    String recordId,
    String start,
    String length,
    int free,
  ) async {
    var address = 'changeRecordTime.php';

    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "record_id": recordId,
      "start": start,
      "length": length,
      "free": free.toString(),
    });

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<String?> changeProfileStatus(
    String masterUid,
    String status,
  ) async {
    var url = 'changeProfileStatus.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "status": status,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> getMasterId(String masterUid) async {
    var url = 'getMasterId.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonText(data).result?.text;
    } else {
      return null;
    }
  }

  static Future<Stats?> getStats(
    String masterUid,
    String start,
    String end,
  ) async {
    var url = 'getStats.php';

    var data = await request(url: url, params: {
      "master_uid": masterUid,
      "start": start,
      "end": end,
    });

    // await Future.delayed(Duration(milliseconds: 500));

    if (data != null) {
      return answerFromJsonStats(data).result?.stats;
    } else {
      return null;
    }
  }

  static Future<int> getLastNotificationId(String masterUid) async {
    var address = 'getLastNotificationId.php';

    var data = await request(url: address, params: {"master_uid": masterUid});

    if (data != null) {
      return answerFromJsonNumber(data).result?.number ?? 0;
    } else {
      return 0;
    }
  }

  static Future<List<Customer>?> getUsers(String masterUid) async {
    var address = 'getUsers.php';
    var data = await request(url: address, params: {
      "master_uid": masterUid,
    });

    if (data != null) {
      return answerFromJsonCustomers(data).result?.customers;
    } else {
      return null;
    }
  }

  static Future<List<Customer>?> getUsersCount(
    String masterUid,
    String rule,
  ) async {
    var address = 'getUsersCount.php';
    var data = await request(url: address, params: {
      "master_uid": masterUid,
      "rule": rule,
    });

    if (data != null) {
      return answerFromJsonCustomers(data).result?.customers;
    } else {
      return null;
    }
  }
}

class CashHandler {
  static Future<File> getFile(String file) async {
    var dir = await getTemporaryDirectory();
    return File(dir.path + '/' + file);
  }

  static Future<String?> getCash(File file, int minutes) async {
    if (file.existsSync()) {
      var time = DateTime.now().difference(await file.lastModified());
      if (time.inMinutes > minutes) {
        return null;
      } else {
        return file.readAsStringSync();
      }
    } else {
      return null;
    }
  }

  static writeCashe(File file, String data) async {
    file.writeAsStringSync(
      data,
      flush: true,
      mode: FileMode.write,
    );
  }

  static deleteCash() async {
    var dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
  }
}
