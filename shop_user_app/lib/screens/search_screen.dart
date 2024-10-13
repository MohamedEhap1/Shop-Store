import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/models/product_model.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/services/assets_manager.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/products/product_widget.dart';
import 'package:shop_user_app/widgets/title.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  final ValueNotifier<List<ProductModel>> productListSearchNotifier =
      ValueNotifier([]);

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    productListSearchNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> productList = passedCategory == null
        ? productProvider.getProducts
        : productProvider.findByCategory(category: passedCategory);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset(AssetsManager.shoppingCart),
          title: CustomShimmerAppName(
            fontSize: 20,
            text: passedCategory ?? 'Search',
            baseColor: Colors.purple,
            highlightColor: Colors.blue,
          ),
        ),
        body: productList.isEmpty
            ? const Center(child: TitleText(text: "No Products Found"))
            : StreamBuilder<List<ProductModel>>(
                stream: productProvider.fetchProductsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: TitleText(
                        text: snapshot.error.toString(),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: TitleText(
                        text: "No Product has been added",
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          TextField(
                            controller: searchTextController,
                            decoration: InputDecoration(
                              hintText: "Search",
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.blue,
                              ),
                              suffixIcon: searchTextController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        searchTextController.clear();
                                        productListSearchNotifier.value =
                                            []; // Clear search results
                                        FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            onChanged: (value) {
                              productListSearchNotifier.value =
                                  productProvider.searchQuery(
                                searchText: value,
                                passedList: productList,
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          ValueListenableBuilder<List<ProductModel>>(
                            valueListenable: productListSearchNotifier,
                            builder: (context, productListSearch, child) {
                              if (searchTextController.text.isNotEmpty &&
                                  productListSearch.isEmpty) {
                                return const Center(
                                  child: TitleText(
                                    text: "NO Result Found",
                                    fontSize: 40,
                                  ),
                                );
                              }
                              return DynamicHeightGridView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchTextController.text.isNotEmpty
                                    ? productListSearch.length
                                    : productList.length,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                builder: (context, index) {
                                  return ProductWidget(
                                    productId:
                                        searchTextController.text.isNotEmpty
                                            ? productListSearch[index].productId
                                            : productList[index].productId,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
