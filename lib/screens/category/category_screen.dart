import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/furniture_provider.dart';
import 'package:furniture_shop_app/screens/detail/detail_screen.dart';
import 'package:furniture_shop_app/screens/home/widget/furniture_cart.dart';
import 'package:furniture_shop_app/widgets/animated_list_item.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  final String category;

  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          category,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<FurnitureProvider>(
        builder: (context, provider, child) {
          final categoryItems = provider.getItemsByCategory(category);

          if (categoryItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No items found in this category',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
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
            itemCount: categoryItems.length,
            itemBuilder: (context, index) {
              return AnimatedListItem(
                index: index,
                isVertical: false,
                child: Hero(
                  tag: 'category_${categoryItems[index].id}',
                  child: FurnitureCart(
                    furniture: categoryItems[index],
                    onTab: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DetailScreen(furniture: categoryItems[index]),
                          transitionsBuilder:
                          (context, animation,secondaryAnimation, child){
                            return FadeTransition(
                                opacity: animation,
                            child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
