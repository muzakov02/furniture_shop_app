import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/screens/auth/sign_in_screen.dart';
import 'package:furniture_shop_app/screens/profile/about_us_screen.dart';
import 'package:furniture_shop_app/screens/profile/help_center_screen.dart';
import 'package:furniture_shop_app/screens/profile/notifications_screen.dart';
import 'package:furniture_shop_app/screens/profile/orders_screen.dart';
import 'package:furniture_shop_app/screens/profile/payment_method_screen.dart';
import 'package:furniture_shop_app/screens/profile/promo_codes_screen.dart';
import 'package:furniture_shop_app/screens/profile/shipping_address_screen.dart';
import 'package:furniture_shop_app/screens/profile/widgets/profile_info.dart';
import 'package:furniture_shop_app/screens/setting/settings_screen.dart';
import 'package:furniture_shop_app/widgets/auth_bottom_sheet.dart';
import 'package:furniture_shop_app/widgets/dialogs/logout_dialog.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _handleSignInOut(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    if (authProvider.isLoggedIn) {
      LogoutDialog.show(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    }
  }

  void _handleAuthRequiredAction(
    BuildContext context, {
    required String message,
    required VoidCallback onAction,
  }) {
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isLoggedIn) {
      AuthBottomSheet.show(
        context,
        message: message,
      );
      return;
    }
    onAction();
  }

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
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileInfo(),
                  SizedBox(height: 24),
                  _buildMenuSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.shopping_cart_outlined,
          title: 'My Orders',
          subtitle: 'View your order history',
          onTab: () => _handleAuthRequiredAction(
            context,
            message: 'Please sign in to view your orders',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrdersScreen(),
                ),
              );
            },
          ),
        ),
        _buildMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Shipping address',
          subtitle: 'Manage delivery addresses',
          onTab: () => _handleAuthRequiredAction(
            context,
            message: 'Please sign in to manage your  shipping addresses',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShippingAddressScreen(),
                ),
              );
            },
          ),
        ),
        _buildMenuItem(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          subtitle: 'Manage your payment options',
          onTab: () => _handleAuthRequiredAction(
            context,
            message: 'Please sign in to manage your payment methods.',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentMethodScreen(),
                ),
              );
            },
          ),
        ),
        _buildMenuItem(
          icon: Icons.local_offer_outlined,
          title: 'Promo Codes',
          subtitle: 'View available discounts',
          onTab: () => _handleAuthRequiredAction(
            context,
            message: 'Please sign in to view your promo codes.',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PromoCodesScreen(),
                ),
              );
            },
          ),
        ),
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Customize notification settings',
          onTab: () => _handleAuthRequiredAction(
            context,
            message: 'Please sign in to manage your notification.',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help Center',
          subtitle: 'Get help and support',
          onTab: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HelpCenterScreen(),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'About Us',
          subtitle: 'Learn more about our company ',
          onTab: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutUsScreen(),
              ),
            );
          },
        ),
        Consumer<AuthProvider>(builder: (context, auth, _) {
          final bool isLoggedIn = auth.isLoggedIn;

          return _buildMenuItem(
              icon: isLoggedIn ? Icons.logout : Icons.login,
              title: isLoggedIn ? 'Sign Out' : 'Sign In',
              subtitle: isLoggedIn
                  ? 'Sing out of your account'
                  : 'Sign in to access all features',
              onTab: () => _handleSignInOut(context),
              isSignOut: isLoggedIn);
        })
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTab,
    bool isSignOut = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSignOut
              ? Colors.red.withValues(alpha: 0.1)
              : Colors.yellow.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSignOut ? Colors.red : Colors.yellow.shade600,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isSignOut ? Colors.red : Colors.black.withValues(alpha: 0.8),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTab,
    );
  }
}
