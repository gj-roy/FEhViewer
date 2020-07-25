import 'package:FEhViewer/common/global.dart';
import 'package:FEhViewer/common/parser/gallery_list_parser.dart';
import 'package:FEhViewer/generated/l10n.dart';
import 'package:FEhViewer/models/index.dart';
import 'package:FEhViewer/utils/utility.dart';
import 'package:FEhViewer/widget/eh_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'item/gallery_item.dart';

class GalleryListTab extends StatefulWidget {
  final tabIndex;

  const GalleryListTab({Key key, this.tabIndex}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _GalleryListTabState();
}

class _GalleryListTabState extends State<GalleryListTab> {
  String _title = "Gallery";
  int _curPage = 0;
  int _maxPage = 0;
  bool _isLoadMore = false;
  bool _firstLoading = false;
  final List<GalleryItem> _gallerItemBeans = [];

  //页码跳转的控制器
  TextEditingController _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _gallerItemBeans.clear();
      _firstLoading = true;
    });
    var tuple = await Api.getGallery();
    var gallerItemBeans = tuple.item1;
    _gallerItemBeans.addAll(gallerItemBeans);
    _maxPage = tuple.item2;
    setState(() {
      _firstLoading = false;
    });
  }

  _reloadData() async {
    setState(() {
      _firstLoading = false;
    });
    var tuple = await Api.getGallery();
    var gallerItemBeans = tuple.item1;
    setState(() {
      _curPage = 0;
      _gallerItemBeans.clear();
      _gallerItemBeans.addAll(gallerItemBeans);
      _maxPage = tuple.item2;
    });
  }

  _loadDataMore() async {
    _isLoadMore = true;
    Global.logger.v('last gid   ===>  ${_gallerItemBeans.last.gid}');
    _curPage += 1;
    var fromGid = _gallerItemBeans.last.gid;
    var tuple = await Api.getGallery(page: _curPage, fromGid: fromGid);
    var gallerItemBeans = tuple.item1;

    _isLoadMore = false;
    setState(() {
      _gallerItemBeans.addAll(gallerItemBeans);
      _maxPage = tuple.item2;
    });
  }

  _loadFromPage(int page) async {
    Global.logger.v('jump to page   ===>  $page');
    setState(() {
      _firstLoading = true;
    });
    _curPage = page;
    var tuple = await Api.getGallery(page: _curPage);
    var gallerItemBeans = tuple.item1;
    setState(() {
      _gallerItemBeans.clear();
      _gallerItemBeans.addAll(gallerItemBeans);
      _maxPage = tuple.item2;
      _firstLoading = false;
    });
  }

  SliverList gallerySliverListView(List gallerItemBeans) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < gallerItemBeans.length) {
            return GalleryItemWidget(
              galleryItem: gallerItemBeans[index],
              tabIndex: widget.tabIndex,
            );
          }
          return null;
        },
      ),
    );
  }

  /// 跳转页码
  Future<void> _jumtToPage(BuildContext context) async {
    return showCupertinoDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('页面跳转'),
          content: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("跳转范围 1~$_maxPage"),
                ),
                CupertinoTextField(
                  controller: _pageController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onEditingComplete: () {
                    // 点击键盘完成
                    // 画廊跳转
                    _loadFromPage(int.parse(_pageController.text) - 1);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'),
              onPressed: () {
                // 画廊跳转
                _loadFromPage(int.parse(_pageController.text) - 1);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final width = size.width;
    final height = size.height;
    final _topPad = height / 2 - 150;

    var ln = S.of(context);
    _title = ln.tab_gallery;
    CustomScrollView customScrollView = CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: TabPageTitle(
            title: _title,
            isLoading: false,
          ),
          trailing: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: Text('${_curPage + 1}'),
            onPressed: () {
              _jumtToPage(context);
            },
          ),
          transitionBetweenRoutes: false,
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await _reloadData();
          },
        ),
        SliverSafeArea(
          top: false,
          sliver: _firstLoading
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(top: _topPad),
                    child: CupertinoActivityIndicator(
                      radius: 14.0,
                    ),
                  ),
                )
              : gallerySliverListView(_gallerItemBeans),
        ),
      ],
    );

    EasyRefresh re = EasyRefresh(
      child: customScrollView,
      // footer: BallPulseFooter(),
      onLoad: () async {
        // ignore: unnecessary_statements
        _isLoadMore ? null : _loadDataMore();
      },
    );

    return re;
  }
}