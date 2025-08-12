import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/app_state_provider.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
class AppStarter extends StatelessWidget {
  const AppStarter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppStateProvider , AuthProvider>(
    builder : (context , appState, auth, child){
      if (!appState.isInitialized){
        appState.initializeApp();
        auth.initializeAuth();
        return const Center(
          child: CircularProgressIndicator() ,
        );
      }
      return const SplashScreen();
    },

    );
  }
}
