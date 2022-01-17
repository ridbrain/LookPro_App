import 'package:flutter/material.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/shimmer.dart';

class ProfileStatus extends StatefulWidget {
  ProfileStatus({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _ProfileStatusState createState() => _ProfileStatusState();
}

class _ProfileStatusState extends State<ProfileStatus> {
  String _getStatus(int status) {
    if (status == 0) {
      return "Профиль на модерации";
    } else if (status == 1) {
      return "Профиль подтверждён";
    } else if (status == 2) {
      return "Профиль отключён";
    } else {
      return "Профиль заблокирован";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NetHandler.getStatusProfile(widget.masterUid),
      builder: (context, AsyncSnapshot<int?> snap) {
        if (snap.hasData) {
          return Text(
            _getStatus(snap.data!),
            style: TextStyle(
              fontSize: 15,
              color: snap.data! == 1 ? Colors.blueGrey : Colors.red[300],
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.only(top: 3),
            child: Shimmer(
              width: 150,
              height: 15,
            ),
          );
        }
      },
    );
  }
}
