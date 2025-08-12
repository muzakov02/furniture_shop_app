import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furniture_shop_app/providers/furniture_provider.dart';
import 'package:furniture_shop_app/screens/category/category_screen.dart';
import 'package:furniture_shop_app/screens/detail/detail_screen.dart';
import 'package:furniture_shop_app/screens/home/widget/featured_items.dart';
import 'package:furniture_shop_app/screens/home/widget/furniture_cart.dart';
import 'package:furniture_shop_app/screens/home/widget/header.dart';
import 'package:furniture_shop_app/screens/home/widget/special_offer_widget.dart';
import 'package:furniture_shop_app/widgets/animated_list_item.dart';
import 'package:furniture_shop_app/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Header(),
                    // SizedBox(height: 20),
                    CustomSearchBar(),
                    SizedBox(height: 20),
                    _buildCategoryFilter(context)
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SpecialOfferWidget(),
            ),
            const SliverToBoxAdapter(
              child: FeaturedItems(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'All Products',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              sliver: _buildAllProducts(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAllProducts() {
    return Consumer<FurnitureProvider>(
      builder: (context, provider, child) {
        final furnitures = provider.items;

        if (furnitures.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'NO items found',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your search or filters',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return AnimatedListItem(
                index: index,
                isVertical: false,
                child: Hero(
                  tag: 'furniture_${furnitures[index].id}',
                  child: FurnitureCart(
                    furniture: furnitures[index],
                    onTab: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DetailScreen(
                            furniture: furnitures[index],
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
            childCount: furnitures.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.63,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Consumer<FurnitureProvider>(builder: (context, provider, child) {
      final categories = provider.categories;
      final selectedCategory = provider.selectedCategory;

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((categories) {
                final isSelected = categories == selectedCategory ||
                    (selectedCategory == null && categories == 'All');
                return _categoryButton(context, categories, isSelected);
              }).toList(),
            ),
          )
        ],
      );
    });
  }

  Widget _categoryButton(BuildContext context, String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final provider =
                Provider.of<FurnitureProvider>(context,listen: false);
              if(text == 'All'){
              provider.selectedCategory!;
              } else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:  (context)=>CategoryScreen(category: text),),

                );
              }

          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.yellow.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? Colors.yellow
                    : Colors.grey.withValues(alpha: 0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.yellow : Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.yellow,
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
