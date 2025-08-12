import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/social_link.dart';
import 'package:furniture_shop_app/models/value.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'About Us',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
          children: [
            _buildHeader(),
            _buildMission(),
            _buildValues(),
            _buildTeam(),
            _buildSocialMedia(),
            _buildAppInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Divider(
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 16),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Furniture Shop. All right reserved.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Privacy Policy'),
              ),
              const Text('.',style: TextStyle(fontSize: 20),),
              TextButton(
                onPressed: () {},
                child: Text('Terms of Service'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSocialMedia() {
    final socialLinks = [
      SocialLink(
        icon: Icons.facebook_outlined,
        name: 'Facebook',
        url: 'https://facebook.com',
      ),
      SocialLink(
        icon: Icons.camera_alt_outlined,
        name: 'Instagram',
        url: 'https://instagram.com',
      ),
      SocialLink(
        icon: Icons.phone_outlined,
        name: 'Contact',
        url: 'tel: +1234567890',
      ),
      SocialLink(
        icon: Icons.email_outlined,
        name: 'Email',
        url: 'mailto: support@furnitureshop.com',
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect With Us',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: socialLinks
                .map((link) => Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(link.icon),
                          color: Colors.yellow,
                          iconSize: 32,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          link.name,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildTeam() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our team',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'We are a team of passionate designers, craftsmen, and customer service professionals dedicated to bringing you the best furniture shopping experience.',
            style: TextStyle(
              height: 1.5,
              color: Colors.grey.shade600,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildValues() {
    final values = [
      Value(
        icon: Icons.verified_outlined,
        title: 'Quality',
        description: 'We never compromise on the quality of our products',
      ),
      Value(
        icon: Icons.design_services_outlined,
        title: 'Design',
        description: 'Every piece is crafted with attention to detail',
      ),
      Value(
        icon: Icons.eco_outlined,
        title: 'Sustainability',
        description:
            'We care about the environment and use sustainable materials ',
      ),
      Value(
        icon: Icons.support_agent_outlined,
        title: 'Service',
        description: 'Customer satisfaction is our top priority',
      ),
    ];
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Values',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: values.length,
              itemBuilder: (context, index) {
                final value = values[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        value.icon,
                        color: Colors.yellow,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        value.title,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget _buildMission() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Mission',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'To provide high-quality, stylish, and affordable furniture  that transforms hourses into homes. We believe everyone deserves to live in a space they love. ',
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.yellow.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chair_outlined,
              size: 60,
              color: Colors.yellow.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Furniture Shop',
            style: TextStyle(
                color: Colors.yellow.shade600,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            ' Your one-shop  destination for premium furniture',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
