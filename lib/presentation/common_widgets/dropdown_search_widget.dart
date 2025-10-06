// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/common/log.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:shareindia_health_camp/res/drawables/drawable_assets.dart';

const double defaultHeight = 27;

class DropdownSearchWidget<T extends Object> extends StatefulWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final String fontFamily;
  final List<T> list;
  T? selectedValue;
  Function(dynamic)? callback;
  final Color? fillColor;
  final bool isMandetory;
  DropdownSearchWidget(
      {required this.list,
      this.height = defaultHeight,
      this.isEnabled = true,
      this.labelText = '',
      this.hintText = '',
      this.errorMessage = '',
      this.textController,
      this.suffixIconPath,
      this.fontFamily = '',
      this.fillColor,
      this.isMandetory = false,
      this.selectedValue,
      this.callback,
      super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateDropdownSearchWidget<T>();
  }
}

class _StateDropdownSearchWidget<T extends Object>
    extends State<DropdownSearchWidget> with WidgetsBindingObserver {
  final _key = GlobalKey();
  double _keyboardHeight = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

@override
  void didUpdateWidget(covariant DropdownSearchWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update text if selectedValue changed
    if (widget.list != oldWidget.list) {
      //print('${widget.labelText}  ${widget.list.toString()}');
      setState(() {});
    }
  }

  @override
  void didChangeMetrics() {
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      final bottomInset = View.of(context).viewInsets.bottom;
      final devicePixelRatio = View.of(context).devicePixelRatio;
      setState(() {
        _keyboardHeight = bottomInset / devicePixelRatio;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final height = getScrrenSize(context).height;
    return LayoutBuilder(builder: (context, constraints) {
      return Autocomplete<T>(
        key: _key,
        optionsBuilder: (TextEditingValue textEditingValue) {
          final list = widget.list as List<T>;
          if (textEditingValue.text == '') {
            return list;
          }
          return list.where((T option) {
            return option
                .toString()
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          if (widget.selectedValue == null || focusNode.hasFocus) {
            textEditingController.text = "";
          } else {
            textEditingController.text = widget.selectedValue.toString();
          }
          return RightIconTextWidget(
            isEnabled: true,
            height: resources.dimen.dp27,
            labelText: widget.labelText,
            hintText: widget.hintText,
            errorMessage: widget.errorMessage,
            textController: textEditingController,
            suffixIconPath: DrawableAssets.icChevronDown,
            focusNode: focusNode,
            fillColor: widget.fillColor,
            isValid: (p0) {
              if (widget.errorMessage.isNotEmpty &&
                  widget.selectedValue == null) {
                return widget.errorMessage;
              }
            },
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          double y = 0;
          if (_key.currentContext?.findRenderObject() is RenderBox) {
            RenderBox box =
                _key.currentContext?.findRenderObject() as RenderBox;
            Offset position =
                box.localToGlobal(Offset.zero); //this is global position
            y = position.dy;
          }
          printLog('position.dy $y');
          return Align(
            alignment:
                isSelectedLocalEn ? Alignment.topLeft : Alignment.topRight,
            child: Material(
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(4.0)),
              ),
              child: SizedBox(
                height: min(
                    52.0 * options.length, height - y - (_keyboardHeight) - 50),
                width: constraints.biggest.width,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int index) {
                    final T option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        color: widget.selectedValue == option
                            ? resources.color.viewBgColorLight
                            : null,
                        child: Text(
                          option.toString(),
                          style: context.textFontWeight400.onColor(
                              widget.selectedValue == option
                                  ? resources.color.colorWhite
                                  : resources.color.textColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        onSelected: (T selection) {
          widget.selectedValue = selection;
          widget.callback?.call(selection);
          //removeFocus(context);
        },
      );
    });
  }
}
