import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickstock/view/dashboard_view.dart';
import 'package:quickstock/view/forgot_password_view.dart';
import 'package:quickstock/view/signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                // Wrap with a Container and Row
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        alignment: Alignment.topLeft,
                        'assets/logo/logo.png',
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Welcome back you've been missed!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1500),
                  child: TextFormField(
                    controller: emailController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Useremail",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(
                        Icons.verified_user,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email is required';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1500),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(
                        Icons.key,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password is required';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 5),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordView(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1500),
                  child: MaterialButton(
                    onPressed: handleLogin,
                    height: 45,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1500),
                  child: Divider(),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                              255,
                              97,
                              96,
                              93,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: FaIcon(FontAwesomeIcons.google, size: 20),
                        ),
                      ),
                      SizedBox(width: 40),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                              255,
                              97,
                              96,
                              93,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: FaIcon(
                            FontAwesomeIcons.apple,
                            size: 25,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupView(),
                            ),
                          );
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
