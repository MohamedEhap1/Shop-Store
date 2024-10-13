import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin_panel/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _product = [];
  List<ProductModel> get getProducts => _product;
  //! find by id provider
  ProductModel? findByProvider(String productId) {
    if (_product.where((element) => element.productId == productId).isEmpty) {
      return null;
    } else {
      return _product.firstWhere((element) => element.productId == productId);
    }
  }

  List<ProductModel> findByCategory({required String category}) {
    List<ProductModel> ctgList = _product
        .where(
          (element) => element.productCategory
              .toLowerCase()
              .contains(category.toLowerCase()),
        )
        .toList();
    return ctgList;
  }

  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    List<ProductModel> searchList = passedList
        .where(
          (element) => element.productTitle
              .toLowerCase()
              .contains(searchText.toLowerCase()),
        )
        .toList();
    return searchList;
  }

  final productDB = FirebaseFirestore.instance.collection('products');
  Future<List<ProductModel>> fetchProducts() async {
    try {
      await productDB.get().then((productSnapShot) {
        _product.clear();

        for (var element in productSnapShot.docs) {
          _product.insert(0, ProductModel.fromFireStore(element));
        }
      }); //fetch all products
      notifyListeners();
      return _product;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchProductsStream() {
    try {
      return productDB.snapshots().map((snapShot) {
        _product.clear();
        for (var element in snapShot.docs) {
          _product.insert(0, ProductModel.fromFireStore(element));
        }
        return _product;
      });
    } catch (e) {
      rethrow;
    }
  }
  // final List<ProductModel> _product = [
  //   ProductModel(
  //     productId: "Iphone14-12Gb-black",
  //     productTitle: "Apple iphone 14 pro (12Gb) - Black",
  //     productPrice: "1399.99",
  //     productImage:
  //         "https://th.bing.com/th/id/OIP._DCGzGe_porvL9SmYwqS7QHaJF?rs=1&pid=ImgDetMain",
  //     productCategory: "Phones",
  //     productDescription:
  //         "The iPhone 14 Pro is Apple’s premium smartphone, designed for those who demand the best in technology and performance. With its sleek design, advanced features, and cutting-edge camera system, the iPhone 14 Pro is perfect for both everyday users and tech enthusiasts.6.1-inch Super Retina XDR display with ProMotion technology for smooth scrolling and enhanced responsiveness.HDR support and a peak brightness of up to 2,000 nits for stunning visuals in any lighting condition.",
  //     productQuantity: "21",
  //   ),
  //   ProductModel(
  //     productId: "Iphone13-mini-256Gb-midnight",
  //     productTitle:
  //         "Iphone 13 Mini (256Gb) - midnight - Unlocked (Renewed Premium)",
  //     productPrice: "659.99",
  //     productImage:
  //         "https://th.bing.com/th/id/OIP.nA4O9j-7R_VNQcCUwPaWNAHaHa?rs=1&pid=ImgDetMain",
  //     productCategory: "Phones",
  //     productDescription:
  //         "The iPhone 13 Mini is a compact powerhouse, perfect for users who want top-tier performance in a smaller form factor. With its sleek design, vibrant display, and impressive camera capabilities, the iPhone 13 Mini offers everything you need in a smartphone without compromising on features.5.4-inch Super Retina XDR display for stunning visuals and vibrant colors.HDR support and a peak brightness of up to 1,200 nits for an exceptional viewing experience.",
  //     productQuantity: "15",
  //   ),
  //   ProductModel(
  //     productId: "nike-air-max-270",
  //     productTitle: "Nike Air Max 270 - Black/White",
  //     productPrice: "149.99",
  //     productImage: "https://i8.amplience.net/i/jpl/jd_011116_a?qlt=92",
  //     productCategory: "Shoes",
  //     productDescription:
  //         "The Nike Air Max 270 features a large Air unit for maximum comfort and style. With its sleek design and breathable upper, these shoes are perfect for both casual wear and athletic activities.",
  //     productQuantity: "30",
  //   ),
  //   ProductModel(
  //     productId: "levis-501-original",
  //     productTitle: "Levi's 501 Original Fit Jeans",
  //     productPrice: "69.99",
  //     productImage:
  //         "https://th.bing.com/th/id/R.49c0e0a57ef71c6bf7728da19792e3ac?rik=yMxtYMgKSdsFVw&pid=ImgRaw&r=0",
  //     productCategory: "Clothes",
  //     productDescription:
  //         "The Levi's 501 Original Fit Jeans are a timeless classic. Made from durable denim, these jeans offer a relaxed fit and can be paired with any outfit for a laid-back look.",
  //     productQuantity: "50",
  //   ),
  //   ProductModel(
  //     productId: "sony-wh-1000xm4",
  //     productTitle: "Sony WH-1000XM4 Wireless Headphones",
  //     productPrice: "349.99",
  //     productImage:
  //         "https://th.bing.com/th/id/OIP.zYL9rxkCyKVTi0CGoADCqwHaD4?rs=1&pid=ImgDetMain",
  //     productCategory: "Headphones",
  //     productDescription:
  //         "Experience industry-leading noise cancellation with the Sony WH-1000XM4 headphones. With up to 30 hours of battery life and touch sensor controls, these headphones provide an unmatched audio experience.",
  //     productQuantity: "25",
  //   ),
  //   ProductModel(
  //     productId: "apple-watch-series-6",
  //     productTitle: "Apple Watch Series 6 - GPS",
  //     productPrice: "399.99",
  //     productImage:
  //         "https://th.bing.com/th/id/R.44b84a42b43211efacb3e1097f0cab0a?rik=jCCuaYnbxdyKWg&pid=ImgRaw&r=0",
  //     productCategory: "Smartwatches",
  //     productDescription:
  //         "The Apple Watch Series 6 offers a stunning display, fitness tracking, and health monitoring features. Stay connected and motivated with this advanced smartwatch that fits seamlessly into your lifestyle.",
  //     productQuantity: "20",
  //   ),
  //   ProductModel(
  //     productId: "samsung-galaxy-tab-s7",
  //     productTitle: "Samsung Galaxy Tab S7 - 128GB",
  //     productPrice: "649.99",
  //     productImage:
  //         "https://th.bing.com/th/id/OIP.0elVIIodUnqUdGdw1EXERQHaHa?rs=1&pid=ImgDetMain",
  //     productCategory: "Tablets",
  //     productDescription:
  //         "The Samsung Galaxy Tab S7 offers a stunning 11-inch display and powerful performance with its Snapdragon processor. Perfect for work and play, it comes with an S Pen for enhanced productivity.",
  //     productQuantity: "40",
  //   ),
  //   ProductModel(
  //     productId: "adidas-ultra-boost",
  //     productTitle: "Adidas Ultra Boost - White/Black",
  //     productPrice: "179.99",
  //     productImage:
  //         "https://th.bing.com/th/id/R.7d41c5d030f7f89a5b0ba2f9e899be62?rik=m5S3hQU6Mvru5g&riu=http%3a%2f%2fimages.solecollector.com%2fcomplex%2fimage%2fupload%2ft_in_content_image%2fadidas-ultra-boost-black-white-02_o6rxf0.jpg&ehk=aSQEHa0WLv6y6F%2fGKW5rfMUe83LdpEyOL8Zubqt1SsM%3d&risl=&pid=ImgRaw&r=0",
  //     productCategory: "Shoes",
  //     productDescription:
  //         "The Adidas Ultra Boost combines style and comfort with its responsive cushioning and lightweight design. Perfect for running or casual wear, these sneakers provide excellent support.",
  //     productQuantity: "35",
  //   ),
  //   ProductModel(
  //     productId: "north-face-recon-backpack",
  //     productTitle: "The North Face Recon Backpack",
  //     productPrice: "99.99",
  //     productImage:
  //         "https://th.bing.com/th/id/OIP.UD_f6M3DqHSIHxWf8A_y6gHaH9?rs=1&pid=ImgDetMain",
  //     productCategory: "Bags",
  //     productDescription:
  //         "The North Face Recon Backpack is designed for durability and comfort. It features multiple pockets, a padded laptop sleeve, and a breathable back panel, making it ideal for school or travel.",
  //     productQuantity: "60",
  //   ),
  //   ProductModel(
  //     productId: "canon-eos-rebel-t7",
  //     productTitle: "Canon EOS Rebel T7 DSLR Camera",
  //     productPrice: "549.99",
  //     productImage:
  //         "https://th.bing.com/th/id/OIP.FFJHJDYZLz5bJPPwsHzaAwHaHa?rs=1&pid=ImgDetMain",
  //     productCategory: "Cameras",
  //     productDescription:
  //         "The Canon EOS Rebel T7 is a versatile DSLR camera with a 24.1MP sensor, built-in Wi-Fi, and Full HD video recording. Perfect for beginners and enthusiasts alike, it captures stunning images.",
  //     productQuantity: "15",
  //   ),
  //   ProductModel(
  //     productId: "amazon-echo-dot",
  //     productTitle: "Amazon Echo Dot (4th Gen) - Smart Speaker",
  //     productPrice: "49.99",
  //     productImage:
  //         "https://th.bing.com/th/id/OIP._8Hd4LSiJ5SDFdqD1mmZ4wAAAA?rs=1&pid=ImgDetMain",
  //     productCategory: "Smart Speakers",
  //     productDescription:
  //         "The Amazon Echo Dot is a compact smart speaker with Alexa. Control your smart home, play music, and ask questions with just your voice. Its sleek design fits any room.",
  //     productQuantity: "100",
  //   ),
  // ];
}
