import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/car_made.dart';
import 'package:trkar_vendor/model/carmodel.dart';
import 'package:trkar_vendor/model/category.dart';
import 'package:trkar_vendor/model/manufacturer_model.dart';
import 'package:trkar_vendor/model/part__category.dart';
import 'package:trkar_vendor/model/prod_country.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/model/tags_model.dart';
import 'package:trkar_vendor/model/transmissions.dart';
import 'package:trkar_vendor/model/year.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/find_dropdown.dart';

class Edit_Product extends StatefulWidget {
  Product product;

  Edit_Product(this.product);

  @override
  _Edit_ProductState createState() => _Edit_ProductState();
}

class _Edit_ProductState extends State<Edit_Product> {
  bool loading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<Carmodel> carmodels;
  List<CarMade> CarMades;
  List<Year> years;
  List<Store> _store;
  List<Tag> _tags;
  List<Categories> _category;
  List<int> categorySelect = [];
  List<Part_Category> part_Categories;
  List<Carmodel> filteredcarmodels_data = List();
  List<CarMade> filteredCarMades_data = List();
  List<Manufacturer> _manufacturers;
  List<Transmission> transmissions;
  List<ProdCountry> _prodcountries;

  DateTime selectedDate = DateTime.now();
  String SelectDate = ' ';
  File _image;
  String base64Image;
  final search = Search(milliseconds: 1000);
  List<String> photos = [];
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        base64Image = base64Encode(_image.readAsBytesSync());
        photos.add(base64Image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    print(widget.product.carMadeId);
    getAllCareMade();
    getAllCareModel(widget.product.carMadeId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("${widget.product.name}"),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: widget.product.name,
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'name');
                          } else if (value.length < 3) {
                            return getTransrlate(context, 'name') + ' < 2';
                          }
                          _formKey.currentState.save();

                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Serial number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              initialValue: widget.product.serialNumber,
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Quantity",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              initialValue: widget.product.quantity,
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
                    Text(
                      "Price",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: widget.product.price,
                        keyboardType: TextInputType.number,
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
                            "Discount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              initialValue: widget.product.discount,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),
                    Text(
                      "Car Made",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: CarMades == null
                            ? Container()
                            : CarMades.isEmpty
                                ? Container()
                                : FindDropdown<CarMade>(
                                    items: CarMades,
                                    dropdownBuilder: (context, selectedText) =>
                                        selectedText == null
                                            ? Container()
                                            : Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  height: 50,
                                                  width: ScreenUtil.getWidth(
                                                          context) /
                                                      1.1,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: themeColor
                                                            .getColor(),
                                                        width: 2),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      AutoSizeText(
                                                        selectedText.carMade,
                                                        minFontSize: 8,
                                                        maxLines: 1,
                                                        //overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: themeColor
                                                                .getColor(),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                    dropdownItemBuilder: (context, item,
                                            isSelected) =>
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            item.carMade,
                                            style: TextStyle(
                                                color: isSelected
                                                    ? themeColor.getColor()
                                                    : Color(0xFF5D6A78),
                                                fontSize: isSelected ? 20 : 17,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w600),
                                          ),
                                        ),
                                    onChanged: (item) {
                                      widget.product.carMadeId =
                                          item.id.toString();
                                      getAllCareModel(item.id.toString());
                                    },
                                    labelStyle: TextStyle(fontSize: 20),
                                    selectedItem: CarMades.isNotEmpty
                                        ? CarMades.where((element) =>
                                                element.id ==
                                                widget.product
                                                    .carMadeId).isNotEmpty
                                            ? CarMades.where((element) =>
                                                element.id ==
                                                widget.product.carMadeId).single
                                            : CarMade(carMade: 'Car Made')
                                        : CarMade(carMade: 'Car Made'),
                                    titleStyle: TextStyle(fontSize: 20),
                                    label: "Car Made",
                                    showSearchBox: false,
                                    isUnderLine: false),
                      ),
                    ),
                    carmodels == null
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Car Model",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 4, top: 4),
                                  child: FindDropdown<Carmodel>(
                                      items: carmodels,
                                      dropdownBuilder: (context,
                                              selectedText) =>
                                          selectedText == null
                                              ? Container()
                                              : Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    height: 50,
                                                    width: ScreenUtil.getWidth(
                                                            context) /
                                                        1.1,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: themeColor
                                                              .getColor(),
                                                          width: 2),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        AutoSizeText(
                                                          selectedText.carmodel,
                                                          minFontSize: 8,
                                                          maxLines: 1,
                                                          //overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: themeColor
                                                                  .getColor(),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                      dropdownItemBuilder: (context, item,
                                              isSelected) =>
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              item.carmodel,
                                              style: TextStyle(
                                                  color: isSelected
                                                      ? themeColor.getColor()
                                                      : Color(0xFF5D6A78),
                                                  fontSize:
                                                      isSelected ? 20 : 17,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w600),
                                            ),
                                          ),
                                      onChanged: (item) {
                                        widget.product.carModelId =
                                            item.id.toString();
                                      },
                                      // onFind: (text) {
                                      //
                                      // },
                                      labelStyle: TextStyle(fontSize: 20),
                                      titleStyle: TextStyle(fontSize: 20),
                                      selectedItem:  Carmodel(carmodel: 'Select Car model'),
                                      label: "Car Model",
                                      showSearchBox: false,
                                      isUnderLine: false),
                                ),
                              ),
                            ],
                          ),
                    Text(
                      "Part Categories",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    part_Categories == null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 4),
                              child: FindDropdown<Part_Category>(
                                  items: part_Categories,
                                  // onFind: (f) async {
                                  //   search.run(() {
                                  //     setState(() {
                                  //       filteredcarmodels_data = carmodels
                                  //           .where((u) =>
                                  //       (u.carmodel
                                  //           .toLowerCase()
                                  //           .contains(f
                                  //           .toLowerCase())))
                                  //           .toList();
                                  //     });
                                  //   });
                                  //   return filteredcarmodels_data;
                                  // } ,
                                  dropdownBuilder: (context, selectedText) =>
                                      selectedText == null
                                          ? Container()
                                          : Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: 50,
                                                width: ScreenUtil.getWidth(
                                                        context) /
                                                    1.1,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color:
                                                          themeColor.getColor(),
                                                      width: 2),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    AutoSizeText(
                                                      "${selectedText.categoryName}",
                                                      minFontSize: 8,
                                                      maxLines: 1,
                                                      //overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: themeColor
                                                              .getColor(),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                  dropdownItemBuilder: (context, item,
                                          isSelected) =>
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          item.categoryName,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? themeColor.getColor()
                                                  : Color(0xFF5D6A78),
                                              fontSize: isSelected ? 20 : 17,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w600),
                                        ),
                                      ),
                                  onChanged: (item) {
                                    widget.product.partCategoryId =
                                        item.id.toString();
                                  },
                                  // onFind: (text) {
                                  //
                                  // },
                                  labelStyle: TextStyle(fontSize: 20),
                                  titleStyle: TextStyle(fontSize: 20),
                                  selectedItem: Part_Category(
                                      categoryName: 'Select Part Category'),
                                  label: "part",
                                  showSearchBox: false,
                                  isUnderLine: false),
                            ),
                          ),
                    Text(
                      "Year",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    years == null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 4),
                              child: FindDropdown<Year>(
                                  items: years,
                                  // onFind: (f) async {
                                  //   search.run(() {
                                  //     setState(() {
                                  //       filteredcarmodels_data = carmodels
                                  //           .where((u) =>
                                  //       (u.carmodel
                                  //           .toLowerCase()
                                  //           .contains(f
                                  //           .toLowerCase())))
                                  //           .toList();
                                  //     });
                                  //   });
                                  //   return filteredcarmodels_data;
                                  // } ,
                                  dropdownBuilder: (context, selectedText) =>
                                      selectedText == null
                                          ? Container()
                                          : Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: 50,
                                                width: ScreenUtil.getWidth(
                                                        context) /
                                                    1.1,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color:
                                                          themeColor.getColor(),
                                                      width: 2),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    AutoSizeText(
                                                      selectedText.year,
                                                      minFontSize: 8,
                                                      maxLines: 1,
                                                      //overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: themeColor
                                                              .getColor(),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                  dropdownItemBuilder: (context, item,
                                          isSelected) =>
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          item.year,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? themeColor.getColor()
                                                  : Color(0xFF5D6A78),
                                              fontSize: isSelected ? 20 : 17,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w600),
                                        ),
                                      ),
                                  onChanged: (item) {
                                    widget.product.yearId = item.id.toString();
                                  },
                                  labelStyle: TextStyle(fontSize: 20),
                                  titleStyle: TextStyle(fontSize: 20),
                                  selectedItem: Year(year: 'Select Year'),
                                  label: "Year",
                                  showSearchBox: false,
                                  isUnderLine: false),
                            ),
                          ),
                    Text(
                      "Categories",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Categories>(
                            items: _category,
                            dropdownBuilder: (context, selectedText) =>
                                selectedText == null
                                    ? Container()
                                    : Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 50,
                                          width: ScreenUtil.getWidth(context) /
                                              1.1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: themeColor.getColor(),
                                                width: 2),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              AutoSizeText(
                                                selectedText.name,
                                                minFontSize: 8,
                                                maxLines: 1,
                                                //overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:
                                                        themeColor.getColor(),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {
                              categorySelect.add(item.id);
                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            selectedItem:widget.product.category!=null?
                            widget.product.category:
                            Categories(name: 'Categories'),
                            label: "Categories",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Text(
                      "Stores",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    _store == null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 4),
                              child: FindDropdown<Store>(
                                  items: _store,
                                  // onFind: (f) async {
                                  //   search.run(() {
                                  //     setState(() {
                                  //       filteredcarmodels_data = carmodels
                                  //           .where((u) =>
                                  //       (u.carmodel
                                  //           .toLowerCase()
                                  //           .contains(f
                                  //           .toLowerCase())))
                                  //           .toList();
                                  //     });
                                  //   });
                                  //   return filteredcarmodels_data;
                                  // } ,
                                  dropdownBuilder: (context, selectedText) =>
                                      selectedText == null
                                          ? Container()
                                          : Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: 50,
                                                width: ScreenUtil.getWidth(
                                                        context) /
                                                    1.1,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color:
                                                          themeColor.getColor(),
                                                      width: 2),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    AutoSizeText(
                                                      selectedText.name,
                                                      minFontSize: 8,
                                                      maxLines: 1,
                                                      //overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: themeColor
                                                              .getColor(),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                  dropdownItemBuilder: (context, item,
                                          isSelected) =>
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? themeColor.getColor()
                                                  : Color(0xFF5D6A78),
                                              fontSize: isSelected ? 20 : 17,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w600),
                                        ),
                                      ),
                                  onChanged: (item) {
                                    widget.product.storeId = item.id.toString();
                                  },
                                  // onFind: (text) {
                                  //
                                  // },
                                  labelStyle: TextStyle(fontSize: 20),
                                  titleStyle: TextStyle(fontSize: 20),
                                  selectedItem: _store.isNotEmpty
                                      ? _store
                                              .where((element) =>
                                                  element.id ==
                                                  widget.product.storeId)
                                              .isNotEmpty
                                          ? _store
                                              .where((element) =>
                                                  element.id ==
                                                  widget.product.storeId)
                                              .first
                                          : Store(name: 'Stores')
                                      : Store(name: 'Stores'),
                                  label: "Stores",
                                  showSearchBox: false,
                                  isUnderLine: false),
                            ),
                          ),
                    Text(
                      "Tags",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Tag>(
                            items: _tags,
                            // onFind: (f) async {
                            //   search.run(() {
                            //     setState(() {
                            //       filteredcarmodels_data = carmodels
                            //           .where((u) =>
                            //       (u.carmodel
                            //           .toLowerCase()
                            //           .contains(f
                            //           .toLowerCase())))
                            //           .toList();
                            //     });
                            //   });
                            //   return filteredcarmodels_data;
                            // } ,
                            dropdownBuilder: (context, selectedText) =>
                                selectedText == null
                                    ? Container()
                                    : Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 50,
                                          width: ScreenUtil.getWidth(context) /
                                              1.1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: themeColor.getColor(),
                                                width: 2),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              AutoSizeText(
                                                selectedText.name,
                                                minFontSize: 8,
                                                maxLines: 1,
                                                //overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:
                                                        themeColor.getColor(),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {
                              //   widget.product.tags = item.name.toString();
                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            selectedItem: Tag(name: 'Select Tags'),
                            label: "Tag",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Text(
                      "Product Country",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    _prodcountries == null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 4),
                              child: FindDropdown<ProdCountry>(
                                  items: _prodcountries,
                                  // onFind: (f) async {
                                  //   search.run(() {
                                  //     setState(() {
                                  //       filteredcarmodels_data = carmodels
                                  //           .where((u) =>
                                  //       (u.carmodel
                                  //           .toLowerCase()
                                  //           .contains(f
                                  //           .toLowerCase())))
                                  //           .toList();
                                  //     });
                                  //   });
                                  //   return filteredcarmodels_data;
                                  // } ,
                                  dropdownBuilder: (context, selectedText) =>
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: 50,
                                            width:
                                                ScreenUtil.getWidth(context) /
                                                    1.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: themeColor.getColor(),
                                                  width: 2),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                AutoSizeText(
                                                  selectedText == null
                                                      ? " "
                                                      : selectedText
                                                          .countryName,
                                                  minFontSize: 8,
                                                  maxLines: 1,
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          themeColor.getColor(),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )),
                                  dropdownItemBuilder: (context, item,
                                          isSelected) =>
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          item.countryName,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? themeColor.getColor()
                                                  : Color(0xFF5D6A78),
                                              fontSize: isSelected ? 20 : 17,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w600),
                                        ),
                                      ),
                                  onChanged: (item) {
                                    widget.product.prodcountry_id =
                                        item.id.toString();
                                  },
                                  // onFind: (text) {
                                  //
                                  // },
                                  labelStyle: TextStyle(fontSize: 20),
                                  titleStyle: TextStyle(fontSize: 20),
                                  selectedItem: ProdCountry(
                                      countryName: 'Select Product Country'),
                                  label: "ProdCountry",
                                  showSearchBox: false,
                                  isUnderLine: false),
                            ),
                          ),
                    Text(
                      "Manufacturers",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    _manufacturers == null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 4),
                              child: FindDropdown<Manufacturer>(
                                  items: _manufacturers,
                                  // onFind: (f) async {
                                  //   search.run(() {
                                  //     setState(() {
                                  //       filteredcarmodels_data = carmodels
                                  //           .where((u) =>
                                  //       (u.carmodel
                                  //           .toLowerCase()
                                  //           .contains(f
                                  //           .toLowerCase())))
                                  //           .toList();
                                  //     });
                                  //   });
                                  //   return filteredcarmodels_data;
                                  // } ,
                                  dropdownBuilder: (context, selectedText) =>
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: 50,
                                            width:
                                                ScreenUtil.getWidth(context) /
                                                    1.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: themeColor.getColor(),
                                                  width: 2),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                AutoSizeText(
                                                  selectedText == null
                                                      ? " "
                                                      : selectedText
                                                          .manufacturerName,
                                                  minFontSize: 8,
                                                  maxLines: 1,
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          themeColor.getColor(),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )),
                                  dropdownItemBuilder: (context, item,
                                          isSelected) =>
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          item.manufacturerName,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? themeColor.getColor()
                                                  : Color(0xFF5D6A78),
                                              fontSize: isSelected ? 20 : 17,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w600),
                                        ),
                                      ),
                                  onChanged: (item) {
                                    widget.product.manufacturer_id =
                                        item.id.toString();
                                  },
                                  // onFind: (text) {
                                  //
                                  // },
                                  labelStyle: TextStyle(fontSize: 20),
                                  titleStyle: TextStyle(fontSize: 20),
                                  selectedItem: Manufacturer(
                                      manufacturerName: 'Select manufacturer'),
                                  label: "manufacturer",
                                  showSearchBox: false,
                                  isUnderLine: false),
                            ),
                          ),
                    Text(
                      "Transmission",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    transmissions == null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 4),
                              child: FindDropdown<Transmission>(
                                  items: transmissions,
                                  // onFind: (f) async {
                                  //   search.run(() {
                                  //     setState(() {
                                  //       filteredcarmodels_data = carmodels
                                  //           .where((u) =>
                                  //       (u.carmodel
                                  //           .toLowerCase()
                                  //           .contains(f
                                  //           .toLowerCase())))
                                  //           .toList();
                                  //     });
                                  //   });
                                  //   return filteredcarmodels_data;
                                  // } ,
                                  dropdownBuilder: (context, selectedText) =>
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: 50,
                                            width:
                                                ScreenUtil.getWidth(context) /
                                                    1.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: themeColor.getColor(),
                                                  width: 2),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                AutoSizeText(
                                                  selectedText == null
                                                      ? " "
                                                      : selectedText
                                                          .transmissionName,
                                                  minFontSize: 8,
                                                  maxLines: 1,
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          themeColor.getColor(),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )),
                                  dropdownItemBuilder: (context, item,
                                          isSelected) =>
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          item.transmissionName,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? themeColor.getColor()
                                                  : Color(0xFF5D6A78),
                                              fontSize: isSelected ? 20 : 17,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w600),
                                        ),
                                      ),
                                  onChanged: (item) {
                                    widget.product.transmission_id =
                                        item.id.toString();
                                  },
                                  // onFind: (text) {
                                  //
                                  // },
                                  labelStyle: TextStyle(fontSize: 20),
                                  titleStyle: TextStyle(fontSize: 20),
                                  selectedItem: Transmission(
                                      transmissionName: 'Select Transmission'),
                                  label: "Transmissions",
                                  showSearchBox: false,
                                  isUnderLine: false),
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: widget.product.description,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "description";
                              } else if (value.length < 5) {
                                return "description" + ' < 5';
                              }
                              _formKey.currentState.save();

                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: _image == null
                            ? Container(
                                color: Color(0xfff3f3f4),
                                height: ScreenUtil.getHeight(context) / 5,
                                width: ScreenUtil.getWidth(context),
                                child: CachedNetworkImage(
                                  imageUrl: widget.product.photo.isNotEmpty
                                      ? widget.product.photo.first.image
                                      : 'https://d3a1v57rabk2hm.cloudfront.net/outerbanksbox/betterman_mobile-copy-42/images/product_placeholder.jpg?ts=1608776387&host=www.outerbanksbox.com',
                                  fit: BoxFit.cover,
                                ))
                            : Image.file(
                                _image,
                                height: ScreenUtil.getHeight(context) / 5,
                                width: ScreenUtil.getWidth(context),
                                fit: BoxFit.cover,
                              ),
                      ),
                      onTap: () {
                        getImage();
                      },
                    ),
                    SizedBox(
                      height: 10,
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
                                .post("products/${widget.product.id}",
                                    widget.product.toJson())
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  loading = false;
                                });
                                print(value.containsKey('errors'));
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
                                      'Done',
                                    ),
                                  );
                                }
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
        ],
      ),
    );
  }

  Future<void> getAllCareMade() async {
    API(context).get('car-madeslist').then((value) {
      if (value != null) {
        setState(() {
          CarMades = CarsMade.fromJson(value).data;
        });
      }
    });
  }

  Future<void> getAllCareModel(String id) async {
    API(context).get('car-modelslist/$id').then((value) {
      if (value != null) {
        setState(() {
          if (value["data"] != null) {
            carmodels = [];
            value["data"].forEach((v) {
              carmodels.add(Carmodel.fromJson(v));
            });
          }
        });
      }
      getAllParts_Category();
    });
  }

  Future<void> getAllParts_Category() async {
    API(context).get('part-categorieslist').then((value) {
      if (value != null) {
        setState(() {
          part_Categories = Parts_Category.fromJson(value).data;
        });
        getAllYear();
      }
    });
  }

  Future<void> getAllYear() async {
    API(context).get('car-yearslist').then((value) {
      if (value != null) {
        setState(() {
          years = Years.fromJson(value).data;
        });
      }
    });
    getAllStore();
  }

  Future<void> getAllStore() async {
    API(context).get('storeslist').then((value) {
      if (value != null) {
        setState(() {
          _store = Store_model.fromJson(value).data;
        });
      }
    });
    getAllCategory();
  }

  Future<void> getAllCategory() async {
    API(context).get('categorieslist').then((value) {
      if (value != null) {
        setState(() {
          _category = Category_model.fromJson(value).data;
        });
      }
    });
    getAlltag();
  }

  Future<void> getAlltag() async {
    API(context).get('product-tagslist').then((value) {
      if (value != null) {
        setState(() {
          _tags = Tags_model.fromJson(value).data;
        });
      }
      getAllprodcountry();
    });
  }

  Future<void> getAllprodcountry() async {
    API(context).get('prodcountries/list').then((value) {
      if (value != null) {
        setState(() {
          _prodcountries = ProdCountry_model.fromJson(value).data;
        });
      }
      getAllmanufacturer();
    });
  }

  Future<void> getAllmanufacturer() async {
    API(context).get('manufacturer/list').then((value) {
      if (value != null) {
        setState(() {
          _manufacturers = Manufacturer_model.fromJson(value).data;
        });
      }
      getAllTransmission();
    });
  }

  Future<void> getAllTransmission() async {
    API(context).get('transmissions-list').then((value) {
      if (value != null) {
        setState(() {
          transmissions = Transmissions.fromJson(value).data;
        });
      }
    });
  }
}
