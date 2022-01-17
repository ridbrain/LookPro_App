import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/services.dart';
import 'package:master/services/extensions.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static String verification = "";

  var firebase = false;

  Future<bool> requestCode(BuildContext context, String phone) async {
    if (phone.length != 18) {
      StandartSnackBar.show(
        context,
        'Введите корректный номер',
        SnackBarStatus.warning(),
      );
      return false;
    }

    var request = await NetHandler.getAuth(phone.removeDecoration());

    if (request == null) {
      StandartSnackBar.show(
        context,
        'Ошибка отправки',
        SnackBarStatus.warning(),
      );
      return false;
    }

    if (request.error == 0) {
      verification = request.result?.text ?? "";
      StandartSnackBar.show(
        context,
        'Код отправлен',
        SnackBarStatus.success(),
      );
    }

    if (request.error == 1) {
      firebase = true;

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+$phone',
        verificationCompleted: (credential) {},
        verificationFailed: (e) {
          StandartSnackBar.show(
            context,
            e.message ?? 'Ошибка отправки',
            SnackBarStatus.warning(),
          );
        },
        codeSent: (verificationId, resendToken) {
          verification = verificationId;
          StandartSnackBar.show(
            context,
            'Код отправлен',
            SnackBarStatus.success(),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    }

    if (request.error == 2) {
      StandartSnackBar.show(
        context,
        request.result?.text ?? 'Ошибка отправки',
        SnackBarStatus.warning(),
      );
      return false;
    }

    return true;
  }

  Future<bool> confirmCode(BuildContext context, String code) async {
    if (code.length < 4 || code.length > 6) {
      StandartSnackBar.show(
        context,
        'Введите корректный код',
        SnackBarStatus.warning(),
      );
      return false;
    }

    var masterProvider = Provider.of<MasterProvider>(context, listen: false);
    var token = await FirebaseMessaging.instance.getToken();
    var platform = Theme.of(context).platform;
    var os = "unknow";

    if (platform == TargetPlatform.iOS) {
      os = "ios";
    } else if (platform == TargetPlatform.android) {
      os = "android";
    }

    if (firebase) {
      await firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verification,
          smsCode: code,
        ),
      );

      var idToken = await firebaseAuth.currentUser?.getIdToken();

      if (idToken == null) {
        StandartSnackBar.show(
          context,
          "Ошибка",
          SnackBarStatus.warning(),
        );
        return false;
      }

      var request = await NetHandler.confirmFirebaseAuth(
        idToken,
        token ?? "unknow",
        os,
      );

      if (request?.error == 0) {
        if (request!.result!.master != null) {
          masterProvider.setMaster(request.result!.master!);
          Purchases.logIn(request.result!.master!.uid!);
        }
      } else {
        StandartSnackBar.show(
          context,
          request?.message ?? "Ошибка",
          SnackBarStatus.warning(),
        );
      }
    } else {
      var request = await NetHandler.confirmAuth(
        verification,
        code,
        token ?? "unknow",
        os,
      );

      if (request?.error == 0) {
        if (request!.result!.master != null) {
          masterProvider.setMaster(request.result!.master!);
        }
      } else {
        StandartSnackBar.show(
          context,
          request?.message ?? "Ошибка",
          SnackBarStatus.warning(),
        );
        return false;
      }
    }

    return true;
  }

  void signOut(BuildContext context) {
    var userProvider = Provider.of<MasterProvider>(context, listen: false);
    userProvider.setMaster(Master(uid: ""));
    Purchases.logOut();
  }
}
