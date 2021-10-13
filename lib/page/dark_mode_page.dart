import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:provider/provider.dart';

class DarkModePage extends StatefulWidget {
  const DarkModePage({Key? key}) : super(key: key);

  @override
  _DarkModePageState createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  static const _ITEMS = [
    {"name": "跟随系统", "mode": ThemeMode.system},
    {"name": "夜间模式", "mode": ThemeMode.dark},
    {"name": "白天模式", "mode": ThemeMode.light},
  ];

  var _currentTheme;

  @override
  void initState() {
    super.initState();
    var themeMode = context.read<ThemeProvider>().getThemeMode();
    _ITEMS.forEach((element) {
      if (element['mode'] == themeMode) {
        _currentTheme = element;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            NavigationBar(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _ITEMS.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Divider(
                          height: 0.2,
                        ),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              _switchTheme(index);
                            },
                            child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                    left: 40, top: 15, bottom: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_ITEMS[index]["name"] as String),
                                    Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child: Opacity(
                                        opacity: _currentTheme == _ITEMS[index]
                                            ? 1
                                            : 0,
                                        child: Icon(Icons.done, color: primary),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        Divider(
                          height: 0.2,
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  void _switchTheme(int index) {
    var theme = _ITEMS[index];
    context.read<ThemeProvider>().setTheme(theme['mode'] as ThemeMode);
    setState(() {
      _currentTheme = theme;
    });
  }
}
