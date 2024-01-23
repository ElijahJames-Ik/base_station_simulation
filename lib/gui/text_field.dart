// ignore_for_file: unnecessary_null_comparison

import 'package:base_station_simulation/gui/rgbo_color.dart';
import 'package:base_station_simulation/gui/text_handler.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class IconTextField extends StatefulWidget {
  final String textHint;
  final String label;
  final TextEditingController controller;
  final bool isSecure;
  final void Function(String?)? changedHandler;
  final String? Function(String?) validatorHandler;
  final TextInputType inputType;
  final int lineNumber;
  final int? maxLength;
  final Color textFieldBackgroundColor;
  final Color hintColor;
  final Color borderColor;
  final Widget? trailing;
  final double fontSize;
  final AutovalidateMode autovalidateMode;
  final Widget prefix;
  final List<TextInputFormatter>? formatter;
  final bool isEnabled;
  const IconTextField(
      {required this.textHint,
      required this.controller,
      required this.isSecure,
      required this.label,
      this.changedHandler = null,
      this.formatter,
      this.autovalidateMode = AutovalidateMode.disabled,
      required this.validatorHandler,
      this.inputType = TextInputType.text,
      this.lineNumber = 1,
      this.isEnabled = true,
      this.maxLength = null,
      this.trailing = null,
      this.prefix = const SizedBox(),
      this.textFieldBackgroundColor = const Color.fromRGBO(255, 255, 255, 1),
      this.hintColor = const Color.fromRGBO(114, 112, 112, 1),
      this.borderColor = const Color.fromRGBO(229, 233, 242, 1),
      this.fontSize = 15});

  //

  @override
  _IconTextFieldState createState() => _IconTextFieldState();
}

class _IconTextFieldState extends State<IconTextField> {
  bool toggle = true;
  @override
  Widget build(BuildContext context) {
    var dimension = MediaQuery.of(context).size;
    var textScaler = TextHanlder(size: dimension);
    //Color borderColor = widget.borderColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textScaler.color16px500w(RgboColors.grey5()),
        ),
        SizedBox(
          height: dimension.height * 0.005,
        ),
        Container(
          // height: widget.lineNumber == 1 ? dimension.height * 0.095 : null,
          margin: EdgeInsets.only(top: dimension.height * 0.007),
          padding: EdgeInsets.zero,
          child: TextFormField(
            enabled: widget.isEnabled,
            maxLength: widget.maxLength,
            autovalidateMode: widget.autovalidateMode,
            controller: widget.controller,
            inputFormatters: widget.formatter,
            textAlignVertical: TextAlignVertical.center,
            obscureText: !widget.isSecure ? widget.isSecure : toggle,
            keyboardType: widget.inputType,
            maxLines: widget.lineNumber,
            onChanged: widget.changedHandler,
            validator: widget.validatorHandler,
            style: textScaler.color14px500w(Colors.black),
            decoration: InputDecoration(
              //labelText: widget.label,
              counterText: "",
              labelStyle: textScaler.color12px400w(Colors.black),
              hintStyle: textScaler
                  .color14px400w(const Color.fromRGBO(177, 180, 187, 1)),
              filled: true,
              fillColor: widget.textFieldBackgroundColor,
              hintText: widget.textHint,
              alignLabelWithHint: true,
              hintMaxLines: widget.lineNumber,
              prefix: widget.prefix,
              helperText: ' ',
              errorMaxLines: 2,
              contentPadding: EdgeInsets.only(
                top: dimension.height * 0.04,
                left: dimension.height * 0.02,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(dimension.width * 0.03),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(dimension.width * 0.03),
                borderSide:
                    BorderSide(color: RgboColors.lifetaliaPrimary(), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(dimension.width * 0.03),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(71, 5, 175, 0.12),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(dimension.width * 0.03),
                borderSide: const BorderSide(color: Colors.red, width: 0.5),
              ),
              errorStyle:
                  textScaler.color12px(const Color.fromRGBO(255, 0, 0, 1)),
              isDense: false,
              // ignore: prefer_if_null_operators
              suffixIcon: widget.trailing == null
                  ? !widget.isSecure
                      ? null
                      : IconButton(
                          icon: Icon(
                            toggle && widget.isSecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: widget.fontSize * 1.5,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                          color: const Color.fromRGBO(196, 196, 196, 1),
                          onPressed: () {
                            setState(() {
                              toggle = !toggle;
                            });
                          })
                  : SizedBox(child: widget.trailing),
            ),
          ),
        ),
      ],
    );
  }
}
