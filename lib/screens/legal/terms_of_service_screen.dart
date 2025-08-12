import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          'Terms of Service',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final sections = [
      _Section(
        title: 'Acceptance of Terms',
        content:
            'By accessing and using our services, you agree to be bound by these Terms of Service.',
        icon: Icons.check_circle_outline,
      ),
      _Section(
        title: 'User Accounts',
        content: ' •You must be at least 18 years old to create an account'
            '\n• You are responsible for maintaining account security'
            '\n• You agree to provide accurate information'
            '\n• One person may only create one account',
        icon: Icons.person_outline,
      ),
      _Section(
        title: 'Orders and Payments',
        content: ' • All prices are in USD unless otherwise stated'
            '\n• Orders are subject to availability'
            '\n• We reserve the right to refuse service'
            '\n• Payment must be made in full before delivery'
            '\n• Prices may change without notice',
        icon: Icons.shopping_cart_outlined,
      ),
      _Section(
        title: 'Shipping and Delivery',
        content: ' • Delivery times are estimates only'
            '\n• Risk passes to you upon delivery'
            '\n• You must inspect items upon delivery'
            '\n• Additional charges may apply for remote areas'
            '\n• We are not responsible for delays beyond our control',
        icon: Icons.local_shipping_outlined,
      ),
      _Section(
        title: 'Returns and Refunds',
        content: '• 30-day return policy for unused items'
            '\n• Items must be in original packaging'
            '\n• Shipping costs for returns are your responsibility'
            '\n• Some items may not be returnable'
            '\n• Refunds will be processed within 14 days',
        icon: Icons.replay_outlined,
      ),
      _Section(
        title: 'Product Information',
        content: '• Product images are illustrative only'
            '\n• We strive for accurate descriptions'
            '\n• Colors may vary due to display settings'
            '\n• Dimensions may have slight variations'
            '\n• Specifications may change without notice',
        icon: Icons.info_outline,
      ),
      _Section(
        title: 'Intellectual Property',
        content:
            'All content on our platform is protected by copyright and other intellectual property right',
        icon: Icons.copyright_outlined,
      ),
      _Section(
        title: 'Limitation of Liability',
        content:
        ' We are not liable for any indirect, incidental, special, or consequential damages arising',
        icon: Icons.gavel_outlined,
      ),
      _Section(
        title: 'Changes to Terms',
        content:
        ' We may modify these terms at any time. Continued use of our services after changes consti',
        icon: Icons.update_outlined,
      ),
      _Section(
        title: 'Contact Information',
        content: 'For any questions about these Terms of Service, please contact us:'
            '\n\nEmail: legal@furnitureshop.com'
            '\nPhone: +1 234 567 890'
            '\nAddress: 123 Furniture Street, Design City, DC 12345',
        icon: Icons.contact_support_outlined,
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: sections.map((section) {
          return _buildSection(section);
        }).toList(),
      ),
    );
  }

  Widget _buildSection(_Section section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ]),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.yellow.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            section.icon,
            color: Colors.yellow.shade600,
            size: 24,
          ),
        ),
        title: Text(
          section.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Text(
            section.content,
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildHeader() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.yellow.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.yellow.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.description_outlined,
            size: 40,
            color: Colors.yellow.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Terms of Service',
          style: TextStyle(
              fontSize: 24,
              color: Colors.yellow.shade600,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Last updated : March 2024',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}

class _Section {
  final String title;
  final String content;
  final IconData icon;

  _Section({
    required this.title,
    required this.content,
    required this.icon,
  });
}
