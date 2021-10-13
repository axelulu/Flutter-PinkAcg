import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'barrage_model.dart';

class BarrageViewUtil {
  static barrageView(BarrageModel model) {
    switch (model.type) {
      case 1:
        return _barrageType1(model);
    }
    return Text(
      model.content,
      style: TextStyle(color: Colors.white),
    );
  }

  static _barrageType1(BarrageModel model) {
    return Center(
      child: Container(
        child: Text(
          model.content,
          style: TextStyle(color: Colors.deepOrangeAccent),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
