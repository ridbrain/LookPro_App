import 'package:flutter/material.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/shimmer.dart';
import 'package:provider/provider.dart';

class MasterInfo extends StatefulWidget {
  @override
  _MasterInfoState createState() => _MasterInfoState();
}

class _MasterInfoState extends State<MasterInfo> {
  String aboutStatus(String? text) {
    if (text == null || text.length < 5)
      return "Заполните описание!";
    else
      return text;
  }

  Color aboutColor(String? text) {
    if (text == null || text.length < 5)
      return Colors.red;
    else
      return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MasterProvider>(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Text(
            provider.master.group ?? "",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 1,
        ),
        Container(
          child: Text(
            provider.master.name ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
          child: Text(
            aboutStatus(provider.master.about),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: aboutColor(provider.master.about),
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Shimmer(
          width: 100,
          height: 15,
        ),
        SizedBox(
          height: 5,
        ),
        Shimmer(
          width: 200,
          height: 25,
        ),
        SizedBox(
          height: 5,
        ),
        Shimmer(
          width: 250,
          height: 40,
        ),
      ],
    );
  }
}
