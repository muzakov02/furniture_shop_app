import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
        title: 'Information We Collect',
        content:
            'We collect information that you provide directly to us, including:'
            '\n• Name and contact information'
            '\n• Account credentials'
            '\n• Payment information'
            '\n• Order history'
            '\n• Device information',
        icon: Icons.info_outline,
      ),
      _Section(
        title: 'How We Use Your Information',
        content: 'We use the information we collect to:'
            '\n• Process your orders'
            '\n• Provide customer support'
            '\n• Send important updates'
            '\n• Improve our services'
            '\n• Ensure security',
        icon: Icons.psychology_outlined,
      ),
      _Section(
        title: 'Information Sharing',
        content: 'We may share your information with:'
            '\n• Service providers'
            '\n• Payment processors'
            '\n• Delivery partners'
            '\n• Legal authorities when required',
        icon: Icons.share_outlined,
      ),
      _Section(
        title: 'Data Security',
        content:
            'We implement appropriate security measures to protect your personal information from unauthorized access.',
        icon: Icons.security_outlined,
      ),
      _Section(
        title: 'Your Rights',
        content: 'You have the right to:'
            '\n• Access your data'
            '\n• Correct your data'
            '\n• Delete your data'
            '\n• Object to processing'
            '\n• Data portability',
        icon: Icons.gavel_outlined,
      ),
      _Section(
        title: 'Contact Us',
        content:
            'If you have any questions about this Privacy Policy, please contact us at:'
            '\nEmail: privacy@furnitureshop.com'
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
        ]
      ),
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
              Icons.privacy_tip_outlined,
              size: 40,
              color: Colors.yellow.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Privacy Matters',
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
