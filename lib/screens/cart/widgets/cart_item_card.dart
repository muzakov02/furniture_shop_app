import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/cart_item.dart';
import 'package:furniture_shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Function(CartItem)? onUndo;

  const CartItemCard({
    super.key,
    required this.item,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.furniture.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false)
            .removeFromCart(item.furniture.id);

        if (onUndo != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.furniture.name} removed from cart'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () => onUndo!(item),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 8)),
            ]),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: AssetImage(
                      item.furniture.imageUrl,
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    item.furniture.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                  item.selectedColor.replaceFirst('#', '0xFF')),
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300)),
                      ),
                      const SizedBox(width: 8),
                      if (item.furniture.hasSpecialOffer) ...[
                        Text(
                          '\$${item.furniture.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '\$${item.untilPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.yellow.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else
                        Text(
                          '\$${item.untilPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _buildQuantityButton(
                  context,
                  Icons.remove,
                    ()=> _updateQuantity(context, item.quantity - 1),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${item.quantity}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                _buildQuantityButton(
                  context,
                  Icons.add,
                      ()=> _updateQuantity(context, item.quantity + 1),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildQuantityButton (
      BuildContext context,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Icon(icon, size: 18, color: Colors.black87,),
        ),
      ),
    );
  }
  void _updateQuantity(BuildContext context, int newQuantity){
    if(newQuantity > 0){
      Provider.of<CartProvider>(context , listen: false).updateQuantity(
      item.furniture.id,
       newQuantity,
      );
    }
  }
}
