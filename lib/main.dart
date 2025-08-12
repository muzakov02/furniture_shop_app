import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furniture_shop_app/app_starter.dart';
import 'package:furniture_shop_app/providers/app_state_provider.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/blog_provider.dart';
import 'package:furniture_shop_app/providers/cart_provider.dart';
import 'package:furniture_shop_app/providers/furniture_provider.dart';
import 'package:furniture_shop_app/providers/notification_provider.dart';
import 'package:furniture_shop_app/providers/order_provider.dart';
import 'package:furniture_shop_app/providers/payment_method_provider.dart';
import 'package:furniture_shop_app/providers/promo_code_provider.dart';
import 'package:furniture_shop_app/providers/shipping_address_provider.dart';
import 'package:furniture_shop_app/providers/special_offer_provider.dart';
import 'package:furniture_shop_app/providers/user_provider.dart';
import 'package:furniture_shop_app/providers/wishlist_provider.dart';
import 'package:furniture_shop_app/theme/app_theme.dart';
import 'package:provider/provider.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
   const  SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx)=> AppStateProvider()),
        ChangeNotifierProvider(create: (ctx)=> AuthProvider()),
        ChangeNotifierProvider(create: (ctx)=> UserProvider()),
        ChangeNotifierProvider(create: (ctx)=> FurnitureProvider()),
        ChangeNotifierProvider(create: (ctx)=> SpecialOfferProvider()),
        ChangeNotifierProvider(create: (ctx)=> WishlistProvider()),
        ChangeNotifierProvider(create: (ctx)=> CartProvider()),
        ChangeNotifierProvider(create: (ctx)=> BlogProvider()),
        ChangeNotifierProvider(create: (ctx)=> OrderProvider()),
        ChangeNotifierProvider(create: (ctx)=> ShippingAddressProvider()),
        ChangeNotifierProvider(create: (ctx)=> PaymentMethodProvider()),
        ChangeNotifierProvider(create: (ctx)=> PromoCodeProvider()),
        ChangeNotifierProvider(create: (ctx)=> NotificationProvider()),








      ],
      child: MaterialApp(
        title: 'Furniture shop app',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AppStarter(),
      ),
    );
  }
}

