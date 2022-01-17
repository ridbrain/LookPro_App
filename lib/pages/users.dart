import 'package:flutter/material.dart';
import 'package:master/pages/user.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/cards.dart';
import 'package:master/widgets/contact_cell.dart';
import 'package:master/widgets/shimmer.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    var master = Provider.of<MasterProvider>(context).master;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Клиенты"),
          ),
          SliverToBoxAdapter(
            child: UsersBlock(
              masterUid: master.uid!,
              future: NetHandler.getUsers(master.uid!),
              label: "Все клиенты",
              descr: "Клиенты с записями",
            ),
          ),
          SliverToBoxAdapter(
            child: UsersBlock(
              masterUid: master.uid!,
              future: NetHandler.getUsersCount(master.uid!, "1"),
              label: "В этом месяце",
              descr: "Есть записи в этом месяце",
            ),
          ),
          SliverToBoxAdapter(
            child: UsersBlock(
              masterUid: master.uid!,
              future: NetHandler.getUsersCount(master.uid!, "2"),
              label: "Постоянные",
              descr: "Есть записи за последние 3 месяца",
            ),
          ),
          SliverToBoxAdapter(
            child: UsersBlock(
              masterUid: master.uid!,
              future: NetHandler.getUsersCount(master.uid!, "3"),
              label: "Остывшие",
              descr: "Не записывались более 3 месяцев",
            ),
          ),
          SliverToBoxAdapter(
            child: UsersBlock(
              masterUid: master.uid!,
              future: NetHandler.getUsersCount(master.uid!, "4"),
              label: "Забытые",
              descr: "Не записывались более 6 месяцев",
            ),
          ),
          SliverToBoxAdapter(
            child: UsersBlock(
              masterUid: master.uid!,
              future: NetHandler.getUsersCount(master.uid!, "5"),
              label: "Новые",
              descr: "Первая запись в этом месяце",
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class UsersBlock extends StatefulWidget {
  UsersBlock({
    required this.masterUid,
    required this.future,
    required this.label,
    required this.descr,
  });

  final String masterUid;
  final Future<List<Customer>?>? future;
  final String label;
  final String descr;

  @override
  _UsersBlockState createState() => _UsersBlockState();
}

class _UsersBlockState extends State<UsersBlock> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, AsyncSnapshot<List<Customer>?> snap) {
        if (snap.hasData) {
          return UsersCard(
            label: widget.label,
            descr: widget.descr,
            count: snap.data?.length.toString() ?? "0",
            onTap: () => MainRouter.nextPage(
              context,
              Users(
                masterUid: widget.masterUid,
                title: widget.label,
                users: snap.data!,
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Shimmer(
              height: 65,
            ),
          );
        }
      },
    );
  }
}

class Users extends StatefulWidget {
  Users({
    required this.masterUid,
    required this.title,
    required this.users,
  });

  final String masterUid;
  final String title;
  final List<Customer> users;

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(widget.title),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ContactCell(
                  name: widget.users[index].name,
                  phone: widget.users[index].phone.getPhoneFormatedString(),
                  onTap: () => MainRouter.nextPage(
                    context,
                    UserPage(
                      masterUid: widget.masterUid,
                      user: widget.users[index],
                    ),
                  ),
                );
              },
              childCount: widget.users.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
