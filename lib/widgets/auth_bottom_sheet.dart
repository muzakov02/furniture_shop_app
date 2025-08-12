import 'package:flutter/material.dart';
import 'package:furniture_shop_app/screens/auth/sign_in_screen.dart';

class AuthBottomSheet extends StatelessWidget {
  final String message;
  final String? actionButtonText;
  final VoidCallback? onActionButtonPressed;

  const AuthBottomSheet({
    super.key,
    required this.message,
    this.actionButtonText,
    this.onActionButtonPressed,
  });

  static Future<void> show(
      BuildContext context, {
        required String message,
        String? actionButtonText,
        VoidCallback? onActionButtonPressed,
      }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => AuthBottomSheet(
        message: message,
        actionButtonText: actionButtonText,
        onActionButtonPressed: onActionButtonPressed,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Icon(
            Icons.lock_outline,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Sign in Required',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignInScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue as Guest',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          if (actionButtonText != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onActionButtonPressed,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(actionButtonText!),
            ),
          ]
        ],
      ),
    );
  }
}
