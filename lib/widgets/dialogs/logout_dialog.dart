import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/user_provider.dart';
import 'package:furniture_shop_app/screens/auth/sign_in_screen.dart';
import 'package:provider/provider.dart';

class LogoutDialog {
  static Future<void> show(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure  you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if(confirmed == true &&  context.mounted){
      final authProvider = Provider.of<AuthProvider>(context,listen : false);
      final userProvider = Provider.of<UserProvider>(context,listen : false);
      await authProvider.signOut();
      userProvider.clearUser();

      if(context.mounted){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context)=> const SignInScreen()),
            (route)=>   false,
        );
      }

    }
  }
}
