import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master/main.dart';
import 'package:master/services/auth.dart';
import 'package:master/services/formater.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/info.dart';
import 'package:master/widgets/text_field.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final _phoneTextController = TextEditingController();
  final _smsCodeTextController = TextEditingController();
  final _authService = AuthService();

  bool _requested = false;
  bool _loading = false;

  Widget _phoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFieldWidget(
        hint: "Номер телефона",
        icon: Icons.phone,
        type: TextInputType.phone,
        controller: _phoneTextController,
        formatter: [
          MaskTextInputFormatter("+_ (___) ___-__-__"),
          LengthLimitingTextInputFormatter(18),
        ],
        maxLength: 18,
        onTap: () {
          if (_phoneTextController.text.length < 4) {
            _phoneTextController.text = "+7 (";
          }
        },
      ),
    );
  }

  Widget _codeField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFieldWidget(
        hint: "Код из SMS",
        icon: Icons.chat,
        type: TextInputType.number,
        controller: _smsCodeTextController,
        formatter: [
          LengthLimitingTextInputFormatter(6),
        ],
      ),
    );
  }

  Widget _authButton() {
    return StandartButton(
      label: 'Авторизация',
      onTap: _pressAuth,
    );
  }

  Widget _confirmButton() {
    if (_loading) {
      return CupertinoActivityIndicator();
    } else {
      return StandartButton(
        label: 'Подтвердить',
        onTap: _pressConfirm,
      );
    }
  }

  Widget _personalDescriprion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Text(
        "Используя приложение, Вы даёте согласие на обработку персональных данных.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _codeDescriprion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Text(
        "Код авторизации будет отправлен в SMS.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }

  void _pressAuth() async {
    var request = await _authService.requestCode(
      context,
      _phoneTextController.text,
    );

    setState(() {
      _requested = request;
    });
  }

  void _pressConfirm() async {
    setState(() {
      _loading = true;
    });

    var confirm = await _authService.confirmCode(
      context,
      _smsCodeTextController.text,
    );

    if (confirm) {
      MainRouter.changeMainPage(context, LoadingApp());
    } else {
      setState(() {
        _loading = false;
      });
    }
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
              title: Text(
                "Авторизация",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => MainRouter.fullScreenDialog(
                    context,
                    InfoBottomSheet(),
                  ),
                  icon: Icon(
                    Icons.info_outline,
                  ),
                ),
              ],
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
              child: SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
                child: Text(
                  "Регистрация не займёт много времени. Нам надо будет подтвердить Ваш телефон, уточнить Фамилию и Имя, сферу деятельности, а также загрузить Ваше фото.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSizeAndFade(
                child: !_requested ? _phoneField() : _codeField(),
                fadeDuration: const Duration(milliseconds: 300),
                sizeDuration: const Duration(milliseconds: 600),
                vsync: this,
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSizeAndFade(
                child:
                    !_requested ? _personalDescriprion() : _codeDescriprion(),
                fadeDuration: const Duration(milliseconds: 300),
                sizeDuration: const Duration(milliseconds: 600),
                vsync: this,
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSizeAndFade(
                child: !_requested ? _authButton() : _confirmButton(),
                fadeDuration: const Duration(milliseconds: 300),
                sizeDuration: const Duration(milliseconds: 600),
                vsync: this,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
