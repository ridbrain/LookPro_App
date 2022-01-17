import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/extensions.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/category_selector.dart';
import 'package:master/widgets/contact_cell.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  var _index = 0;
  List<Contact> contacts = [];
  List<Customer> users = [];

  void checkPermission() async {
    if (await Permission.contacts.request().isGranted) {
      var loads = await FastContacts.allContacts;
      setState(() {
        contacts = loads;
      });
    }
  }

  void loadUsers() async {
    var loads = await NetHandler.getContacts(widget.masterUid);
    if (loads == null) return;

    setState(() {
      users = loads;
    });
  }

  void selectUser(String name, String phone) {
    Navigator.pop(
      context,
      Customer(
        userId: 0,
        name: name,
        recordsCount: 0,
        lastDate: 0,
        phone: phone,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadUsers();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Выбор клиента"),
          ),
          SliverToBoxAdapter(
            child: CategorySelector(
              onTap: (index) => setState(() {
                _index = index;
              }),
              badges: [],
              categies: [
                "Клиеты",
                "Контакты",
              ],
            ),
          ),
          SliverList(
            delegate: _index == 0
                ? SliverChildBuilderDelegate(
                    (context, index) {
                      return ContactCell(
                        name: users[index].name,
                        phone: users[index].phone.getPhoneFormatedString(),
                        onTap: () => selectUser(
                          users[index].name,
                          users[index].phone.getPhoneFormatedString(),
                        ),
                      );
                    },
                    childCount: users.length,
                  )
                : SliverChildBuilderDelegate(
                    (context, index) {
                      return ContactCell(
                        name: contacts[index].displayName,
                        phone: contacts[index].phones.isNotEmpty
                            ? contacts[index]
                                .phones
                                .first
                                .getPhoneFormatedString()
                            : "Нет номера",
                        onTap: () => selectUser(
                          contacts[index].displayName,
                          contacts[index].phones.first,
                        ),
                      );
                    },
                    childCount: contacts.length,
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
