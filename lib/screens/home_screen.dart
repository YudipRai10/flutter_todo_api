import 'package:flutter/material.dart';
import 'package:flutter_api/bloc/auth_bloc.dart';
import 'package:flutter_api/models/user.dart';
import 'package:flutter_api/screens/login_screen.dart';
import 'package:flutter_api/services/user_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final authState = context.watch<AuthBloc>().state;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // Navigate back to LoginScreen and clear previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(
              authState is AuthSuccess
                  ? 'Welcome, ${authState.uid}'
                  : widget.title,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                tooltip: 'Sign out',
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutEvent());
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final color = user.gender == "male"
                  ? Colors.blue.shade100
                  : Colors.pink.shade100;

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
      },
    );
  }
}
