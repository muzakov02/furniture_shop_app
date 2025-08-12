import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/furniture_provider.dart';
import 'package:furniture_shop_app/screens/detail/detail_screen.dart';
import 'package:furniture_shop_app/screens/home/widget/furniture_cart.dart';
import 'package:furniture_shop_app/widgets/animated_list_item.dart';
import 'package:provider/provider.dart';

class FeaturedItemsScreen extends StatelessWidget {
  const FeaturedItemsScreen({super.key});

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
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Featured Items',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<FurnitureProvider>(builder: (context, provider, child) {
        final featuredItems = provider.featuredItems;

        if (featuredItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No featured items available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: featuredItems.length,
            itemBuilder: (context, index) {
              return AnimatedListItem(
                isVertical: false,
                index: index,
                child: Hero(
                  tag: 'featured_${featuredItems[index].id}',
                  child: FurnitureCart(
                    furniture: featuredItems[index],
                    onTab: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                              DetailScreen(
                                furniture: featuredItems[index],
                              ),
                          transitionsBuilder: (context, animation,
                              secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration:
                          const Duration(milliseconds: 300),
                        ),
                      );
                    },
                  ),
                ),
              );
            });
      }),
    );
  }
}
