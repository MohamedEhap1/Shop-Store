import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shop_user_app/consts/my_validators.dart';
import 'package:shop_user_app/services/assets_manager.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late final TextEditingController emailController;
  late final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      //if screen active and not destroy
      emailController.dispose();
    }
    super.dispose();
  }

  Future<void> forgetPasswordFun() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        String message;
        // Check if the error is a user not found error
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            message = 'No user found for that email.';
          } else {
            message = e.message ?? 'An error occurred.';
          }
        } else {
          message = 'An unknown error occurred.';
        }
        if (mounted) {
          await ToastService.showToast(
            backgroundColor: Colors.red,
            leading: const Icon(Icons.error),
            context,
            message: message,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomShimmerAppName(
          fontSize: 22,
          text: "Shop Store",
          baseColor: Colors.purple,
          highlightColor: Colors.lightBlue,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 10,
              ),
              Opacity(
                opacity: 0.8,
                child: Image.asset(
                  AssetsManager.forgetPassword,
                  height: size.width * 0.6,
                  width: size.width * 0.6,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TitleText(
                text: "Forget Password",
                fontSize: 22,
              ),
              const SubtitleText(
                text:
                    "please enter the email address you'd like your password reset information send to",
                fontSize: 14,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "your email@gmail.com",
                        prefixIconColor: Colors.blue,
                        prefixIcon: Icon(
                          IconlyLight.message,
                        ),
                      ),
                      validator: (value) {
                        return MyValidators.emailValidator(value);
                      },
                      onFieldSubmitted: (value) async {
                        await forgetPasswordFun();
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          await forgetPasswordFun();
                        },
                        label: const Text(
                          "Request Link",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        icon: const Icon(
                          IconlyBold.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
