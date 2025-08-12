import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/furniture_provider.dart';
import 'package:furniture_shop_app/providers/wishlist_provider.dart';
import 'package:furniture_shop_app/screens/auth/sign_in_screen.dart';
import 'package:furniture_shop_app/screens/home/widget/furniture_cart.dart';
import 'package:furniture_shop_app/screens/wishlist/widgets/empty_wishlist.dart';
import 'package:furniture_shop_app/widgets/animated_list_item.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 8,
              right: 8,
              bottom: 8,
            ),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wishlist',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Consumer2<WishlistProvider, AuthProvider>(
                  builder: (context, wishlistProvider, authProvider, child) {
                    if (!authProvider.isLoggedIn ||
                        wishlistProvider.wishlistIds.isEmpty) {
                      return const SizedBox();
                    }
                    return IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Clear Wishlist'),
                            content: const Text(
                              'Are you sure you want to clear your wishlist? ',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cencel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  wishlistProvider.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.delete_outline),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer3<FurnitureProvider, WishlistProvider, AuthProvider>(
              builder: (context, furnitureProvider, wishlistProvider,
                  authProvider, child) {
                if (!authProvider.isLoggedIn) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sign in to view your wishlist',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create an account to save your favorite items',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final wishlistItems = furnitureProvider.items
                    .where((items) => wishlistProvider.isInWishlist(items.id))
                    .toList();

                if (wishlistItems.isEmpty) {
                  return EmptyWishlist();
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: wishlistItems.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    return AnimatedListItem(
                      index: index,
                      isVertical: false,
                      child: Hero(
                        tag: 'wishlist_${wishlistItems[index].id}',
                        child: FurnitureCart(
                          furniture: wishlistItems[index],
                          onTab: () {},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
