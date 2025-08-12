import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/faq.dart';
import 'package:furniture_shop_app/models/quick_help_item.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Help Center',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildSearchBar(),
          _buildQuickHelp(context),
          _buildFAQSection(),
          _buildContactSupport(context),
        ],
      ),
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Still Need Help?',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow.withValues(alpha: 0.1),
            ),
            child: Column(
              children: [
                const Text(
                  'Our support team is available 24/7 to help you with any questions or concerns',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )

                    ),
                    icon: const Icon(Icons.chat_outlined, color: Colors.white,),
                    label: const Text(
                      'Contact Support ',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      FAQ(
        question: 'How do I track my order?',
        answer:
            'You can track your order by going  to my Orders in your profile and selecting the specification',
      ),
      FAQ(
        question: 'What is your return policy?',
        answer:
            'We offer a 30-day return policy for most items. The item must be unused and in its original',
      ),
      FAQ(
        question: 'How long does delivery take?',
        answer:
            'Delivery typically takes 3-5 business days for standard shipping. Express shipping optional',
      ),
      FAQ(
        question: 'Do you offer assembly services?',
        answer:
            'Yes, we offer assembly services for most furniture items. You can select this option duration ',
      ),
    ];
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ExpansionPanelList.radio(
            elevation: 0,
            dividerColor: Colors.grey.shade200,
            children: faqs
                .map(
                  (faq) => ExpansionPanelRadio(
                    value: faq.question,
                    headerBuilder: (context, isExpanded) => ListTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    body: Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq.answer,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHelp(BuildContext context) {
    final quickHelp = [
      QuickHelpItem(
        icon: Icons.local_shipping_outlined,
        title: 'Track Order',
        onTab: () {},
      ),
      QuickHelpItem(
        icon: Icons.assignment_return_outlined,
        title: 'Returns',
        onTab: () {},
      ),
      QuickHelpItem(
        icon: Icons.payment_outlined,
        title: 'Payment',
        onTab: () {},
      ),
      QuickHelpItem(
        icon: Icons.support_agent_outlined,
        title: 'Live Chat',
        onTab: () {},
      ),
    ];

    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Help',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: quickHelp
                .map((item) => InkWell(
                      onTap: item.onTab,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              color: Colors.yellow.shade600,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for help',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
}
