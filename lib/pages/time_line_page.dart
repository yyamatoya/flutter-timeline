import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:post_app/models/user_model.dart';
import 'package:post_app/pages/login_page.dart';
import 'package:post_app/providers/user_provider.dart';
import 'package:post_app/widget/avatar.dart';
import 'package:post_app/widget/time_line_widget.dart';
import 'package:provider/provider.dart';

import '../widget/drawer.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({super.key});

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  var logger = Logger();

  final String title = "タイムライン";

  final List<String> _tabTitles = ['新着順', 'フォロー順'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  List<Tab> generateTabs() {
    return _tabTitles.map((t) => Tab(text: t)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
          length: _tabTitles.length,
          child: Builder(
            builder: (context) {
              _tabController = DefaultTabController.of(context);
              _tabController.addListener(() {
                if (_tabController.indexIsChanging) {}
              });
              return Scaffold(
                appBar: AppBar(
                  bottom: TabBar(tabs: generateTabs()),
                  title: Text(title),
                  leading: getOpenDrawerIcon(),
                  elevation: 0,
                  centerTitle: true,
                ),
                body:
                    const TabBarView(children: [TimeLineWidget(), Scaffold()
                ]),
                drawer: const DrawerWidget(),
              );
            },
          )),
    );
  }

  Future<Widget?> showAppInfoDialog(BuildContext context) async {
    return await PackageInfo.fromPlatform().then((info) {
      showAboutDialog(
        context: context,
        applicationName: info.appName,
        applicationVersion: info.version,
      );
    }).catchError((error) => null);
  }

  Widget getOpenDrawerIcon() {
    return Builder(builder: ((context) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    }));
  }
}
