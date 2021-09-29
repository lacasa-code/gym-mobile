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

class EditStaff extends StatefulWidget {
  EditStaff(this.user);

  User user;

  @override
  _EditStaffState createState() => _EditStaffState();
}

class _EditStaffState extends State<EditStaff> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  List<Role> roles;
  bool passwordVisible = false;
  List<Store> _listStore;

  @override
  void initState() {
    getRoles();
    getStore();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Container(
                  height: ScreenUtil.getHeight(context) / 1.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextFormField(
                        intialLabel: widget.user.name ?? ' ',
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
                          } else if (value.length <= 2) {
                            return "${getTransrlate(context, 'requiredlength')}";
                          } else if (RegExp(r"^[+-]?([0-9]*[.])?[0-9]+")
                              .hasMatch(value)) {
                            return getTransrlate(context, 'invalidname');
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          widget.user.name = value;
                        },
                      ),
                      MyTextFormField(
                        intialLabel: widget.user.email ?? ' ',
                        Keyboard_Type: TextInputType.emailAddress,
                        labelText: getTransrlate(context, 'Email'),
                        hintText: getTransrlate(context, 'Email'),
                        isPhone: true,
                        enabled: false,
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
                        // onSaved: (String value) {
                        //   widget.user.email = value;
                        // },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${getTransrlate(context, 'role')}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      roles == null
                          ? Container()
                          : DropdownSearch<Role>(
                              maxHeight: ScreenUtil.getWidth(context) / 3,
                              showSearchBox: false,
                              showClearButton: false,
                              selectedItem: widget.user.roles,
                              label: "   ",
                              validator: (Role item) {
                                if (item == null) {
                                  return "Required field";
                                } else
                                  return null;
                              },
                              items: roles,
                              //  onFind: (String filter) => getData(filter),
                              itemAsString: (Role u) => u.title,
                              onChanged: (Role data) =>
                                  widget.user.rolesid = data.id.toString()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${getTransrlate(context, 'stores')}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
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
                              title: Text( suggestion.nameStore
                              ),
                            );
                          },
                          suggestionsCallback: (val) {
                            return _sugestionList(
                              Stores:  _listStore,
                              suggestion: val,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
                    ):   FlatButton(
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
                            print("users/${widget.user.id}");
                            API(context).Put("users/${widget.user.id}", {
                              "name": widget.user.name,
                              "email": widget.user.email,
                              "roles": widget.user.rolesid??widget.user.roles.id,
                              "stores": widget.user.stores!=null? widget.user.stores.isNotEmpty?widget.user.stores.map((e) => e.id).toList().toString():"":""
                            }).then((value) {
                              if (value != null) {
                                setState(() {
                                  loading = false;
                                });
                                print(value.containsKey('errors'));
                                if (value['status_code']!=200) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      "${value['message']??value['errors']}",
                                    ),
                                  );
                                } else {
                                  data.getAllstaff(context,'users');
                                  data.getAllStore(context,'stores');
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      '${value['message']??value['errors']}',
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
  _generateStores(Provider_control themeColor) {
    return widget.user.stores.isEmpty
        ? Container()
        : Container(
      alignment: Alignment.topLeft,
      child: Tags(
        alignment: WrapAlignment.center,
        itemCount: widget.user.stores.length,
        itemBuilder: (index) {
          return ItemTags(
            index: index,
            title:  widget.user.stores[index].nameStore,
            color: Colors.orange,
            activeColor: Colors.orange,
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
                  _onSuggestionRemoved(widget.user.stores[index]);
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
        widget.user.stores.add(value);
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
        widget.user.stores.remove(value);
        _listStore.add(value);
      });
    }
  }

  _sugestionList({@required List<Store> Stores, @required String suggestion}) {
    List<Store> modifiedList = [];
    modifiedList.addAll(Stores);
    modifiedList.retainWhere(
            (text) => text.nameStore.toLowerCase().contains(suggestion.toLowerCase()));
    if (suggestion.length >= 0) {
      return modifiedList;
    } else {
      return null;
    }
  }

  void getStore() {
    API(context).get('storeslist').then((value) {
      if (value != null) {
        setState(() {
          _listStore= Store_model.fromJson(value).data;
        });
        widget.user.stores.forEach((element) {
          setState(() {
            _listStore.remove(_listStore.where((e) => element.id==e.id).first);
          });
        });
      }
    });
  }
}
