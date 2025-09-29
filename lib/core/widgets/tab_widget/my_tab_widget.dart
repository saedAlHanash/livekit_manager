import 'package:flutter/material.dart';

class MyTabWidget extends StatelessWidget {
  const MyTabWidget({
    super.key,
    required this.tabs,
    this.height,
    required this.tabsView,
  });

  final List<Widget> tabs;
  final List<Widget> tabsView;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
              labelPadding: EdgeInsetsGeometry.all(5),
              tabs: tabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: tabsView,
            ),
          ),
        ],
      ),
    );
  }
}
