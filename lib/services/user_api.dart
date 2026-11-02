import 'package:flutter_api/models/user.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class UserApi {
  static Future<List<User>> fetchUsers() async {
    const url = "https://randomuser.me/api/?results=20";
    final uri = Uri.parse(url);
    final res = await http.get(uri);
    final body = res.body;
    final json = jsonDecode(body);
    final results = json["results"] as List<dynamic>;
    final users = results.map((e) {
      final name = UserName(
        title: e["name"]["title"],
        first: e["name"]["first"],
        last: e["name"]["last"],
      );
      return User(
        gender: e["gender"],
        email: e["email"],
        phone: e["phone"],
        cell: e["cell"],
        nat: e["nat"],
        name: name,
      );
    }).toList();

    return users;
  }
}
