import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_pin_picker/map_pin_picker.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class add_Store extends StatefulWidget {
  @override
  _add_StoreState createState() => _add_StoreState();
}

class _add_StoreState extends State<add_Store> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _controller = Completer();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(31.2060916, 29.9187),
    zoom: 14.4746,
  );
  double lat = 31.2060916, long = 29.9187;
  TextEditingController moderatorNameController,
      namecontroler,
      moderatorPhoneController;
  TextEditingController moderatorPhoneAltController, AddressController;

  @override
  void initState() {
    moderatorNameController = TextEditingController();
    namecontroler = TextEditingController();
    moderatorPhoneAltController = TextEditingController();
    moderatorPhoneController = TextEditingController();
    AddressController = TextEditingController();
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
      body: Column(
        children: [
          Container(
            height: ScreenUtil.getHeight(context) / 3.5,
            child: MapPicker(
              // pass icon widget
              iconWidget: Icon(
                Icons.location_pin,
                size: 50,
              ),
              //add map picker controller
              mapPickerController: mapPickerController,
              child: GoogleMap(
                zoomControlsEnabled: true,
                // hide location button
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                //  camera position
                initialCameraPosition: cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMoveStarted: () {
                  // notify map is moving
                  mapPickerController.mapMoving();
                },
                onCameraMove: (cameraPosition) {
                  this.cameraPosition = cameraPosition;
                },
                onCameraIdle: () async {
                  // notify map stopped moving
                  mapPickerController.mapFinishedMoving();
                  //get address name from camera position
                  lat = cameraPosition.target.latitude;
                  long = cameraPosition.target.longitude;
                  List<Address> addresses = await Geocoder.local
                      .findAddressesFromCoordinates(Coordinates(
                          cameraPosition.target.latitude,
                          cameraPosition.target.longitude));
                  // update the ui with the address
                  AddressController.text =
                      '${addresses.first?.addressLine ?? ''}';
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
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
                        TextFormField(
                            controller: moderatorNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "moderator name";
                              } else if (value.length < 5) {
                                return "moderator name" + ' < 4';
                              }
                              _formKey.currentState.save();

                              return null;
                            }),
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
                              TextFormField(
                                  controller: moderatorPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      prefix: Text('+966 '),
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "moderator Phone";
                                    } else if (value.length < 8) {
                                      return "moderator Phone" + ' <8';
                                    }
                                    _formKey.currentState.save();

                                    return null;
                                  })
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
                              TextFormField(
                                  controller: moderatorPhoneAltController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      prefix: Text('+966 '),
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  validator: (String value) {
                                    if (value.length > 0 && value.length < 8) {
                                      return "Moderator Phone Alternative" +
                                          ' < 8';
                                    }
                                    _formKey.currentState.save();

                                    return null;
                                  })
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

                                API(context)
                                    .post(
                                        "add/stores",
                                        Store(
                                                name: namecontroler.text,
                                                address: AddressController.text,
                                                lat: lat.toString(),
                                                long: long.toString(),
                                                moderatorName:
                                                    moderatorNameController
                                                        .text,
                                                moderatorPhone:
                                                    moderatorPhoneController
                                                            .text.isEmpty
                                                        ? moderatorPhoneController
                                                            .text
                                                        : "00966${moderatorPhoneController.text}",
                                                moderatorAltPhone:
                                                    moderatorPhoneAltController
                                                            .text.isEmpty
                                                        ? moderatorPhoneAltController
                                                            .text
                                                        : "00966${moderatorPhoneAltController.text}")
                                            .toJson())
                                    .then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                  if (value.containsKey('errors')) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                        value['errors'].toString(),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                        'تم إضافة المتجر بنجاح',
                                      ),
                                    );
                                  }
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
            ),
          ),
        ],
      ),
    );
  }
}
