import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/notification_provider.dart';
import 'package:furniture_shop_app/screens/auth/sign_in_screen.dart';
import 'package:furniture_shop_app/screens/legal/privacy_policy_screen.dart';
import 'package:furniture_shop_app/screens/legal/terms_of_service_screen.dart';
import 'package:furniture_shop_app/screens/profile/account_info_screen.dart';
import 'package:furniture_shop_app/screens/profile/change_password_screen.dart';
import 'package:furniture_shop_app/screens/profile/help_center_screen.dart';
import 'package:furniture_shop_app/screens/profile/notifications_screen.dart';
import 'package:furniture_shop_app/widgets/auth_bottom_sheet.dart';
import 'package:furniture_shop_app/widgets/dialogs/logout_dialog.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Account'),
            Consumer<AuthProvider>(
              builder: (context, auth, child) => _buildSettingItem(
                  icon: Icons.person_outline,
                  title: 'Account Information',
                  subtitle: auth.userEmail ?? 'Not signed in',
                  onTab: () => _handleAuthRequiredAction(
                      context,
                      message: 'Please sign in to view your account information',
                      onAction: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountInfoScreen(),
                          ),
                        );
                      },
                  ),
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, auth, child) => auth.isLoggedIn
                  ? _buildSettingItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Change your account password',
                      onTab: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      })
                  : const SizedBox.shrink(),
            ),
            _buildSectionTitle('Preferences'),
            Consumer2<AuthProvider, NotificationProvider>(
              builder: (context, auth, notificationProvider, child) =>
                  _buildSettingItem(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Manage notification settings',
                trailing: Switch(
                  value: auth.isLoggedIn && notificationProvider.pushEnabled,
                  onChanged: auth.isLoggedIn
                      ? (value) async {
                          await notificationProvider.setPushEnabled(value);
                        }
                      : null,
                  activeColor: Colors.yellow,
                ),
                    onTab: () => _handleAuthRequiredAction(
                      context,
                      message: 'Please sign in to view your settings',
                      onAction: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
              ),
            ),
            _buildSectionTitle('Support'),
            _buildSettingItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and find answer',
              onTab: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterScreen(),
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTab: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms of service',
              onTab: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServiceScreen(),
                  ),
                );
              },
            ),
            Consumer<AuthProvider>(
              builder: (context, auth, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (auth.isLoggedIn) ...[
                    _buildSectionTitle('Danger Zone'),
                    _buildSettingItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'sign out of your account',
                      textColor: Colors.red,
                      onTab: () => _handleSignInOut(context),
                    ),
                  ] else
                    _buildSettingItem(
                      icon: Icons.login,
                      title: 'Sign In',
                      subtitle: 'Sign in to access all features',
                      textColor: Colors.yellow,
                      onTab: () => _handleSignInOut(context),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTab,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? Colors.yellow).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? Colors.yellow.shade600,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
      onTap: onTab,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
