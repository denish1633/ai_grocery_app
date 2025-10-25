import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),

            // Register button
            Obx(() {
              return ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final confirm = confirmPasswordController.text.trim();

                  if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
                    Get.snackbar('Error', 'All fields are required');
                    return;
                  }
                  if (password != confirm) {
                    Get.snackbar('Error', 'Passwords do not match');
                    return;
                  }

                  await authController.register(email, password);
                  // Navigation handled in AuthController if registration succeeds
                },
                child: Text('Register'),
              );
            }),

            SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
