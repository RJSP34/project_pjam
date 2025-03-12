import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/dtos/login_dto.dart';
import '../../../shared/services/navigation_service.dart';
import 'login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: loginProvider.isLoading
                    ? null
                    : () => _performLogin(loginProvider),
                child: loginProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  NavigationService().replaceScreen('Register');
                },
                child: const Text(
                  "Create a new account if you haven't already.",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performLogin(LoginProvider loginProvider) async {
    LoginDTO loginDTO = LoginDTO(
        email: _emailController.text, password: _passwordController.text);

    await loginProvider.login(loginDTO);
  }
}
