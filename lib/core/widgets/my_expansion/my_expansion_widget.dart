import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../strings/app_color_manager.dart';
import 'item_expansion.dart';
import 'my_expansion_panal.dart';

class MyExpansionWidget extends StatefulWidget {
  const MyExpansionWidget({
    super.key,
    required this.items,
    this.onTapItem,
  });

  final List<ItemExpansion> items;

  final Function(int i, bool isExpanded, bool enable)? onTapItem;

  @override
  State<MyExpansionWidget> createState() => _MyExpansionWidgetState();
}

class _MyExpansionWidgetState extends State<MyExpansionWidget> {
  @override
  Widget build(BuildContext context) {
    final listItem = widget.items.map(
      (e) {
        return MyExpansionPanel(
          canTapOnHeader: true,
          isExpanded: e.isExpanded,
          headerBuilder: e.headerBuilder,
          itemBuilder: e.itemBuilder,
          headerDecoration: e.headerDecoration,
          enable: e.enable,
          onTapItem: widget.onTapItem,
          body: e.body,
        );
      },
    ).toList();

    return MyExpansionPanelList(
      elevation: 0.0,
      cardElevation: 0,
      children: listItem,
      dividerColor: Colors.transparent,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          widget.items[panelIndex].isExpanded = !widget.items[panelIndex].isExpanded;
        });
      },
    );
  }
}

class MyExpansionWidgetRadio extends StatefulWidget {
  const MyExpansionWidgetRadio({
    super.key,
    required this.items,
    this.onTapItem,
    this.elevation,
    this.onExpansion,
    this.enable,
  });

  final List<ItemExpansion> items;
  final double? elevation;

  final Function(int, bool, bool)? onTapItem;
  final bool Function()? enable;
  final Function(int panelIndex, bool isExpanded)? onExpansion;

  @override
  State<MyExpansionWidgetRadio> createState() => _MyExpansionWidgetRadioState();
}

class _MyExpansionWidgetRadioState extends State<MyExpansionWidgetRadio> {
  @override
  Widget build(BuildContext context) {
    final listItem = widget.items.map(
      (e) {
        return MyExpansionPanelRadio(
          canTapOnHeader: true,
          isExpanded: e.isExpanded,
          onTapItem: widget.onTapItem,
          backgroundColor: (e.isExpanded) ? AppColorManager.lightGray : AppColorManager.white,
          headerBuilder: e.headerBuilder,
          itemBuilder: e.itemBuilder,
          headerDecoration: e.headerDecoration,
          enableTap: widget.enable,
          body: e.body,
          enable: e.enable,
          value: e.id ?? '',
        );
      },
    ).toList();

    return MyExpansionPanelList.radio(
      elevation: 0.0,
      cardElevation: 0,
      children: listItem,
      initialOpenPanelValue: listItem.firstWhereOrNull((e) => e.isExpanded)?.value,
      dividerColor: Colors.transparent,
      expansionCallback: (panelIndex, isExpanded) {
        widget.onExpansion?.call(panelIndex, isExpanded);
        setState(() {
          widget.items[panelIndex].isExpanded = !widget.items[panelIndex].isExpanded;
        });
      },
    );
  }
}
