import 'package:flutter/widgets.dart';

abstract class DimensionHelper {
  double getPercentFromWidth(BuildContext context, int percent)  => getWidth(context) * percent / 100;
  double getPercentFromHeight(BuildContext context, int percent)  => getHeight(context) * percent / 100;
  double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double getHeight(BuildContext context) => MediaQuery.of(context).size.height;
  double getFactor(BuildContext context) => getWidth(context) / 600;
}