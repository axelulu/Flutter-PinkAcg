import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HiDefend {
  run(Widget app) {
    //框架异常
    FlutterError.onError = (FlutterErrorDetails details) async {
      //线上环境
      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        //开发期间
        FlutterError.dumpErrorToConsole(details);
      }
    };

    runZonedGuarded(() {
      runApp(app);
    }, (e, s) => _reportError(e, s));
  }

  _reportError(Object error, StackTrace s) {
    print("kReleaseMode: $kReleaseMode");
    print("carch error: $error");
  }
}
