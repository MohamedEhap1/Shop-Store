import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/consts/app_constans.dart';
import 'package:shop_user_app/consts/my_validators.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/screens/auth/google_button.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;
  late final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  Future<void> fetchFun() async {
    final connectionProvider =
        Provider.of<ConnectivityService>(context, listen: false);
    try {
      Future.wait({
        connectionProvider.checkInitialConnection(),
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchFun();
  }

  @override
  void initState() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    //Focus Node
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    //Focus Node
    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  Future<void> googleSignin() async {
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    if (!connectivityService.isConnected) {
      await ToastService.showToast(
        backgroundColor: Colors.red,
        leading: const Icon(Icons.wifi_off_sharp),
        context,
        message: "No internet connection",
      );
      return;
    }
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          );
          //!save user info to firestore on google sign
          if (authResult.additionalUserInfo!.isNewUser) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'userId': authResult.user!.uid,
              'userName': authResult.user!.displayName,
              'userImage': authResult.user!.photoURL,
              'userEmail': authResult.user!.email,
              'createdAt': Timestamp.now(),
              'userCart': [],
              'userWish': [],
            });
          }
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            MyAppMethods.customSnackBar(
              context: context,
              message: 'Login Successfully',
              seconds: 3,
            );
          });
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Navigator.pushReplacementNamed(
                context, AppConstans.rootScreenRoot);
          });
        } on FirebaseException catch (e) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            MyAppMethods.customSnackBar(
              context: context,
              message: '${e.message}',
              seconds: 3,
            );
          });
        } catch (e) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            MyAppMethods.customSnackBar(
              context: context,
              message: e.toString(),
              seconds: 3,
            );
          });
        }
      }
    }
  }

  Future<void> loginFun() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      final connectivityService =
          Provider.of<ConnectivityService>(context, listen: false);
      if (!connectivityService.isConnected) {
        await ToastService.showToast(
          backgroundColor: Colors.red,
          leading: const Icon(Icons.wifi_off_sharp),
          context,
          message: "No internet connection",
        );
        return;
      }
      try {
        setState(() {
          isLoading = true;
        });
        await auth.signInWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'Login successfully.',
            seconds: 3,
          );

          await Navigator.pushReplacementNamed(
              context, AppConstans.rootScreenRoot);
        });
      } on PlatformException catch (e) {
        // Handle PlatformException
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'Platform error: ${e.message}',
            seconds: 3,
          );
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            MyAppMethods.customSnackBar(
              context: context,
              message: 'No user found for that email.',
              seconds: 3,
            );
          });
        } else if (e.code == 'wrong-password') {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            MyAppMethods.customSnackBar(
              context: context,
              message: 'Wrong password provided for that user.',
              seconds: 3,
            );
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            MyAppMethods.customSnackBar(
              context: context,
              message: 'An unexpected error occurred.',
              seconds: 3,
            );
          });
        }
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: e.toString(),
            seconds: 3,
          );
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Column(
            children: [
              ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  height: 120,
                  color: Colors.blue,
                  child: const Center(
                    child: CustomShimmerAppName(
                        fontSize: 30,
                        text: "Shop Store",
                        baseColor: Colors.deepPurple,
                        highlightColor: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: TitleText(text: "Welcome back")),
                      const SizedBox(
                        height: 16,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: emailTextController,
                              focusNode: emailFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "Enter Email address",
                                prefixIconColor: Colors.blue,
                                prefixIcon: Icon(
                                  IconlyLight.message,
                                ),
                              ),
                              validator: (value) {
                                return MyValidators.emailValidator(value);
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(
                                    passwordFocusNode); //move curser to write in password field
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: passwordTextController,
                              focusNode: passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                  hintText: "Enter Password",
                                  prefixIcon: const Icon(IconlyLight.lock),
                                  prefixIconColor: Colors.blue,
                                  suffixIconColor: Colors.blue,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                    icon: Icon(obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  )),
                              validator: (value) {
                                return MyValidators.passwordValidator(value);
                              },
                              onFieldSubmitted: (value) async {
                                await loginFun();
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, AppConstans.forgetPasswordRoot);
                                },
                                child: const SubtitleText(
                                  text: "Forget Password ?",
                                  color: Colors.lightBlue,
                                  textDecoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: kBottomNavigationBarHeight - 10,
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  await loginFun();
                                },
                                label: const Text(
                                  "Sign in",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                icon: const Icon(
                                  Icons.login,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Divider(
                              color: Colors.grey,
                              indent: 60,
                              endIndent: 60,
                            ),
                            const SubtitleText(
                              text: "OR CONNECT USING",
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: kBottomNavigationBarHeight + 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: kBottomNavigationBarHeight,
                                        child: FittedBox(
                                          child: GoogleButton(
                                            onPressed: () {
                                              googleSignin();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: kBottomNavigationBarHeight,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor: Colors.blue,
                                          ),
                                          onPressed: () async {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) async {
                                              await Navigator
                                                  .pushReplacementNamed(
                                                      context,
                                                      AppConstans
                                                          .rootScreenRoot);
                                            });
                                          },
                                          child: const Text(
                                            "Guest",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SubtitleText(
                                    text: "Don't have an account? "),
                                TextButton(
                                  onPressed: () async {
                                    await Navigator.pushNamed(context,
                                        AppConstans.registerScreenRoot);
                                  },
                                  child: const SubtitleText(
                                    text: "Sign up",
                                    color: Colors.lightBlue,
                                    textDecoration: TextDecoration.underline,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ClipPath(
                clipper: WaveClipperOne(reverse: true, flip: true),
                child: Container(
                  height: 80,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
