import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/furniture.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/wishlist_provider.dart';
import 'package:furniture_shop_app/screens/detail/widgets/product_details.dart';
import 'package:furniture_shop_app/widgets/auth_bottom_sheet.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final Furniture furniture;

  const DetailScreen({
    super.key,
    required this.furniture,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _contentAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleWishlist(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isLoggedIn) {
      AuthBottomSheet.show(
        context,
        message: 'Please sign in to add items to your wishlist',
      );
      return;
    }
    context.read<WishlistProvider>().toggleWishlist(widget.furniture.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.45;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          SizedBox(
            height: imageHeight + topPadding,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: 'furniture_${widget.furniture.id}',
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemCount: widget.furniture.images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: Image.asset(
                            widget.furniture.images[index],
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: topPadding + 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircularButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      Consumer<WishlistProvider>(
                          builder: (context, wishlistProvider, child) {
                        final isInWishlist =
                            wishlistProvider.isInWishlist(widget.furniture.id);
                        return _buildCircularButton(
                          icon: isInWishlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          onTap: () => _toggleWishlist(context),
                          iconColor: isInWishlist ? Colors.red : null,
                        );
                      })
                    ],
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.furniture.images.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? Colors.yellow
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
              child: ProductDetails(
                furniture: widget.furniture,
                contentAnimation: _contentAnimation,
              ),)
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ]),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}
