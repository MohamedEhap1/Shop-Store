// import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_admin_panel/models/all_order_model.dart';
// import 'package:shop_admin_panel/provider/all_order_provider.dart';
// import 'package:shop_admin_panel/provider/product_provider.dart';
// import 'package:shop_admin_panel/services/my_app_methods.dart';
// import 'package:shop_admin_panel/widgets/subtitle.dart';
// import 'package:shop_admin_panel/widgets/title.dart';

// class OrderWidget extends StatefulWidget {
//   const OrderWidget({super.key});

//   @override
//   State<OrderWidget> createState() => _OrderWidgetState();
// }

// class _OrderWidgetState extends State<OrderWidget> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final allOrderModel = Provider.of<AllOrderModel>(context);

//     final allOrderProvider = Provider.of<AllOrderProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);

//     final getCurrentProduct =
//         productProvider.findByProvider(allOrderModel.productId);
//     return getCurrentProduct == null
//         ? const SizedBox.shrink()
//         : Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: FancyShimmerImage(
//                     imageUrl: getCurrentProduct.productImage,
//                     height: size.width * 0.35,
//                     width: size.width * 0.25,
//                   ),
//                 ),
//                 Flexible(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Flexible(
//                               child: TitleText(
//                                 text: getCurrentProduct.productTitle,
//                                 maxLines: 2,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 MyAppMethods.customAlertDialog(context,
//                                     contentText: "Remove this order",
//                                     onPressed: () {
//                                   allOrderProvider.removeOneItem(
//                                       productId: getCurrentProduct.productId);
//                                   Navigator.pop(context);
//                                 });
//                               },
//                               icon: const Icon(
//                                 Icons.clear,
//                                 size: 22,
//                                 color: Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const TitleText(
//                               text: "Price: ",
//                               fontSize: 15,
//                             ),
//                             Flexible(
//                               child: SubtitleText(
//                                 text: "${getCurrentProduct.productPrice}\$",
//                                 color: Colors.blue,
//                                 fontSize: 15,
//                               ),
//                             )
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Row(
//                           children: [
//                             Flexible(
//                               child: TitleText(
//                                 text: "Qty: ",
//                                 fontSize: double.parse(
//                                     getCurrentProduct.productQuantity),
//                               ),
//                             ),
//                             Flexible(
//                               child: SubtitleText(
//                                 text: allOrderModel.quantity.toString(),
//                                 fontSize: 15,
//                               ),
//                             )
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//   }
// }
