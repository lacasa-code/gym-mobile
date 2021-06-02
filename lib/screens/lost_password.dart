import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

class LostPassword extends StatefulWidget {
  const LostPassword({Key key}) : super(key: key);

  @override
  _LostPasswordState createState() => _LostPasswordState();
}

class _LostPasswordState extends State<LostPassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Image.asset("assets/images/logo.png",width: ScreenUtil.getWidth(context)/4,)),
     body: Form(
       key: _formKey,
       child: SingleChildScrollView(
         child: Padding(
           padding:  EdgeInsets.all(ScreenUtil.getWidth(context)/10),
           child: Column(
             children: [
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
                 onSaved: (String value) {
                 },
               ),
               SizedBox(height: 25 ),
               Center(
                 child: GestureDetector(
                   child: Container(
                     width: ScreenUtil.getWidth(context) / 3,
                     padding: const EdgeInsets.all(5.0),
                     decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
                     child: Center(
                       child: AutoSizeText(
                         getTransrlate(context, 'changePassword'),
                         overflow: TextOverflow.ellipsis,
                         maxFontSize: 14,
                         maxLines: 1,
                         minFontSize: 10,
                         style:
                         TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                       ),
                     ),
                   ),
                   onTap: () {

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
