import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/hi_video_controls.dart' as MaterialControls;
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

///播放器组件
class VideoView extends StatefulWidget {
  final String url;
  final String cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Widget overlayUI;
  final Widget barrageUI;

  const VideoView(this.url,
      {Key? key,
      this.cover = "",
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      required this.overlayUI,
      required this.barrageUI})
      : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  //封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover, height: 220),
      );

  //进度条颜色
  get _progressColors => ChewieProgressColors(
        playedColor: primary,
        handleColor: primary,
        backgroundColor: Colors.grey,
        bufferedColor: primary,
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化播放器
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
        customControls: MaterialControls.MaterialControls(
          showBigPlayIcon: false,
          showLoadingOnInitialize: true,
          bottomGradient: blackLinearGradient(),
          overlayUI: widget.overlayUI,
          barrageUI: widget.barrageUI,
        ),
        allowMuting: false,
        allowPlaybackSpeedChanging: false,
        placeholder: _placeholder,
        videoPlayerController: _videoPlayerController,
        materialProgressColors: _progressColors,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        aspectRatio: widget.aspectRatio);
    _chewieController.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    _chewieController.removeListener(_fullScreenListener);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;
    return Container(
      height: playerHeight,
      width: screenWidth,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
