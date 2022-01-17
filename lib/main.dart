import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master/pages/block.dart';
import 'package:master/pages/home.dart';
import 'package:master/pages/intro.dart';
import 'package:master/pages/new_master.dart';
import 'package:master/pages/offerings.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/network.dart';
import 'package:master/services/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:smartlook/smartlook.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey,
    ),
  );

  final provider = await MasterProvider.init();

  Smartlook.setupAndStartRecording(
    SetupOptionsBuilder(Constants.slApiKey).build(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => provider,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Look Pro',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: LoadingApp(),
      ),
    );
  }
}

class LoadingApp extends StatelessWidget {
  Widget checkProfile(MasterProvider provider) {
    return FutureBuilder(
      future: NetHandler.checkProfile(provider.master.uid!),
      builder: (context, AsyncSnapshot<Answer?> snap) {
        if (snap.hasData) {
          var answer = snap.data!;

          if (answer.error == 0) {
            switch (answer.result?.text) {
              case "block":
                return BlockPage();
              case "empty":
                return NewMasterPage();
              case "active":
                return getHome(provider);
              default:
                return LoadingLogo();
            }
          }
        }

        return LoadingLogo();
      },
    );
  }

  Widget getHome(MasterProvider provider) {
    final uid = provider.master.uid!;
    final name = provider.master.name!;
    final entitlement = provider.subscribeInfo.entitlement;

    Smartlook.setUserIdentifier(uid, {"name": name});

    switch (provider.subscribeInfo.entitlement) {
      case Entitlement.none:
        return CheckTrial(masterUid: uid);
      case Entitlement.lite:
        return HomeLite(
          masterUid: uid,
          entitlement: entitlement,
        );
      case Entitlement.base:
        return HomeBase(
          masterUid: uid,
          entitlement: entitlement,
        );
      case Entitlement.pro:
        return HomeBase(
          masterUid: uid,
          entitlement: entitlement,
        );
      case Entitlement.max:
        return HomeBase(
          masterUid: uid,
          entitlement: entitlement,
        );
      default:
        return OfferingsPage(first: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MasterProvider>(context);
    return provider.hasMaster ? checkProfile(provider) : IntroPage();
  }
}

class CheckTrial extends StatelessWidget {
  CheckTrial({
    required this.masterUid,
  });

  final String masterUid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NetHandler.checkTrial(masterUid),
      builder: (context, AsyncSnapshot<Answer?> snap) {
        if (snap.hasData) {
          var answer = snap.data!;

          if (answer.error == 0) {
            switch (answer.result?.text) {
              case "trial":
                return HomeBase(
                  masterUid: masterUid,
                  entitlement: Entitlement.none,
                );
              case "none":
                return OfferingsPage(first: true);
              default:
                return LoadingLogo();
            }
          }
        }

        return LoadingLogo();
      },
    );
  }
}

class LoadingLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logopro.png', height: 40),
          SizedBox(height: 50),
          CupertinoActivityIndicator(),
        ],
      ),
    );
  }
}
