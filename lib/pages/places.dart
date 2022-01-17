import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/pages/new_place.dart';
import 'package:master/pages/place.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/place_cell.dart';
import 'package:provider/provider.dart';

class PlacesPage extends StatefulWidget {
  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  List<Place> _places = [];
  bool _loading = true;
  bool _first = true;

  void _updatePlaces(String masterUid) async {
    setState(() {
      _loading = true;
    });

    var places = await NetHandler.getPlaces(masterUid);

    setState(() {
      _places = places ?? [];
      _loading = false;
    });
  }

  Widget _getList(String masterUid) {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      );
    }
    if (_places.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            var place = _places[index];
            return PlaceCell(
              place: place,
              onTap: () => MainRouter.nextPage(
                context,
                PlacePage(
                  masterUid: masterUid,
                  place: place,
                ),
              ).then(
                (value) => _updatePlaces(masterUid),
              ),
            );
          },
          childCount: _places.length,
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: EmptyBanner(
          description: "Рабочие адреса еще не добавлены.",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var master = Provider.of<MasterProvider>(context).master;

    if (_first) {
      _updatePlaces(master.uid!);
      _first = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              StandartAppBar(
                title: Text("Адреса"),
              ),
              _getList(master.uid!),
            ],
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).padding.bottom + 15,
            child: StandartButton(
              label: "Добавить адрес",
              onTap: () => MainRouter.nextPage(
                context,
                NewPlacePage(masterUid: master.uid!),
              ).then(
                (value) => _updatePlaces(master.uid!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
