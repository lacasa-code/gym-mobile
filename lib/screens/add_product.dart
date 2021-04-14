import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class Add_Product extends StatefulWidget {
  @override
  _Add_ProductState createState() => _Add_ProductState();
}

class _Add_ProductState extends State<Add_Product> {
  bool loading = false;
  String count = "0";
  int checkboxValueB = 0;
  int checkboxValueA = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String inviter_counter = "0";
  String selectwedding;
  TextEditingController citycontroler, namecontroler, COUNTRYcontroler;
  TextEditingController addresscontroler,
      ModeratorPhone,
      max_number_of_invitees_controller;
  DateTime selectedDate = DateTime.now();
  String SelectDate = ' ';
  File _image;
  String base64Image;

  @override
  void initState() {
    citycontroler = TextEditingController();
    namecontroler = TextEditingController();
    addresscontroler = TextEditingController();
    ModeratorPhone = TextEditingController();
    max_number_of_invitees_controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Add Product"),
        centerTitle: true,
        backgroundColor: themeColor.getColor(),
      ),
      body: Stack(
        children: [
          Container(
            width: ScreenUtil.getWidth(context),
            height: ScreenUtil.getHeight(context),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: namecontroler,
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'name');
                          } else if (value.length < 10) {
                            return getTransrlate(context, 'name') + ' < 10';
                          }
                          _formKey.currentState.save();

                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: max_number_of_invitees_controller,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return getTransrlate(context, 'counter');
                                } else if (value.length < 2) {
                                  return getTransrlate(context, 'counter');
                                }
                                _formKey.currentState.save();

                                return null;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "Moderator Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: addresscontroler,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Moderator Phone",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                              controller: ModeratorPhone,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    loading
                        ? Image.network(
                            'https://i.pinimg.com/originals/65/ba/48/65ba488626025cff82f091336fbf94bb.gif')
                        : FlatButton(
                            color: themeColor.getColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                setState(() => loading = true);
                                API(context).post("add/stores", {
                                  "name": namecontroler.text,
                                  "address": addresscontroler.text,
                                  "lat": 40.111,
                                  "long": 40.111,
                                  "moderator_name": "a mod",
                                  "moderator_phone": 966504444449,
                                  "moderator_alt_phone": 966504444449
                                }).then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      'تم إضافة المتجر بنجاح',
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
