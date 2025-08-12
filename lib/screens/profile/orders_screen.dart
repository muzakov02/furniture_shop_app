import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/order.dart';
import 'package:furniture_shop_app/providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

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
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
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
                        offset: const Offset(0, 2)),
                  ],
                ),
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(type: OrderListType.active),
                  _buildOrderList(type: OrderListType.completed),
                  _buildOrderList(type: OrderListType.cancelled),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList({required OrderListType type}) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {
      final orders = switch (type) {
        OrderListType.active => orderProvider.activeOrders,
        OrderListType.completed => orderProvider.completedOrders,
        OrderListType.cancelled => orderProvider.cancelledOrders,
      };

      if (orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No ${type.name} orders found',
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
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          order.id,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusText(order.status),
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM dd yyyy').format(
                              order.orderDate,
                            ),
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${order.items.length}items',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: 24,
                    color: Colors.grey.shade300,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$${order.total.toStringAsFixed(2)} ',
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (order.isActive) ...[
                    const SizedBox(height: 16),
                    LayoutBuilder(builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 300;
                      final buttonFlex = isWide ? 1 : 0;
                      return Flex(
                        direction: isWide ? Axis.horizontal : Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                if (order.tracingNumber != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Tracking Number: ${order.tracingNumber}'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  minimumSize: const Size(double.infinity, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                              child: const Text(
                                'Track Order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          if (order.status == OrderStatus.processing) ...[
                            SizedBox(
                              height: isWide ? 0 : 12,
                              width: isWide ? 12 : 0,
                            ),
                            Flexible(
                              flex: buttonFlex,
                              child: OutlinedButton(
                                onPressed: () async {
                                  final shouldCancel = await showDialog<bool>(
                                    context: context,
                                    builder: (context)=> AlertDialog(
                                      title: const Text('Cancel Order'),
                                      content: const Text(
                                        'Are you sure you want  to cancel this order?'
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: ()=> Navigator.pop(context, false),
                                            child: const Text('No'),),
                                        TextButton(
                                          onPressed: ()=> Navigator.pop(context, true),
                                          child: const Text('Yes'),),
                                      ],
                                    ),
                                  );
                                  if(shouldCancel == true){
                                    await context
                                        .read<OrderProvider>()
                                        .cancelOrder(order.id);
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    minimumSize: const Size(double.infinity, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                child: const Text('Cancel Order'),
                              ),
                            ),
                          ]
                        ],
                      );
                    }),
                  ]
                ],
              ),
            );
          });
    });
  }

  Color _getStatusColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.processing => Colors.orange,
      OrderStatus.confirmed => Colors.blue,
      OrderStatus.shipped => Colors.indigo,
      OrderStatus.outForDelivery => Colors.purple,
      OrderStatus.delivered => Colors.green,
      OrderStatus.cancelled => Colors.red,
    };
  }

  String _getStatusText(OrderStatus status) {
    return switch (status) {
      OrderStatus.processing => 'Processing',
      OrderStatus.confirmed => 'Confirmed',
      OrderStatus.shipped => 'Shipped',
      OrderStatus.outForDelivery => 'Out For Delivery',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.cancelled => 'Cancelled',
    };
  }
}

enum OrderListType { active, completed, cancelled }
