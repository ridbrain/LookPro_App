import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class Photo extends StatefulWidget {
  Photo({
    required this.newImage,
  });

  final Function(String image) newImage;

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  File? _image;

  Widget _getImage(String url) {
    if (_image == null) {
      if (url.isEmpty) {
        return Image.asset(
          'assets/placeholder.png',
          fit: BoxFit.cover,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => CupertinoActivityIndicator(),
        );
      }
    } else {
      return Image.file(
        _image!,
        fit: BoxFit.cover,
      );
    }
  }

  Future _pickImage() async {
    try {
      var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image == null) return;

      var bytes = await image.readAsBytes();
      var string = base64Encode(bytes);

      setState(() {
        _image = File(image.path);
        widget.newImage(string);
      });
    } on PlatformException catch (error) {
      StandartSnackBar.show(
        context,
        error.toString(),
        SnackBarStatus.warning(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var master = Provider.of<MasterProvider>(context).master;

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              child: _getImage(master.imageUrl!),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 100,
            child: Stack(
              children: [
                Positioned(
                  right: 3,
                  bottom: 3,
                  child: Container(
                    width: 25,
                    height: 25,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.blueGrey,
                      size: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
