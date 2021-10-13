import 'dart:async';
import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pink/http/dao/category_dao.dart';
import 'package:flutter_pink/http/dao/publish_post_dao.dart';
import 'package:flutter_pink/http/dao/upload_dao.dart';
import 'package:flutter_pink/model/category_mo.dart';
import 'package:flutter_pink/model/home_mo.dart';
import 'package:flutter_pink/model/upload_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/appbar.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:flutter_pink/widget/video_view.dart';
import 'package:hi_barrage/hi_barrage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:zefyrka/zefyrka.dart';

class PublishPage extends StatefulWidget {
  final String type;

  const PublishPage(this.type, {Key? key}) : super(key: key);

  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage>
    with SingleTickerProviderStateMixin {
  /// 编辑器
  late ZefyrController _controller;
  late FocusNode _focusNode;

  /// 视频
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

  List<CategoryMo>? category;

  String cover = "";

  String video = "";

  String title = "";

  String contents = "";

  String categorySlug = "";

  @override
  void initState() {
    /// 编辑器
    _controller = ZefyrController();
    _focusNode = FocusNode();

    /// 视频
    _videoPlayerController = VideoPlayerController.network(video);
    _videoPlayerController.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: false);
    _loadData();
    super.initState();
  }

  _loadData() async {
    CategoryModel result = await CategoryDao.get(20);
    setState(() {
      category = result.data;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _buildNavigationBar(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              // 标题
              widget.type == "post" || widget.type == "video"
                  ? _title()
                  : Container(),

              // 编辑器
              widget.type == "post"
                  ? _content()
                  : _textField(10, 500, 16, "请输入内容", "contents"),
              Divider(),
              // 分类
              _category(),
              // 封面
              widget.type == "post" ||
                      widget.type == "video" ||
                      widget.type == "dynamic"
                  ? _cover()
                  : Container(),
              // 视频
              widget.type == "video" ? _video() : Container(),
            ],
          ),
        )
      ],
    ));
  }

  Widget customZefyrEmbedBuilder(BuildContext context, EmbedNode node) {
    if (node.value.type.contains('image')) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          child: Image.network(node.value.data["source"], fit: BoxFit.fill),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(node.value.data["source"]);
            }));
          },
        ),
      );
    }

    return Container();
  }

  _buildNavigationBar() {
    return NavigationBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          appBarButton(Icons.arrow_back_ios_outlined, () {
            Navigator.of(context).pop();
          }),
          InkWell(
              onTap: _publish,
              child: Padding(
                padding: EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    color: primary,
                    child: Text(
                      "发布",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  _initZefyrEditor() {
    return ZefyrToolbar(children: [
      ToggleStyleButton(
        attribute: NotusAttribute.bold,
        icon: Icons.format_bold,
        controller: _controller,
      ),
      SizedBox(width: 1),
      ToggleStyleButton(
        attribute: NotusAttribute.italic,
        icon: Icons.format_italic,
        controller: _controller,
      ),
      VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
      SelectHeadingStyleButton(controller: _controller),
      VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
      ToggleStyleButton(
        attribute: NotusAttribute.block.numberList,
        controller: _controller,
        icon: Icons.format_list_numbered,
      ),
      ToggleStyleButton(
        attribute: NotusAttribute.block.bulletList,
        controller: _controller,
        icon: Icons.format_list_bulleted,
      ),
      VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
      ToggleStyleButton(
        attribute: NotusAttribute.block.quote,
        controller: _controller,
        icon: Icons.format_quote,
      ),
      CustomInsertImageButton(
        controller: _controller,
        icon: Icons.image,
      ),
    ]);
  }

  _itemTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  _title() {
    return Column(
      children: [
        _textField(1, 50, 22, "标题（建议30字以内）", "title"),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Divider(
            height: 1,
          ),
        ),
        hiSpace(height: 18),
      ],
    );
  }

  _textField(int lines, int length, double size, String hintText, String val) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      child: TextField(
        maxLines: lines,
        maxLength: length,
        cursorColor: primary,
        onChanged: (value) {
          setState(() {
            if (val == "title") {
              title = value;
            } else {
              contents = value;
            }
          });
        },
        style: TextStyle(fontSize: size, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: size, color: Colors.grey),

          isCollapsed: true,
          //内容内边距，影响高度
          border: OutlineInputBorder(
            ///用来配置边框的样式
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  _content() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, child: _initZefyrEditor()),
        ),
        Container(
          height: 200,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ZefyrEditor(
            minHeight: 100,
            maxHeight: 100,
            padding: EdgeInsets.only(top: 5, left: 10, right: 10),
            scrollable: true,
            controller: _controller,
            focusNode: _focusNode,
            autofocus: false,
            embedBuilder:
                customZefyrEmbedBuilder, // embedBuilder是处理图片上传的function
            // readOnly: true,
            // onLaunchUrl: _launchUrl,
          ),
        )
      ],
    );
  }

  _category() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 4, bottom: 4, right: 50),
          child: Column(
            children: [
              _itemTitle("请选择专栏分类"),
              category != null
                  ? Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 0,
                      runSpacing: -15,
                      children: category!.map((e) {
                        return Container(
                          child: menuButton(e.categoryName, () {
                            setState(() {
                              categorySlug = e.categorySlug;
                            });
                          }, isSelect: e.categorySlug == categorySlug),
                          margin: EdgeInsets.only(left: 6, right: 6, bottom: 8),
                        );
                      }).toList(),
                    )
                  : Container(),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  _cover() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 4, bottom: 4, right: 20),
          child: Column(
            children: [
              _itemTitle("请上传封面"),
              InkWell(
                onTap: () async {
                  ImageSource gallerySource = ImageSource.gallery;
                  final ImagePicker _picker = ImagePicker();
                  final file = await _picker.pickImage(
                      source: gallerySource, imageQuality: 65);
                  if (file == null) return null;
                  UplaodMo url = await UploadDao.uploadImg(file);
                  setState(() {
                    cover = url.data;
                  });
                },
                child: cachedImage(cover,
                    width: MediaQuery.of(context).size.width - 80, height: 150),
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  _video() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 4, bottom: 4, right: 20),
          child: Column(
            children: [
              _itemTitle("请上传视频"),
              Container(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                      onTap: () async {
                        ImageSource gallerySource = ImageSource.gallery;
                        final ImagePicker _picker = ImagePicker();
                        final file =
                            await _picker.pickVideo(source: gallerySource);
                        if (file == null) return null;
                        UplaodMo url = await UploadDao.uploadVideo(file);
                        setState(() {
                          video = HiConstants.ossDomain + "/" + url.data;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          color: primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_upload,
                                color: Colors.white,
                                size: 14,
                              ),
                              Text(
                                "点我上传视频!",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ],
                          ))),
                ),
              ),
              video != ""
                  ? VideoView(
                      video,
                      cover: cover,
                      overlayUI: videoAppBar(onBack: () {}),
                      barrageUI: HiBarrage(
                        headers: HiConstants.header(),
                        vid: "0",
                        autoPlay: true,
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width - 80,
                      height: 150)
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  void _publish() async {
    if (widget.type == "dynamic" && contents.length <= 0) {
      showWarnToast("请填写完整内容");
      return;
    }
    if (widget.type == "post" &&
        (_controller.document.length <= 0 ||
            cover.length <= 0 ||
            title.length <= 0)) {
      showWarnToast("请填写完整内容");
      return;
    }
    if (widget.type == "video" &&
        (_controller.document.length <= 0 ||
            cover.length <= 0 ||
            title.length <= 0 ||
            video.length <= 0)) {
      showWarnToast("请填写完整内容");
      return;
    }
    if (widget.type != "dynamic") {
      contents = jsonEncode(_controller.document);
    }
    var res = await PublishPostDao.get(
        title, contents, cover, categorySlug, widget.type, video);
    if (res["code"] == 1000) {
      showToast("文章发布成功");
      Future.delayed(Duration(milliseconds: 1000), () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      });
    } else {
      showWarnToast("文章发布失败");
    }
  }
}

///图片上传按钮
class CustomInsertImageButton extends StatelessWidget {
  final ZefyrController controller;
  final IconData icon;

  const CustomInsertImageButton({
    Key? key,
    required this.controller,
    required this.icon,
  }) : super(key: key);

  Future<String?> pickImage(ImageSource source) async {}

  @override
  Widget build(BuildContext context) {
    return ZIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 32,
      icon: Icon(
        icon,
        size: 18,
        color: Theme.of(context).iconTheme.color,
      ),
      fillColor: Theme.of(context).canvasColor,
      onPressed: () async {
        final index = controller.selection.baseOffset;
        final length = controller.selection.extentOffset - index;
        ImageSource gallerySource = ImageSource.gallery;
        // controller.replaceText(index, length, BlockEmbed.image("https://img.alicdn.com/imgextra/i1/6000000003634/O1CN01XkL17h1ciPvkUalkW_!!6000000003634-2-octopus.png",));

        final ImagePicker _picker = ImagePicker();
        final file =
            await _picker.pickImage(source: gallerySource, imageQuality: 65);
        if (file == null) return null;
        UplaodMo url = await UploadDao.uploadImg(file);
        controller.replaceText(index, length,
            BlockEmbed.image(HiConstants.ossDomain + "/" + url.data));
      },
    );
  }
}

///图片细节
class DetailScreen extends StatelessWidget {
  String _image = "";

  DetailScreen(this._image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imageHero',
              child: Image.network(_image, fit: BoxFit.contain)),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
