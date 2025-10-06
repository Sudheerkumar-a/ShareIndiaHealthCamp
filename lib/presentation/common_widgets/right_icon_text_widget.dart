import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/image_widget.dart';

const double defaultHeight = 27;

class RightIconTextWidget extends StatefulWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final int? maxLines;
  final int? maxLength;
  final int maxLengthValidation;
  final String fontFamily;
  final FocusNode? focusNode;
  final bool isMandetory;
  final BorderSide borderSide;
  final double? borderRadius;
  final Color? fillColor;
  final Color? disableColor;
  final Function(String)? onChanged;
  final Function? suffixIconClick;
  final Function(String)? isValid;
  final String? regex;
  final AutovalidateMode? autovalidateMode;
  const RightIconTextWidget({
    this.height = defaultHeight,
    this.isEnabled = true,
    this.labelText = '',
    this.hintText = '',
    this.errorMessage = '',
    this.textController,
    this.suffixIconPath,
    this.textInputType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.maxLengthValidation = 0,
    this.fontFamily = '',
    this.focusNode,
    this.isMandetory = false,
    this.fillColor,
    this.disableColor,
    this.borderSide = const BorderSide(color: Color(0xffD1DAE2), width: 1),
    this.borderRadius = 10,
    this.onChanged,
    this.suffixIconClick,
    this.regex,
    this.isValid,
    this.autovalidateMode,
    super.key,
  });

  @override
  State<RightIconTextWidget> createState() => _RightIconTextWidgetState();
}

class _RightIconTextWidgetState extends State<RightIconTextWidget> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.labelText.isNotEmpty,
          child: Text.rich(
            TextSpan(
              text: widget.labelText,
              style: context.textFontWeight400.onFontSize(
                context.resources.fontSize.dp14,
              ),
              children: [
                if (widget.isMandetory)
                  TextSpan(
                    text: ' *',
                    style: context.textFontWeight400
                        .onFontSize(context.resources.fontSize.dp14)
                        .onColor(Theme.of(context).colorScheme.error),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.resources.dimen.dp4),
        Align(
          alignment: Alignment.center,
          child: TextFormField(
            key: ValueKey(widget.labelText),
            enabled: widget.isEnabled,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: widget.textInputType,
            obscureText:
                widget.textInputType == TextInputType.visiblePassword ? true : false,
            textInputAction: widget.textInputAction,
            controller: widget.textController,
            textAlignVertical: TextAlignVertical.center,
            focusNode: widget.focusNode,
            autovalidateMode: widget.autovalidateMode,
            validator: (value) {
              if (widget.isValid != null) {
                return widget.isValid?.call(value ?? '');
              } else if (widget.errorMessage.isNotEmpty &&
                  (value == null ||
                      value.isEmpty ||
                      value.length < widget.maxLengthValidation ||
                      !RegExp(widget.regex ?? '').hasMatch(value))) {
                return widget.errorMessage.isNotEmpty ? widget.errorMessage : null;
              }
              return null;
            },
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp12,
                horizontal: context.resources.dimen.dp10,
              ),
              hintText: widget.hintText,
              hintStyle: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onFontFamily(
                    fontFamily:
                        context.resources.isLocalEn
                            ? fontFamilyEN
                            : fontFamilyAR,
                  )
                  .onColor(context.resources.color.colorD6D6D6),
              suffixIconConstraints: BoxConstraints(
                maxHeight: widget.height,
                minHeight: widget.height,
              ),
              suffixIcon:
                  (widget.suffixIconPath ?? '').isNotEmpty
                      ? InkWell(
                        onTap: () {
                          widget.suffixIconClick?.call();
                        },
                        child: Padding(
                          padding:
                              context.resources.isLocalEn
                                  ? const EdgeInsets.only(right: 15.0)
                                  : const EdgeInsets.only(left: 15.0),
                          child:
                              ImageWidget(path: widget.suffixIconPath ?? '').loadImage,
                        ),
                      )
                      : null,
              fillColor:
                  widget.isEnabled
                      ? (widget.fillColor ?? context.resources.color.colorWhite)
                      : widget.disableColor ??
                          context.resources.color.dividerColorB3B8BF,
              border: OutlineInputBorder(
                borderSide: widget.borderSide,
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? context.resources.dimen.dp10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: widget.borderSide,
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? context.resources.dimen.dp10),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: widget.borderSide,
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? context.resources.dimen.dp10),
                ),
              ),
              errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            style:
                widget.fontFamily.isNotEmpty
                    ? context.textFontWeight400
                        .onFontFamily(fontFamily: widget.fontFamily)
                        .onFontSize(context.resources.fontSize.dp12)
                    : context.textFontWeight400.onFontSize(
                      context.resources.fontSize.dp12,
                    ),
          ),
        ),
      ],
    );
  }
}
