import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/consts/app_constans.dart';
import 'package:shop_user_app/consts/my_validators.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/screens/auth/picker_image_widget.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toasty_box/toast_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController userNameTextController;
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;
  late final TextEditingController confirmPasswordTextController;
  late final FocusNode userNameFocusNode;
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;
  late final FocusNode confirmPasswordFocusNode;
  late final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureText2 = true;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  String? userImageUrl;
  XFile? pickImage;

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
    userNameTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
    //Focus Node
    userNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    userNameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    //Focus Node
    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  Future<void> registerFun() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (pickImage == null) {
      MyAppMethods.customAlertDialog(
        context,
        isError: true,
        contentText: "Make sure pick an image",
      );
      return;
    }
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
      formKey.currentState!.save();
      final ref = FirebaseStorage.instance
          .ref()
          .child("usersImages")
          .child('${emailTextController.text.trim()}.jpg');
      await ref.putFile(File(pickImage!.path));
      userImageUrl = await ref.getDownloadURL();
      try {
        setState(() {
          isLoading = true;
        });
        await auth.createUserWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
        );
        //! create collection in firestore
        User? user = auth.currentUser;
        final uid = user!.uid;

        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'userId': uid,
          'userName': userNameTextController.text,
          'userImage': userImageUrl,
          'userEmail': emailTextController.text,
          'createdAt': Timestamp.now(),
          'userCart': [],
          'userWish': [],
        });
        if (mounted) {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'Registered successfully.',
            seconds: 3,
          );
          await Navigator.pushReplacementNamed(
            context,
            AppConstans.rootScreenRoot,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (mounted) {
            MyAppMethods.customSnackBar(
              context: context,
              message: 'The password provided is too weak.',
              seconds: 3,
            );
          }
        } else if (e.code == 'email-already-in-use') {
          if (mounted) {
            MyAppMethods.customSnackBar(
              context: context,
              message: 'The account already exists for that email.',
              seconds: 3,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          MyAppMethods.customSnackBar(
            context: context,
            message: e.toString(),
            seconds: 3,
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  final ImagePicker picker = ImagePicker();
  Future<void> localmagePicker() async {
    await MyAppMethods.imagePickerDialog(
      context: context,
      camera: () async {
        pickImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      gallery: () async {
        pickImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      remove: () {
        pickImage = null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      const CustomShimmerAppName(
                        fontSize: 30,
                        text: "Shop Store",
                        baseColor: Colors.deepPurple,
                        highlightColor: Colors.white,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: TitleText(text: "Welcome back")),
                      const SizedBox(
                        height: 8,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: SubtitleText(
                              text:
                                  "Sign up now to receive special offers and updates from our app")),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: size.width * 0.3,
                          width: size.width * 0.3,
                          child: PickerImageWidget(
                            pickerImage: pickImage,
                            function: () async {
                              await localmagePicker();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: userNameTextController,
                              focusNode: userNameFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: "Full Name",
                                prefixIconColor: Colors.blue,
                                prefixIcon: Icon(
                                  IconlyLight.profile,
                                ),
                              ),
                              validator: (value) {
                                return MyValidators.displayNameValidator(value);
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(
                                  emailFocusNode,
                                ); //move curser to write in password field
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: emailTextController,
                              focusNode: emailFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "Email address",
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
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: const Icon(IconlyLight.password),
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
                                FocusScope.of(context)
                                    .requestFocus(confirmPasswordFocusNode);
                                // await loginFun();
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: confirmPasswordTextController,
                              focusNode: confirmPasswordFocusNode,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              obscureText: obscureText2,
                              decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  prefixIcon: const Icon(IconlyLight.password),
                                  prefixIconColor: Colors.blue,
                                  suffixIconColor: Colors.blue,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscureText2 = !obscureText2;
                                      });
                                    },
                                    icon: Icon(obscureText2
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  )),
                              validator: (value) {
                                return MyValidators.repeatPasswordValidator(
                                    value: value,
                                    password: passwordTextController.text);
                              },
                              onFieldSubmitted: (value) async {
                                await registerFun();
                              },
                            ),
                            const SizedBox(
                              height: 50,
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
                                  await registerFun();
                                },
                                label: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                icon: const Icon(
                                  IconlyLight.addUser,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
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
