import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Function validator;
  final Function onSaved;
  final TextDirection textDirection;
  final Widget suffixIcon;
  final bool isPassword;
  final bool isEmail;
  final bool enabled;
  final bool isPhone;
  final Widget prefix;
  final TextInputType Keyboard_Type;
  final String intialLabel;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.enabled,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
    this.isPhone = false,
    this.labelText,
    this.suffixIcon,
    this.textDirection,
    this.prefix,
    this.Keyboard_Type,
    this.intialLabel
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        initialValue: intialLabel==null?'':intialLabel,
        decoration: InputDecoration(
          prefixIcon:prefix,
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          fillColor: Color(0xFFEEEEF3),

          labelText: labelText,
          filled: true,
          suffixIcon: this.suffixIcon,
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        textDirection:textDirection ,
        onSaved: onSaved,
        enabled: enabled,
        keyboardType:Keyboard_Type,
      ),
    );
  }
}
