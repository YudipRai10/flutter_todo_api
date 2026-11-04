import 'package:flutter/material.dart';
import 'package:flutter_api/bloc/auth_bloc.dart';
import 'package:flutter_api/screens/home_screen.dart';
import 'package:flutter_api/widgets/gradient_button.dart';
import 'package:flutter_api/widgets/login_field.dart';
import 'package:flutter_api/widgets/social_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login successful! Welcome.'),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(title: 'Home Page'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading || state is AuthSuccess) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Center(
                child: Form(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Sign in.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                      const SizedBox(height: 50),
                      const SocialButton(label: 'Continue with Google'),
                      const SizedBox(height: 20),
                      const SocialButton(
                        label: 'Continue with Facebook',
                        horizontalPadding: 90,
                      ),
                      const SizedBox(height: 15),
                      const Text('or', style: TextStyle(fontSize: 17)),
                      const SizedBox(height: 15),
                      // Clean and simple - no duplicate validators!
                      LoginField(
                        hintText: 'Email',
                        controller: emailController,
                      ),
                      const SizedBox(height: 15),
                      LoginField(
                        hintText: 'Password',
                        controller: passwordController,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        onPressed: () {
                          // Send directly to BLoC to handle the validation:
                          context.read<AuthBloc>().add(
                            AuthLoginEvent(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
