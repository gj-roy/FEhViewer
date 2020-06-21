import 'package:FEhViewer/common/global.dart';
import 'package:FEhViewer/fehviewer/route/navigator_util.dart';
import 'package:FEhViewer/fehviewer/route/routes.dart';
import 'package:FEhViewer/models/provider/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FEhViewer/values/const.dart';
import 'package:provider/provider.dart';

/// 定义一个回调接口
typedef OnItemClickListener = void Function(int position);

class SettingTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingTab();
}

class _SettingTab extends State<SettingTab> {
  String _title = "设置";
  List _settingItemList = EHConst.settingList;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(_title),
        ),
        SliverSafeArea(
            top: false,
            minimum: const EdgeInsets.only(
              left: 8,
              top: 8,
              bottom: 8,
              right: 8,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                switch (index) {
                  case 0:
                    return UserItem();
                  default:
                    {
                      if (index < _settingItemList.length + 1)
                        return SettingItems(
                          index: index,
                          text: _settingItemList[index - 1]["title"],
                          icon: _settingItemList[index - 1]["icon"],
                          isLast: _settingItemList.length == index,
                          route: _settingItemList[index - 1]["route"],
                        );
                    }
                }
              }),
            ))
      ],
    );
  }
}

class UserItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserItem();
}

class _UserItem extends State<UserItem> {
  final _normalText = "未登录";
  Color _color;

  @override
  Widget build(BuildContext context) {
    void _tapItem() {
      if (Global.profile.user != null) {
        debugPrint(Global.profile.user.username);
      } else {
        NavigatorUtil.jump(context, EHRoutes.login);
      }
    }

    Widget _buildText() {
      return Consumer<UserModel>(
        builder: (BuildContext context, UserModel value, Widget child) {
          if (value.isLogin) {
            final _userName = value.user.username;
            return Text(_userName);
          } else {
            return Text(_normalText);
          }
        },
      );
    }

    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        // left: 16,
        top: 8,
        bottom: 8,
        // right: 16,
      ),
      child: Container(
        color: _color,
        child: Row(children: <Widget>[
          Icon(
            CupertinoIcons.profile_circled,
            size: 55.0,
            color: CupertinoColors.systemGrey,
          ),
          // 头像右侧信息
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _buildText(),
          )
        ]),
      ),
    );

//    return row;

    return GestureDetector(
      child: row,
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _tapItem();
//        NavigatorUtil.jump(context, EHRoutes.login);
      },
      onTapDown: (_) => _updatePressedColor(),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _updateNormalColor();
        });
      },
      onTapCancel: () => _updateNormalColor(),
    );
  }

  void _updateNormalColor() {
    setState(() {
      _color = CupertinoColors.systemBackground;
    });
  }

  void _updatePressedColor() {
    setState(() {
      _color = CupertinoColors.systemGrey4;
    });
  }
}

class SettingItems extends StatefulWidget {
  final int index;
  final String text;
  final IconData icon;
  final bool isLast;
  final String route;

  SettingItems({
    this.index,
    this.text,
    this.icon,
    this.isLast,
    this.route,
  });

  @override
  _SettingItems createState() => _SettingItems();
}

/// 设置项
class _SettingItems extends State<SettingItems> {
  Color _color;

  @override
  void initState() {
    super.initState();
    _color = CupertinoColors.systemBackground;
  }

  @override
  Widget build(BuildContext context) {
    // return Text(text);

    Widget container = Container(
        color: _color,
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _settingItemDivider(),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Icon(
                    widget.icon,
                    size: 28.0,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(widget.text),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      CupertinoIcons.forward,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
              ],
            ),
            widget.isLast ? _settingItemDivider() : new Container(), // 末尾分隔线
          ],
        ));

    return GestureDetector(
      child: container,
      // 不可见区域有效
      behavior: HitTestBehavior.opaque,
      onTap: () {
        debugPrint("set tap ${widget.index}  ${widget.isLast}");
        NavigatorUtil.jump(context, widget.route);
      },
      onTapDown: (_) => _updatePressedColor(),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _updateNormalColor();
        });
      },
      onTapCancel: () => _updateNormalColor(),
    );
  }

  void _updateNormalColor() {
    setState(() {
      _color = CupertinoColors.systemBackground;
    });
  }

  void _updatePressedColor() {
    setState(() {
      _color = CupertinoColors.systemGrey4;
    });
  }

  /// 设置项分隔线
  Widget _settingItemDivider() {
    return Divider(
      height: 0.5,
      indent: 45.0,
      color: CupertinoColors.systemGrey4,
    );
  }
}