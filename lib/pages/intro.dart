import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:master/pages/auth.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/router.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  var listPagesViewModel = [
    PageViewModel(
      titleWidget: Center(
        child: Image(
          image: AssetImage('assets/logopro.png'),
          height: 40,
        ),
      ),
      body:
          "Добро пожаловать в лучшее приложение учёта и автоматизации работы с клиентами!",
      image: Center(
        child: Image(
          image: AssetImage('assets/profile.png'),
          height: 170,
        ),
      ),
    ),
    PageViewModel(
      titleWidget: Container(
        height: 40,
        child: Text(
          "Онлайн запись",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body:
          "Клиенты смогут записываться сами, не отрывая Вас от работы или отдыха.",
      image: Center(
        child: Image(
          image: AssetImage('assets/check.png'),
          height: 170,
        ),
      ),
    ),
    PageViewModel(
      titleWidget: Container(
        height: 40,
        child: Text(
          "Напоминания",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body:
          "Напомним клиенту о записи по средствам звонка, SMS или Push за день и за час до приёма.",
      image: Center(
        child: Image(
          image: AssetImage('assets/bell.png'),
          height: 170,
        ),
      ),
    ),
    PageViewModel(
      titleWidget: Container(
        height: 40,
        child: Text(
          "Статистика",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body:
          "Все клиенты и записи сохранены, можно отслеживать показатели от месяца к месяцу.",
      image: Center(
        child: Image(
          image: AssetImage('assets/chart.png'),
          height: 170,
        ),
      ),
    ),
    PageViewModel(
      titleWidget: Container(
        height: 40,
        child: Text(
          "Заметки",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body:
          "Записывайте, какие материалы использовали, какие у клиента предпочтения или настроение.",
      image: Center(
        child: Image(
          image: AssetImage('assets/note.png'),
          height: 170,
        ),
      ),
    ),
  ];

  void onDonePress() {
    MainRouter.nextPage(context, AuthPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroductionScreen(
        pages: listPagesViewModel,
        onDone: onDonePress,
        next: const Icon(Icons.arrow_forward),
        done: const Text(
          "Готово",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.black,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: Constants.radius,
          ),
        ),
      ),
    );
  }
}
