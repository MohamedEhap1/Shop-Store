import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/models/all_order_model.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key, required this.allOrderModel});
  final AllOrderModel allOrderModel;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              imageUrl: widget.allOrderModel.imageUrl,
              height: size.width * 0.35,
              width: size.width * 0.25,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitleText(
                          text: widget.allOrderModel.productTitle,
                          maxLines: 2,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (!connectivityService.isConnected) {
                            await ToastService.showToast(
                              backgroundColor: Colors.red,
                              leading: const Icon(Icons.wifi_off_sharp),
                              context,
                              message: "No internet connection",
                            );
                            return;
                          }
                          MyAppMethods.customAlertDialog(context,
                              contentText: "Remove this order", onPressed: () {
                            // allOrderProvider.removeOneItem(
                            //     productId: getCurrentProduct.productId);
                            // Navigator.pop(context);
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          size: 22,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const TitleText(
                        text: "Price: ",
                        fontSize: 15,
                      ),
                      Flexible(
                        child: SubtitleText(
                          text: "${widget.allOrderModel.price}\$",
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Flexible(
                          child: TitleText(
                        text: "Qty: ${widget.allOrderModel.quantity}",
                      )),
                      // Flexible(
                      //   child: SubtitleText(
                      //     text: allOrderModel.quantity.toString(),
                      //     fontSize: 15,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
