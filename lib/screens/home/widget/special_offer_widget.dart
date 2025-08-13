import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/special_offer_provider.dart';
import 'package:furniture_shop_app/screens/home/special_offers_screen.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SpecialOfferWidget extends StatefulWidget {
  const SpecialOfferWidget({super.key});

  @override
  State<SpecialOfferWidget> createState() => _SpecialOfferWidgetState();
}

class _SpecialOfferWidgetState extends State<SpecialOfferWidget> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpecialOfferProvider>(
      builder: (context, provider, child) {
        final offers = provider.specialOffers;

        if (offers.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpecialOffersScreen(offerId: offer.id),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 180,
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/sale.png',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          offer.title,
                                          style: TextStyle(
                                            color: Colors.yellow.shade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${offer.discountPercentage.toStringAsFixed(0)} % off',
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        offer.description,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.yellow.shade800,
                                            elevation: 0,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 6,
                                            ),
                                            minimumSize: const Size(0, 32),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Shop now',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ]),
                        ),
                      );
                    }),
              ),
              if (offers.length > 1)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: offers.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                      activeDotColor: Colors.yellow,
                      dotColor: Colors.grey.shade300,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
