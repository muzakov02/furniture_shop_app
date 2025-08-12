import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/cart_provider.dart';
import 'package:furniture_shop_app/providers/user_provider.dart';
import 'package:furniture_shop_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, AuthProvider>(
      builder: (context, userProvider, authProvider, child) {
        final user = userProvider.user;
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: user?.profileImage != null
                        ? NetworkImage(user!.profileImage!)
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: (){},
                child: Column(
                  children: [
                    Text(
                      user?.name ?? authProvider.userName ?? 'Guest User',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),

                    Text(
                      user?.email ?? authProvider.userEmail ?? 'Guest User',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Consumer2<CartProvider, WishlistProvider>(
                  builder: (context, cartProvider, wishlistProvider, child){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('Order', '2'),
                        _buildStatItem('Cart', cartProvider.itemCount.toString()),
                        _buildStatItem('Wishlist', wishlistProvider.wishlistIds.length.toString()),
                      ],
                    );
                  })
            ],
          ),
        );
      },
    );
  }
  Widget _buildStatItem(String label, String value){
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
              fontWeight: FontWeight.w400
          ),
        )
      ],
    );
  }
}
