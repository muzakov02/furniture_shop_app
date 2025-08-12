import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furniture_shop_app/providers/promo_code_provider.dart';
import 'package:provider/provider.dart';

class PromoCodesScreen extends StatelessWidget {
  const PromoCodesScreen({super.key});

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
          'Promo codes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.all(3),
                indicator: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]),
                tabs: [
                  Tab(text: 'Available'),
                  Tab(text: 'Used'),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(children: [
              _buildPromoCodesList(isAvailable: true),
              _buildPromoCodesList(isAvailable: false),
            ]))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _buildPromoCodeDialog(context),
          );
        },
        backgroundColor: Colors.yellow,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPromoCodesList({required bool isAvailable}) {
    return Consumer<PromoCodeProvider>(
      builder: (context, promoCodesProvider, child) {
        final promoCodes = isAvailable
            ? promoCodesProvider.availablePromoCodes
            : promoCodesProvider.usedPromoCodes;

        if (promoCodes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isAvailable ? Icons.local_offer_outlined : Icons.history,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  isAvailable
                      ? 'No promo codes available'
                      : 'No used promo codes',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: promoCodes.length,
          itemBuilder: (context, index) {
            final promoCode = promoCodes[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200!),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      children: [
                        Text(
                          promoCode.code,
                          style: TextStyle(
                            fontSize: 18,
                            color: promoCode.isExpired
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        if (!promoCode.isExpired && !promoCode.isUsed)
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: promoCode.code));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Promo cody copied to clipboard'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.copy_outlined,
                              ))
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: promoCode.isExpired || promoCode.isUsed
                                ? Colors.grey.shade200
                                : Colors.yellow.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            promoCode.discount,
                            style: TextStyle(
                              color: promoCode.isExpired || promoCode.isUsed
                                  ? Colors.grey
                                  : Colors.yellow,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          promoCode.description,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Valid until ${_formatDate(promoCode.validUntil)}',
                          style: TextStyle(
                            color: promoCode.isExpired
                                ? Colors.red
                                : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildPromoCodeDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: Text(
        'Add Promo Code',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: 'Enter promo code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        textCapitalization: TextCapitalization.characters,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        Consumer<PromoCodeProvider>(
            builder: (context, promoCodeProvider, child) {
          return ElevatedButton(
            onPressed: () async {
              final success =
                  await promoCodeProvider.addPromoCode(controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Promo code added successfully'
                        : 'Invalid promo code',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child: Text(
              'Apply',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        })
      ],
    );
  }
}
