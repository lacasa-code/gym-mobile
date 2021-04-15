import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class edit_Store extends StatefulWidget {
  Store store;

  edit_Store(this.store);

  @override
  _edit_StoreState createState() => _edit_StoreState();
}

class _edit_StoreState extends State<edit_Store> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController moderatorNameController, namecontroler, moderatorPhoneController;
  TextEditingController moderatorPhoneAltController,AddressController;

  @override
  void initState() {
    moderatorNameController = TextEditingController(text: widget.store.moderatorName);
    namecontroler = TextEditingController(text: widget.store.name);
    moderatorPhoneAltController = TextEditingController(text: widget.store.moderatorAltPhone);
    moderatorPhoneController = TextEditingController(text: widget.store.moderatorPhone);
    AddressController = TextEditingController(text: widget.store.address);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Store"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
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
                          } else if (value.length < 4) {
                            return getTransrlate(context, 'name') + ' < 4';
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
                    Text(
                      "Moderator Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: moderatorNameController,
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
                              controller: moderatorPhoneController,
                              keyboardType: TextInputType.phone,
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Moderator Phone Alternative",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                              controller: moderatorPhoneAltController,
                              keyboardType: TextInputType.phone,
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
                              controller: AddressController,
                              keyboardType: TextInputType.text,
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
                      height: 20,
                    ),
                     Center(
                          child: FlatButton(
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
                                  API(context).post("update/stores/${widget.store.id}", {
                                    "name": namecontroler.text,
                                    "address": AddressController.text,
                                    "lat": 40.111,
                                    "long": 40.111,
                                    "moderator_name": moderatorNameController.text,
                                    "moderator_phone": moderatorPhoneController.text,
                                    "moderator_alt_phone": moderatorPhoneController.text
                                  }).then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                        'تم تعديل المتجر بنجاح',
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
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
