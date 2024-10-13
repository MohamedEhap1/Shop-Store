import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/consts/app_constans.dart';
import 'package:shop_user_app/models/user_model.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/theme_provider.dart';
import 'package:shop_user_app/provider/user_provider.dart';
import 'package:shop_user_app/services/assets_manager.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/custom_list_tile.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive =>
      true; //this screen keep active and not reload data each time open it
  User? user = FirebaseAuth.instance.currentUser;
  bool isloading = true;
  UserModel? userModel;
  Future<void> fetchUserInfo() async {
    setState(() {
      isloading = false;
    });
    if (user == null) {
      return;
    }
    final userProvider = Provider.of<UserProvider>(context);
    try {
      userModel = await userProvider.fetchUserInfo();
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
        isloading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserInfo();
  }

  final Uri _url = Uri.parse(
    'https://www.freeprivacypolicy.com/live/a8563493-f990-42ea-afd4-48ea2df6fb46',
  );
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    return Scaffold(
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
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: user == null ? true : false,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TitleText(
                        text: "Please login to have ultimate access "),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                userModel == null
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                color: Colors.blue, //take color of background
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(userModel?.userImage ??
                                    "https://th.bing.com/th/id/R.19fa7497013a87bd77f7adb96beaf768?rik=144XvMigWWj2bw&riu=http%3a%2f%2fwww.pngall.com%2fwp-content%2fuploads%2f5%2fUser-Profile-PNG-High-Quality-Image.png&ehk=%2bat%2brmqQuJrWL609bAlrUPYgzj%2b%2f7L1ErXRTN6ZyxR0%3d&risl=&pid=ImgRaw&r=0"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                    child: TitleText(
                                        text: userModel?.userName ??
                                            "User Name")),
                                FittedBox(
                                  child: SubtitleText(
                                    text: userModel?.userEmail ??
                                        "userName@gmail.com",
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleText(text: "General"),
                      user == null
                          ? const SizedBox.shrink()
                          : CustomListTile(
                              imagePath: AssetsManager.orderSvg,
                              text: 'All orders',
                              onTap: () async {
                                await Navigator.pushNamed(
                                    context, AppConstans.orderScreenRoot);
                              },
                            ),
                      user == null
                          ? const SizedBox.shrink()
                          : CustomListTile(
                              imagePath: AssetsManager.wishlistSvg,
                              text: 'WishList',
                              onTap: () async {
                                await Navigator.pushNamed(
                                    context, AppConstans.wishListRoot);
                              },
                            ),
                      CustomListTile(
                        imagePath: AssetsManager.recent,
                        text: 'Viewed recently',
                        onTap: () async {
                          await Navigator.pushNamed(
                              context, AppConstans.viewedRecentlyRoot);
                        },
                      ),
                      CustomListTile(
                        imagePath: AssetsManager.addresses,
                        text: 'Address',
                        onTap: () {},
                      ),
                      const Divider(),
                      const TitleText(text: "Settings"),
                      SwitchListTile(
                        activeThumbImage:
                            const AssetImage("assets/images/dark-mode.png"),
                        inactiveThumbImage:
                            const AssetImage("assets/images/light-mode.png"),
                        activeTrackColor: Colors.blueGrey,
                        inactiveTrackColor: Colors.amberAccent,
                        secondary: Image.asset(
                          AssetsManager.theme,
                          height: 30,
                        ),
                        title: Text(
                          themeProvider.getIsDarkTheme
                              ? "Dark Mode"
                              : "Light Mode",
                        ),
                        value: themeProvider.getIsDarkTheme,
                        onChanged: (val) {
                          themeProvider.setTheme(themeValue: val);
                        },
                      ),
                      const Divider(),
                      const TitleText(text: "Others"),
                      CustomListTile(
                        imagePath: AssetsManager.privacy,
                        text: "Privacy & Policy",
                        onTap: () async {
                          if (!connectivityService.isConnected) {
                            await ToastService.showToast(
                              backgroundColor: Colors.red,
                              leading: const Icon(Icons.wifi_off_sharp),
                              context,
                              message: "No internet connection",
                            );
                            return;
                          }
                          await _launchUrl();
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    label: Text(
                      user == null ? "Login" : "Logout",
                      style: const TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      user == null ? Icons.login_outlined : Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (user == null) {
                        //!login
                        await Navigator.pushReplacementNamed(
                            context, AppConstans.loginScreenRoot);
                      } else {
                        //!sign out
                        await MyAppMethods.customAlertDialog(context,
                            contentText: "Are you sure  ?",
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
                          await FirebaseAuth.instance.signOut();
                          if (!context.mounted) return;
                          await Navigator.pushReplacementNamed(
                            context,
                            AppConstans.loginScreenRoot,
                          );
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
