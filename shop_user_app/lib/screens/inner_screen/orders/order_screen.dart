import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/models/all_order_model.dart';
import 'package:shop_user_app/provider/all_order_provider.dart';
import 'package:shop_user_app/screens/inner_screen/orders/order_widget.dart';
import 'package:shop_user_app/services/assets_manager.dart';
import 'package:shop_user_app/widgets/cart/empty_cart.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final allOrderProvider = Provider.of<AllOrderProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const CustomShimmerAppName(
            text: "Place orders",
            baseColor: Colors.purple,
            highlightColor: Colors.lightBlue,
          ),
        ),
        body: FutureBuilder<List<AllOrderModel>>(
            future: allOrderProvider.fetchOrder(),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapShot.hasError) {
                return Center(
                  child: SelectableText(
                      "An error has been occurred ${snapShot.error.toString()}"),
                );
              } else if (!snapShot.hasData) {
                return EmptyPageWidget(
                  size: size,
                  title: "Whoops!",
                  subTitle1: "No Orders has been placed yet",
                  subTitle2:
                      "Looks like you didn't order anything yet go a head and start shopping now",
                  buttonText: "Shop Now",
                  imagePath: AssetsManager.order,
                );
              }
              return ListView.separated(
                itemCount: snapShot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: OrderWidget(
                      allOrderModel: snapShot.data!.elementAt(index),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: Colors.grey,
                  );
                },
              );
            }));
  }
}
