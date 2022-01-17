import 'package:flutter/material.dart';
import 'package:master/services/network.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:master/widgets/text_field.dart';

class NotePage extends StatefulWidget {
  NotePage({
    required this.masterUid,
    required this.userId,
    required this.note,
  });

  final String masterUid;
  final String userId;
  final String note;

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  var noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteController.text = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            StandartAppBar(
              title: Text("Заметка о клиенте"),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Заметку видно только Вам",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 140,
                child: TextFieldWidget(
                  controller: noteController,
                  maxLines: 8,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 25),
                child: StandartButton(
                  label: "Сохранить",
                  onTap: () {
                    NetHandler.saveNote(
                      widget.masterUid,
                      widget.userId,
                      noteController.text,
                    ).then((value) {
                      StandartSnackBar.show(
                        context,
                        value ?? "Готово!",
                        SnackBarStatus.success(),
                      );
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
