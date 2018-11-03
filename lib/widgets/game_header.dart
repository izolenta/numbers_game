import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numbers_game/util/dimension_helper.dart';

class GameHeader extends StatelessWidgetProxy with DimensionHelper {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getPercentFromWidth(context, 10), top: getPercentFromWidth(context, 10)),
      child: Text('2048', style: TextStyle(
          color: Colors.teal,
          fontSize: 72 * getFactor(context),
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

//a dirty hack because of https://github.com/dart-lang/sdk/issues/31543
class StatelessWidgetProxy extends StatelessWidget {
  @override
  Widget build(BuildContext context) => null;
}