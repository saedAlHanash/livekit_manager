import 'package:flutter/material.dart' hide ExpansionPanelHeaderBuilder;
import 'package:livekit_manager/core/strings/app_color_manager.dart';

import 'my_expansion_panal.dart';

class ItemExpansion {
  ItemExpansion({
    required this.headerBuilder,
    required this.itemBuilder,
    required this.body,
    this.isExpanded = false,
    this.enable = true,
    this.additional,
    this.headerDecoration,
    this.id,
  });

  final ExpansionPanelHeaderBuilder headerBuilder;
  final ExpansionPanelBodyBuilder itemBuilder;
  final Widget body;
  bool isExpanded;
  final BoxDecoration? headerDecoration;

  bool enable;

  String? additional;
  String? id;
}

class ItemExpansionOption {
  ItemExpansionOption({
    this.withSideColor = false,
    this.color = AppColorManager.white,
  });

  bool withSideColor;
  Color color;
}
