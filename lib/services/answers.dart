import 'dart:convert';

Answer answerFromJson(String str) => Answer.fromJson(json.decode(str));

Answer answerFromJsonExist(String str) =>
    Answer.fromJsonExist(json.decode(str));

Answer answerFromJsonText(String str) => Answer.fromJsonText(json.decode(str));

Answer answerFromJsonGrops(String str) =>
    Answer.fromJsonGroups(json.decode(str));

Answer answerFromJsonMaster(String str) =>
    Answer.fromJsonMaster(json.decode(str));

Answer answerFromJsonRecords(String str) =>
    Answer.fromJsonRecords(json.decode(str));

Answer answerFromJsonPlaces(String str) =>
    Answer.fromJsonPlaces(json.decode(str));

Answer answerFromJsonWorkshifts(String str) =>
    Answer.fromJsonWorkshifts(json.decode(str));

Answer answerFromJsonPrices(String str) =>
    Answer.fromJsonPrices(json.decode(str));

Answer answerFromJsonPhotos(String str) =>
    Answer.fromJsonPhotos(json.decode(str));

Answer answerFromJsonRecord(String str) =>
    Answer.fromJsonRecord(json.decode(str));

Answer answerFromJsonReview(String str) =>
    Answer.fromJsonReview(json.decode(str));

Answer answerFromJsonReviews(String str) =>
    Answer.fromJsonReviews(json.decode(str));

Answer answerFromJsonWorkTimes(String str) =>
    Answer.fromJsonWorkTimes(json.decode(str));

Answer answerFromJsonOrder(String str) =>
    Answer.fromJsonOrder(json.decode(str));

Answer answerFromJsonMasterRating(String str) =>
    Answer.fromJsonMasterRating(json.decode(str));

Answer answerFromJsonStatus(String str) =>
    Answer.fromJsonStatus(json.decode(str));

Answer answerFromJsonStats(String str) =>
    Answer.fromJsonStats(json.decode(str));

Answer answerFromJsonNotifications(String str) =>
    Answer.fromJsonNotifications(json.decode(str));

Answer answerFromJsonNumber(String str) =>
    Answer.fromJsonNumber(json.decode(str));

Answer answerFromJsonCustomers(String str) =>
    Answer.fromJsonCustomers(json.decode(str));

Answer answerFromJsonCostsGroups(String str) =>
    Answer.fromJsonCostsGroups(json.decode(str));

Answer answerFromJsonCosts(String str) =>
    Answer.fromJsonCosts(json.decode(str));

Answer answerFromJsonUser(String str) => Answer.fromJsonUser(json.decode(str));

class Answer {
  Answer({
    required this.error,
    required this.message,
    this.result,
  });

  int error;
  String message;
  Result? result;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
      );

  factory Answer.fromJsonExist(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonExist(json["result"]),
      );

  factory Answer.fromJsonText(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonText(json["result"]),
      );

  factory Answer.fromJsonGroups(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonGroups(json["result"]),
      );

  factory Answer.fromJsonMaster(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonMaster(json["result"]),
      );

  factory Answer.fromJsonRecords(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonRecords(json["result"]),
      );

  factory Answer.fromJsonPlaces(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonPlaces(json["result"]),
      );

  factory Answer.fromJsonWorkshifts(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonWorkshifts(json["result"]),
      );

  factory Answer.fromJsonPrices(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonPrices(json["result"]),
      );

  factory Answer.fromJsonPhotos(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonPhotos(json["result"]),
      );

  factory Answer.fromJsonRecord(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonRecord(json["result"]),
      );

  factory Answer.fromJsonReview(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonReview(json["result"]),
      );

  factory Answer.fromJsonReviews(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonReviews(json["result"]),
      );

  factory Answer.fromJsonWorkTimes(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonWorkTimes(json["result"]),
      );

  factory Answer.fromJsonOrder(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonOrder(json["result"]),
      );

  factory Answer.fromJsonMasterRating(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonMasterRating(json["result"]),
      );

  factory Answer.fromJsonStatus(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonStatus(json["result"]),
      );

  factory Answer.fromJsonStats(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonStats(json["result"]),
      );

  factory Answer.fromJsonNotifications(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonNotifications(json["result"]),
      );

  factory Answer.fromJsonNumber(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonNumber(json["result"]),
      );

  factory Answer.fromJsonCustomers(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonCustomers(json["result"]),
      );

  factory Answer.fromJsonUser(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonUser(json["result"]),
      );

  factory Answer.fromJsonCostsGroups(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonCostsGroups(json["result"]),
      );

  factory Answer.fromJsonCosts(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonCosts(json["result"]),
      );
}

class Result {
  Result({
    this.exist,
    this.text,
    this.groups,
    this.master,
    this.records,
    this.places,
    this.prices,
    this.workshifts,
    this.photos,
    this.record,
    this.review,
    this.reviews,
    this.workTimes,
    this.order,
    this.masterRating,
    this.status,
    this.stats,
    this.notifications,
    this.number,
    this.customers,
    this.customer,
    this.costsGroups,
    this.costs,
  });

  bool? exist;
  String? text;
  int? number;

  Master? master;
  Record? record;
  Review? review;
  Customer? customer;

  List<Group>? groups;
  List<Record>? records;
  List<Place>? places;
  List<Price>? prices;
  List<Workshift>? workshifts;
  List<Photo>? photos;
  List<Review>? reviews;
  List<int>? workTimes;
  Order? order;
  MasterRating? masterRating;
  Status? status;
  Stats? stats;
  List<Notifications>? notifications;
  List<Customer>? customers;
  List<CostGroup>? costsGroups;
  List<Cost>? costs;

  factory Result.fromJsonCosts(Map<String, dynamic> json) => Result(
        costs: List<Cost>.from(json["costs"].map((x) => Cost.fromJson(x))),
      );

  factory Result.fromJsonCustomers(Map<String, dynamic> json) => Result(
        customers:
            List<Customer>.from(json["users"].map((x) => Customer.fromJson(x))),
      );

  factory Result.fromJsonNotifications(Map<String, dynamic> json) => Result(
        notifications: List<Notifications>.from(
            json["notifications"].map((x) => Notifications.fromJson(x))),
      );

  factory Result.fromJsonStats(Map<String, dynamic> json) => Result(
        stats: Stats.fromJson(json["stats"]),
      );

  factory Result.fromJsonStatus(Map<String, dynamic> json) => Result(
        status: Status.fromJson(json["status"]),
      );

  factory Result.fromJsonMasterRating(Map<String, dynamic> json) => Result(
        masterRating: MasterRating.fromJson(json["master_rating"]),
      );

  factory Result.fromJsonOrder(Map<String, dynamic> json) => Result(
        order: Order.fromJson(json["order"]),
      );

  factory Result.fromJsonReview(Map<String, dynamic> json) => Result(
        review: json["review"] != null ? Review.fromJson(json["review"]) : null,
      );

  factory Result.fromJsonReviews(Map<String, dynamic> json) => Result(
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );

  factory Result.fromJsonPhotos(Map<String, dynamic> json) => Result(
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      );

  factory Result.fromJsonWorkshifts(Map<String, dynamic> json) => Result(
        workshifts: List<Workshift>.from(
            json["workshifts"].map((x) => Workshift.fromJson(x))),
      );

  factory Result.fromJsonWorkTimes(Map<String, dynamic> json) => Result(
        workTimes: List<int>.from(json["work_times"].map((x) => x)),
      );

  factory Result.fromJsonPlaces(Map<String, dynamic> json) => Result(
        places: List<Place>.from(json["places"].map((x) => Place.fromJson(x))),
      );

  factory Result.fromJsonPrices(Map<String, dynamic> json) => Result(
        prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
      );

  factory Result.fromJsonRecords(Map<String, dynamic> json) => Result(
        records:
            List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
      );

  factory Result.fromJsonMaster(Map<String, dynamic> json) => Result(
        master: Master.fromJson(json["master"]),
      );

  factory Result.fromJsonUser(Map<String, dynamic> json) => Result(
        customer: Customer.fromJson(json["user"]),
      );

  factory Result.fromJsonRecord(Map<String, dynamic> json) => Result(
        record: Record.fromJson(json["record"]),
      );

  factory Result.fromJsonExist(Map<String, dynamic> json) => Result(
        exist: json["exist"],
      );

  factory Result.fromJsonText(Map<String, dynamic> json) => Result(
        text: json["text"] == null ? json["text"] : json["text"].toString(),
      );

  factory Result.fromJsonNumber(Map<String, dynamic> json) => Result(
        number: json["number"],
      );

  factory Result.fromJsonGroups(Map<String, dynamic> json) => Result(
        groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
      );

  factory Result.fromJsonCostsGroups(Map<String, dynamic> json) => Result(
        costsGroups: List<CostGroup>.from(
            json["costs_groups"].map((x) => CostGroup.fromJson(x))),
      );
}

class Group {
  Group({
    required this.groupId,
    required this.groupLabel,
    required this.masterLabel,
  });

  int groupId;
  String groupLabel;
  String masterLabel;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json["group_id"],
        groupLabel: json["group_label"],
        masterLabel: json["master_label"],
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "group_label": groupLabel,
        "master_label": masterLabel,
      };
}

class Master {
  Master({
    this.uid,
    this.name,
    this.about,
    this.phone,
    this.email,
    this.experience,
    this.birthday,
    this.group,
    this.imageUrl,
  });

  String? uid;
  String? name;
  String? about;
  String? phone;
  String? email;
  int? experience;
  int? birthday;
  String? group;
  String? imageUrl;

  factory Master.fromJson(Map<String, dynamic> json) => Master(
        uid: json["uid"] ?? "",
        name: json["name"] ?? "",
        about: json["about"] ?? "",
        phone: json["phone"].toString(),
        email: json["email"] ?? "",
        experience: json["experience"] ?? 0,
        birthday: json["birthday"] ?? 0,
        group: json["group"] ?? "",
        imageUrl: json["image_url"] ?? "",
      );
}

class Record {
  Record({
    required this.recordId,
    required this.userId,
    required this.date,
    required this.status,
    required this.place,
    required this.prices,
    required this.total,
    required this.start,
    required this.end,
    required this.name,
    required this.discount,
    required this.costs,
  });

  int recordId;
  int userId;
  int date;
  int status;
  Place place;
  List<Price> prices;
  List<Cost> costs;
  int total;
  int start;
  int end;
  String name;
  int discount;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        recordId: json["record_id"] ?? 0,
        userId: json["user_id"] ?? 0,
        date: json["date"] ?? 0,
        status: json["status"] ?? 0,
        place: Place.fromJson(json["place"]),
        prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
        costs: json["costs"] != null
            ? List<Cost>.from(json["costs"].map((x) => Cost.fromJson(x)))
            : [],
        total: json["total"] ?? 0,
        start: json["start"] ?? 0,
        end: json["end"] ?? 0,
        name: json["name"] ?? "",
        discount: json["discount"] ?? 0,
      );
}

class Place {
  Place({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.metro,
    required this.placeId,
    required this.placeNumber,
    required this.togo,
    required this.percent,
    required this.rent,
  });

  String address;
  double latitude;
  double longitude;
  String metro;
  int placeId;
  String placeNumber;
  String togo;
  int percent;
  int rent;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        address: json["address"] ?? "",
        latitude: json["latitude"].toDouble() ?? 0,
        longitude: json["longitude"].toDouble() ?? 0,
        metro: json["metro"] ?? "",
        placeId: json["place_id"] ?? 0,
        placeNumber: json["place_number"] ?? "",
        togo: json["togo"] ?? "",
        percent: json["percent"] ?? 0,
        rent: json["rent"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "place_number": placeNumber,
        "address": address,
        "metro": metro,
        "togo": togo,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Price {
  Price({
    required this.description,
    required this.price,
    required this.priceId,
    required this.time,
    required this.title,
    required this.userId,
  });

  String description;
  int price;
  int priceId;
  int time;
  String title;
  int userId;

  factory Price.fromJson(Map<String, dynamic> json) {
    try {
      return Price(
        description: json["description"],
        price: json["price"],
        priceId: json["price_id"],
        time: json["time"],
        title: json["title"],
        userId: json["user_id"],
      );
    } catch (e) {
      return Price(
        description: "",
        price: 0,
        priceId: 0,
        time: 0,
        title: "",
        userId: 0,
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "price_id": priceId,
        "user_id": userId,
        "title": title,
        "price": price,
        "description": description,
        "time": time,
      };
}

class Customer {
  Customer({
    required this.userId,
    required this.name,
    required this.recordsCount,
    required this.lastDate,
    required this.phone,
  });

  int userId;
  String phone;
  String name;
  int recordsCount;
  int lastDate;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        userId: json["user_id"] ?? 0,
        name: json["name"] ?? "Нет имени",
        recordsCount: json["records_count"] ?? 0,
        lastDate: json["last_date"] ?? 0,
        phone: json["phone"].toString(),
      );
}

class Workshift {
  Workshift({
    required this.workshiftId,
    required this.placeId,
    required this.start,
    required this.end,
    required this.address,
  });

  int workshiftId;
  int placeId;
  int start;
  int end;
  String address;

  factory Workshift.fromJson(Map<String, dynamic> json) => Workshift(
        workshiftId: json["workshift_id"],
        placeId: json["place_id"],
        start: json["start"],
        end: json["end"],
        address: json['address'],
      );
}

class Photo {
  Photo({
    required this.photoId,
    required this.imgUrl,
  });

  int photoId;
  String imgUrl;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        photoId: json["photo_id"],
        imgUrl: json["img_url"],
      );
}

class Review {
  Review({
    this.reviewId,
    this.message,
    this.stars,
    this.date,
    this.name,
  });

  int? reviewId;
  String? message;
  double? stars;
  int? date;
  String? name;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewId: json["review_id"],
        message: json["message"],
        date: json["date"],
        name: json["name"],
        stars: json["stars"] is int
            ? (json['stars'] as int).toDouble()
            : json['stars'],
      );
}

class Order {
  Order({
    required this.masterId,
    required this.orderId,
  });

  int masterId;
  int orderId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        masterId: json["master_id"],
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "master_id": masterId,
        "order_id": orderId,
      };
}

class MasterRating {
  MasterRating({
    required this.rating,
    required this.reviews,
    required this.customers,
  });

  double rating;
  int reviews;
  int customers;

  factory MasterRating.fromJson(Map<String, dynamic> json) => MasterRating(
        rating: json["rating"] is int
            ? (json['rating'] as int).toDouble()
            : json['rating'] ?? 0.0,
        reviews: json["reviews"] ?? 0,
        customers: json["customers"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "reviews": reviews,
        "customers": customers,
      };
}

class Status {
  Status({
    required this.status,
    required this.storeUrl,
    required this.message,
  });

  int status;
  String storeUrl;
  String message;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        status: json["status"] ?? 0,
        storeUrl: json["store_url"] ?? "",
        message: json["message"],
      );
}

class Stats {
  Stats({
    required this.profit,
    required this.costs,
    required this.amount,
    required this.discount,
    required this.hours,
    required this.priceCount,
    required this.estimation,
    required this.perHour,
    this.prices,
  });

  String profit;
  String costs;
  String amount;
  String discount;
  String hours;
  String priceCount;
  String estimation;
  String perHour;

  List<Service>? prices;

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        profit: json["profit"],
        costs: json["costs"],
        amount: json["amount"],
        discount: json["discount"],
        hours: json["hours"],
        priceCount: json["price_count"],
        estimation: json["estimation"],
        perHour: json["per_hour"],
        prices:
            List<Service>.from(json["prices"].map((x) => Service.fromJson(x))),
      );
}

class Service {
  Service({
    required this.title,
    required this.count,
  });

  String title;
  int count;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        title: json["title"],
        count: json["count"],
      );
}

class Notifications {
  Notifications({
    required this.notificationId,
    required this.message,
    required this.date,
  });

  int notificationId;
  String message;
  int date;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        notificationId: json["notification_id"],
        message: json["message"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "message": message,
        "date": date,
      };
}

class CostGroup {
  CostGroup({
    required this.groupId,
    required this.label,
  });

  int groupId;
  String label;

  factory CostGroup.fromJson(Map<String, dynamic> json) => CostGroup(
        groupId: json["group_id"],
        label: json["label"],
      );
}

class Cost {
  Cost({
    required this.costId,
    required this.groupId,
    required this.amount,
    required this.date,
    required this.description,
  });

  int costId;
  int groupId;
  int amount;
  int date;
  String description;

  factory Cost.fromJson(Map<String, dynamic> json) {
    try {
      return Cost(
        costId: json["cost_id"],
        groupId: json["group_id"],
        amount: json["amount"],
        date: json["date"],
        description: json["description"],
      );
    } catch (e) {
      return Cost(
        costId: 0,
        groupId: 0,
        amount: 0,
        date: 0,
        description: "",
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "cost_id": costId,
        "group_id": groupId,
        "amount": amount,
        "date": date,
        "description": description,
      };
}
