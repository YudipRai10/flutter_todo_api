import 'package:flutter/material.dart';
import 'package:flutter_api/models/user.dart';
import 'package:flutter_api/services/user_api.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<User> users = [];

  Future<void> fetchUsers() async {
    final response = await UserApi.fetchUsers();
    setState(() {
      users = response;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          // final name = user["name"]["first"];
          // final email = user.email;
          final color = user.gender == "male"
              ? Colors.blue.shade100
              : Colors.pink.shade100;
          // final first = user.first;
          // final cell = user.cell;
          // final title = user.name.title;
          // final image = user["picture"]["thumbnail"];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: color,
            child: ListTile(
              title: Text(user.email),
              subtitle: Text(user.fullName),
            ),
          );
        },
      ),
    );
  }
}
