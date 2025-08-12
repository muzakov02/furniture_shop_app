import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/cart_provider.dart';
import 'package:furniture_shop_app/screens/cart/widgets/cart_total.dart';
import 'package:furniture_shop_app/screens/cart/widgets/empty_cart.dart';
import 'package:furniture_shop_app/screens/auth/sign_in_screen.dart';
import 'package:furniture_shop_app/screens/cart/widgets/cart_item_card.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
                  'Shopping Cart',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                Consumer2<CartProvider, AuthProvider>(
                    builder: (context, cartProvider, authProvider, child) {
                  if (!authProvider.isLoggedIn || cartProvider.items.isEmpty) {
                    return const SizedBox();
                  }
                  return IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Clear Cart'),
                            content: const Text(
                              'Are you sure you want to clear your cart? ',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cencel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  cartProvider.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline));
                })
              ],
            ),
          ),
          Expanded(
            child: Consumer2<CartProvider, AuthProvider>(
              builder: (context, cartProvider, authProvider, child) {
                if (!authProvider.isLoggedIn) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.grey.shade400,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sign in to view your cart',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create an account to start shopping',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
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
                if (cartProvider.items.isEmpty) {
                  return const EmptyCart();
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        itemCount: cartProvider.items.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.items[index];
                          return CartItemCard(
                            item: item,
                            onUndo: (cartItem)=> cartProvider.addToCart(cartItem),
                          );
                        },
                      ),
                    ),
                    CartTotal(
                      total: cartProvider.total,
                      cartItems: cartProvider.items,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
