import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/car_made.dart';
import 'package:trkar_vendor/model/car_types.dart';
import 'package:trkar_vendor/model/carmodel.dart';
import 'package:trkar_vendor/model/category.dart';
import 'package:trkar_vendor/model/main_category.dart';
import 'package:trkar_vendor/model/manufacturer_model.dart';
import 'package:trkar_vendor/model/part__category.dart';
import 'package:trkar_vendor/model/prod_country.dart';
import 'package:trkar_vendor/model/product_type_model.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/model/tags_model.dart';
import 'package:trkar_vendor/model/transmissions.dart';
import 'package:trkar_vendor/model/year.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

class Edit_Product extends StatefulWidget {
  Product product;

  Edit_Product(this.product);

  @override
  _Edit_ProductState createState() => _Edit_ProductState();
}

class _Edit_ProductState extends State<Edit_Product> {
  List<Main_Category> category=[];

  bool loading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<Carmodel> carmodels;
  List<CarMade> CarMades;
  List<Year> years;
  List<Store> _store;
  List<Tag> _tags;
  List<Categories> _category;
  List<String> categories;
  List<Part_Category> part_Categories;
  List<Manufacturer> _manufacturers;
  List<ProdCountry> _prodcountries;
  List<Transmission> transmissions;
  List<CarType> cartypes;
  List<Asset> images = List<Asset>();
  List<Main_Category> _listCategory;
  List<ProductType> _ProductType;
  DateTime selectedDate = DateTime.now();
  String SelectDate = ' ';
  File _image;
  List<String> photos = [];
  String base64Image;
  final search = Search(milliseconds: 1000);
  final picker = ImagePicker();
  int CheckBox = 0;
  TextEditingController totaldiscount = TextEditingController();
  bool isqty_reminder = false;

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

  Future getImages() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#EF9300",
          actionBarTitle: "Product Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          statusBarColor: "#EF9300",
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      // _error = error;
    });
  }

  @override
  void initState() {
    category=widget.product.allcategory;
    setState(() {
      isqty_reminder =widget.product.qty_reminder!=null;
    });
    getAllType();
    getAllproducttypes();
    getAllMain_category();
    getAllStore();
    getAllYear();
    totaldiscount.text =
        "${(double.parse(widget.product.discount ?? "0") / 100) * double.parse(widget.product.price ?? "0")}";

    getAllCategory(widget.product.maincategory == null
        ? ''
        : widget.product.maincategory.id.toString());
    widget.product.category == null
        ? null
        : getAllParts_Category(widget.product.category.id);
    widget.product.carType == null
        ? null
        : getAllCarMade(widget.product.carType.id.toString());
    getAllCareModel(widget.product.carMadeId);
    widget.product.yearto == null
        ? null
        : widget.product.yeartoId = widget.product.yearto.id.toString();
    widget.product.yearfrom == null
        ? null
        : widget.product.yearfromId = widget.product.yearfrom.id.toString();

    setState(() {
      widget.product.prodcountry_id = widget.product.prodCountry != null
          ? widget.product.prodCountry.id.toString()
          : null;
      widget.product.maincategory == null
          ? null
          : widget.product.Main_categoryid =
              widget.product.maincategory.id.toString();
    });
    widget.product.carMadeId = widget.product.carMade != null
        ? widget.product.carMade.id.toString()
        : null;
    widget.product.productType_id = widget.product.producttypeId != null
        ? widget.product.producttypeId.id.toString()
        : null;
    widget.product.manufacturer_id = widget.product.manufacturer == null
        ? ''
        : widget.product.manufacturer.id.toString();
    widget.product.maincategory_id = widget.product.maincategory == null
        ? ''
        : widget.product.maincategory.id.toString();
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
            Text(getTransrlate(context, 'products')),
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
                builder: (_) => SearchOverlay(url: 'products/search/dynamic',),
              );
            },
          )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextFormField(
                  intialLabel: widget.product.name ?? ' ',
                  Keyboard_Type: TextInputType.name,
                  labelText: getTransrlate(context, 'name'),
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(200),
                  ],
                  hintText: getTransrlate(context, 'name'),
                  isPhone: true,
                  enabled: true,
                  validator: (String value) {
                    if (themeColor.local == 'ar') {
                      if (value.isEmpty) {
                        return getTransrlate(context, 'requiredempty');
                      } else if (value.length < 2) {
                        return "${getTransrlate(context, 'requiredlength')}";
                      } else if (RegExp(r"^[+-]?([0-9]*[.])?[0-9]+")
                          .hasMatch(value)) {
                        return getTransrlate(context, 'invalidname');
                      }
                      return null;
                    }
                  },
                  onSaved: (String value) {
                    widget.product.name = value;
                  },
                ),
                MyTextFormField(
                  intialLabel: widget.product.nameEn ?? ' ',
                  Keyboard_Type: TextInputType.name,
                  labelText: getTransrlate(context, 'nameEn'),
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(200),
                  ],
                  hintText: getTransrlate(context, 'nameEn'),
                  isPhone: true,
                  enabled: true,
                  validator: (String value) {
                    if (themeColor.local == 'en') {
                      if (value.isEmpty) {
                        return getTransrlate(context, 'requiredempty');
                      } else if (value.length <= 2) {
                        return "${getTransrlate(context, 'requiredlength')}";
                      } else if (RegExp(r"^[+-]?([0-9]*[.])?[0-9]+")
                          .hasMatch(value)) {
                        return getTransrlate(context, 'invalidname');
                      }
                      return null;
                    }
                  },
                  onSaved: (String value) {
                    widget.product.nameEn = value;
                  },
                ),
                MyTextFormField(
                  intialLabel: widget.product.description.length<100? widget.product.description:widget.product.descriptionEn,
                  Keyboard_Type: TextInputType.name,
                  labelText: getTransrlate(context, 'description'),
                  hintText: getTransrlate(context, 'description'),
                  isPhone: false,
                  enabled: true,
                  validator: (String value) {
                    if (themeColor.local == 'ar') {
                      if (value.isEmpty) {
                        return getTransrlate(context, 'description');
                      } else if (value.length < 4) {
                        return getTransrlate(context, 'description');
                      }
                      _formKey.currentState.save();
                      return null;
                    }
                  },
                  onSaved: (String value) {
                    widget.product.description = value;
                  },
                ),
                MyTextFormField(
                  intialLabel: widget.product.descriptionEn ?? ' ',
                  Keyboard_Type: TextInputType.name,
                  labelText: getTransrlate(context, 'descriptionEn'),
                  hintText: getTransrlate(context, 'descriptionEn'),
                  isPhone: true,
                  enabled: true,
                  validator: (String value) {
                    if (themeColor.local == 'en') {
                      if (value.isEmpty) {
                        return getTransrlate(context, 'requiredempty');
                      } else if (value.length < 6) {
                        return getTransrlate(context, 'requiredlength');
                      }
                      _formKey.currentState.save();
                      return null;
                    }
                  },
                  onSaved: (String value) {
                    widget.product.descriptionEn = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                cartypes == null
                    ? Container(
                  child: DropdownSearch<String>(
                    showSearchBox: false,
                    showClearButton: false,
                    label: " ",
                    items: [''],
                    enabled: false,
                    //  onFind: (String filter) => getData(filter),
                  ),
                )
                    : Container(
                    child: DropdownSearch<CarType>(
                        showSearchBox: false,
                        showClearButton: false,
                        label:
                        " ${getTransrlate(context, 'CarType')}",
                        selectedItem:
                        widget.product.carType == null
                            ? CarType()
                            : widget.product.carType,
                        validator: (CarType item) {
                          if (item == null) {
                            return "${getTransrlate(context, 'Required')}";
                          } else
                            return null;
                        },
                        items: cartypes,
                        //  onFind: (String filter) => getData(filter),
                        itemAsString: (CarType u) =>
                        "${themeColor.getlocal() == 'ar' ? u.typeName ?? u.name_en : u.name_en ?? u.typeName}",
                        onChanged: (CarType data) {
                          widget.product.cartype_id =
                              data.id.toString();
                          setState(() {
                            widget.product.carType=data;
                            widget.product.carMade=null;
                            widget.product.carMadeId=null;
                            CarMades=null;
                          });
                          getAllCarMade(data.id.toString());

                        })),
                SizedBox(
                  height: 10,
                ),
                // _listCategory == null
                //     ? Container(
                //   child: DropdownSearch<String>(
                //     showSearchBox: false,
                //     showClearButton: false,
                //     label: " ",
                //     items: [''],
                //     enabled: false,
                //     //  onFind: (String filter) => getData(filter),
                //   ),
                // )
                //     : Container(
                //   child: DropdownSearch<Main_Category>(
                //       showSearchBox: false,
                //       showClearButton: false,
                //       label: "${getTransrlate(context, 'mainCategory')}",
                //       validator: (Main_Category item) {
                //         if (item == null) {
                //           return "${getTransrlate(context, 'Required')}";
                //         } else
                //           return null;
                //       },
                //       items: _listCategory,
                //       selectedItem: widget.product.maincategory == null
                //           ? Main_Category()
                //           : widget.product.maincategory,
                //       itemAsString: (Main_Category u) =>
                //       "${themeColor.getlocal() == 'ar' ? u.mainCategoryName ?? u.mainCategoryNameen : u.mainCategoryNameen ?? u.mainCategoryName}",
                //       onChanged: (Main_Category data) {
                //         setState(() {
                //           widget.product.Main_categoryid = data.id.toString();
                //           widget.product.maincategory = data;
                //           widget.product.category = null;
                //           category=[];
                //         });
                //         getAllCategory(data.id.toString());
                //         Timer(Duration(seconds: 1), () =>
                //             setState(() {
                //               category.add(data);
                //             }));
                //       }),
                //
                // ),
                SizedBox(
                  height: 5,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: category.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${getTransrlate(context, 'subCategory')} ",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: ScreenUtil.getWidth(context) /
                                1.15,
                            child: DropdownSearch<Main_Category>(
                                showSearchBox: false,
                                showClearButton: false,
                                label: " ",
                                validator: (Main_Category item) {
                                  if(category.length<2){
                                    if (item == null) {
                                      return "${getTransrlate(
                                          context, 'Required')}";
                                    }} else return null;
                                },
                                items: category[index].categories,
                                //  onFind: (String filter) => getData(filter),
                                itemAsString: (Main_Category u) =>
                                themeColor.getlocal()=='ar'?u.mainCategoryName??u.mainCategoryNameen:u.mainCategoryNameen??u.mainCategoryName,
                                onChanged: (Main_Category data) {

                                  setState(() {
                                    if(category.length>index+1){
                                      category.remove(category[index+1]);
                                      for( var i = index+1 ; i < category.length; i++ ) {
                                        category.remove(category[i]);
                                      }
                                    }

                                  });
                                  Timer(Duration(seconds: 1), () =>
                                      setState(() {
                                        category.add(data);
                                      }));
                                }),
                          ),
                        ],
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                 Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${getTransrlate(context, 'car')} :- ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    transmissions == null
                        ? DropdownSearch<String>(
                      showSearchBox: false,
                      showClearButton: false,
                      label: " ",
                      items: [''],
                      enabled: false,
                      //  onFind: (String filter) => getData(filter),
                    )
                        : Container(
                      child: DropdownSearch<Transmission>(
                          showSearchBox: false,
                          showClearButton: false,
                          label: " ${getTransrlate(context, 'transmissions')}",
                          validator: (Transmission item) {
                            if (item == null) {
                              return "${getTransrlate(context, 'Required')}";
                            } else
                              return null;
                          },
                          items: transmissions,
                          selectedItem:
                          widget.product.transmission ,
                          itemAsString: (Transmission u) =>
                          "${themeColor.getlocal() == 'ar' ? u.transmissionName ?? u.name_en : u.name_en ?? u.transmissionName}",
                          onChanged: (Transmission data) =>
                          widget.product.transmission_id = data.id.toString()
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CarMades == null
                        ? DropdownSearch<String>(
                      showSearchBox: false,
                      showClearButton: false,
                      label: " ",
                      items: [''],
                      enabled: false,
                      //  onFind: (String filter) => getData(filter),
                    )
                        : DropdownSearch<CarMade>(
                        showSearchBox: false,
                        showClearButton: false,
                        label: " ${getTransrlate(context, 'brand')}",
                        validator: (CarMade item) {
                          if (item == null) {
                            return "${getTransrlate(context, 'Required')}";
                          } else
                            return null;
                        },
                        items: CarMades,
                        selectedItem:
                        widget.product.carMade ,
                        itemAsString: (CarMade u) =>
                        "${themeColor.getlocal() == 'ar' ? u.carMade ?? u.name_en : u.name_en ?? u.carMade}",
                        onChanged: (CarMade data) {
                          widget.product.carMadeId =
                              data.id.toString();
                          setState(() {
                            widget.product.carModel=[];

                          });
                          getAllCareModel(data.id);
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${getTransrlate(context, 'models')}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.black26)),
                      child: TypeAheadField(
                        // hideOnLoading: true,
                        // hideOnEmpty: true,
                        getImmediateSuggestions: false,
                        onSuggestionSelected: (val) {
                          _onModelSelected(val);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(
                              themeColor.getlocal() == 'ar'
                                  ? suggestion.carmodel ??
                                  suggestion.name_en
                                  : suggestion.name_en ??
                                  suggestion.carmodel,
                            ),
                          );
                        },
                        suggestionsCallback: (val) {
                          return _ModelList(
                            tags: carmodels,
                            suggestion: val,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    widget.product.carModel == null
                        ? Container()
                        : _generateModels(themeColor),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        years == null
                            ? Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: DropdownSearch<String>(
                            showSearchBox: false,
                            showClearButton: false,
                            label: " ",
                            items: [''],
                            enabled: false,
                            //  onFind: (String filter) => getData(filter),
                          ),
                        )
                            : Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: DropdownSearch<Year>(
                              showSearchBox: false,
                              showClearButton: false,
                              label: " ${getTransrlate(context, 'yearfrom')}",
                              validator: (Year item) {
                                if (item == null) {
                                  return "${getTransrlate(context, 'Required')}";
                                } else
                                  return null;
                              },
                              items: years,
                              selectedItem:
                              widget.product.yearfrom ,
                              itemAsString: (Year u) =>
                              "${themeColor.getlocal() == 'ar' ? u.year ?? u.name_en : u.name_en ?? u.year}",
                              onChanged: (Year data) => widget.product.yearfromId = data.id.toString()),
                        ),
                        years == null
                            ? Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: DropdownSearch<String>(
                            showSearchBox: false,
                            showClearButton: false,
                            label: " ",
                            items: [''],
                            enabled: false,
                            //  onFind: (String filter) => getData(filter),
                          ),
                        )
                            : Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: DropdownSearch<Year>(
                              showSearchBox: false,
                              showClearButton: false,
                              label: "${getTransrlate(context, 'yearto')}",
                              validator: (Year item) {
                                if (item == null) {
                                  return "${getTransrlate(context, 'Required')}";
                                } else
                                  return null;
                              },
                              items: years,
                              selectedItem:
                              widget.product.yearto,
                              itemAsString: (Year u) =>
                              "${themeColor.getlocal() == 'ar' ? u.year ?? u.name_en : u.name_en ?? u.year}",
                              onChanged: (Year data) => widget
                                  .product
                                  .yeartoId = data.id.toString()),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                _manufacturers == null
                    ? Container(
                  width: ScreenUtil.getWidth(context) / 2.5,
                  child: DropdownSearch<String>(
                    showSearchBox: false,
                    showClearButton: false,
                    label: " ",
                    items: [''],
                    enabled: false,
                    //  onFind: (String filter) => getData(filter),
                  ),
                )
                    : Container(
                  child: DropdownSearch<Manufacturer>(
                      showSearchBox: false,
                      showClearButton: false,
                      label: " ${getTransrlate(context, 'manufacturer')}",
                      validator: (Manufacturer item) {
                        if (item == null) {
                          return "${getTransrlate(context, 'Required')}";
                        } else
                          return null;
                      },
                      items: _manufacturers,
                      selectedItem: widget.product.manufacturer == null
                          ? Manufacturer()
                          : widget.product.manufacturer,
                      itemAsString: (Manufacturer u) =>
                      "${themeColor.getlocal() == 'ar' ? u.manufacturerName ?? u.name_en : u.name_en ?? u.manufacturerName}",
                      onChanged: (Manufacturer data) => widget
                          .product.manufacturer_id = data.id.toString()),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  intialLabel: widget.product.serialNumber ?? ' ',
                  Keyboard_Type: TextInputType.number,
                  labelText: '${getTransrlate(context, 'serial')}',
                  hintText: '${getTransrlate(context, 'serial')}',
                  isPhone: true,
                  enabled: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return '${getTransrlate(context, 'serial')}';
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  onSaved: (String value) {
                    widget.product.serialNumber = value;
                  },
                ),
                Text(
                  "${getTransrlate(context, 'stock')}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                _store == null
                    ? Container(
                  child: DropdownSearch<String>(
                    showSearchBox: false,
                    showClearButton: false,
                    label: " ",
                    items: [''],
                    enabled: false,
                    //  onFind: (String filter) => getData(filter),
                  ),
                )
                    : Container(
                  child: DropdownSearch<Store>(
                      showSearchBox: false,
                      showClearButton: false,
                      validator: (Store item) {
                        if (item == null) {
                          return "${getTransrlate(context, 'Required')}";
                        } else
                          return null;
                      },
                      items: _store,
                      selectedItem: widget.product.store == null
                          ? Store()
                          : widget.product.store,
                      itemAsString: (Store u) => u.nameStore ?? '',
                      onChanged: (Store data) =>
                      widget.product.storeId = data.id.toString()),
                ),
                Text(
                  "${getTransrlate(context, 'productType')}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                _ProductType == null
                    ? Container(
                  child: DropdownSearch<String>(
                    showSearchBox: false,
                    showClearButton: false,
                    label: " ",
                    items: [''],
                    enabled: false,
                    //  onFind: (String filter) => getData(filter),
                  ),
                )
                    : Container(
                  child: DropdownSearch<ProductType>(
                      showSearchBox: false,
                      showClearButton: false,
                      validator: (ProductType item) {
                        if (item == null) {
                          return "${getTransrlate(context, 'Required')}";
                        } else
                          return null;
                      },
                      items: _ProductType,
                      // enabled: false,
                      selectedItem:
                      widget.product.producttypeId ?? ProductType(),
                      // onFind: (String filter) => getData(filter),
                      itemAsString: (ProductType u) =>
                      "${themeColor.getlocal() == 'ar' ? u.producttype ?? u.name_en : u.name_en ?? u.producttype}",
                      onChanged: (ProductType data) {
                        setState(() {
                          widget.product.productType_id =
                              data.id.toString();
                        });
                      }),
                ),
                widget.product.productType_id == "1"
                    ? Column(
                  children: [
                    MyTextFormField(
                      intialLabel: widget.product.price ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText: '${getTransrlate(context, 'price')}',
                      hintText: '${getTransrlate(context, 'price')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'price')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onChanged: (String value) {
                        widget.product.price = value;
                      },
                      onSaved: (String value) {
                        widget.product.price = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: widget.product.quantity ?? '',
                      Keyboard_Type: TextInputType.number,
                      labelText: "${getTransrlate(context, 'quantity')}",
                      hintText: '${getTransrlate(context, 'quantity')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'quantity')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.quantity = value;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: MyTextFormField(
                            intialLabel: widget.product.discount,
                            Keyboard_Type: TextInputType.number,
                            labelText:
                            "${getTransrlate(context, 'Percentage')}",
                            hintText:
                            '${getTransrlate(context, 'Percentage')}',
                            isPhone: true,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(2),
                            ],
                            enabled: true,
                            validator: (String value) {
                              _formKey.currentState.save();
                              return null;
                            },
                            onSaved: (String value) {
                              widget.product.discount = value;
                            },
                            onChanged: (String value) {
                              widget.product.discount = value;
                              if (value != null) {
                                if (value.isNotEmpty) {
                                  if (widget.product.price != null) {
                                    if (widget.product.price.isNotEmpty) {
                                      totaldiscount.text =
                                      "${(double.parse(value) / 100) * double.parse(widget.product.price)}";
                                      print(totaldiscount.text);
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: MyTextFormField(
                            textEditingController: totaldiscount,
                            Keyboard_Type: TextInputType.number,
                            labelText:
                            "${getTransrlate(context, 'totaldiscount')}",
                            hintText:
                            '${getTransrlate(context, 'totaldiscount')}',
                            isPhone: true,
                            enabled: true,
                            validator: (String value) {
                              _formKey.currentState.save();
                              return null;
                            },
                            onSaved: (String value) {},
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor:Colors.orange ,
                          //fillColor:Colors.orange,
                          value: isqty_reminder,
                          onChanged: (bool value) {
                            setState(() {
                              isqty_reminder = value;

                            });
                          },
                        ),
                         Text("${getTransrlate(context, 'reminder')}"),
                      ],
                    ),
                    !isqty_reminder?Container():  MyTextFormField(
                      intialLabel: widget.product.qty_reminder ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText: " ${getTransrlate(context, 'qty_reminder')} ",
                      hintText: '${getTransrlate(context, 'qty_reminder')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'qty_reminder')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.qty_reminder = value;
                      },
                    ),

                  ],
                )
                    : widget.product.productType_id == "2"
                    ? Column(
                  children: [
                    MyTextFormField(
                      intialLabel: widget.product.holesalePrice ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText:
                      '${getTransrlate(context, 'Wholesaleprice')}',
                      hintText:
                      '${getTransrlate(context, 'Wholesaleprice')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'Wholesaleprice')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.holesalePrice = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: widget.product.noOfOrders ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText:
                      "${getTransrlate(context, 'minOfOrder')} ",
                      hintText:
                      '${getTransrlate(context, 'minOfOrder')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'minOfOrder')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.noOfOrders = value;
                      },
                    ),
                  ],
                )
                    : Column(
                  children: [
                    MyTextFormField(
                      intialLabel: widget.product.price ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText: '${getTransrlate(context, 'price')}',
                      hintText: '${getTransrlate(context, 'price')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'price')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.price = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: widget.product.quantity ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText:
                      "${getTransrlate(context, 'quantity')}",
                      hintText:
                      '${getTransrlate(context, 'quantity')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'quantity')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.quantity = value;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: MyTextFormField(
                            intialLabel: widget.product.discount,
                            Keyboard_Type: TextInputType.number,
                            labelText:
                            "${getTransrlate(context, 'Percentage')}",
                            hintText:
                            '${getTransrlate(context, 'Percentage')}',
                            isPhone: true,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(2),
                            ],
                            enabled: true,
                            validator: (String value) {
                              _formKey.currentState.save();
                              return null;
                            },
                            onSaved: (String value) {
                              widget.product.discount = value;
                            },
                            onChanged: (String value) {
                              widget.product.discount = value;
                              if (value != null) {
                                if (value.isNotEmpty) {
                                  if (widget.product.price != null) {
                                    if (widget.product.price.isNotEmpty) {
                                      totaldiscount.text =
                                      "${(double.parse(value) / 100) * double.parse(widget.product.price)}";
                                      print(totaldiscount.text);
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: MyTextFormField(
                            textEditingController: totaldiscount,
                            Keyboard_Type: TextInputType.number,
                            labelText:
                            "${getTransrlate(context, 'totaldiscount')}",
                            hintText:
                            '${getTransrlate(context, 'totaldiscount')}',
                            isPhone: true,
                            enabled: true,
                            validator: (String value) {
                              _formKey.currentState.save();
                              return null;
                            },
                            onSaved: (String value) {},
                          ),
                        ),
                      ],
                    ),
                    MyTextFormField(
                      intialLabel: widget.product.holesalePrice ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText:
                      '${getTransrlate(context, 'Wholesaleprice')}',
                      hintText:
                      '${getTransrlate(context, 'Wholesaleprice')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'Wholesaleprice')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.holesalePrice = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: widget.product.noOfOrders ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText:
                      "${getTransrlate(context, 'minOfOrder')}",
                      hintText:
                      ' ${getTransrlate(context, 'minOfOrder')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'minOfOrder')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.noOfOrders = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: widget.product.qty_reminder ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText: " ${getTransrlate(context, 'qty_reminder')} ",
                      hintText: '${getTransrlate(context, 'qty_reminder')}',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '${getTransrlate(context, 'qty_reminder')}';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        widget.product.qty_reminder = value;
                      },
                    ),

                  ],
                ),
                Text(
                  "${getTransrlate(context, 'prodcountry')}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                _prodcountries == null
                    ? Container()
                    : Container(
                  child: DropdownSearch<ProdCountry>(
                      showSearchBox: false,
                      showClearButton: false,
                      validator: (ProdCountry item) {
                        if (item == null) {
                          return "${getTransrlate(context, 'Required')}";
                        } else
                          return null;
                      },
                      items: _prodcountries,
                      selectedItem: widget.product.prodCountry == null
                          ? ProdCountry()
                          : widget.product.prodCountry,
                      itemAsString: (ProdCountry u) =>
                      "${themeColor.getlocal() == 'ar' ? u.countryName ?? u.name_en : u.name_en ?? u.countryName}",
                      onChanged: (ProdCountry data) => widget
                          .product.prodcountry_id = data.id.toString()),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${getTransrlate(context, 'tags')}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                _generateTags(themeColor),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black26)),
                  child: TypeAheadField(
                    // hideOnLoading: true,
                    // hideOnEmpty: true,
                    getImmediateSuggestions: false,
                    onSuggestionSelected: (val) {
                      _onSuggestionSelected(val);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(
                          themeColor.getlocal() == 'ar'
                              ? suggestion.name ?? suggestion.name_en
                              : suggestion.name_en ?? suggestion.name,
                        ),
                      );
                    },
                    suggestionsCallback: (val) {
                      return _sugestionList(
                        tags: _tags,
                        suggestion: val,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${getTransrlate(context, 'productimage')}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                images.isEmpty
                    ? Container()
                    : GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: List.generate(images.length, (index) {
                    Asset asset = images[index];

                    return Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.black26)),
                      child: Stack(
                        children: [
                          AssetThumb(
                            asset: asset,
                            width: 500,
                            height: 400,
                          ),
                          Positioned(
                            left: 5,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  images.remove(asset);
                                });
                              },
                              child: Container(
                                color: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/Trash.svg',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 5,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${index + 1}'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                widget.product.photo.isEmpty
                    ? Container()
                    : GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children:
                  List.generate(widget.product.photo.length, (index) {
                    PhotoProduct asset = widget.product.photo[index];
                    return Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.black26)),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: asset.image,
                            width: 500,
                            height: 400,
                          ),
                          Positioned(
                            left: 5,
                            child: InkWell(
                              onTap: () {
                                if (widget.product.photo.length != 1) {
                                  API(context).post(
                                      'products/remove/checked/media', {
                                    'product_id': widget.product.id,
                                    'media_ids': "[${asset.id}]",
                                  }).then((value) {
                                    if (value['status_code'] == 200) {
                                      setState(() {
                                        widget.product.photo
                                            .remove(asset);
                                      });
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                        '${value['message'] ?? value['errors']}',
                                      ),
                                    );
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      '${getTransrlate(context, 'NotDelete')}',
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                color: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/Trash.svg',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: Radio(
                                value: index,
                                activeColor: Colors.orange,
                                groupValue: CheckBox,
                                onChanged: (index) {
                                  API(context).post(
                                      'mark/default/media', {
                                    "media_id":
                                    widget.product.photo[index].id,
                                    "product_id": widget.product.id
                                  }).then((value) {
                                    if (value != null) {
                                      if (value['status_code'] == 200) {
                                        setState(() {
                                          CheckBox = index;
                                        });
                                      }
                                      showDialog(
                                        context: context,
                                        builder: (_) => ResultOverlay(
                                          value['message'] ??
                                              '${getTransrlate(context, 'Done')}',
                                        ),
                                      );
                                    }
                                  });
                                }),
                          )
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                        side: BorderSide(color: Colors.orange, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.orange,
                          ),
                          Text(
                            '${getTransrlate(context, 'add')}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      getImages();
                    }),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      loading?FlatButton(
                        minWidth: ScreenUtil.getWidth(context) / 2.5,
                        color: Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:Container(
                            height: 30,
                            child: Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>( Colors.white),
                                )),
                          ),
                        ),
                        onPressed: () async {
                        },
                      ): FlatButton(
                        minWidth: ScreenUtil.getWidth(context) / 2.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                            side: BorderSide(color: Colors.orange, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTransrlate(context, "save"),
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            widget.product.qty_reminder=isqty_reminder?widget.product.qty_reminder:'1';
                            print(widget.product.toJson());
                            widget.product.allcategory_id=category.map((e) => e.id).toList().toString();

                            if (widget.product.photo.isNotEmpty ||
                                images.isNotEmpty) {
                              setState(() => loading = true);

                              API(context)
                                  .postFile("products/${widget.product.id}",
                                  widget.product.toJson(),
                                  attachment: images)
                                  .then((value) {

                                setState(() {
                                  loading = false;
                                });
                                    print("value= $value");
                                if (value != null) {

                                  if (value['status_code']!=200) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                        "${value['errors']??value['message']}",
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                    Provider.of<Provider_Data>(context,
                                        listen: false)
                                        .getProducts(context,"products");
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                          '${value['message']}'),
                                    );
                                  }
                                }
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => ResultOverlay(
                                  "${getTransrlate(context,'Selectimage')}",
                                ),
                              );
                            }
                          }
                        },
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getAllCarMade(String id) async {
    API(context).get('cartype/madeslist/$id').then((value) {
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
    });
  }

  Future<void> getAllParts_Category(int id) async {
    API(context).get('part-categorieslist/$id').then((value) {
      if (value != null) {
        setState(() {
          part_Categories = Parts_Category.fromJson(value).data;
        });
      }
    });
  }

  Future<void> getAllMain_category() async {
    API(context).get('allcategories').then((value) {
      if (value != null) {
        setState(() {
          _listCategory = Main_category.fromJson(value).data;
        });
      }
    });
  }

  Future<void> getAllproducttypes() async {
    API(context).get('product/types/list').then((value) {
      if (value != null) {
        setState(() {
          _ProductType = ProductTypeModel.fromJson(value).data;
          //widget.product.productType_id = _ProductType[0].id.toString();
        });
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
  }

  Future<void> getAllStore() async {
    API(context).get('storeslist').then((value) {
      if (value != null) {
        setState(() {
          _store = Store_model.fromJson(value).data;
        });
      }
    });
  }

  Future<void> getAllCategory(String id) async {
    API(context).get('categorieslist/$id').then((value) {
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


  _generateModels(Provider_control themeColor) {
    return widget.product.carModel.isEmpty
        ? Container()
        : Container(
            alignment: Alignment.topLeft,
            child: Tags(
              alignment: WrapAlignment.center,
              itemCount: widget.product.carModel.length,
              itemBuilder: (index) {
                return ItemTags(
                  index: index,
                  title: themeColor.getlocal() == 'ar'
                      ? widget.product.carModel[index].carmodel ??
                          widget.product.carModel[index].name_en
                      : widget.product.carModel[index].name_en ??
                          widget.product.carModel[index].carmodel,
                  color: Colors.orange.shade400,
                  activeColor: Colors.orange.shade400,

                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  elevation: 0.0,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                textColor: ,
                  textColor: Colors.white,
                  textActiveColor: Colors.white,
                  removeButton: ItemTagsRemoveButton(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                      size: 18,
                      onRemoved: () {
                        _onModelRemoved(widget.product.carModel[index]);
                        return true;
                      }),
                  textOverflow: TextOverflow.ellipsis,
                );
              },
            ),
          );
  }
  _generateTags(Provider_control themeColor) {
    return widget.product.tags.isEmpty
        ? Container()
        : Container(
      alignment: Alignment.topLeft,
      child: Tags(
        alignment: WrapAlignment.center,
        itemCount: widget.product.tags.length,
        itemBuilder: (index) {
          return ItemTags(
            index: index,
            title: themeColor.getlocal() == 'ar'
                ? widget.product.tags[index].name ??
                widget.product.tags[index].name_en
                : widget.product.tags[index].name_en ??
                widget.product.tags[index].name,
            color: Colors.black26,
            activeColor: Colors.black26,

            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            elevation: 0.0,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                textColor: ,
            textColor: Colors.white,
            textActiveColor: Colors.white,
            removeButton: ItemTagsRemoveButton(
                color: Colors.white,
                backgroundColor: Colors.transparent,
                size: 18,
                onRemoved: () {
                  _onSuggestionRemoved(widget.product.tags[index]);
                  return true;
                }),
            textOverflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }

  _onSuggestionSelected(Tag value) {
    if (value != null) {
      setState(() {
        widget.product.tags.add(value);
        _tags.remove(value);
      });
    }
  }

  _onSuggestionRemoved(Tag value) {
    // final Tag exist =
    //     _tags.firstWhere((text) => text.name == value, orElse: () {
    //   return null;
    // });
    if (value != null) {
      setState(() {
        widget.product.tags.remove(value);
        _tags.add(value);
      });
    }
  }

  _sugestionList({@required List<Tag> tags, @required String suggestion}) {
    List<Tag> modifiedList = [];
    modifiedList.addAll(tags);
    modifiedList.retainWhere(
        (text) => text.name.toLowerCase().contains(suggestion.toLowerCase()));
    if (suggestion.length >= 0) {
      return modifiedList;
    } else {
      return null;
    }
  }

  _onModelSelected(Carmodel value) {
    if (value != null) {
      setState(() {
        widget.product.carModel.add(value);
        carmodels.remove(value);
      });
    }
  }

  _onModelRemoved(Carmodel value) {


    if (value != null) {
      setState(() {
        widget.product.carModel.remove(value);
        carmodels.add(value);
      });
    }
  }

  _ModelList({@required List<Carmodel> tags, @required String suggestion}) {
    List<Carmodel> modifiedList = [];
    modifiedList.addAll(tags);
    modifiedList.retainWhere((text) =>
        text.carmodel.toLowerCase().contains(suggestion.toLowerCase()));
    if (suggestion.length >= 0) {
      return modifiedList;
    } else {
      return null;
    }
  }
}
