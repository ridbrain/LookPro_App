import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master/services/constants.dart';

class PhotoCell extends StatelessWidget {
  PhotoCell({
    required this.imgUrl,
    required this.onTap,
  });

  final String imgUrl;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: Constants.radius,
        child: ClipRRect(
          borderRadius: Constants.radius,
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }
}
