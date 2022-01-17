import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master/services/answers.dart';
import 'package:master/services/network.dart';
import 'package:master/services/router.dart';
import 'package:master/widgets/app_bar.dart';
import 'package:master/widgets/buttons.dart';
import 'package:master/widgets/empty_banner.dart';
import 'package:master/widgets/photo_cell.dart';
import 'package:master/widgets/snack_bar.dart';

class PhotosPage extends StatefulWidget {
  PhotosPage({
    required this.masterUid,
  });

  final String masterUid;

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  List<Photo> _photos = [];
  bool _loading = true;

  Future _pickImage() async {
    try {
      var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 550,
        maxHeight: 550,
      );
      if (image == null) return;

      var bytes = await image.readAsBytes();
      var string = base64Encode(bytes);

      NetHandler.addPhoto(widget.masterUid, string).then((value) {
        _updatePhotos();
        StandartSnackBar.show(
          context,
          value!,
          SnackBarStatus.success(),
        );
      });
    } on PlatformException catch (error) {
      StandartSnackBar.show(
        context,
        error.toString(),
        SnackBarStatus.warning(),
      );
    }
  }

  void _updatePhotos() async {
    setState(() {
      _loading = true;
    });

    var photos = await NetHandler.getPhotos(widget.masterUid);

    setState(() {
      _photos = photos ?? [];
      _loading = false;
    });
  }

  Widget _getList() {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: CupertinoActivityIndicator(),
        ),
      );
    } else {
      if (_photos.isEmpty) {
        return SliverToBoxAdapter(
          child: EmptyBanner(
            description: "Примеры еще не добавлены",
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var photo = _photos[index];
              return PhotoCell(
                imgUrl: photo.imgUrl,
                onTap: () => _checkDelete(
                  photo.photoId.toString(),
                ),
              );
            },
            childCount: _photos.length,
          ),
        );
      }
    }
  }

  void _checkDelete(String photoId) {
    MainRouter.openBottomSheet(
      context: context,
      height: MediaQuery.of(context).padding.bottom + 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            child: Text(
              "Удалить выбранное фото?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          StandartButton(
            label: "Удалить",
            color: Colors.red[700],
            onTap: () {
              Navigator.pop(context);
              _deletePhoto(photoId);
            },
          ),
        ],
      ),
    );
  }

  void _deletePhoto(String photoId) async {
    var result = await NetHandler.deletePhoto(widget.masterUid, photoId);

    if (result == null) {
      StandartSnackBar.show(
        context,
        "Ошибка",
        SnackBarStatus.warning(),
      );
    } else {
      StandartSnackBar.show(
        context,
        result,
        SnackBarStatus.success(),
      );
      _updatePhotos();
    }
  }

  @override
  void initState() {
    super.initState();
    _updatePhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              StandartAppBar(
                title: Text("Ваши примеры"),
              ),
              _getList(),
              SliverToBoxAdapter(
                child: Container(
                  height: 120,
                ),
              ),
            ],
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).padding.bottom + 15,
            child: StandartButton(
              label: "Добавить пример",
              onTap: _pickImage,
            ),
          ),
        ],
      ),
    );
  }
}
