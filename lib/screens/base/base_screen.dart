import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:lojavirtual/screens/admin_users/admin_users_screen.dart';
import 'package:lojavirtual/screens/categories/categories_screen.dart';
import 'package:lojavirtual/screens/home/home_screen.dart';
import 'package:lojavirtual/screens/home/select_city_screen.dart';
import 'package:lojavirtual/screens/orders/orders_screen.dart';
import 'package:lojavirtual/screens/products/products_screen.dart';
import 'package:lojavirtual/screens/stores/stores_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    configFCM();
  }

  void configFCM(){
    final fcm = FirebaseMessaging();

    if(Platform.isIOS){
      fcm.requestNotificationPermissions(
        const IosNotificationSettings(provisional: true)
      );
    }

    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showNotification(
          message['notification']['title'] as String,
          message['notification']['body'] as String,
        );
      }
    );

  }

  void showNotification(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.shopping_cart, color: Colors.white,),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              CategoriesScreen(),
              //ProductsScreen(),
              OrdersScreen(),
              StoresScreen(),
              if(userManager.adminEnabled)
                ...[
                  AdminUsersScreen(),
                  AdminOrdersScreen(),
                ]
            ],
          );
        },
      ),
    );
  }
}