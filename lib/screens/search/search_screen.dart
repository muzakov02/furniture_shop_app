import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/furniture_provider.dart';
import 'package:furniture_shop_app/screens/detail/detail_screen.dart';
import 'package:furniture_shop_app/screens/home/widget/furniture_cart.dart';
import 'package:furniture_shop_app/widgets/animated_list_item.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Provider.of<FurnitureProvider>(context, listen: false)
                          .setSearchQuery('');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        onChanged: (value) {
                          Provider.of<FurnitureProvider>(context, listen: false)
                              .setSearchQuery(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search furniture ...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    Provider.of<FurnitureProvider>(context,
                                            listen: false)
                                        .setSearchQuery('');
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer<FurnitureProvider>(builder: (context, provider, child) {
        final searchResult = provider.items;

        if (_searchController.text.isEmpty) {
          return _buildSuggestedSearches(context);
        }
        if (searchResult.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No items found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try searching with different keywords ',
                  style: TextStyle(
                    color: Colors.grey.shade500,
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
            itemBuilder: (context, index) {
              return AnimatedListItem(
                index: index,
                isVertical: false,
                child: Hero(
                  tag: 'search_${searchResult[index].id}',
                  child: FurnitureCart(
                    furniture: searchResult[index],
                    onTab: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DetailScreen(
                            furniture: searchResult[index],
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
            });
      }),
    );
  }

  Widget _buildSuggestedSearches(BuildContext context) {
    final categories = Provider.of<FurnitureProvider>(context).categories;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories.map((category) {
              return _buildSuggestionChip(
                  label: category,
                  onTap: () {
                    _searchController.text = category;
                    Provider.of<FurnitureProvider>(context, listen: false)
                        .setSearchQuery(category);
                  },
                  icon: _getCategoryIcon(category));
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              'Modern Chair',
              ' Sofa Set',
              ' Dining Table',
              'Bed',
              'Storage',
              'Office Chair',
              'Tv Cabinet',
              ' Coffee Table',
            ].map((term) {
              return _buildSuggestionChip(
                label: term,
                onTap: () {
                  _searchController.text = term;
                  Provider.of<FurnitureProvider>(context, listen: false)
                      .setSearchQuery(term);
                },
                icon: _getSearchTermIcon(term),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildSuggestionChip({
    required String label,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.yellow.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return Icons.grid_view_rounded;
      case 'chair':
        return Icons.chair_rounded;
      case 'sofa':
        return Icons.weekend_rounded;
      case 'table':
        return Icons.table_restaurant_rounded;
      case 'bed':
        return Icons.bed_rounded;
      case 'lamp':
        return Icons.light_rounded;
      case 'cabinet':
        return Icons.kitchen_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  IconData _getSearchTermIcon(String term) {
    if (term.toLowerCase().contains('chair')) {
      return Icons.chair_rounded;
    } else if (term.toLowerCase().contains('sofa')) {
      return Icons.weekend_rounded;
    } else if (term.toLowerCase().contains('table')) {
      return Icons.table_restaurant_rounded;
    } else if (term.toLowerCase().contains('bed')) {
      return Icons.bed_rounded;
    } else if (term.toLowerCase().contains('storage')) {
      return Icons.kitchen_rounded;
    } else if (term.toLowerCase().contains('tv')) {
      return Icons.tv_rounded;
    } else if (term.toLowerCase().contains('coffee')) {
      return Icons.coffee_rounded;
    } else {
      return Icons.search_rounded;
    }
  }
}
