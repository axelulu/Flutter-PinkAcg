import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 文章盒子长按更多操作蒙板
void moreHandleDialog(BuildContext context, double height, Widget child) {
  showFlexibleBottomSheet(
    minHeight: 0,
    initHeight: height,
    maxHeight: 1,
    context: context,
    builder: (
      BuildContext context,
      ScrollController scrollController,
      double bottomSheetOffset,
    ) {
      return child;
    },
    anchors: [0, 0.5, 1],
  );
}
