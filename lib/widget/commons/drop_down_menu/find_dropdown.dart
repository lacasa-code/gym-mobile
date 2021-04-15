library find_dropdown;

import 'package:flutter/material.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/select_dialog.dart';

import 'find_dropdown_bloc.dart';

typedef Future<List<T>> FindDropdownFindType<T>(String text);
typedef void FindDropdownChangedType<T>(T selectedItem);
typedef Widget FindDropdownBuilderType<T>(BuildContext context, T selectedText);
typedef String FindDropdownValidationType<T>(T selectedText);
typedef Widget FindDropdownItemBuilderType<T>(
  BuildContext context,
  T item,
  bool isSelected,
);

class FindDropdown<T> extends StatefulWidget {
  final String label;
  final bool showSearchBox;
  final bool showClearButton;
  final TextStyle labelStyle;
  final List<T> items;
  final T selectedItem;
  final bool isUnderLine;
  final FindDropdownFindType<T> onFind;
  final FindDropdownChangedType<T> onChanged;
  final FindDropdownBuilderType<T> dropdownBuilder;
  final FindDropdownItemBuilderType<T> dropdownItemBuilder;
  final FindDropdownValidationType<T> validate;
  final InputDecoration searchBoxDecoration;
  final Color backgroundColor;
  final TextStyle titleStyle;

  const FindDropdown({
    Key key,
    @required this.onChanged,
    this.label,
    this.labelStyle,
    this.items,
    this.selectedItem,
    this.onFind,
    this.dropdownBuilder,
    this.dropdownItemBuilder,
    this.showSearchBox = true,
    this.showClearButton = false,
    this.validate,
    this.searchBoxDecoration,
    this.backgroundColor,
    this.titleStyle,
    this.isUnderLine,
  })  : assert(onChanged != null),
        super(key: key);

  @override
  _FindDropdownState<T> createState() => _FindDropdownState<T>();
}

class _FindDropdownState<T> extends State<FindDropdown<T>> {
  FindDropdownBloc<T> bloc;

  @override
  void initState() {
    super.initState();
    bloc = FindDropdownBloc<T>(
      seedValue: widget.selectedItem,
      validate: widget.validate,
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<T>(
              stream: bloc.selected$,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    SelectDialog.showModal(
                      context,
                      items: widget.items,
                      label: widget.label,
                      onFind: widget.onFind,
                      showSearchBox: widget.showSearchBox,
                      itemBuilder: widget.dropdownItemBuilder,
                      selectedValue: snapshot.data,
                      searchBoxDecoration: widget.searchBoxDecoration,
                      backgroundColor: widget.backgroundColor,
                      titleStyle: widget.titleStyle,
                      onChange: (item) {
                        bloc.selected$.add(item);
                        widget.onChanged(item);
                      },
                    );
                  },
                  child: (widget.dropdownBuilder != null)
                      ? widget.dropdownBuilder(context, snapshot.data)
                      : Container(
                          height: 50,
                          decoration: widget.isUnderLine
                              ? BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Colors.black)))
                              : BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.2),
                                        blurRadius: 1.0,
                                        // soften the shadow
                                        spreadRadius: 0.0,
                                        //extend the shadow
                                        offset: Offset(
                                          0.0,
                                          // Move to right 10  horizontally
                                          1.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 12,right: 12),
                                child: Text(
                                  snapshot.data?.toString() ?? "",
                                  style: TextStyle(
                                      color: widget.isUnderLine
                                          ? Colors.black54
                                          : Color(0xFF5D6A78),
                                      fontSize: widget.isUnderLine ? 12 : 14,
                                      fontWeight: widget.isUnderLine
                                          ? FontWeight.w600
                                          : FontWeight.w600),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: <Widget>[
                                    if (snapshot.data != null &&
                                        widget.showClearButton)
                                      GestureDetector(
                                        onTap: () {
                                          bloc.selected$.add(null);
                                          widget.onChanged(null);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    if (snapshot.data == null ||
                                        !widget.showClearButton)
                                      Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 1, left: 3),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 22,
                                          color: Color(0xFF5D6A78),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),

          ],
        ),
      ],
    );
  }
}
