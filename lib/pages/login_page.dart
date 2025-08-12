import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_input_field.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login(context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text("Error"), content: Text(e.toString())),
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

        Text(
          "Welcome back! You've been missed",
          style: TextStyle(fontSize: 20),
        ),
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

        const SizedBox(height: 20),

        // MyInputField(
        //   hintText: "Password",
        //   controller: passwordController,
        //   obscureText: true,
        // ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: passwordController,
            obscureText: isPasswordVisible,
            autofillHints: [AutofillHints.password],
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "Password",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
              suffixIcon: IconButton(
                onPressed: togglePasswordVisibility,
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "forget password",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("You're not a member?"),
        // const SizedBox(width: 4),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          ),
          child: Text("Register Now", style: TextStyle(color: Colors.blue)),
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

              MyButton(onTap: () => login(context), text: "Login"),

              const SizedBox(height: 50),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
