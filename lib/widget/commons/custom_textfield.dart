import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatelessWidget {
  final TextStyle textStyle;
  final String hintText;
  final String labelText;
  final Function validator;
  final Function onSaved;
  final List<TextInputFormatter> inputFormatters;
  final TextDirection textDirection;
  final Widget suffixIcon;
  final bool isPassword;
  final bool isEmail;
  final bool enabled;
  final bool isPhone;
  final Widget prefix;
  final TextInputType Keyboard_Type;
  final String intialLabel;
  final GestureTapCallback press;

  MyTextFormField(
      {this.hintText,
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
        this.intialLabel,
        this.textStyle,
        this.inputFormatters,
        this.press});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText??'',style:textStyle?? TextStyle(color: Colors.black,fontSize: 16),),
          SizedBox(height: 5),
          TextFormField(
            onTap: press,
            initialValue: intialLabel == null ? '' : intialLabel,
            inputFormatters:inputFormatters ,
            decoration: InputDecoration(
              fillColor: Colors.white,
              prefixIcon: prefix,
              //  hintText: hintText,
              contentPadding: EdgeInsets.all(10.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              filled: true,
              suffixIcon: this.suffixIcon,
            ),
            obscureText: isPassword ? true : false,
            validator: validator,
            textDirection: textDirection,
            onSaved: onSaved,
            enabled: enabled,
            keyboardType: Keyboard_Type,
          ),
        ],
      ),
    );
  }
}
