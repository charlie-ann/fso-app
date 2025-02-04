import 'package:flutter/material.dart';

import 'config.dart';

// Extensions to easily reach the size configuration class
extension SizeExtension on num {
  double get height => SizeConfig.height(toDouble());

  double get relHeight => SizeConfig.relHeight(toDouble());
  double get width => SizeConfig.width(toDouble());
  double get relWidth => SizeConfig.relWidth(toDouble());

  double get text => SizeConfig.textSize(toDouble());

  SizedBox get vSpacer => SizedBox(
        height: relHeight,
      );
  SizedBox get hSpacer => SizedBox(
        width: relWidth,
      );
}
