import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numbers_game/util/dimension_helper.dart';
import 'package:numbers_game/widgets/stateless_widget_proxy.dart';

class GameButton extends StatelessWidgetProxy with DimensionHelper {

  final String caption;
  final String value;
  final VoidCallback onTap;

  GameButton({this.caption, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    final valueFontSize = 24 * getFactor(context);
    final captionFontSize = value != null? 12 * getFactor(context) : valueFontSize;

    var child = value != null
      ? Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(caption, style: TextStyle(fontSize: captionFontSize, color: Colors.white)),
        Text(value, style: TextStyle(fontSize: valueFontSize, color: Colors.white)),
      ])
      : Text(caption, style: TextStyle(fontSize: captionFontSize, color: Colors.white));

    if (onTap != null) {
      child = GestureDetector(child: child, onTapDown: (_) => onTap());
    }

    final container = Container(
      height: getPercentFromHeight(context, 6),
      padding: EdgeInsets.symmetric(horizontal: getPercentFromWidth(context, 3)),
      margin: EdgeInsets.only(top: getPercentFromHeight(context, 3), right: getPercentFromWidth(context, 5)),
      child: Center(child: child),
      decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.all(Radius.circular(getPercentFromWidth(context, 1)))),
    );
    return container;
  }

}