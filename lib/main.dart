import 'package:flutter/material.dart';
import 'package:lojavirtual/models/admin_user_manager.dart';
import 'package:lojavirtual/models/avaliation_manager.dart';
import 'package:lojavirtual/models/avalition.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/credit_card.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/orders_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/address/address_screen.dart';
import 'package:lojavirtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:lojavirtual/screens/avaliations/avaliations_screen.dart';
import 'package:lojavirtual/screens/avaliations/create_avaliation_screen.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/cart/cart_screen.dart';
import 'package:lojavirtual/screens/checkout/checkout_screen.dart';
import 'package:lojavirtual/screens/confirmation/confirmation_screen.dart';
import 'package:lojavirtual/screens/edit_product/create_product_screen.dart';
import 'package:lojavirtual/screens/edit_product/edit_product_screen.dart';
import 'package:lojavirtual/screens/home/home_screen.dart';
import 'package:lojavirtual/screens/home/select_city_screen.dart';
import 'package:lojavirtual/screens/home/splash_screen.dart';
import 'package:lojavirtual/screens/login/login_screen.dart';
import 'package:lojavirtual/screens/product/product_screen.dart';
import 'package:lojavirtual/screens/products/products_screen.dart';
import 'package:lojavirtual/screens/products_store/products_store_screen.dart';
import 'package:lojavirtual/screens/select_product/select_product_screen.dart';
import 'package:lojavirtual/screens/signup/signup_screen.dart';
import 'package:lojavirtual/screens/store/store_screen.dart';
import 'package:lojavirtual/screens/stores/stores_screen.dart';
import 'package:lojavirtual/screens/stores_category/stores_category_screen.dart';
import 'package:provider/provider.dart';

import 'models/admin_orders_manager.dart';
import 'models/stores_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => StoresManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CreditCard(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => AvaliationManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
          ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) =>
          adminOrdersManager..updateAdmin(
              adminEnabled: userManager.adminEnabled
          ),
        )
      ],
      child: MaterialApp(
        title: 'Êta Fome',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 128, 53, 73),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case '/orders':
              return MaterialPageRoute(builder: (_) => AdminOrdersScreen());
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(settings.arguments as Product));
            case '/stores':
              return MaterialPageRoute(
                  builder: (_) => StoresCategoryScreen(category: settings.arguments as String));
            case '/productsStore':
              return MaterialPageRoute(
                  builder: (_) => StoreScreen(settings.arguments as Store));
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
                settings: settings
              );
            case '/address':
              return MaterialPageRoute(builder: (_) => AddressScreen());
            case '/checkout':
              return MaterialPageRoute(builder: (_) => CheckoutScreen());
            case '/confirmation':
              return MaterialPageRoute(builder: (_) => ConfirmationScreen(
                settings.arguments as Order
              ));
            case '/select_product':
              return MaterialPageRoute(builder: (_) => SelectProductScreen());
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) => EditProductScreen(settings.arguments as Product));
            case '/create_product':
              return MaterialPageRoute(
                  builder: (_) => CreateProductScreen(settings.arguments as String));
            case '/select_city':
              return MaterialPageRoute(
                  builder: (_) => SelectCityScreen());
            case '/avaliations':
              return MaterialPageRoute(
                  builder: (_) => CreateAvaliationScreen(settings.arguments as String));
            case '/':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen(),
                  settings: settings
              );
          }
        },
      ),
    );
  }

}
