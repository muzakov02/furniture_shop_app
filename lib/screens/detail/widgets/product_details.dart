import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/cart_item.dart';
import 'package:furniture_shop_app/models/furniture.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/cart_provider.dart';
import 'package:furniture_shop_app/widgets/auth_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final Furniture furniture;
  final Animation<double> contentAnimation;

  const ProductDetails({
    super.key,
    required this.furniture,
    required this.contentAnimation,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? _selectedColor;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.furniture.colors.isNotEmpty
        ? widget.furniture.colors[0]
        : '#FFFFFF';
  }

  void _addToCart() {
    if (_selectedColor == null) return;

    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isLoggedIn) {
      AuthBottomSheet.show(
        context,
        message: 'Please sign in to add items to your cart',
      );
      return;
    }
    setState(() => _isAddingToCart = true);

    final cartItem = CartItem(
      furniture: widget.furniture,
      quantity: 1,
      selectedColor: _selectedColor!,
    );

    Provider.of<CartProvider>(context, listen: false).addToCart(cartItem);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isAddingToCart = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.furniture.name} added to cart'),
            action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false)
                      .removeFromCart(widget.furniture.id);
                }),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.furniture.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.furniture.hasSpecialOffer) ...[
                      Text(
                        '\$${widget.furniture.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${widget.furniture.getDiscountedPrice(20).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ] else
                      Text(
                        '\$${widget.furniture.getDiscountedPrice(20).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.furniture.category,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.furniture.description,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Select color',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: widget.furniture.colors.map((colorHex) {
                final isSelected = colorHex == _selectedColor;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorHex;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.yellow : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(
                          int.parse(
                            colorHex.replaceFirst('#', '0XFF'),
                          ),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                  onPressed: _isAddingToCart ? null : _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isAddingToCart
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Add to cart',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
            )
          ],
        ),
      ),
    );
  }
}
