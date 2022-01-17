import 'package:master/services/answers.dart';
import 'package:master/services/formater.dart';

extension StringExtension on String {
  String capitalLetter() {
    if (this.isEmpty) {
      return this;
    } else {
      return '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
    }
  }

  String removeDecoration() {
    return this
        .replaceAll("+", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("-", "")
        .replaceAll(" ", "");
  }

  String removeOther() {
    return this
        .replaceAll("+", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("-", "");
  }

  String getPhoneFormatedString() {
    return MaskTextInputFormatter("+_ (___) ___-__-__").getMaskedText(
      '7${this.removeDecoration().substring(1)}',
    );
  }
}

extension Records on List<Record> {
  List<Record> forDate(DateTime date) {
    List<Record> events = [];

    var start = date.millisecondsSinceEpoch ~/ 1000;
    var end = start + 86400;

    for (var item in this) {
      if (item.start > start && item.start < end) {
        events.add(item);
      }
    }

    return events;
  }
}

extension Costs on List<Cost> {
  List<Cost> forDate(DateTime date) {
    List<Cost> events = [];

    var start = date.millisecondsSinceEpoch ~/ 1000;
    var end = start + 86400;

    for (var item in this) {
      if (item.date > start && item.date < end) {
        events.add(item);
      }
    }

    return events;
  }

  String getAmount() {
    var amount = 0;
    for (var item in this) {
      amount += item.amount;
    }
    return amount.toString();
  }

  List<Cost> encodeQuotes() {
    for (var item in this) {
      item.description = item.description.replaceAll('"', '');
    }
    return this;
  }
}

extension Workshifts on List<Workshift> {
  List<Workshift> forDate(DateTime date) {
    List<Workshift> events = [];

    var start = date.millisecondsSinceEpoch ~/ 1000;
    var end = start + 86400;

    for (var item in this) {
      if (item.start > start && item.start < end) {
        events.add(item);
      }
    }

    return events;
  }
}

extension Prices on List<Price> {
  String getString() {
    var descr = "";

    for (var item in this) {
      var title = item.title.capitalLetter();
      descr = descr + title + ", ";
    }

    return descr.substring(0, descr.length - 2);
  }

  List<Price> encodeQuotes() {
    for (var item in this) {
      item.title = item.title.replaceAll('"', '');
      item.description = " ";
    }
    return this;
  }

  String getAmount() {
    var amount = 0;
    for (var item in this) {
      amount += item.price;
    }
    return amount.toString();
  }

  String getAllTime() {
    var seconds = 0;
    for (var item in this) {
      seconds += item.time;
    }

    return seconds.getTime();
  }

  int getLength() {
    var seconds = 0;
    for (var item in this) {
      seconds += item.time;
    }
    return seconds;
  }
}

extension IntExtension on int {
  String getTime() {
    var h = this ~/ 3600;
    var m = ((this - h * 3600)) ~/ 60;

    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    return "$hourLeft:$minuteLeft";
  }
}

extension ParseToString on Enum {
  String getValue() {
    return this.toString().split('.').last;
  }
}

extension RecordExtension on Record {
  String getAmount() {
    var prices = int.parse(this.prices.getAmount());
    var costs = int.parse(this.costs.getAmount());
    return (prices + costs).toString();
  }
}
