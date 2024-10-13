import 'package:flutter/material.dart';
import 'package:shop_admin_panel/widgets/custom_shimmer_app_name.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const CustomShimmerAppName(
          text: "Place orders",
          baseColor: Colors.purple,
          highlightColor: Colors.lightBlue,
        ),
      ),
      body: ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index) {
          // return Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          //   child: ChangeNotifierProvider.value(
          //     value: allOrderProvider.getAllOrderItems.values
          //         .toList()
          //         .reversed
          //         .toList()[index],
          //     child: const OrderWidget(),
          //   ),
          // );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.grey,
          );
        },
      ),
    );
  }
}
