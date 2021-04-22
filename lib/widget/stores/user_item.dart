import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class User_item extends StatelessWidget {
  User_item({Key key, this.hall_model}) : super(key: key);
  final User hall_model;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: ScreenUtil.getWidth(context) / 1.7,
        decoration: BoxDecoration(
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, 0),
                blurRadius: 3)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: ScreenUtil.getWidth(context) / 2.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      hall_model.name,
                      minFontSize: 10,
                      style: TextStyle(
                        color: Color(0xFF5D6A78),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText(
                      '${hall_model.email}',
                      minFontSize: 10,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5D6A78),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Container(
                      height: 50,
                      child: ListView.builder(scrollDirection: Axis.horizontal,
                          itemCount: hall_model.roles.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return  Container(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${hall_model.roles[index].title}",
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  )),
                              decoration: BoxDecoration(
                                  color: themeColor.getColor(),
                                  border: Border.all(color: themeColor.getColor(), width: 1),
                                  borderRadius: BorderRadius.circular(35)),
                              margin: EdgeInsets.only(right: 12),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
