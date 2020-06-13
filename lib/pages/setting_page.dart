import 'package:FEhViewer/route/navigator_util.dart';
import 'package:FEhViewer/utils/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FEhViewer/values/const.dart';

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
                        return SettingItem(
                          index: index,
                          text: _settingItemList[index - 1]["title"],
                          icon: _settingItemList[index - 1]["icon"],
                          isLast: _settingItemList.length == index,
                        );
                    }
                }
              }),
            ))
      ],
    );
  }
}

class _UserItem extends State<UserItem> {
  String _userName = "未登录";

  @override
  Widget build(BuildContext context) {
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
        child: Row(children: <Widget>[
          Icon(
            CupertinoIcons.profile_circled,
            size: 55.0,
            color: CupertinoColors.systemGrey,
          ),
          // 头像右侧信息
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(_userName),
          )
        ]),
      ),
    );
    return row;
  }
}

class UserItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserItem();
}

class SettingItem extends StatefulWidget {
  final int index;
  final String text;
  final IconData icon;
  final bool isLast;

  SettingItem({
    this.index,
    this.text,
    this.icon,
    this.isLast,
  });

  @override
  _SettingItem createState() => _SettingItem();
}

/// 设置项
class _SettingItem extends State<SettingItem> {
  Color _color;

  @override
  void initState() {
    super.initState();
    _color = Colors.white;
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
//            _settingItemDivider(),
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
//            widget.isLast ? _settingItemDivider() : new Container(), // 末尾分隔线
          ],
        ));

    return GestureDetector(
      child: container,
      onTap: () {
        debugPrint("set tap ${widget.index}  ${widget.isLast}");
//          widget.listener(widget.index);
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
      _color = Colors.white;
    });
  }

  void _updatePressedColor() {
    setState(() {
      _color = Color(0xFFF0F1F2);
    });
  }

  /// 设置项分隔线
  Widget _settingItemDivider() {
    return Divider(
      height: 1.0,
      indent: 45.0,
      color: CupertinoColors.systemGrey,
    );
  }
}