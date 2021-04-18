import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/car_made.dart';
import 'package:trkar_vendor/model/carmodel.dart';
import 'package:trkar_vendor/model/category.dart';
import 'package:trkar_vendor/model/part__category.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/model/tags_model.dart';
import 'package:trkar_vendor/model/year.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/find_dropdown.dart';

class Add_Product extends StatefulWidget {
  @override
  _Add_ProductState createState() => _Add_ProductState();
}

class _Add_ProductState extends State<Add_Product> {
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

  TextEditingController serialcontroler, namecontroler, description;
  TextEditingController car_made_id_controler,
      car_model_id_Controler,
      part_category_id_controller,
      year_idcontroler,
      store_id,
      price_controller,
      tagscontroler,
      discountcontroler,
      quantityController;

  DateTime selectedDate = DateTime.now();
  String SelectDate = ' ';
  File _image;
  String base64Image;
  final search = Search(milliseconds: 1000);

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        base64Image = base64Encode(_image.readAsBytesSync());

        print(base64Image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    getAllCareMade();
    serialcontroler = TextEditingController();
    namecontroler = TextEditingController();
    car_made_id_controler = TextEditingController();
    car_model_id_Controler = TextEditingController();
    part_category_id_controller = TextEditingController();
    description = TextEditingController();
    discountcontroler = TextEditingController();
    store_id = TextEditingController();
    price_controller = TextEditingController();
    tagscontroler = TextEditingController();
    year_idcontroler = TextEditingController();
    serialcontroler = TextEditingController();
    namecontroler = TextEditingController();
    car_made_id_controler = TextEditingController();
    car_model_id_Controler = TextEditingController();
    quantityController = TextEditingController();

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
                        controller: namecontroler,
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
                              controller: serialcontroler,
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
                              controller: quantityController,
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
                    TextField(
                        controller: price_controller,
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
                          TextField(
                              controller: discountcontroler,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<CarMade>(
                            items: CarMades,
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(), width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        selectedText.carMade,
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
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
                              car_made_id_controler.text = item.id.toString();
                              getAllCareModel(item.id);
                            },
                            labelStyle: TextStyle(fontSize: 20),
                            selectedItem: CarMade(carMade: 'Select Car Made'),
                            titleStyle: TextStyle(fontSize: 20),
                            label: "Car Made",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Carmodel>(
                            items: carmodels,
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
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(), width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        selectedText.carmodel,
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.carmodel,
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
                              car_model_id_Controler.text = item.id.toString();
                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            selectedItem:
                                Carmodel(carmodel: 'Select Car model'),
                            label: "Car Model",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(), width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        selectedText.categoryName,
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
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
                              part_category_id_controller.text =
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
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(), width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        selectedText.year,
                                        minFontSize: 8,
                                        maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
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
                              year_idcontroler.text = item.id.toString();
                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            selectedItem: Year(year: 'Select Year'),
                            label: "Year",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
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
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(), width: 2),
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
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                            selectedItem: Categories(name: 'Categories'),
                            label: "Categories",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(), width: 2),
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
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                              store_id.text = item.id.toString();
                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            selectedItem: Store(name: 'Stores'),
                            label: "Stores",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
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
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(), width: 2),
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
                                            color: themeColor.getColor(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                              tagscontroler.text = item.name.toString();
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
                            controller: description,
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
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 30,
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
                            API(context).post("add/products", {
                              "name": namecontroler.text,
                              "categories": "[1, 2]",
                              "car_made_id": car_made_id_controler.text,
                              "car_model_id": car_model_id_Controler.text,
                              "year_id": year_idcontroler.text,
                              "part_category_id":
                                  part_category_id_controller.text,
                              "photo": base64Image,
                              "discount": discountcontroler.text,
                              "price": price_controller.text,
                              "description": description.text,
                              "store_id": store_id.text,
                              "quantity": quantityController.text,
                              "serial_number": serialcontroler.text,
                              "tags": tagscontroler.text,
                            }).then((value) {
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

  Future<void> getAllCareModel(int id) async {
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
    });
  }
}
