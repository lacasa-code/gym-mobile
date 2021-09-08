import 'dart:async';

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
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

class Edit_Store extends StatefulWidget {
  Store store;

  Edit_Store(this.store);

  @override
  _Edit_StoreState createState() => _Edit_StoreState();
}

class _Edit_StoreState extends State<Edit_Store> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _controller = Completer();
  MapPickerController mapPickerController = MapPickerController();
  List<Country> contries;
  List<City> cities;
  List<Area> area;
  TextEditingController phone1;
  TextEditingController phone2;

  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(31.2060916, 29.9187),
    zoom: 14.4746,
  );
  @override
  void initState() {
    phone1=TextEditingController(text: widget.store.moderatorPhone??'');
    phone2=TextEditingController(text: widget.store.moderatorAltPhone??'');
    getCountry();
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
                  widget.store.lat = cameraPosition.target.latitude.toString();
                  widget.store.long = cameraPosition.target.longitude.toString();
                  List<Address> addresses = await Geocoder.local
                      .findAddressesFromCoordinates(Coordinates(
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude));
                  // update the ui with the address
                  widget.store.address =
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
                        MyTextFormField(
                          intialLabel: widget.store.nameStore ?? ' ',
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
                            }else   if (value.length<2) {
                              return "${getTransrlate(context, 'requiredlength')}";
                            }else if (RegExp(
                                r"^[+-]?([0-9]*[.])?[0-9]+").hasMatch(value)) {
                              return getTransrlate(context, 'invalidname');
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            widget.store.nameStore=value;
                            print("value $value");
                            print("value ${widget.store.nameStore}");
                          }, onSaved: (String value) {
                            widget.store.nameStore = value;
                          },
                        ),

                        Text(
                          getTransrlate(
                              context, 'Countroy'),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        contries == null
                            ? Container()
                            : Padding(
                          padding: const EdgeInsets
                              .symmetric(
                              vertical: 10),
                          child:
                          DropdownSearch<Country>(
                            // label: getTransrlate(context, 'Countroy'),
                            validator:
                                (Country item) {
                              if (item == null) {
                                return "Required field";
                              } else
                                return null;
                            },
                            selectedItem:widget.store.country??Country(countryName: " ${widget.store.countryName??' '}"),
                            //selectedItem:widget.store.countryId==null?Country(countryName: 'select country'):contries.where((element) => element.id==widget.store.countryId).first,
                            showSearchBox: true,
                            items: contries,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString:
                                (Country u) =>
                                themeColor.getlocal()=='ar'?u.countryName??u.name_en:u.name_en??u.countryName,

                            onChanged:
                                (Country data) {
                              setState(() {
                                phone1.text='${data.phonecode}';
                                phone2.text='';
                                widget.store.country=data;
                                widget.store.countryId = data.id;
                                widget.store.area = Area(areaName: '');
                                widget.store.city = City(cityName: '');
                                area=null;
                              });
                              getArea(data.id);
                            },
                          ),
                        ),
                        Text(
                          "${getTransrlate(context, 'Area')}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16),
                        ),

                        area == null
                            ? Container()
                            : Padding(
                          padding: const EdgeInsets
                              .symmetric(
                              vertical: 10),
                          child: DropdownSearch<Area>(
                            // label: getTransrlate(context, 'Countroy'),
                            validator: (Area item) {
                              if (item == null) {
                                return "Required field";
                              } else
                                return null;
                            },

                            items: area,
                            selectedItem:widget.store.area??Area(areaName: " ${widget.store.areaName??' '}"),

                            //  selectedItem:widget.store.areaId==null?Area(areaName:'Select Area'):area.where((element) => element.id==widget.store.areaId).first,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (Area u) =>
                            themeColor.getlocal()=='ar'?u.areaName??u.name_en:u.name_en??u.areaName,
                            onChanged: (Area data) {
                              setState(() {
                                phone1.text='';
                                phone2.text='';
                                widget.store.areaId = data.id;
                                widget.store.city = City(cityName: '');
                                widget.store.area =data;

                                cities=null;
                              });
                              getCity(data.id);
                            },
                          ),
                        ),
                        Text(
                          getTransrlate(
                              context, 'City'),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16),
                        ),

                        cities == null
                            ? Container()
                            : Padding(
                          padding: const EdgeInsets
                              .symmetric(
                              vertical: 10),
                          child: DropdownSearch<City>(
                           // selectedItem:widget.store.cityId==null?City(cityName:'Select City'):cities.where((element) => element.id==widget.store.cityId).first,
                            selectedItem:widget.store.city??City(cityName:' ${widget.store.cityName??' '}'),
                            validator: (City item) {
                              if (item == null) {
                                return "Required field";
                              } else
                                return null;
                            },

                            items: cities,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (City u) =>
                            themeColor.getlocal()=='ar'?u.cityName??u.name_en:u.name_en??u.cityName,
                            onChanged: (City data) {
                              phone1.text='';
                              phone2.text='';
                              widget.store.cityId =data.id;
                              widget.store.city=data;
                            },
                          ),
                        ),
                        MyTextFormField(
                          intialLabel: widget.store.address ?? ' ',
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
                            widget.store.address = value;
                          },
                        ),
                        MyTextFormField(
                          textEditingController:phone1,
                          textDirection: TextDirection.ltr,
                          Keyboard_Type: TextInputType.phone,
                          labelText: "${getTransrlate(context, 'phone')} 1",
                          hintText:"${getTransrlate(context, 'phone')} 1",
                          isPhone: true,
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(15),
                          ],
                          enabled: true,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return getTransrlate(context, 'requiredlength');
                            } else if (value.length<12) {
                              return getTransrlate(context, 'requiredempty');
                            }
                            _formKey.currentState.save();
                            return null;
                          },
                          onSaved: (String value) {
                            widget.store.moderatorPhone = value;
                          },
                        ),
                        MyTextFormField(
                          textEditingController:phone2,
                          textDirection: TextDirection.ltr,
                          Keyboard_Type: TextInputType.phone,
                          labelText: "${getTransrlate(context, 'phone')} 2",
                          hintText: "${getTransrlate(context, 'phone')} 2",
                          isPhone: true,
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(15),
                          ],
                          enabled: true,
                          validator: (String value) {
                            if (value.length > 1&&value.length < 12) {
                              return getTransrlate(context, 'Required');
                            }
                            _formKey.currentState.save();
                            return null;
                          },
                          onSaved: (String value) {
                            widget.store.moderatorAltPhone = value;
                          },
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
                          side: BorderSide(
                              color: Colors.orange, width: 1)),
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
                          print(widget.store.nameStore);

                          API(context)
                              .post(
                              "update/stores/${widget.store.id}",
                              widget.store.toJson())
                              .then((value) {
                            setState(() {
                              loading = false;
                            });
                            if (value.containsKey('errors')) {
                              showDialog(
                                context: context,
                                builder: (_) => ResultOverlay(
                                  "${value['errors']}",
                                ),
                              );
                            } else {
                              Provider.of<Provider_Data>(context,listen: false).getAllStore(context);

                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (_) => ResultOverlay(
                                  "${value['message']}",
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
                          side:
                          BorderSide(color: Colors.grey, width: 1)),
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
      getCity(widget.store.areaId);

    });
  }

  void getCountry() {
    API(context).get('countries/list/all').then((value) {
      setState(() {
        contries = Country_model.fromJson(value).data;
      });
      getArea(widget.store.countryId);
    });
  }
}
