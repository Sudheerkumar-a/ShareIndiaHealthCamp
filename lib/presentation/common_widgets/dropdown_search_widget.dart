// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
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
  final T? selectedValue;
  final Function(T?)? callback;
  final Color? fillColor;
  final bool isMandetory;

  const DropdownSearchWidget({
    required this.list,
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
    super.key,
  });

  @override
  State<DropdownSearchWidget<T>> createState() =>
      _DropdownSearchWidgetState<T>();
}

class _DropdownSearchWidgetState<T extends Object>
    extends State<DropdownSearchWidget<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.textController ?? TextEditingController();

    // initialize selected value if provided
    if (widget.selectedValue != null) {
      _controller.text = widget.selectedValue.toString();
    }
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
  void dispose() {
    if (widget.textController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<T>(
          key: ValueKey(widget.list.hashCode), // force refresh if list changes
          initialValue: TextEditingValue(
            text: widget.selectedValue?.toString() ?? '',
          ),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return widget.list;
            }
            return widget.list.where((T option) {
              return option.toString().toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
            });
          },
          fieldViewBuilder: (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            // Sync with external controller
            textEditingController.value = _controller.value;

            return RightIconTextWidget(
              isEnabled: widget.isEnabled,
              height: resources.dimen.dp27,
              labelText: widget.labelText,
              hintText: widget.hintText,
              errorMessage: widget.errorMessage,
              textController: textEditingController,
              suffixIconPath: DrawableAssets.icChevronDown,
              focusNode: focusNode,
              fillColor: widget.fillColor ?? resources.color.colorWhite,
              borderSide: BorderSide(
                color: resources.color.sideBarItemUnselected,
                width: 1,
              ),
              borderRadius: 10,
            );
          },
          optionsViewBuilder:
              (context, onSelected, options) => Align(
                alignment: Alignment.topLeft,
                child: Material(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(4.0),
                    ),
                  ),
                  child: SizedBox(
                    height: 52.0 * options.length,
                    width: constraints.maxWidth,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final T option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              option.toString(),
                              style: context.textFontWeight400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          onSelected: (T selection) {
            _controller.text = selection.toString();
            widget.callback?.call(selection);
          },
        );
      },
    );
  }
}
