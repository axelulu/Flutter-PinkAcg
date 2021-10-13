import 'package:flutter/material.dart';
import 'package:flutter_pink/util/view_util.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 40),
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: Column(
        children: [
          Image(
            height: 150,
            fit: BoxFit.cover,
            image: AssetImage('assets/images/404.png'),
          ),
          hiSpace(height: 20),
          Text(
            "这里什么都没有······",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
