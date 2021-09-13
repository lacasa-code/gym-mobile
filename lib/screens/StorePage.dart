
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/screens/edit_store.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay_Store.dart';

class StorePage extends StatefulWidget {
  Store store;

  StorePage({Key key,this.store}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = <Marker>[];

  static  CameraPosition _kGooglePlex ;
@override
  void initState() {

 setState(() {
   _kGooglePlex = CameraPosition(
     target: LatLng(double.parse(widget.store.lat??'0.0'), double.parse(widget.store.long??'0.0')),
     zoom: 14.4746,
   );
   _markers.add(
       Marker(
           markerId: MarkerId('1'),
           position: LatLng(double.parse(widget.store.lat??'0.0'), double.parse(widget.store.long??'0.0')),
           infoWindow: InfoWindow(
               title: '${widget.store.nameStore}'
           )
       )
   );
 });
    // TODO: implement initState
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
              height: 30,
              width: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'stores')),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => SearchOverlay_Store(url: 'stores/search/name',),
              );
            },
          )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/store.svg",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      PopupMenuButton<int>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: InkWell(
                              onTap: (){
                                Nav.route(context, Edit_Store(widget.store));
                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Text("${getTransrlate(context, 'edit')}"),
                                  Icon(
                                    Icons.edit_outlined,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                            ),
                          ),
                          widget.store.headCenter==1?PopupMenuItem(
                            value: 2,

                          ):
                          PopupMenuItem(
                            value: 2,
                            child:  InkWell(
                              onTap: (){
                                API(context)
                                    .Delete("stores/${widget.store.id}")
                                    .then((value) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      "${value['message']??value['errors'] ?? 'تم حذف المتجر بنجاح'}",
                                    ),
                                  );
                                  Provider.of<Provider_Data>(context,listen: false).getAllStore(context);
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Text("${getTransrlate(context, 'delete')}"),
                                  Icon(
                                    CupertinoIcons.delete,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.store.nameStore}",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Text(
                    "${getTransrlate(context, 'ModeratorPhone')} : ${widget.store.moderatorPhone}",
                    style: TextStyle(fontSize: 14),
                  ),
                  widget.store.moderatorAltPhone==null?Container(): Text(
                    "${getTransrlate(context, 'moderatorAltPhone')} : ${widget.store.moderatorAltPhone}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "${getTransrlate(context, 'staff')} : ",
                    style: TextStyle(fontSize: 14),
                  ),
                  widget.store.members==null?Container():
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.store.members.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                     //   mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil.getWidth(context) / 1.5,
                            child: Text(
                              "${widget.store.members[index].name}",
                              style: TextStyle(
                                  color: themeColor.getColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                          Container(
                            width: ScreenUtil.getWidth(context) / 1.5,
                            child: Text(
                              "${widget.store.members[index].email}",
                              style: TextStyle(
                                  color: themeColor.getColor(),
                                  fontSize: 13),
                            ),
                          ),
                          Container(
                            width: ScreenUtil.getWidth(context) / 1.5,
                            child: Text(
                              "${widget.store.members[index].roleName} ",
                              style: TextStyle(
                                  color: themeColor.getColor(),
                                  fontSize: 13),
                            ),
                          ),
                          Container(color: Colors.black12,height: 1,),
                          SizedBox(height: 10,),

                        ],
                      );
                    },
                  ),
                  Text(
                    "${getTransrlate(context, 'country')} : ${widget.store.countryName??' '}",
                    style: TextStyle(fontSize: 14),
                  ),   Text(
                    "${getTransrlate(context, 'Area')} : ${widget.store.areaName??' '}",
                    style: TextStyle(fontSize: 14),
                  ),   Text(
                    "${getTransrlate(context, 'City')} : ${widget.store.cityName??' '}",
                    style: TextStyle(fontSize: 14),
                  ),  Text(
                    "${getTransrlate(context, 'address')} : ${widget.store.address}",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8,),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${getTransrlate(context, 'Location')} :",
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                      height: ScreenUtil.getHeight(context)/5,
                      width: ScreenUtil.getWidth(context),

                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        markers: Set<Marker>.of(_markers),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}
