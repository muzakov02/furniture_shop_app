import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/cart_item.dart';
import 'package:furniture_shop_app/models/furniture.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/cart_provider.dart';
import 'package:furniture_shop_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class FurnitureCart extends StatefulWidget {
  final Furniture furniture;
  final VoidCallback? onTab;

  const FurnitureCart({
    super.key,
    required this.furniture,
    this.onTab,
  });

  @override
  State<FurnitureCart> createState() => _FurnitureCartState();
}

class _FurnitureCartState extends State<FurnitureCart> {
  bool isAddingToCart = false;

  void _toggleWishlist(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isLoggedIn) {
      return;
    }

    context.read<WishlistProvider>().toggleWishlist(widget.furniture.id);
  }

  void _addToCart(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isLoggedIn) {
      return;
    }

    setState(() => isAddingToCart = true);

    String defaultColor = widget.furniture.colors.isNotEmpty
        ? widget.furniture.colors[0]
        : '#FFFFFF';

    CartItem cartItem = CartItem(
      furniture: widget.furniture,
      quantity: 1,
      selectedColor: defaultColor,
    );

    context.read<CartProvider>().addToCart(cartItem);

    Future.delayed(const Duration(milliseconds: 500),() {
      if (mounted) {
        setState(() => isAddingToCart = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${widget.furniture.name} added to cart',
            ),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                context
                    .read<CartProvider>()
                    .removeFromCart(widget.furniture.id);
              },
            ),
          ),
        );
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardWith = MediaQuery.of(context).size.width / 2 - (16 * 1.5);
    final imageSize = cardWith;
    final contentHeight = cardWith * 0.95;
    return GestureDetector(
      onTap: widget.onTab,
      child: Container(
        width: cardWith,
        height: imageSize + contentHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: imageSize - 20,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.asset(
                        widget.furniture.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<WishlistProvider>(
                      builder: (context, wishlistProvider, child) {
                        final isInWishlist =
                            wishlistProvider.isInWishlist(widget.furniture.id);
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _toggleWishlist(context),
                              child: Icon(
                                isInWishlist
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isInWishlist ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.furniture.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.furniture.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: widget.furniture.hasSpecialOffer
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '\$${widget.furniture.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                    Text(
                                      '\$${widget.furniture.getDiscountedPrice(20).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '\$${widget.furniture.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color:
                                isAddingToCart ? Colors.green : Colors.yellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                                onTap: isAddingToCart
                                    ? null
                                    : () => _addToCart(context),

                              borderRadius: BorderRadius.circular(8),
                              child: Center(
                                child: Icon(
                                  isAddingToCart
                                      ? Icons.check
                                      : Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
