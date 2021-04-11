import 'package:flutter/material.dart';

class ItemHiddenMenu extends StatelessWidget {
  /// name of the menu item
  final String name;

  final Widget icon;

  /// callback to recibe action click in item
  final Function onTap;

  final Color colorLineSelected;

  /// Base style of the text-item.
  final TextStyle baseStyle;

  /// style to apply to text when item is selected
  final TextStyle selectedStyle;

  final bool selected;

  ItemHiddenMenu({
    Key key,
    this.name,
    this.icon,
    this.selected = false,
    this.onTap,
    this.colorLineSelected = Colors.blue,
    this.baseStyle,
    this.selectedStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15.0, left: 24),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(width: 32, child: icon),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                name,
                style: (this.baseStyle ??
                        TextStyle(color: Colors.grey, fontSize: 14.0))
                    .merge(this.selected
                        ? this.selectedStyle ??
                            TextStyle(
                                color: Colors.white, fontSize: 14)
                        : TextStyle(
                            color: Colors.white, fontSize: 14)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
