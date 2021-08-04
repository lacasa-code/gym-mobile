import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

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
  List<Tag> _tagSelect = [];
  List<Categories> _category;
  List<String> categories;
  List<Part_Category> part_Categories;
  List<Carmodel> filteredcarmodels_data = List();
  List<CarMade> filteredCarMades_data = List();
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
    getAllType();
    getAllMain_category();
    getAllStore();
    getAllYear();
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
                builder: (_) => SearchOverlay(
                  url: 'products/search/dynamic',
                ),
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
                        onChanged: (CarType data) {
                          product.cartype_id = data.id.toString();
                          getAllCarMade(data.id.toString());
                        })
                ),
                SizedBox(
                  height: 10,
                ),
                _listCategory == null
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
                        child: DropdownSearch<Main_Category>(
                            showSearchBox: false,
                            showClearButton: false,
                            label: "الفئة الرئيسية",
                            validator: (Main_Category item) {
                              if (item == null) {
                                return "Required field";
                              } else
                                return null;
                            },
                            items: _listCategory,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (Main_Category u) =>
                                u.mainCategoryName,
                            onChanged: (Main_Category data) {
                                product.Main_categoryid = data.id.toString();
                                setState(() {
                                  _category=null;
                                });
                                getAllCategory(data.id);}),
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
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _category == null
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
                                child: DropdownSearch<Categories>(
                                    showSearchBox: false,
                                    showClearButton: false,
                                    label: " ",
                                    validator: (Categories item) {
                                      if (item == null) {
                                        return "Required field";
                                      } else
                                        return null;
                                    },
                                    items: _category,
                                    //  onFind: (String filter) => getData(filter),
                                    itemAsString: (Categories u) => u.name,
                                    onChanged: (Categories data) {
                                    product.CategoryId = data.id.toString();
                                    setState(() {
                                      part_Categories=null;
                                    });
                                    getAllParts_Category( data.id);
                                    }),
                              ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "الفئة الفرعية",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        part_Categories == null
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
                                    itemAsString: (Part_Category u) =>
                                        u.categoryName,
                                    onChanged: (Part_Category data) => product
                                        .partCategoryId = data.id.toString()),
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
                                itemAsString: (Transmission u) =>
                                    u.transmissionName,
                                onChanged: (Transmission data) => product
                                    .transmission_id = data.id.toString()),
                          ),
                    CarMades == null
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
                                  product.carMadeId = data.id.toString();
                                  getAllCareModel(data.id);
                                }),
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
                                    product.carModelId = data.id.toString()),
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
                                    product.yearId = data.id.toString()),
                          ),
                  ],
                ),

                SizedBox(
                  height: 10,
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
                            label: " المصنع",
                            validator: (Manufacturer item) {
                              if (item == null) {
                                return "Required field";
                              } else
                                return null;
                            },
                            items: _manufacturers,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (Manufacturer u) =>
                                u.manufacturerName,
                            onChanged: (Manufacturer data) =>
                                product.manufacturer_id = data.id.toString()),
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
                    } else if (value.length < 6) {
                      return getTransrlate(context, 'description');
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  onSaved: (String value) {
                    product.description = value;
                  },
                ),
                MyTextFormField(
                  intialLabel: product.serialNumber ?? ' ',
                  Keyboard_Type: TextInputType.number,
                  labelText: 'الرقم التسلسلي',
                  hintText: 'الرقم التسلسلي',
                  isPhone: true,
                  enabled: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'الرقم التسلسلي';
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  onSaved: (String value) {
                    product.serialNumber = value;
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
                                return "Required field";
                              } else
                                return null;
                            },
                            items: _store,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (Store u) => u.name,
                            onChanged: (Store data) =>
                                product.storeId = data.id.toString()),
                      ),
                Text(
                  "نوع المنتج",
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
                                return "Required field";
                              } else
                                return null;
                            },
                            items: _ProductType,
                            selectedItem: _ProductType[0],
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (ProductType u) => u.producttype,
                            onChanged: (ProductType data) {
                              setState(() {
                                product.productType_id = data.id.toString();

                              });
                            }),
                      ),
                product.productType_id == "1"
                    ? Column(
                        children: [
                          MyTextFormField(
                            intialLabel: product.price ?? ' ',
                            Keyboard_Type: TextInputType.number,
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
                            intialLabel: ' ',
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
                              product.quantity = value;
                            },
                          ),
                          MyTextFormField(
                            intialLabel: ' ',
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
                        ],
                      )
                    :product.productType_id == "2"
                    ? Column(
                        children: [
                          MyTextFormField(
                            intialLabel: product.price ?? ' ',
                            Keyboard_Type: TextInputType.number,
                            labelText: 'سعر الجملة',
                            hintText: 'سعر الجملة',
                            isPhone: true,
                            enabled: true,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'سعر الجملة';
                              }
                              _formKey.currentState.save();
                              return null;
                            },
                            onSaved: (String value) {
                              product.wholesale = value;
                            },
                          ),
                          MyTextFormField(
                            intialLabel: ' ',
                            Keyboard_Type: TextInputType.number,
                            labelText: "الحد الادنى للطلب ",
                            hintText: 'الحد الادنى للطلب',
                            isPhone: true,
                            enabled: true,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'الحد الادنى للطلب';
                              }
                              _formKey.currentState.save();
                              return null;
                            },
                            onSaved: (String value) {
                              product.minOfOrder = value;
                            },
                          ),
                        ],
                      ):Column(
                  children: [
                    MyTextFormField(
                      intialLabel: product.price ?? ' ',
                      Keyboard_Type: TextInputType.number,
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
                      intialLabel: ' ',
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
                        product.quantity = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: ' ',
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
                    MyTextFormField(
                      intialLabel: product.price ?? ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText: 'سعر الجملة',
                      hintText: 'سعر الجملة',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'سعر الجملة';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        product.wholesale = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: ' ',
                      Keyboard_Type: TextInputType.number,
                      labelText: "الحد الادنى للطلب جملة",
                      hintText: ' الحد الادنى للطلب جملة',
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'الحد الادنى للطلب';
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        product.minOfOrder = value;
                      },
                    ),
                  ],
                ),
                MyTextFormField(
                  intialLabel: ' ',
                  Keyboard_Type: TextInputType.number,
                  labelText: "تنبيه الكمية ",
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
                    product.qty_reminder = value;
                  },
                ),
                Text(
                  "بلد المنشأ",
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
                                return "Required field";
                              } else
                                return null;
                            },
                            items: _prodcountries,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (ProdCountry u) => u.countryName,
                            onChanged: (ProdCountry data) =>
                                product.prodcountry_id = data.id.toString()),
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "الكلمات المفتاحية",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                _generateTags(),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black26)),
                  child: TypeAheadField(
                    hideOnLoading: true,
                    hideOnEmpty: true,
                    getImmediateSuggestions: false,
                    onSuggestionSelected: (val) {
                      _onSuggestionSelected(val);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.name,
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
                  "صور المنتج",
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
                            'إضافة',
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
                      FlatButton(
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
                            product.tags = _tagSelect;
                            product.photos = images;
                            setState(() => loading = true);
                            print(product.toJson());

                            API(context)
                                .postFile("add/products", product.toJson(),
                                    attachment: images)
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
    API(context).get('main/categories/list/all').then((value) {
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
          product.productType_id = _ProductType[0].id.toString();
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

  Future<void> getAllCategory(int id) async {
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
    getAllproducttypes();
  }

  _generateTags() {
    return _tagSelect.isEmpty
        ? Container()
        : Container(
            alignment: Alignment.topLeft,
            child: Tags(
              alignment: WrapAlignment.center,
              itemCount: _tagSelect.length,
              itemBuilder: (index) {
                return ItemTags(
                  index: index,
                  title: _tagSelect[index].name,
                  color: Colors.blue,
                  activeColor: Colors.black26,
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
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                      size: 18,
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
    if (value != null) {
      setState(() {
        _tagSelect.add(value);
        _tags.remove(value);
      });
    }
  }

  _onSuggestionRemoved(Tag value) {
    final Tag exist =
        _tags.firstWhere((text) => text.name == value, orElse: () {
      return null;
    });

    if (value != null) {
      setState(() {
        _tagSelect.remove(value);
        _tags.add(exist);
      });
    }
  }

  _sugestionList({@required List<Tag> tags, @required String suggestion}) {
    List<Tag> modifiedList = [];
    modifiedList.addAll(tags);
    modifiedList.retainWhere(
        (text) => text.name.toLowerCase().contains(suggestion.toLowerCase()));
    if (suggestion.length >= 2) {
      return modifiedList;
    } else {
      return null;
    }
  }
}
