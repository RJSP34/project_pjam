import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/dtos/register_dto.dart';
import '../../../shared/services/navigation_service.dart';
import 'register_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 8.0),
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
              TextField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: registerProvider.isLoading
                    ? null
                    : () async {
                        _performRegister(registerProvider);
                      },
                child: registerProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  NavigationService().replaceScreen('Login');
                },
                child: const Text(
                  "Already have an account? Log in here.",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performRegister(RegisterProvider registerProvider) async {
    RegisterDTO registerDTO = RegisterDTO(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text);

    await registerProvider.register(registerDTO);
  }
}
