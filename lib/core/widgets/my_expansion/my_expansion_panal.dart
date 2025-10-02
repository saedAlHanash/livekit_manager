import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lk_assistant/core/widgets/my_card_widget.dart';

import '../../strings/app_color_manager.dart';

const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension;
const EdgeInsets _kPanelHeaderExpandedDefaultPadding = EdgeInsets.symmetric(
  vertical: 64.0 - _kPanelHeaderCollapsedHeight,
);

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _SaltedKey<S, V> && other.salt == salt && other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? "<'$salt'>" : '<$salt>';
    final String valueString = V == String ? "<'$value'>" : '<$value>';
    return '[$saltString $valueString]';
  }
}

/// Signature for the callback that's called when an [MyExpansionPanel] is
/// expanded or collapsed.
///
/// The position of the panel within an [MyExpansionPanelList] is given by
/// [panelIndex].
typedef ExpansionPanelCallback = void Function(int panelIndex, bool isExpanded);

/// Signature for the callback that's called when the header of the
/// [MyExpansionPanel] needs to rebuild.
typedef ExpansionPanelHeaderBuilder = Widget Function(BuildContext context, bool isExpanded);
typedef ExpansionPanelBodyBuilder = Widget Function(BuildContext context, Widget body);

/// A material expansion panel. It has a header and a body and can be either
/// expanded or collapsed. The body of the panel is only visible when it is
/// expanded.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=2aJZzRMziJc}
///
/// Expansion panels are only intended to be used as children for
/// [MyExpansionPanelList].
///
/// See [MyExpansionPanelList] for a sample implementation.
///
/// See also:
///
///  * [MyExpansionPanelList]
///  * <https://material.io/design/components/lists.html#types>
class MyExpansionPanel {
  /// Creates an expansion panel to be used as a child for [MyExpansionPanelList].
  /// See [MyExpansionPanelList] for an example on how to use this widget.
  ///
  /// The [headerBuilder], [body], and [isExpanded] arguments must not be null.
  MyExpansionPanel({
    this.onTapItem,
    required this.enable,
    this.enableTap,
    required this.headerBuilder,
    required this.itemBuilder,
    required this.body,
    this.isExpanded = false,
    this.canTapOnHeader = false,
    this.backgroundColor,
    this.headerDecoration,
  });

  final bool Function()? enableTap;

  /// The widget builder that builds the expansion panels' header.
  final ExpansionPanelHeaderBuilder headerBuilder;
  final ExpansionPanelBodyBuilder itemBuilder;

  final Function(int i, bool isExpanded, bool enable)? onTapItem;

  /// The body of the expansion panel that's displayed below the header.
  ///
  /// This widget is visible only when the panel is expanded.
  final Widget body;

  /// Whether the panel is expanded.
  ///
  /// Defaults to false.
  final bool isExpanded;

  final bool enable;

  // final Widget Function(Widget child)? headerBuilder;
  // final Widget Function(Widget child)? headerBuilder;

  /// Whether tapping on the panel's header will expand/collapse it.
  ///
  /// Defaults to false.
  final bool canTapOnHeader;

  /// Defines the background color of the panel.
  ///
  /// Defaults to [ThemeData.cardColor].
  final Color? backgroundColor;
  final BoxDecoration? headerDecoration;
}

/// An expansion panel that allows for radio-like functionality.
/// This means that at any given time, at most, one [MyExpansionPanelRadio]
/// can remain expanded.
///
/// A unique identifier [value] must be assigned to each panel.
/// This identifier allows the [MyExpansionPanelList] to determine
/// which [MyExpansionPanelRadio] instance should be expanded.
///
/// See [ExpansionPanelList.radio] for a sample implementation.
/// An expansion panel that allows for radio-like functionality.
/// This means that at any given time, at most, one [MyExpansionPanelRadio]
/// can remain expanded.
///
/// A unique identifier [value] must be assigned to each panel.
/// This identifier allows the [MyExpansionPanelList] to determine
/// which [MyExpansionPanelRadio] instance should be expanded.
///
/// See [ExpansionPanelList.radio] for a sample implementation.
class MyExpansionPanelRadio extends MyExpansionPanel {
  /// An expansion panel that allows for radio functionality.
  ///
  /// A unique [value] must be passed into the constructor. The
  /// [headerBuilder], [body], [value] must not be null.
  MyExpansionPanelRadio({
    required this.value,
    required super.headerBuilder,
    required super.itemBuilder,
    required super.body,
    super.canTapOnHeader,
    super.isExpanded,
    super.onTapItem,
    super.backgroundColor,
    super.enableTap,
    super.headerDecoration,
    super.enable = true,
  });

  /// The value that uniquely identifies a radio panel so that the currently
  /// selected radio panel can be identified.
  final Object value;
}

/// A material expansion panel list that lays out its children and animates
/// expansions.
///
/// Note that [expansionCallback] behaves differently for [MyExpansionPanelList]
/// and [ExpansionPanelList.radio].
///
/// {@tool dartpad}
/// Here is a simple example of how to implement ExpansionPanelList.
///
/// ** See code in examples/api/lib/material/expansion_panel/expansion_panel_list.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [MyExpansionPanel]
///  * [ExpansionPanelList.radio]
///  * <https://material.io/design/components/lists.html#types>
class MyExpansionPanelList extends StatefulWidget {
  /// Creates an expansion panel list widget. The [expansionCallback] is
  /// triggered when an expansion panel expand/collapse button is pushed.
  ///
  /// The [children] and [animationDuration] arguments must not be null.
  const MyExpansionPanelList({
    super.key,
    this.children = const <MyExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2,
    this.cardElevation,
    this.headerDecoration,
  }) : _allowOnlyOnePanelOpen = false,
       initialOpenPanelValue = null;

  /// Creates a radio expansion panel list widget.
  ///
  /// This widget allows for at most one panel in the list to be open.
  /// The expansion panel callback is triggered when an expansion panel
  /// expand/collapse button is pushed. The [children] and [animationDuration]
  /// arguments must not be null. The [children] objects must be instances
  /// of [MyExpansionPanelRadio].
  ///
  /// {@tool dartpad}
  /// Here is a simple example of how to implement ExpansionPanelList.radio.
  ///
  /// ** See code in examples/api/lib/material/expansion_panel/expansion_panel_list.expansion_panel_list_radio.0.dart **
  /// {@end-tool}
  const MyExpansionPanelList.radio({
    super.key,
    this.children = const <MyExpansionPanelRadio>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.initialOpenPanelValue,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2,
    this.headerDecoration,
    this.cardElevation,
  }) : _allowOnlyOnePanelOpen = true;

  /// The children of the expansion panel list. They are laid out in a similar
  /// fashion to [ListBody].
  final List<MyExpansionPanel> children;

  /// The callback that gets called whenever one of the expand/collapse buttons
  /// is pressed. The arguments passed to the callback are the i of the
  /// pressed panel and whether the panel is currently expanded or not.
  ///
  /// If ExpansionPanelList.radio is used, the callback may be called a
  /// second time if a different panel was previously open. The arguments
  /// passed to the second callback are the i of the panel that will close
  /// and false, marking that it will be closed.
  ///
  /// For ExpansionPanelList, the callback needs to setState when it's notified
  /// about the closing/opening panel. On the other hand, the callback for
  /// ExpansionPanelList.radio is simply meant to inform the parent widget of
  /// changes, as the radio panels' open/close states are managed internally.
  ///
  /// This callback is useful in order to keep track of the expanded/collapsed
  /// panels in a parent widget that may need to react to these changes.
  final ExpansionPanelCallback? expansionCallback;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  // Whether multiple panels can be open simultaneously
  final bool _allowOnlyOnePanelOpen;

  /// The value of the panel that initially begins open. (This value is
  /// only used when initializing with the [ExpansionPanelList.radio]
  /// constructor.)
  final Object? initialOpenPanelValue;

  /// The padding that surrounds the panel header when expanded.
  ///
  /// By default, 16px of space is added to the header vertically (above and below)
  /// during expansion.
  final EdgeInsets expandedHeaderPadding;

  /// Defines color for the divider when [MyExpansionPanel.isExpanded] is false.
  ///
  /// If [dividerColor] is null, then [DividerThemeData.color] is used. If that
  /// is null, then [ThemeData.dividerColor] is used.
  final Color? dividerColor;

  /// Defines elevation for the [MyExpansionPanel] while it's expanded.
  ///
  /// By default, the value of elevation is 2.
  final double elevation;

  final double? cardElevation;
  final BoxDecoration? headerDecoration;

  @override
  State<StatefulWidget> createState() => _MyExpansionPanelListState();
}

class _MyExpansionPanelListState extends State<MyExpansionPanelList> {
  MyExpansionPanelRadio? _currentOpenPanel;

  @override
  void initState() {
    super.initState();
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All MyExpansionPanelRadio identifier values must be unique.');
      if (widget.initialOpenPanelValue != null) {
        _currentOpenPanel = searchPanelByValue(
          widget.children.cast<MyExpansionPanelRadio>(),
          widget.initialOpenPanelValue,
        );
      }
    }
  }

  @override
  void didUpdateWidget(MyExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All MyExpansionPanelRadio identifier values must be unique.');
      // If the previous widget was non-radio ExpansionPanelList, initialize the
      // open panel to widget.initialOpenPanelValue
      if (!oldWidget._allowOnlyOnePanelOpen) {
        _currentOpenPanel = searchPanelByValue(
          widget.children.cast<MyExpansionPanelRadio>(),
          widget.initialOpenPanelValue,
        );
      }
    } else {
      _currentOpenPanel = null;
    }
  }

  bool _allIdentifiersUnique() {
    final Map<Object, bool> identifierMap = <Object, bool>{};
    for (final MyExpansionPanelRadio child in widget.children.cast<MyExpansionPanelRadio>()) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int i) {
    if (widget._allowOnlyOnePanelOpen) {
      final radioWidget = widget.children[i] as MyExpansionPanelRadio;
      return _currentOpenPanel?.value == radioWidget.value;
    }
    return widget.children[i].isExpanded;
  }

  void _handlePressed(bool isExpanded, int i) {
    widget.children[i].onTapItem?.call(
      i,
      !isExpanded,
      (widget.children[i].enable && (widget.children[i].enableTap?.call() ?? true)),
    );

    if (!widget.children[i].enable || !(widget.children[i].enableTap?.call() ?? true)) return;

    widget.expansionCallback?.call(i, isExpanded);

    if (widget._allowOnlyOnePanelOpen) {
      final pressedChild = widget.children[i] as MyExpansionPanelRadio;

      // If another MyExpansionPanelRadio was already open, apply its
      // expansionCallback (if any) to false, because it's closing.
      for (int childIndex = 0; childIndex < widget.children.length; childIndex += 1) {
        final MyExpansionPanelRadio child = widget.children[childIndex] as MyExpansionPanelRadio;
        if (widget.expansionCallback != null && childIndex != i && child.value == _currentOpenPanel?.value) {
          widget.expansionCallback!(childIndex, false);
        }
      }

      setState(() {
        _currentOpenPanel = isExpanded ? null : pressedChild;
      });
    }
  }

  MyExpansionPanelRadio? searchPanelByValue(List<MyExpansionPanelRadio> panels, Object? value) {
    for (final MyExpansionPanelRadio panel in panels) {
      if (panel.value == value) {
        return panel;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      kElevationToShadow.containsKey(widget.elevation),
      'Invalid value for elevation. See the kElevationToShadow constant for'
      ' possible elevation values.',
    );

    final items = <MergeableMaterialItem>[];

    for (int i = 0; i < widget.children.length; i += 1) {
      if (_isChildExpanded(i) && i != 0 && !_isChildExpanded(i - 1)) {
        items.add(MaterialGap(key: _SaltedKey<BuildContext, int>(context, i * 2 - 1)));
      }

      final MyExpansionPanel child = widget.children[i];
      final headerWidget = child.headerBuilder(context, _isChildExpanded(i));

      dynamic expandIconContainer = ExpandIcon(
        isExpanded: _isChildExpanded(i),
        color: AppColorManager.mainColor,
        disabledColor: AppColorManager.mainColor,
        expandedColor: AppColorManager.mainColor,
        padding: EdgeInsets.zero,
        size: 24.0.r,
        onPressed: (!child.canTapOnHeader) ? (bool isExpanded) => _handlePressed(isExpanded, i) : null,
      );
      if (!child.canTapOnHeader) {
        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        expandIconContainer = Semantics(
          label: _isChildExpanded(i) ? localizations.expandedIconTapHint : localizations.collapsedIconTapHint,
          container: true,
          child: expandIconContainer,
        );
      }
      dynamic header = AnimatedContainer(
        duration: widget.animationDuration,
        decoration: child.headerDecoration,
        clipBehavior: child.headerDecoration == null ? Clip.none : Clip.hardEdge,
        child: Row(
          children: [
            Expanded(child: headerWidget),
            expandIconContainer,
          ],
        ),
      );

      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: GestureDetector(
            onTap: () {
              _handlePressed(_isChildExpanded(i), i);
            },
            child: header,
          ),
        );
      }

      final body = AnimatedCrossFade(
        firstChild: Container(height: 0.0),
        secondChild: child.body,
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: _isChildExpanded(i) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: widget.animationDuration,
      );

      items.add(
        MaterialSlice(
          color: Colors.transparent,
          key: _SaltedKey<BuildContext, int>(context, i * 2),
          child: child.itemBuilder(context, Column(children: [header, body])),
        ),
      );

      if (_isChildExpanded(i) && i != widget.children.length - 1) {
        items.add(MaterialGap(key: _SaltedKey<BuildContext, int>(context, (i * 2) + 1)));
      }
    }

    return MergeableMaterial(dividerColor: widget.dividerColor, elevation: widget.elevation, children: items);
  }
}
