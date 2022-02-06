import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

class LostPassword extends StatefulWidget {
  const LostPassword({Key key}) : super(key: key);

  @override
  _LostPasswordState createState() => _LostPasswordState();
}

class _LostPasswordState extends State<LostPassword> {
  final _formKey = GlobalKey<FormState>();
String email;
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      backgroundColor: themeColor.getColor(),
        appBar: AppBar(),
      body: Form(
       key: _formKey,
       child: SingleChildScrollView(
         child: Padding(
           padding:  EdgeInsets.all(ScreenUtil.getWidth(context)/10),
           child: Column(
             children: [
               SvgPicture.asset(
                 'assets/images/trkar_logo_white.svg',
               ),
               MyTextFormField(
                 intialLabel: '',
                 Keyboard_Type: TextInputType.emailAddress,
                 labelText: getTransrlate(context, 'mail'),
                 isPhone: true,
                 validator: (String value) {
                   if (value.isEmpty) {
                     return getTransrlate(context, 'mail');
                   }
                   _formKey.currentState.save();
                   return null;
                 },
                 textStyle: TextStyle(color: Colors.white),
                 onSaved: (String value) {
                   email=value;
                 },
               ),
               SizedBox(height: 25 ),
               Center(
                 child:_isLoading?FlatButton(
                   minWidth: ScreenUtil.getWidth(context) / 2.5,
                   color:  Colors.black,
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
                 ): GestureDetector(
                   child: Container(
                     width: ScreenUtil.getWidth(context) / 1.2,
                     padding: const EdgeInsets.all(5.0),
                     decoration: BoxDecoration( color: Colors.black,border: Border.all(color:  Colors.black)),
                     child: Center(
                       child: AutoSizeText(
                         getTransrlate(context, 'changePassword'),
                         overflow: TextOverflow.ellipsis,
                         maxFontSize: 14,
                         maxLines: 1,
                         minFontSize: 10,
                         style:
                         TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                       ),
                     ),
                   ),
                   onTap: () {
                     if (_formKey.currentState.validate()) {
                       _formKey.currentState.save();
                       setState(() => _isLoading = true);

                       API(context).post('user/forget/password',
                           {"email": email}).then((value) {
                         setState(() => _isLoading = false);

                         if (value != null) {
                           if (value.containsKey('error')) {
                             showDialog(
                                 context: context,
                                 builder: (_) =>
                                     ResultOverlay(value['error']));
                           } else {
                             showDialog(
                                 context: context,
                                 builder: (_) =>
                                     ResultOverlay(value['data']));
                           }
                         }
                       });
                     }
                   },
                 ),
               ),
               SizedBox(height: 25 ),
             ],
           ),
         ),
       ),
     ),);
  }
}
