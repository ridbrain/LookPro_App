import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/link_card.dart';
import 'package:master/widgets/pdf.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoBottomSheet extends StatefulWidget {
  @override
  State<InfoBottomSheet> createState() => _InfoBottomSheetState();
}

class _InfoBottomSheetState extends State<InfoBottomSheet> {
  String version = "Версия";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        version = "Версия ${value.version}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("О приложении"),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
            ),
          ),
          SliverToBoxAdapter(
            child: Image.asset(
              'assets/logopro.png',
              height: 40,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                "Разработчик Виталий Яковлев",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 40),
              child: Text(
                version,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: LinkCard(
              label: "Поддержка",
              icon: Icons.phone,
              onTap: () => MainRouter.openBottomSheet(
                height: 380,
                context: context,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
                      child: Text(
                        "Мы всегда на связи. Сообщайте об ошибках, пишите замечания и предложения.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RoundButton(
                            icon: LineIcons.mailBulk,
                            label: "E-Mail",
                            onTap: () async {
                              await launch("mailto:support@confeta.app");
                            },
                          ),
                          RoundButton(
                            icon: LineIcons.telegram,
                            label: "Telegram",
                            onTap: () async {
                              await launch("tg://resolve?domain=ridbrain");
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: LinkCard(
              label: "Публичная оферта",
              icon: Icons.file_copy,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFPages(
                    title: "Документ",
                    pdfUrl: "https://server.looklike.beauty/docs/license.pdf",
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: LinkCard(
              label: "Персональные данные",
              icon: Icons.shield,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFPages(
                    title: "Документ",
                    pdfUrl: "https://server.looklike.beauty/docs/agree.pdf",
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: LinkCard(
              label: "Правила использования",
              icon: Icons.check_box,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFPages(
                    title: "Документ",
                    pdfUrl: "https://server.looklike.beauty/docs/rules.pdf",
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: LinkCard(
              label: "Конфиденциальность",
              icon: Icons.safety_divider,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFPages(
                    title: "Документ",
                    pdfUrl: "https://server.looklike.beauty/docs/conf.pdf",
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: LinkCard(
              label: "Соглашение",
              icon: Icons.person,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFPages(
                    title: "Документ",
                    pdfUrl: "https://server.looklike.beauty/docs/users.pdf",
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
