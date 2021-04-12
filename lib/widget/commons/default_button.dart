import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Provider_control>(context);
    return SizedBox(
      width: double.infinity,
      // height: getProportionateScreenHeight(56),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: provider.getColor(),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            //fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
