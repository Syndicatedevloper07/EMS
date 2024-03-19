import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final void Function()? onPressed;
  final void Function()? onPressed2;
  const Login({super.key, required this.onPressed, required this.onPressed2});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _password = true;
  bool _loading = false;
  Future signIn() async {
    try {
      setState(() {
        _loading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const CupertinoAlertDialog(
              content: Text(
                'Enter a Valid Email Id',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            );
          });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(
                height: 140,
              ),
              Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Login in to your account to continue',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return 'Enter a valid email!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _password ? true : false,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                          _password ? Icons.visibility_off : Icons.visibility),
                      color: Colors.grey.shade600,
                      onPressed: () {
                        setState(() {
                          _password = !_password;
                        });
                      }),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                ),
              ),
              SizedBox(height: 8.0),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onPressed2,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Login Button
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () {
                          if (_passwordController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty) {
                            setState(() {
                              signIn();
                            });
                            // ignore: avoid_print
                            print("success");
                          } else {
                            // ignore: avoid_print
                            const AlertDialog(
                                actions: [Text('Please enter both fields')]);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Signup Button
                    TextButton(
                      onPressed: widget.onPressed,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
