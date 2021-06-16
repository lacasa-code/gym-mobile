import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/car_made.dart';
import 'package:trkar_vendor/model/car_types.dart';
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
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/find_dropdown.dart';

class Add_Product extends StatefulWidget {
  @override
  _Add_ProductState createState() => _Add_ProductState();
}

class _Add_ProductState extends State<Add_Product> {
  Product product = Product();
  bool loading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<Carmodel> carmodels;
  List<CarMade> CarMades;
  List<Year> years;
  List<Store> _store;
  List<Tag> _tags;
  List<String> _tagSelect=[];
  List<Categories> _category;
  List<String> categories;
  List<Part_Category> part_Categories;
  List<Carmodel> filteredcarmodels_data = List();
  List<CarMade> filteredCarMades_data = List();
  List<Manufacturer> _manufacturers;
  List<ProdCountry> _prodcountries;
  List<Transmission> transmissions;
  List<CarType> cartypes;

  DateTime selectedDate = DateTime.now();
  String SelectDate = ' ';
  File _image;
  List<String> photos = [];
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
        photos.add(base64Image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    getAllCareMade();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/ic_shopping_cart_bottom.svg',
              height: 30,
              width: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'product')),
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
                builder: (_) => SearchOverlay(),
              );
            },
          )
        ],
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
                    MyTextFormField(
                      intialLabel: product.name ?? ' ',
                      Keyboard_Type: TextInputType.name,
                      labelText: getTransrlate(context, 'name'),
                      hintText: getTransrlate(context, 'name'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'name');
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        product.name = value;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الفئة الرئيسية",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _category == null
                                ? Container()
                                : Container(
                                    width: ScreenUtil.getWidth(context) / 2.5,
                                    child: DropdownSearch<Categories>(
                                        showSearchBox: false,
                                        showClearButton: false,
                                        label: "   ",
                                        validator: (Categories item) {
                                          if (item == null) {
                                            return "Required field";
                                          } else
                                            return null;
                                        },
                                        items: _category,
                                        //  onFind: (String filter) => getData(filter),
                                        itemAsString: (Categories u) => u.name,
                                        onChanged: (Categories data) =>
                                            product.CategoryId = data.id),
                                  ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الفئة الفرعية",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            part_Categories == null
                                ? Container()
                                : Container(
                                    width: ScreenUtil.getWidth(context) / 2.5,
                                    child: DropdownSearch<Part_Category>(
                                        showSearchBox: false,
                                        showClearButton: false,
                                        label: "   ",
                                        validator: (Part_Category item) {
                                          if (item == null) {
                                            return "Required field";
                                          } else
                                            return null;
                                        },
                                        items: part_Categories,
                                        //  onFind: (String filter) => getData(filter),
                                        itemAsString: (Part_Category u) => u.categoryName,
                                        onChanged: (Part_Category data) =>
                                            product.partCategoryId = data.id),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "المركبة",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        transmissions == null
                            ? Container()
                            : Container(
                                width: ScreenUtil.getWidth(context) / 2.5,
                                child: DropdownSearch<Transmission>(
                                    showSearchBox: false,
                                    showClearButton: false,
                                    label: " نوع المركبة",
                                    validator: (Transmission item) {
                                      if (item == null) {
                                        return "Required field";
                                      } else
                                        return null;
                                    },
                                    items: transmissions,
                                    //  onFind: (String filter) => getData(filter),
                                    itemAsString: (Transmission u) => u.transmissionName,
                                    onChanged: (Transmission data) =>
                                        product.transmission_id = data.id),
                              ),
                        CarMades == null
                            ? Container()
                            : Container(
                                width: ScreenUtil.getWidth(context) / 2.5,
                                child: DropdownSearch<CarMade>(
                                    showSearchBox: false,
                                    showClearButton: false,
                                    label: " ماركة",
                                    validator: (CarMade item) {
                                      if (item == null) {
                                        return "Required field";
                                      } else
                                        return null;
                                    },
                                    items: CarMades,
                                    //  onFind: (String filter) => getData(filter),
                                    itemAsString: (CarMade u) => u.carMade,
                                    onChanged: (CarMade data) {
                                      product.carMadeId = data.id;
                                    getAllCareModel(data.id);}),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        carmodels == null
                            ? Container()
                            : Container(
                                width: ScreenUtil.getWidth(context) / 2.5,
                                child: DropdownSearch<Carmodel>(
                                    showSearchBox: false,
                                    showClearButton: false,
                                    label: " الموديل",
                                    validator: (Carmodel item) {
                                      if (item == null) {
                                        return "Required field";
                                      } else
                                        return null;
                                    },
                                    items: carmodels,
                                    //  onFind: (String filter) => getData(filter),
                                    itemAsString: (Carmodel u) => u.carmodel,
                                    onChanged: (Carmodel data) =>
                                        product.carModelId = data.id),
                              ),
                        years == null
                            ? Container()
                            : Container(
                                width: ScreenUtil.getWidth(context) / 2.5,
                                child: DropdownSearch<Year>(
                                    showSearchBox: false,
                                    showClearButton: false,
                                    label: " السنة",
                                    validator: (Year item) {
                                      if (item == null) {
                                        return "Required field";
                                      } else
                                        return null;
                                    },
                                    items: years,
                                    //  onFind: (String filter) => getData(filter),
                                    itemAsString: (Year u) => u.year,
                                    onChanged: (Year data) =>
                                        product.yearId = data.id),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    cartypes == null
                        ? Container()
                        : Container(
                      child: DropdownSearch<CarType>(
                          showSearchBox: false,
                          showClearButton: false,
                          label: " نوع المركبة",
                          validator: (CarType item) {
                            if (item == null) {
                              return "Required field";
                            } else
                              return null;
                          },
                          items: cartypes,
                          //  onFind: (String filter) => getData(filter),
                          itemAsString: (CarType u) => u.typeName,
                          onChanged: (CarType data) =>
                              product.cartype_id = data.id),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    MyTextFormField(
                      intialLabel: product.name ?? ' ',
                      Keyboard_Type: TextInputType.name,
                      labelText: getTransrlate(context, 'description'),
                      hintText: getTransrlate(context, 'description'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'description');
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        product.description = value;
                      },
                    ),
                    Text(
                      "المخزن",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _store == null
                        ? Container()
                        : Container(
                            child: DropdownSearch<Store>(
                                showSearchBox: false,
                                showClearButton: false,
                                validator: (Store item) {
                                  if (item == null) {
                                    return "Required field";
                                  } else
                                    return null;
                                },
                                items: _store,
                                //  onFind: (String filter) => getData(filter),
                                itemAsString: (Store u) => u.name,
                                onChanged: (Store data) =>
                                    product.storeId = data.id),
                          ),
                    MyTextFormField(
                      intialLabel: product.name ?? ' ',
                      Keyboard_Type: TextInputType.name,
                      labelText: 'السعر',
                      hintText: 'السعر',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'السعر';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        product.price = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: product.quantity ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText: "الكمية",
                      hintText: 'الكمية',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'الكمية';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        product.quantity = int.parse(value);
                      },
                    ),
                    MyTextFormField(
                      intialLabel: product.quantity ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText: "الخصم",
                      hintText: 'الخصم',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'الخصم';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        product.discount = value;
                      },
                    ),
                    Text(
                      "بلد المنشأ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _prodcountries== null
                        ? Container()
                        : Container(
                            child: DropdownSearch<ProdCountry>(
                                showSearchBox: false,
                                showClearButton: false,
                                validator: (ProdCountry item) {
                                  if (item == null) {
                                    return "Required field";
                                  } else
                                    return null;
                                },
                                items: _prodcountries,
                                //  onFind: (String filter) => getData(filter),
                                itemAsString: (ProdCountry u) => u.countryName,
                                onChanged: (ProdCountry data) =>
                                    product.prodcountry_id = data.id),
                          ),
                    TypeAheadField(
                      hideOnLoading: true,
                      hideOnEmpty: true,
                      getImmediateSuggestions: false,
                      onSuggestionSelected: (val) {
                        _onSuggestionSelected(val);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.name,),
                        );
                      },
                      suggestionsCallback: (val) {
                        return _sugestionList(tags: _tags, suggestion: val,);
//                return ;
                      },
                    ),
                    _generateTags(),
// Container(
                    //   margin: EdgeInsets.symmetric(vertical: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text(
                    //         "Serial number",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       TextFormField(
                    //           controller: serialcontroler,
                    //           keyboardType: TextInputType.number,
                    //           validator: (String value) {
                    //             if (value.isEmpty) {
                    //               return getTransrlate(context, 'counter');
                    //             } else if (value.length < 2) {
                    //               return getTransrlate(context, 'counter');
                    //             }
                    //             _formKey.currentState.save();
                    //
                    //             return null;
                    //           },
                    //           decoration: InputDecoration(
                    //               border: InputBorder.none,
                    //               fillColor: Color(0xfff3f3f4),
                    //               filled: true))
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text(
                    //         "Quantity",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       TextFormField(
                    //           controller: quantityController,
                    //           keyboardType: TextInputType.number,
                    //           validator: (String value) {
                    //             if (value.isEmpty) {
                    //               return getTransrlate(context, 'counter');
                    //             } else if (value.length < 2) {
                    //               return getTransrlate(context, 'counter');
                    //             }
                    //             _formKey.currentState.save();
                    //
                    //             return null;
                    //           },
                    //           decoration: InputDecoration(
                    //               border: InputBorder.none,
                    //               fillColor: Color(0xfff3f3f4),
                    //               filled: true))
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   "Price",
                    //   style:
                    //       TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // TextField(
                    //     controller: price_controller,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //         border: InputBorder.none,
                    //         fillColor: Color(0xfff3f3f4),
                    //         filled: true)),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text(
                    //         "Discount",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       TextField(
                    //           controller: discountcontroler,
                    //           keyboardType: TextInputType.number,
                    //           decoration: InputDecoration(
                    //               suffix: Text('%'),
                    //               border: InputBorder.none,
                    //               fillColor: Color(0xfff3f3f4),
                    //               filled: true))
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<CarMade>(
                    //         items: CarMades,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.carMade,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.carMade,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           car_made_id_controler.text = item.id.toString();
                    //           getAllCareModel(item.id);
                    //         },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         selectedItem: CarMade(carMade: 'Select Car Made'),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         label: "Car Made",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<Carmodel>(
                    //         items: carmodels,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.carmodel,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.carmodel,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           car_model_id_Controler.text = item.id.toString();
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem:
                    //             Carmodel(carmodel: 'Select Car model'),
                    //         label: "Car Model",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<Part_Category>(
                    //         items: part_Categories,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.categoryName,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.categoryName,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           part_category_id_controller.text =
                    //               item.id.toString();
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem: Part_Category(
                    //             categoryName: 'Select Part Category'),
                    //         label: "part",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<Year>(
                    //         items: years,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.year,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.year,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           year_idcontroler.text = item.id.toString();
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem: Year(year: 'Select Year'),
                    //         label: "Year",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<Categories>(
                    //         items: _category,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.name,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.name,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           categories = [];
                    //           categories.add(item.id.toString());
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem: Categories(name: 'Categories'),
                    //         label: "Categories",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<Store>(
                    //         items: _store,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.name,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.name,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           store_id.text = item.id.toString();
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem: Store(name: 'Stores'),
                    //         label: "Stores",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<Tag>(
                    //         items: _tags,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.name,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.name,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           tagscontroler.text = item.name.toString();
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem: Tag(name: 'Select Tags'),
                    //         label: "Tag",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<ProdCountry>(
                    //         items: _prodcountries,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.countryName,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.countryName,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           prodcountry_id.text = item.id.toString();
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem: ProdCountry(
                    //             countryName: 'Select Product Country'),
                    //         label: "Product Country",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<Manufacturer>(
                    //         items: _manufacturers,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.manufacturerName,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.manufacturerName,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           manufacturer_id.text = item.id.toString();
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem: Manufacturer(
                    //             manufacturerName: 'Select manufacturer'),
                    //         label: "manufacturer",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(6.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 4, top: 4),
                    //     child: FindDropdown<Transmission>(
                    //         items: transmissions,
                    //         // onFind: (f) async {
                    //         //   search.run(() {
                    //         //     setState(() {
                    //         //       filteredcarmodels_data = carmodels
                    //         //           .where((u) =>
                    //         //       (u.carmodel
                    //         //           .toLowerCase()
                    //         //           .contains(f
                    //         //           .toLowerCase())))
                    //         //           .toList();
                    //         //     });
                    //         //   });
                    //         //   return filteredcarmodels_data;
                    //         // } ,
                    //         dropdownBuilder: (context, selectedText) => Align(
                    //             alignment: Alignment.topRight,
                    //             child: Container(
                    //               height: 50,
                    //               width: ScreenUtil.getWidth(context) / 1.1,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: themeColor.getColor(), width: 2),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   AutoSizeText(
                    //                     selectedText.transmissionName,
                    //                     minFontSize: 8,
                    //                     maxLines: 1,
                    //                     //overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: themeColor.getColor(),
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //         dropdownItemBuilder: (context, item, isSelected) =>
                    //             Padding(
                    //               padding: const EdgeInsets.all(12),
                    //               child: Text(
                    //                 item.transmissionName,
                    //                 style: TextStyle(
                    //                     color: isSelected
                    //                         ? themeColor.getColor()
                    //                         : Color(0xFF5D6A78),
                    //                     fontSize: isSelected ? 20 : 17,
                    //                     fontWeight: isSelected
                    //                         ? FontWeight.w600
                    //                         : FontWeight.w600),
                    //               ),
                    //             ),
                    //         onChanged: (item) {
                    //           transmission_id.text = item.id.toString();
                    //         },
                    //         // onFind: (text) {
                    //         //
                    //         // },
                    //         labelStyle: TextStyle(fontSize: 20),
                    //         titleStyle: TextStyle(fontSize: 20),
                    //         selectedItem: Transmission(
                    //             transmissionName: 'Select transmission'),
                    //         label: "Transmissions",
                    //         showSearchBox: false,
                    //         isUnderLine: false),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text(
                    //         "Description",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       TextFormField(
                    //         controller: description,
                    //         keyboardType: TextInputType.text,
                    //         decoration: InputDecoration(
                    //             border: InputBorder.none,
                    //             fillColor: Color(0xfff3f3f4),
                    //             filled: true),
                    //         validator: (String value) {
                    //           if (value.isEmpty) {
                    //             return "description";
                    //           } else if (value.length < 5) {
                    //             return "description" + ' < 5';
                    //           }
                    //           _formKey.currentState.save();
                    //
                    //           return null;
                    //         },
                    //       )
                    //     ],
                    //   ),
                    // ),
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
                            API(context)
                                .post("add/products", product.toJson())
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
      getAllParts_Category();
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
    getAllType();
  }
  Future<void> getAllType() async {
    API(context).get('car/types/list').then((value) {
      if (value != null) {
        setState(() {
          cartypes = CarTypes.fromJson(value).data;
        });
      }
    });
  }
  _generateTags() {
    return _tagSelect.isEmpty ?
    Container()
        :
    Container(
      alignment: Alignment.topLeft,
      child: Tags(
        alignment: WrapAlignment.center,
        itemCount: _tagSelect.length,
        itemBuilder: (index) {
          return ItemTags(
            index: index,
            title: _tagSelect[index],
            color: Colors.blue,
            activeColor: Colors.red,
            onPressed: (Item item) {
              print('pressed');
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            elevation: 0.0,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                textColor: ,
            textColor: Colors.white,
            textActiveColor: Colors.white,
            removeButton: ItemTagsRemoveButton(
                color: Colors.black,
                backgroundColor: Colors.transparent,
                size: 14,
                onRemoved: () {
                  _onSuggestionRemoved(_tagSelect[index]);
                  return true;
                }),
            textOverflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
  _onSuggestionSelected(Tag value) {
    if(value !=null) {
      final String isAlreadyInSelectedList = _tagSelect.firstWhere((text)=> text==value,orElse: () {return null;});

      if(isAlreadyInSelectedList ==null) {
        setState(() {
          _tagSelect.add(value.name);
          _tags.remove(value);
        });
      }
    }
  }

  _onSuggestionRemoved(String value) {
    final Tag exist = _tags.firstWhere((text) => text.name==value,orElse: (){return null;});

    final String exists = _tagSelect.firstWhere((text) => text==value,orElse: () {return null;});
    if(exists !=null) {
      setState(() {
        _tagSelect.remove(value);
        _tags.add(exist);
      });
    }
  }
  _sugestionList({@required List<Tag> tags , @required String suggestion}) {
    List<Tag> modifiedList = [];
    modifiedList.addAll(tags);
    modifiedList.retainWhere((text) => text.name.toLowerCase().contains(suggestion.toLowerCase()));
    if(suggestion.length >=2) {
      return modifiedList;
    }
    else {
      return null;
    }
  }
}
