import 'dart:async';
import 'package:location/location.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_pin_picker/map_pin_picker.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/area_model.dart';
import 'package:trkar_vendor/model/city_model.dart';
import 'package:trkar_vendor/model/country_model.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

class add_Store extends StatefulWidget {
  @override
  _add_StoreState createState() => _add_StoreState();
}

class _add_StoreState extends State<add_Store> {
  Store store = Store(lat: 31.2060916.toString(), long: 29.9187.toString());
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _controller = Completer();
  MapPickerController mapPickerController = MapPickerController();
  List<Country> contries;
  TextEditingController addressController = TextEditingController();
  List<City> cities;
  List<Area> area;
  String  code=' ';

  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(31.2060916, 29.9187),
    zoom: 14.4746,
  );

  @override
  void initState() {
    getCountry();
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/store.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'stores')),
          ],
        ),
        backgroundColor: themeColor.getColor(),
      ),
      body: Column(
        children: [
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
                        MyTextFormField(
                          intialLabel: store.nameStore ?? ' ',
                          Keyboard_Type: TextInputType.name,
                             labelText: getTransrlate(context, 'name'),inputFormatters: [
                            new LengthLimitingTextInputFormatter(200),
                          ],
                          hintText: getTransrlate(context, 'name'),
                          isPhone: true,
                          enabled: true,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return getTransrlate(context, 'requiredempty');
                            } else if (value.length <2) {
                              return "${getTransrlate(context, 'requiredlength')}";
                            } else if (RegExp(r"^[+-]?([0-9]*[.])?[0-9]+")
                                .hasMatch(value)) {
                              return getTransrlate(context, 'invalidname');
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            store.nameStore = value;
                          },
                        ),
                        Text(
                          "${getTransrlate(context, 'country')}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        contries == null
                            ? Container()
                            : Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 10),
                          child: DropdownSearch<Country>(
                            // label: getTransrlate(context, 'Countroy'),
                            validator: (Country item) {
                              if (item == null) {
                                return "Required field";
                              } else
                                return null;
                            },
                            selectedItem: store.countryId == null
                                ? Country(countryName: 'select country')
                                : contries
                                .where((element) =>
                            element.id == store.countryId)
                                .first,
                            showSearchBox: true,
                            items: contries,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (Country u) => u.countryName,
                            onChanged: (Country data) {
                              store.countryId = data.id;
                              setState(() {
                                code=data.phonecode.toString();
                                area=null;
                                cities=null;
                              });
                              getArea(data.id);
                            },
                          ),
                        ),
                        MyTextFormField(
                          intialLabel: store.nameStore ?? ' ',
                          Keyboard_Type: TextInputType.phone,
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(10),
                          ],
                          labelText: getTransrlate(context, 'ModeratorPhone'),
                          hintText: getTransrlate(context, 'ModeratorPhone'),
                          suffixIcon: Container(width: 50,child: Center(child: Text(' $code', textDirection: TextDirection.ltr))),
                          isPhone: true,
                          textDirection: TextDirection.ltr,
                          enabled: true,
                          validator: (String value) {
                            if (value.length < 9) {
                              return getTransrlate(context, 'Required');
                            }
                            _formKey.currentState.save();
                            return null;
                          },
                          onSaved: (String value) {
                            store.moderatorPhone = "+$code$value";
                            print("+$code$value");
                          },
                        ),
                        MyTextFormField(
                          intialLabel: store.moderatorAltPhone??'',
                          Keyboard_Type: TextInputType.phone,
                          textDirection: TextDirection.ltr,
                          labelText: getTransrlate(context, 'phone'),
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(10),
                          ],
                          hintText: getTransrlate(context, 'phone'),
                          suffixIcon: Container(width: 50,child: Center(child: Text(' $code', textDirection: TextDirection.ltr))),
                          isPhone: true,
                          validator: (String value) {
                            if (value.length > 1&&value.length < 9) {
                              return getTransrlate(context, 'Required');
                            }
                            _formKey.currentState.save();
                            return null;
                          },
                          enabled: true,
                          onSaved: (String value) {
                            store.moderatorAltPhone = value.isEmpty?'':"+$code$value";
                          },
                        ),
                        Text(
                          "${getTransrlate(context, 'address')}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        area == null
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: DropdownSearch<Area>(
                                  // label: getTransrlate(context, 'Countroy'),
                                  validator: (Area item) {
                                    if (item == null) {
                                      return "Required field";
                                    } else
                                      return null;
                                  },

                                  items: area,
                                  //  onFind: (String filter) => getData(filter),
                                  itemAsString: (Area u) => u.areaName,
                                  onChanged: (Area data) {
                                    store.areaId = data.id;
                                    setState(() {
                                      cities=null;

                                    });
                                    getCity(data.id);
                                  },
                                ),
                              ),
                        cities == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: DropdownSearch<City>(
                                  // label: getTransrlate(context, 'Countroy'),
                                  validator: (City item) {
                                    if (item == null) {
                                      return "Required field";
                                    } else
                                      return null;
                                  },

                                  items: cities,
                                  //  onFind: (String filter) => getData(filter),
                                  itemAsString: (City u) => u.cityName,
                                  onChanged: (City data) {
                                    store.cityId = data.id;
                                  },
                                ),
                              ),
                        MyTextFormField(
                          textEditingController: addressController,
                          Keyboard_Type: TextInputType.text,
                          labelText: getTransrlate(context, 'address'),
                          hintText: getTransrlate(context, 'address'),
                          enabled: true,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return getTransrlate(context, 'address');
                            }
                            _formKey.currentState.save();
                            return null;
                          },
                          onSaved: (String value) {
                            store.address = value;
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: ScreenUtil.getHeight(context) / 5,
                          child: MapPicker(
                            // pass icon widget
                            iconWidget: Icon(
                              Icons.store,
                              size: 50,
                            ),
                            //add map picker controller
                            mapPickerController: mapPickerController,
                            child: GoogleMap(
                              zoomControlsEnabled: true,
                              // hide location button
                              myLocationButtonEnabled: true,
                              myLocationEnabled: true,

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
                                store.lat =
                                    cameraPosition.target.latitude.toString();
                                store.long =
                                    cameraPosition.target.longitude.toString();
                                List<Address> addresses = await Geocoder.local
                                    .findAddressesFromCoordinates(Coordinates(
                                        cameraPosition.target.latitude,
                                        cameraPosition.target.longitude));
                                // update the ui with the address

                                addressController.text =
                                    '${addresses.first?.addressLine ?? ''}';
                                store.address =
                                    '${addresses.first?.addressLine ?? ''}';
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12.withOpacity(0.5),
                    offset: Offset(0, 0),
                    blurRadius: 1)
              ],
            ),
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      minWidth: ScreenUtil.getWidth(context) / 2.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                          side: BorderSide(color: Colors.orange, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTransrlate(context, 'save'),
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          setState(() => loading = true);

                          API(context)
                              .post("add/stores", store.toJson())
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
                                  '${value['message']}',
                                ),
                              );
                            }
                          });
                        }
                      }),
                  FlatButton(
                      minWidth: ScreenUtil.getWidth(context) / 2.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                          side: BorderSide(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTransrlate(context, 'close'),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getCity(int id) {
    API(context).get('cities/list/all/$id').then((value) {
      setState(() {
        cities = City_model.fromJson(value).data;
      });
    });
  }

  void getArea(int id) {
    API(context).get('areas/list/all/$id').then((value) {
      print(value);
      setState(() {
        area = Area_model.fromJson(value).data;
      });
    });
  }

  void getCountry() {
    API(context).get('countries/list/all').then((value) {
      setState(() {
        contries = Country_model.fromJson(value).data;
      });
    });
  }

  Future<void> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      cameraPosition = CameraPosition(
        target: LatLng(31.2060916, 29.9187),
        zoom: 14.4746,
      );
    });
  }
}
