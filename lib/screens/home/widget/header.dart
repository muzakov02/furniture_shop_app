import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, AuthProvider>(
        builder: (context, userProvider, auth, child) {
      final user = userProvider.user;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello',
                style: TextStyle(color: Colors.grey),
              ),
              Text(user?.name ?? auth.userName ?? 'Guest User',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: user?.profileImage != null
                  ? NetworkImage(user!.profileImage!)
                  : const AssetImage('assets/images/profile.png')
                      as ImageProvider,
            ),
          )
        ]),
      );
    });
  }
}
