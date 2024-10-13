import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/consts/app_constans.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/services/assets_manager.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/products/catego_rounded_widget.dart';
import 'package:shop_user_app/widgets/products/latest_arrival.dart';
import 'package:shop_user_app/widgets/title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      //! AppBar
      appBar: AppBar(
        leading: Image.asset(AssetsManager.shoppingCart),
        title: const CustomShimmerAppName(
          fontSize: 20,
          text: 'Shop Store',
          baseColor: Colors.purple,
          highlightColor: Colors.blue,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! swiper
              SizedBox(
                height: size.height * 0.24,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      AppConstans.bannerImages[index],
                      fit: BoxFit.fill,
                    );
                  },
                  autoplay: true,
                  itemCount: AppConstans.bannerImages.length,
                  pagination: const SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                    color: Colors.white,
                    activeColor: Colors.black,
                  )),
                  // control: const SwiperControl(),//! arrows
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              //! latest Arrival
              Visibility(
                visible: productProvider.getProducts.isNotEmpty,
                child: const TitleText(
                  text: "Latest Arrival",
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Visibility(
                visible: productProvider.getProducts.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.getProducts.length < 10
                        ? productProvider.getProducts.length
                        : 10,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: productProvider.getProducts[index],
                          child: const LatestArrivalProduct());
                    },
                  ),
                ),
              ),
              //! Categories
              const SizedBox(
                height: 18,
              ),
              //! latest Arrival
              const TitleText(
                text: "Categories",
                fontSize: 22,
              ),
              const SizedBox(
                height: 18,
              ),
              GridView.count(
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: List.generate(
                    AppConstans.categoriesList.length,
                    (index) => CategoryRoundedWidget(
                      image: AppConstans.categoriesList[index].image,
                      name: AppConstans.categoriesList[index].name,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
