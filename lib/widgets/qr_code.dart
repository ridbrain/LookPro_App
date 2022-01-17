import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/network.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodeLook extends StatefulWidget {
  QrCodeLook({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _QrCodeLookState createState() => _QrCodeLookState();
}

class _QrCodeLookState extends State<QrCodeLook> {
  void shareMaster(String url) async {
    var share = await FlutterShare.share(
      title: 'Look',
      text: 'Лучшие мастера в приложении Look!',
      linkUrl: url,
    );

    if (share == null) return;
    if (share) (await PrefsHandler.getInstance()).setShowLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Ссылка на профиль"),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              child: FutureBuilder(
                future: NetHandler.getMasterId(widget.masterUid),
                builder: (context, AsyncSnapshot<String?> snap) {
                  if (snap.data != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(50),
                          decoration: BoxDecoration(
                            borderRadius: Constants.radius,
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              PrettyQr(
                                typeNumber: 3,
                                size: 170,
                                data: snap.data!,
                                errorCorrectLevel: QrErrorCorrectLevel.M,
                                roundEdges: true,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Text(
                                  "Покажите этот QR Code клиенту или поделитесь ссылкой на свой профиль в сервисе Look.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        StandartButton(
                          label: "Поделиться ссылкой",
                          onTap: () => shareMaster(snap.data!),
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
