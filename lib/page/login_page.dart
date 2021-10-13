import 'package:flutter/material.dart';
import 'package:flutter_pink/http/dao/login_dao.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/util/string_util.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/widget/appbar.dart';
import 'package:flutter_pink/widget/login_button.dart';
import 'package:flutter_pink/widget/login_effect.dart';
import 'package:flutter_pink/widget/login_input.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  late String userName;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("密码登录", "注册", () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              title: "密码",
              hint: "请输入密码",
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (text) {
                setState(() {
                  protect = text;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                "登录",
                enable: loginEnable,
                onPressed: send,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      this.loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName, password);
      if (result['code'] == 1000) {
        showToast("登录成功");
        // 登录用户账号
        UmengCommonSdk.onProfileSignIn("user_id");
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      } else {
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      // showWarnToast(e.toString());
    }
  }
}
