import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin_panel/providers/product_provider.dart';
import 'package:shop_admin_panel/screens/edit_upload_product.dart';
import 'package:shop_admin_panel/widgets/subtitle.dart';
import 'package:shop_admin_panel/widgets/title.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    // final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProvider(widget.productId);

    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditUploadProduct(
                    productModel: getCurrentProduct,
                  );
                }));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.productImage,
                      height: size.height * 0.32,
                      width: double.infinity,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: TitleText(
                          fontSize: 18,
                          text: getCurrentProduct.productTitle,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: SubtitleText(
                            text: "${getCurrentProduct.productPrice} \$",
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
  }
}
