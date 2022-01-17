import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockPage extends StatefulWidget {
  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(40),
            child: Image.asset('assets/logopro.png', height: 40),
          ),
          Center(
            child: Text(
              "Профиль заблокирован :(",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(40),
            child: Text(
              "Чтобы разблокировать профиль, свяжитесь со службой поддержки, в письме обязательно укажите номер телефона, который привязан к профилю.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Center(
            child: RoundButton(
              icon: LineIcons.mailBulk,
              label: "E-Mail",
              onTap: () async {
                await launch("mailto:support@confeta.app");
              },
            ),
          ),
        ],
      ),
    );
  }
}
