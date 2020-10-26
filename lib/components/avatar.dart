import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'matrix.dart';

class Avatar extends StatelessWidget {
  final Uri mxContent;
  final String name;
  final double size;
  final Function onTap;
  static const double defaultSize = 44;

  const Avatar(
    this.mxContent,
    this.name, {
    this.size = defaultSize,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var thumbnail = mxContent?.getThumbnail(
      Matrix.of(context).client,
      width: size * MediaQuery.of(context).devicePixelRatio,
      height: size * MediaQuery.of(context).devicePixelRatio,
    );
    final src = thumbnail;
    var fallbackLetters = '@';
    if ((name?.runes?.length ?? 0) >= 2) {
      fallbackLetters = String.fromCharCodes(name.runes, 0, 2);
    } else if ((name?.runes?.length ?? 0) == 1) {
      fallbackLetters = name;
    }
    final textWidget = Center(
      child: Text(
        fallbackLetters,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
    final noPic = mxContent == null || mxContent.toString().isEmpty;
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          color: noPic
              ? name?.lightColor ?? Theme.of(context).secondaryHeaderColor
              : Theme.of(context).secondaryHeaderColor,
          child: noPic
              ? textWidget
              : CachedNetworkImage(
                  imageUrl: src,
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                  placeholder: (c, s) => Stack(
                    children: [
                      Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      textWidget,
                    ],
                  ),
                  errorWidget: (c, s, d) => Stack(
                    children: [
                      textWidget,
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
