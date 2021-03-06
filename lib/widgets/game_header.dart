import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numbers_game/util/dimension_helper.dart';
import 'package:numbers_game/widgets/stateless_widget_proxy.dart';

class GameHeader extends StatelessWidgetProxy with DimensionHelper {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getPercentFromWidth(context, 5),
        top: getPercentFromWidth(context, 5),
        bottom: getPercentFromWidth(context, 2),
      ),
      child: Text('2048', style: TextStyle(
          color: Colors.teal,
          fontSize: 72 * getFactor(context),
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}