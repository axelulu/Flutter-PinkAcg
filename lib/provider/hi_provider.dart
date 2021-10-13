import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/provider/websocket_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> topProviders = [
  ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ChangeNotifierProvider(create: (_) => WebSocketProvider())
];
