import 'dart:html';

import 'package:flutter/material.dart';

class AppDrawerMenu extends StatefulWidget {
  const AppDrawerMenu({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<AppDrawerMenu> createState() => _AppDrawerMenuState();
}

class _AppDrawerMenuState extends State<AppDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        //TODO:feedlyのメニューをパクる
        //
        scrollDirection: Axis.vertical,//垂直
        child: Column(children: const [
          Align(
            alignment: Alignment.topRight,
            child: ,
          ),
          // DrawerHeader(
          //   decoration: BoxDecoration(
          //       // color: Color.fromARGB(79, 74, 81, 88),
          //       ),
          //   child: Text(
          //     'Drawer Header',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 24,
          //     ),
          //   ),
          // ),
          ListTile(
            //子要素としてはListTileを入れる
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          //PLAN:ボタンでメニューを閉じる
        ]),
      ),
    );
  }
}
