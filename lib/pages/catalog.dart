import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/about_subscribe.dart';
import 'package:master/pages/master.dart';
import 'package:master/pages/photos.dart';
import 'package:master/pages/places.dart';
import 'package:master/pages/prices.dart';
import 'package:master/pages/work_settings.dart';
import 'package:master/services/auth.dart';
import 'package:master/services/constants.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/info.dart';
import 'package:master/widgets/link.dart';
import 'package:master/widgets/profile_status.dart';
import 'package:master/widgets/qr_code.dart';
import 'package:provider/provider.dart';

class Catalog extends StatefulWidget {
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  Widget _qrCode(String masterUid) {
    return StandartLink(
      label: "Ссылка на профиль",
      icon: LineIcons.qrcode,
      onTap: () => MainRouter.nextPage(
        context,
        QrCodeLook(
          masterUid: masterUid,
        ),
      ),
    );
  }

  Widget _getQRCode(MasterProvider provider) {
    switch (provider.subscribeInfo.entitlement) {
      case Entitlement.none:
        return _qrCode(provider.master.uid!);
      case Entitlement.lite:
        return Container();
      case Entitlement.base:
        return Container();
      case Entitlement.pro:
        return _qrCode(provider.master.uid!);
      case Entitlement.max:
        return _qrCode(provider.master.uid!);
      default:
        return Container();
    }
  }

  Widget _photos(String masterUid) {
    return StandartLink(
      label: "Примеры работ",
      icon: LineIcons.imageFile,
      onTap: () => MainRouter.nextPage(
        context,
        PhotosPage(
          masterUid: masterUid,
        ),
      ),
    );
  }

  Widget _getPhotos(MasterProvider provider) {
    switch (provider.subscribeInfo.entitlement) {
      case Entitlement.none:
        return _photos(provider.master.uid!);
      case Entitlement.lite:
        return Container();
      case Entitlement.base:
        return Container();
      case Entitlement.pro:
        return _photos(provider.master.uid!);
      case Entitlement.max:
        return _photos(provider.master.uid!);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MasterProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Image.asset('assets/logopro.png', height: 20),
            actions: [
              IconButton(
                icon: Icon(LineIcons.alternateSignOut),
                onPressed: () => AuthService().signOut(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  height: 80,
                  width: 63,
                  child: ClipRRect(
                    borderRadius: Constants.radius,
                    child: CachedNetworkImage(
                      imageUrl: provider.master.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CupertinoActivityIndicator(),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: Constants.radius,
                    boxShadow: Constants.shadow,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.master.group ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      provider.master.name ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    ProfileStatus(
                      masterUid: provider.master.uid!,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 15, top: 5),
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Редактировать профиль",
              icon: LineIcons.edit,
              onTap: () => MainRouter.nextPage(
                context,
                MasterPage(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Управление подпиской",
              icon: LineIcons.creditCard,
              onTap: () => MainRouter.nextPage(
                context,
                ManageSubscribePage(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _getQRCode(provider),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 15, top: 50),
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Настройки смен",
              icon: LineIcons.calendar,
              onTap: () => MainRouter.nextPage(
                context,
                ShiftSettingsPage(
                  masterUid: provider.master.uid!,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Рабочие адреса",
              icon: LineIcons.mapPin,
              onTap: () => MainRouter.nextPage(
                context,
                PlacesPage(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "Услуги и цены",
              icon: LineIcons.rubleSign,
              onTap: () => MainRouter.nextPage(
                context,
                PricesPage(
                  masterUid: provider.master.uid!,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _getPhotos(provider),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 15, top: 50),
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          SliverToBoxAdapter(
            child: StandartLink(
              label: "О приложении",
              icon: LineIcons.infoCircle,
              onTap: () => MainRouter.nextPage(
                context,
                InfoBottomSheet(),
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
