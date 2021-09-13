import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/screens/Maintenance.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class API {
  BuildContext context;

  API(this.context);

  get(String url) async {
    final String full_url =
        '${GlobalConfiguration().getString('api_base_url')}$url';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print(full_url);

      http.Response response = await http.get(Uri.parse(full_url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}',
       // 'Accept-Language': Provider.of<Provider_control>(context,listen: false).getlocal(),
      });
      print(response.body);
      if (response.statusCode == 500) {
        Nav.route(
            context, Maintenance(erorr: jsonDecode(response.body).toString()));
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => ResultOverlay(
            "${getTransrlate(context, 'ConnectionFailed')}"),
      );
    } finally {}
  }

  post(String url, Map<String, dynamic> body) async {
    final String full_url =
        '${GlobalConfiguration().getString('api_base_url')}$url';

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    print("full_url =$full_url");
    print(body);
    try {
      http.Response response = await http.post(Uri.parse(full_url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('token')}',
            'Accept-Language': "${Provider.of<Provider_control>(context,listen: false).getlocal()}",
          },
          body: json.encode(body));

      if (response.statusCode == 500) {
        Nav.route(
            context, Maintenance(erorr:"${url}\n${response.body}",));
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => ResultOverlay(
            "${getTransrlate(context, 'ConnectionFailed')}"),
      );
      print(e);
    } finally {}
  }

  Put(String url, Map<String, dynamic> body) async {
    final String full_url =
        '${GlobalConfiguration().getString('api_base_url')}$url';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("body: ${body}");

    try {
      http.Response response = await http.put(Uri.parse(full_url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('token')}',
            'Accept-Language': "${Provider.of<Provider_control>(context,listen: false).getlocal()}",

          },
          body: json.encode(body));
      print(jsonDecode(response.body));
      if (response.statusCode == 500) {
        Nav.route(
            context,
            Maintenance(
              erorr: "${url}\n${response.body}",
            ));
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {

      showDialog(
        context: context,
        builder: (_) => ResultOverlay(
            "${getTransrlate(context, 'ConnectionFailed')}"),
      );
    } finally {}
  }

  Delete(String url) async {
    final String full_url =
        '${GlobalConfiguration().getString('api_base_url')}$url';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(full_url);
    try {
      http.Response response = await http.delete(
        Uri.parse(full_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
          'Accept-Language': "${Provider.of<Provider_control>(context,listen: false).getlocal()}",

        },
      );
      print(response.body);
      if (response.statusCode == 500) {
        Nav.route(
            context, Maintenance(
          erorr: "${url}\n${response.body}",
        ));
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {

      showDialog(
        context: context,
        builder: (_) => ResultOverlay(
            "${getTransrlate(context, 'ConnectionFailed')}"),
      );
    } finally {}
  }

  postFile(String url, Map<String, String> body,
      {List<Asset> attachment}) async {
    print(Provider.of<Provider_control>(context,listen: false).getlocal());
    final full_url = Uri.parse('${GlobalConfiguration().getString('api_base_url')}$url');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Authorization': 'Bearer  ${prefs.getString('token')}',
    'Accept-Language': "${Provider.of<Provider_control>(context,listen: false).getlocal()}",
    };
    //  try { remove headers if not wanted
    try {
    var request = http.MultipartRequest(
        'POST', Uri.parse(full_url.toString())); // your server url
    request.fields.addAll(body);
    for (Asset asset in attachment) {
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      request.files.add(http.MultipartFile.fromBytes(
        'photo[${attachment.indexOf(asset)}]',
        imageData,
        filename: 'photo',
        contentType: MediaType("image", "jpg"),
      ));
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response.stream.bytesToString().then((value) {
      print(jsonDecode(value));
      return jsonDecode(value);
    });
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => ResultOverlay(
            "${getTransrlate(context, 'ConnectionFailed')}"),
      );
    }
  }
}
