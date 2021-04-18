import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/screens/Maintenance.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
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

      http.Response response = await http.get(full_url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}',
        //  'locale': Provider.of<Provider_control>(context).getlocal(),
      });
      print(response.body);
      if (response.statusCode == 500) {
        Nav.route(
            context, Maintenance(erorr: jsonDecode(response.body).toString()));
      } else if (response.statusCode == 404) {
        Nav.route(
            context,
            Maintenance(
              erorr: full_url + '\n' + response.body.toString(),
            ));
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (_) =>
              ResultOverlay('${jsonDecode(response.body)['errors']}'),
        );
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
      Nav.route(context, Maintenance());
    } finally {}
  }

  post(String url, Map<String, dynamic> body) async {
    final String full_url =
        '${GlobalConfiguration().getString('api_base_url')}$url';

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    print("full_url =$full_url");

    try {
      http.Response response = await http.post(full_url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('token')}',
            //  'locale': Provider.of<Provider_control>(context).getlocal(),
          },
          body: json.encode(body));
      print("body =${jsonDecode(response.body)}");

      if (response.statusCode == 500) {
        Nav.route(
            context, Maintenance(erorr: jsonDecode(response.body).toString()));
      } else if (response.statusCode == 404) {
        Nav.route(
            context, Maintenance(erorr: jsonDecode(response.body).toString()));
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (_) => ResultOverlay(
              '${jsonDecode(response.body)['errors'] ?? jsonDecode(response.body)}'),
        );
        return null;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      Nav.route(
          context,
          Maintenance(
            erorr: e.toString(),
          ));
      print(e);
    } finally {}
  }

  Put(String url, Map<String, dynamic> body) async {
    final String full_url =
        '${GlobalConfiguration().getString('api_base_url')}$url';

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      http.Response response = await http.put(full_url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('token')}',
            'locale': Provider.of<Provider_control>(context).getlocal(),
          },
          body: json.encode(body));
      print(jsonDecode(response.body));
      if (response.statusCode == 500) {
        Nav.route(
            context,
            Maintenance(
              erorr: jsonDecode(response.body).toString(),
            ));
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {} finally {}
  }

  Delete(String url) async {
    final String full_url =
        '${GlobalConfiguration().getString('api_base_url')}$url';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(full_url);
    try {
      http.Response response = await http.delete(
        full_url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      );
      print(response.body);
      if (response.statusCode == 500) {
        Nav.route(
            context, Maintenance(erorr: jsonDecode(response.body).toString()));
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {} finally {}
  }
}
