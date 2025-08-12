import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_input_field.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  void register(context) {
    final auth = AuthService();

    if (passwordController.text == passwordController.text) {
      try {
        auth.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text("Error"), content: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("The password and confirm password do not match"),
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.message,
          size: 48,
          color: Theme.of(context).colorScheme.secondary,
        ),

        const SizedBox(height: 50),

        Text("Let's get you registered", style: TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        MyInputField(
          hintText: "Username",
          controller: emailController,
          obscureText: false,
        ),

        const SizedBox(height: 15),

        MyInputField(
          hintText: "Password",
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 15),

        MyInputField(
          hintText: "Confirm Password",
          controller: confirmpasswordController,
          obscureText: true,
        ),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already a member?"),
        // const SizedBox(width: 4),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          ),
          child: Text("Login Now", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              _buildHeader(),
              const SizedBox(height: 50),
              _buildLoginForm(),

              const SizedBox(height: 20),

              MyButton(onTap: () => register(context), text: "Register"),

              const SizedBox(height: 50),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
