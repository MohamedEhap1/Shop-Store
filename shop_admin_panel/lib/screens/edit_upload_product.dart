import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shop_admin_panel/consts/app_constans.dart';
import 'package:shop_admin_panel/consts/my_validators.dart';
import 'package:shop_admin_panel/models/product_model.dart';
import 'package:shop_admin_panel/services/my_app_methods.dart';
import 'package:shop_admin_panel/widgets/custom_text_form_field.dart';
import 'package:shop_admin_panel/widgets/subtitle.dart';
import 'package:uuid/uuid.dart';

class EditUploadProduct extends StatefulWidget {
  const EditUploadProduct({super.key, this.productModel});
  final ProductModel? productModel;

  @override
  State<EditUploadProduct> createState() => _EditUploadProductState();
}

class _EditUploadProductState extends State<EditUploadProduct> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickImage;
  String? productNetworkImage;
  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;
  String? categoryValue;
  bool isEditing = false;
  bool isLoading = false;
  String? productImageUrl;

  @override
  void initState() {
    if (widget.productModel != null) {
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
      categoryValue = widget.productModel!.productCategory;
    }
    _titleController =
        TextEditingController(text: widget.productModel?.productTitle);
    _priceController =
        TextEditingController(text: widget.productModel?.productPrice);
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quantityController =
        TextEditingController(text: widget.productModel?.productQuantity);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
  }

  void removePickedImage() {
    setState(() {
      _pickImage = null;
      productNetworkImage = null;
    });
  }

  Future<void> _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickImage == null) {
      MyAppMethods.customAlertDialog(
        context,
        isError: true,
        contentText: "Make sure pick an image",
        onPressed: () {
          Navigator.pop(context);
        },
      );
      return;
    }
    if (categoryValue == null) {
      MyAppMethods.customAlertDialog(context,
          isError: true, contentText: "Category is Empty", onPressed: () {
        Navigator.pop(context);
      });
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      final productId = const Uuid().v4();
      final ref = FirebaseStorage.instance
          .ref()
          .child("productsImages")
          .child('$productId.jpg');
      await ref.putFile(File(_pickImage!.path));
      productImageUrl = await ref.getDownloadURL();
      try {
        setState(() {
          isLoading = true;
        });

        //! create collection in firestore
        FirebaseFirestore.instance.collection('products').doc(productId).set({
          'productId': productId,
          'productTitle': _titleController.text,
          'productPrice': _priceController.text,
          'productImage': productImageUrl,
          'productCategory': categoryValue,
          'productDescription': _descriptionController.text,
          'productQuantity': _quantityController.text,
          'ratingOfProduct': {
            'counterOneStars': 0,
            'counterTwoStars': 0,
            'counterThreeStars': 0,
            'counterFourStars': 0,
            'counterFiveStars': 0,
          },
          'usersRating': [],
          'createdAt': Timestamp.now(),
        });
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'Product has been added.',
            seconds: 3,
          );
        });

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customAlertDialog(context, contentText: 'Clear form ?',
              onPressed: () {
            clearAllFields();
            Navigator.pop(context);
          });
        });
      } on FirebaseException catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'An error has been occurred ${e.message}',
            seconds: 3,
          );
        });
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'An error has been occurred $e',
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

  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickImage == null && productNetworkImage == null) {
      MyAppMethods.customAlertDialog(context,
          isError: true, contentText: "Please pick image", onPressed: () {
        Navigator.pop(context);
      });
      return;
    }
    if (categoryValue == null) {
      MyAppMethods.customAlertDialog(context,
          isError: true, contentText: "Category is Empty", onPressed: () {
        Navigator.pop(context);
      });
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      if (_pickImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("productsImages")
            .child('${widget.productModel!.productId}.jpg');
        await ref.putFile(File(_pickImage!.path));
        productImageUrl = await ref.getDownloadURL();
      }
      try {
        setState(() {
          isLoading = true;
        });

        //! create collection in firestore
        FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productModel!.productId)
            .update({
          'productId': widget.productModel!.productId,
          'productTitle': _titleController.text,
          'productPrice': _priceController.text,
          'productImage': productImageUrl ?? productNetworkImage,
          'productCategory': categoryValue,
          'productDescription': _descriptionController.text,
          'productQuantity': _quantityController.text,
          'createdAt': widget.productModel!.createAt,
          'ratingOfProduct': widget.productModel!.productRating,
          'usersRating': widget.productModel!.usersRating,
        });
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'Product has been edited.',
            seconds: 3,
          );
        });

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customAlertDialog(context, contentText: 'Clear form ?',
              onPressed: () {
            clearAllFields();
            Navigator.pop(context);
          });
        });
      } on FirebaseException catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'An error has been occurred ${e.message}',
            seconds: 3,
          );
        });
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MyAppMethods.customSnackBar(
            context: context,
            message: 'An error has been occurred $e',
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

  void clearAllFields() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    removePickedImage();
    categoryValue = null;
    FocusScope.of(context).unfocus();
  }

  final ImagePicker picker = ImagePicker();
  Future<void> localmagePicker() async {
    await MyAppMethods.imagePickerDialog(
      context: context,
      camera: () async {
        _pickImage = await picker.pickImage(source: ImageSource.camera);

        setState(() {
          productNetworkImage = null;
        });
      },
      gallery: () async {
        _pickImage = await picker.pickImage(source: ImageSource.gallery);

        setState(() {
          productNetworkImage = null;
        });
      },
      remove: () {
        _pickImage = null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? "Edit Product" : "Upload a new product"),
            centerTitle: true,
          ),
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      clearAllFields();
                    },
                    label: const Text(
                      "Clear",
                      style: TextStyle(fontSize: 20),
                    ),
                    icon: const Icon(Icons.clear),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (isEditing) {
                        _editProduct();
                      } else {
                        _uploadProduct();
                      }
                    },
                    label: Text(
                      isEditing ? "Edit Product" : "Upload Product",
                      style: const TextStyle(fontSize: 20),
                    ),
                    icon: const Icon(Icons.upload),
                  ),
                ],
              ),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    if (isEditing && productNetworkImage != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          productNetworkImage!,
                          fit: BoxFit.fitHeight,
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                          alignment: Alignment.center,
                        ),
                      ),
                    ] else if (_pickImage == null) ...[
                      GestureDetector(
                        onTap: () async {
                          await localmagePicker();
                        },
                        child: SizedBox(
                          height: size.width * 0.4 + 10,
                          width: size.width * 0.4,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            padding: const EdgeInsets.all(6),
                            color: Colors.blue,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 80,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    "Pick product image",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_pickImage!.path),
                          fit: BoxFit.fill,
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                    if (_pickImage != null || productNetworkImage != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await localmagePicker();
                            },
                            child: const Text(
                              "Pick another image",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              removePickedImage();
                            },
                            child: const Text(
                              "Remove image",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    ],
                    const SizedBox(
                      height: 25,
                    ),
                    DropdownButton(
                        items: AppConstans.categoriesDropDownList,
                        hint: Text(categoryValue ?? "Select Category"),
                        value: categoryValue,
                        onChanged: (String? value) {
                          setState(() {
                            categoryValue = value;
                          });
                        }),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: _titleController,
                                keyValue: "Title",
                                keyboardType: TextInputType.multiline,
                                maxLength: 80,
                                minLines: 1,
                                maxLines: 2,
                                hintText: "Product title",
                                validator: (value) {
                                  return MyValidators.uploadProductText(
                                    value: value,
                                    toBeReturnedString:
                                        "Please enter a valid title",
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: CustomTextFormField(
                                      controller: _priceController,
                                      keyValue: "Price \$",
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}'),
                                        ),
                                      ],
                                      minLines: 1,
                                      maxLines: 1,
                                      hintText: "Product price",
                                      prefix: const SubtitleText(
                                        text: "\$ ",
                                        color: Colors.blue,
                                      ),
                                      validator: (value) {
                                        return MyValidators.uploadProductText(
                                          value: value,
                                          toBeReturnedString:
                                              "Price is missing",
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: CustomTextFormField(
                                      controller: _quantityController,
                                      keyValue: "Quantity",
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      minLines: 1,
                                      maxLines: 1,
                                      hintText: "Qty",
                                      validator: (value) {
                                        return MyValidators.uploadProductText(
                                          value: value,
                                          toBeReturnedString:
                                              "Quantity is missed",
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomTextFormField(
                                controller: _descriptionController,
                                keyValue: "Description",
                                minLines: 3,
                                maxLines: 8,
                                maxLength: 1000,
                                hintText: "Product description",
                                validator: (value) {
                                  return MyValidators.uploadProductText(
                                    value: value,
                                    toBeReturnedString: "Description is missed",
                                  );
                                },
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onTap: () {},
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: kBottomNavigationBarHeight + 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
