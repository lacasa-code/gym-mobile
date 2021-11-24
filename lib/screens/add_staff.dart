import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/roles_model.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/find_dropdown.dart';
import 'package:trkar_vendor/widget/custom_loading.dart';
import 'package:trkar_vendor/widget/no_found_item.dart';

class add_Staff extends StatefulWidget {
  @override
  _add_StaffState createState() => _add_StaffState();
}

class _add_StaffState extends State<add_Staff> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  List<Role> roles;
  List<Store> listStore;
  List<Store> _listStore;
  bool passwordVisible = false;
  User user = User();

  @override
  void initState() {
    getRoles();
    getAllStore();
    user.stores=[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    final data = Provider.of<Provider_Data>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/staff.svg',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'staff')),
          ],
        ),
        backgroundColor: themeColor.getColor(),
      ),
      body: listStore==null?Custom_Loading():listStore.isEmpty?NotFoundItem(title: '${getTransrlate(context, 'messagestaff')}',) :
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  border: Border.all(color: Colors.black12, width: 1)),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${getTransrlate(context, 'AddNewUser')}'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextFormField(
                      intialLabel: user.name ?? ' ',
                      Keyboard_Type: TextInputType.name,
                         labelText: getTransrlate(context, 'title'),inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      hintText: getTransrlate(context, 'title'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'requiredempty');
                        }else   if (value.length<2) {
                          return "${getTransrlate(context, 'requiredlength')}";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        user.name = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: user.email ?? ' ',
                      Keyboard_Type: TextInputType.emailAddress,
                      labelText: getTransrlate(context, 'Email'),
                      hintText: getTransrlate(context, 'Email'),
                      isPhone: true,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'mail');
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                            .hasMatch(value)) {
                          return getTransrlate(context, 'invalidemail');
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        user.email = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${getTransrlate(context, 'role')}",style: TextStyle(color: Colors.black,fontSize: 16),),
                    SizedBox(
                      height: 10,
                    ),
                    roles == null
                        ? Container()
                        : DropdownSearch<Role>(
                            showSearchBox: false,
                            showClearButton: false,
                            maxHeight: ScreenUtil.getHeight(context)/3,
                            label: "   ",
                            validator: (Role item) {
                              if (item == null) {
                                return "${getTransrlate(context, 'Required')}";
                              } else
                                return null;
                            },
                            items: roles,
                            //  onFind: (String filter) => getData(filter),
                            itemAsString: (Role u) =>
                            themeColor.getlocal()=='ar'?u.title??u.name_en:u.name_en??u.title,
                            onChanged: (Role data) =>
                                user.rolesid = data.id.toString()),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${getTransrlate(context, 'stores')}",style: TextStyle(color: Colors.black,fontSize: 16),),
                    SizedBox(
                      height: 10,
                    ),
                    _listStore == null
                        ? Container()
                        : _generateStores(themeColor),
                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.black26)),
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
                              suggestion.nameStore,
                            ),
                          );
                        },
                        suggestionsCallback: (val) {
                          return _sugestionList(
                            Stores:   _listStore,
                            suggestion: val,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                  ],
                ),
              ),
            ),
            Container(
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      loading?FlatButton(
                        minWidth: ScreenUtil.getWidth(context) / 2.5,
                        color: Colors.blue,
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
                              side: BorderSide(
                                  color: Colors.blue, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              getTransrlate(context, 'save'),
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() => loading = true);
                              API(context).post("vendor/add/staff", {
                                "stores": user.storeid,
                                "email": user.email,
                                "password": user.password,
                                "role": user.rolesid,
                                "stores": user.stores.map((e) => e.id).toList().toString()
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
                                    data.getAllstaff(context,'users');
                                    data.getAllStore(context,'stores');
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                        value['message'].toString(),
                                      ),
                                    );
                                  }
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
            ),

          ],
        ),
      ),
    );
  }

  Future<void> getRoles() async {
    API(context).get('roleslist').then((value) {
      if (value != null) {
        setState(() {
          roles = Roles_model.fromJson(value).data;
        });
      }
    });
  }
  Future<void> getAllStore() async {
    API(context).get('storeslist').then((value) {
      if (value != null) {
        setState(() {
          _listStore= Store_model.fromJson(value).data;
          listStore= Store_model.fromJson(value).data;
        });
      }
    });
  }
  _generateStores(Provider_control themeColor) {
    return user.stores==null
        ? Container()
        : Container(
      alignment: Alignment.topLeft,
      child: Tags(
        alignment: WrapAlignment.center,
        itemCount: user.stores.length,
        itemBuilder: (index) {
          return ItemTags(
            index: index,
            title:  user.stores[index].nameStore,
            color: Colors.blue,
            activeColor: Colors.blue,
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
                  _onSuggestionRemoved(user.stores[index]);
                  return true;
                }),
            textOverflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
  _onSuggestionSelected(Store value) {
    if (value != null) {
      setState(() {
        user.stores.add(value);
        _listStore.remove(value);
      });
    }
  }
  _onSuggestionRemoved(Store value) {
    // final Store exist =
    //     _Stores.firstWhere((text) => text.name == value, orElse: () {
    //   return null;
    // });
    if (value != null) {
      setState(() {
        user.stores.remove(value);
        _listStore.add(value);
      });
    }
  }
  _sugestionList({@required List<Store> Stores, @required String suggestion}) {
    List<Store> modifiedList = [];
    modifiedList.addAll(Stores);
    modifiedList.retainWhere(
            (text) => text.nameStore.toLowerCase().contains(suggestion.toLowerCase()));

    return Stores;

  }
}
