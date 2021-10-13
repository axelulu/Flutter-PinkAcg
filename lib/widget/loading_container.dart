import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  ///加载动画是否覆盖在原有界面上
  final bool cover;

  const LoadingContainer(
      {Key? key,
      required this.isLoading,
      required this.child,
      this.cover = true})
      : super(key: key);

  Widget get _loadingView {
    return Center(
      child: Lottie.asset("assets/json/loading.json"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: [
          child,
          isLoading ? _loadingView : Container(),
        ],
      );
    } else {
      return Container();
    }
  }
}
