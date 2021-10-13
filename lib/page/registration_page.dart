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

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  late String userName;
  late String password;
  late String rePassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
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
                focusChanged: (text) {}),
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
                    this.protect = text;
                  });
                }),
            LoginInput(
                title: "确认密码",
                hint: "请再次输入密码",
                obscureText: true,
                onChanged: (text) {
                  rePassword = text;
                  checkInput();
                },
                focusChanged: (text) {
                  setState(() {
                    this.protect = text;
                  });
                }),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                "注册",
                enable: loginEnable,
                onPressed: checkParams,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword)) {
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
      var result = await LoginDao.registration(userName, password, rePassword);
      if (result['code'] == 1000) {
        showToast("注册成功");
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      } else {
        showWarnToast(result['msg']);
      }
    } on NeedLogin catch (e) {}
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = "二次密码不一致";
    }
    if (tips != null) {
      return;
    }
    send();
  }
}
