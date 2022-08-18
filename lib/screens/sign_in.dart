import 'package:flutter/material.dart';

import 'package:instagram_app/firebase_services/auth.dart';
import 'package:instagram_app/screens/register.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/contants.dart';
import 'package:instagram_app/shared/snackbar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisable = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });

    await AuthMethods().signIn(
        emailll: emailController.text,
        passworddd: passwordController.text,
        context: context);

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;
    showSnackBar(context, "successfully sign-in ☺");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    // final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          // backgroundColor: appbarGreen,
          title: const Text("Sign in"),
        ),
        body: Center(
            child: Padding(
          padding: widthScreen > 600
              ? EdgeInsets.symmetric(horizontal: widthScreen * .3)
              : const EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 64,
              ),
              TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Email : ",
                      suffixIcon: const Icon(Icons.email))),
              const SizedBox(
                height: 33,
              ),
              TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: isVisable ? false : true,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Password : ",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisable = !isVisable;
                            });
                          },
                          icon: isVisable
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)))),
              const SizedBox(
                height: 33,
              ),
              ElevatedButton(
                onPressed: () async {
                  signIn();
                },
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(BTNgreen),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 19),
                      ),
              ),
              const SizedBox(
                height: 9,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do not have an account?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                      child: const Text('sign up',
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.underline))),
                ],
              ),
            ]),
          ),
        )));
  }
}
