import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/constants.dart';

class AboutSubscribePage extends StatefulWidget {
  @override
  _AboutSubscribePageState createState() => _AboutSubscribePageState();
}

class _AboutSubscribePageState extends State<AboutSubscribePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Column(
              children: [
                SubCard(
                  icon: LineIcons.calendar,
                  title: "Интерактивный календарь",
                  description: "Все записи в одном месте и в нужном порядке",
                ),
                SubCard(
                  icon: LineIcons.calendarCheck,
                  title: "Рабочие смены",
                  description:
                      "Не стройте графиков работы, добавляйте смены как Вам удобно",
                ),
                SubCard(
                  icon: LineIcons.globe,
                  title: "Онлайн запись",
                  description:
                      "Клиенты записываются сами, не отрывая Вас от работы",
                ),
                SubCard(
                  icon: LineIcons.mapMarker,
                  title: "Рабочие адреса",
                  description:
                      "Можно добавить несколько адресов, о новых будем сообщать клиентам",
                ),
                SubCard(
                  icon: LineIcons.lineChart,
                  title: "Статистика",
                  description:
                      "Все клиенты и записи сохранены, следите за показателями от месяца к месяцу",
                ),
                SubCard(
                  icon: LineIcons.bell,
                  title: "Напоминания",
                  description:
                      "Напоминаем клиентам заранее о записях и Вам о рабочих днях",
                ),
                SubCard(
                  icon: LineIcons.image,
                  title: "Лента работ",
                  description:
                      "Все клиенты сервиса увидят фото Ваших работ у себя в ленте",
                ),
                SubCard(
                  icon: LineIcons.stickyNote,
                  title: "Заметки",
                  description:
                      "Записывайте какие материалы использовали с конкретным клиентом",
                ),
                SubCard(
                  icon: LineIcons.comments,
                  title: "Отзывы",
                  description:
                      "Пишите отзывы о клиентах, чтобы другие мастера знали своих героев",
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        // SliverToBoxAdapter(
        //   child: Container(
        //     margin: const EdgeInsets.fromLTRB(0, 30, 0, 50),
        //     child: GradientButton(
        //       label: "Выбрать подписку",
        //       width: 200,
        //       onTap: () {},
        //     ),
        //   ),
        // ),
        // SliverToBoxAdapter(
        //   child: Container(
        //     margin: const EdgeInsets.fromLTRB(15, 25, 15, 15),
        //     child: Text(
        //       "Почему сервис платный",
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         fontSize: 18,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
        // SliverToBoxAdapter(
        //   child: Container(
        //     margin: const EdgeInsets.fromLTRB(15, 0, 15, 25),
        //     decoration: BoxDecoration(
        //       color: Colors.grey[100],
        //       borderRadius: BorderRadius.all(Radius.circular(15)),
        //     ),
        //     child: Column(
        //       children: [
        //         SubCard(
        //           icon: LineIcons.server,
        //           title: "Аренда серверов",
        //           description:
        //               "Все данные храняться на сервере и им ничего не угрожает",
        //         ),
        //         SubCard(
        //           icon: LineIcons.terminal,
        //           title: "Разработка ПО",
        //           description:
        //               "Сейчас проект состоит более чем из 60000 строк кода и это только начало",
        //         ),
        //         SubCard(
        //           icon: LineIcons.mailBulk,
        //           title: "SMS и Push",
        //           description:
        //               "Взаимодействие клиентов с одним мастером требует от 200 SMS или Push уведомлений в месяц",
        //         ),
        //         SubCard(
        //           icon: LineIcons.googleLogo,
        //           title: "Реклама",
        //           description:
        //               "Для продвижения сервиса и привлечения новых клиентов",
        //         ),
        //         SubCard(
        //           icon: LineIcons.userTie,
        //           title: "Менеджмент",
        //           description:
        //               "Координация деятельности, направленная на достижение поставленных целей",
        //         ),
        //         SizedBox(
        //           height: 20,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class SubCard extends StatelessWidget {
  SubCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 130;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 20),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
            decoration: BoxDecoration(
              borderRadius: Constants.radius,
            ),
          ),
          Column(
            children: [
              Container(
                width: width,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                width: width,
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
