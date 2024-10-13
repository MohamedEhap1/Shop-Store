import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin_panel/models/dashboard_buttons._model.dart';
import 'package:shop_admin_panel/providers/theme_provider.dart';
import 'package:shop_admin_panel/widgets/custom_shimmer_app_name.dart';
import 'package:shop_admin_panel/widgets/dashboard_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const CustomShimmerAppName(
            text: "Shop Store",
            baseColor: Colors.purple,
            highlightColor: Colors.lightBlueAccent),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setTheme(themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(
              themeProvider.getIsDarkTheme
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          DashboardButtonsModel.dashboardButtonsList(context).length,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: DashboardButton(
              image: DashboardButtonsModel.dashboardButtonsList(context)[index]
                  .image,
              text: DashboardButtonsModel.dashboardButtonsList(context)[index]
                  .text,
              onTap: DashboardButtonsModel.dashboardButtonsList(context)[index]
                  .onTap,
            ),
          ),
        ),
      ),
    );
  }
}
