import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/shipping_address.dart';
import 'package:furniture_shop_app/providers/shipping_address_provider.dart';
import 'package:furniture_shop_app/screens/profile/widgets/add_edit_address_dialog.dart';
import 'package:provider/provider.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});

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
          'Shipping Addresses',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddEditAddressDialog(context),
            icon: Icon(
              Icons.add,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
      body: Consumer<ShippingAddressProvider>(
          builder: (context, addressProvider, child) {
        if (addressProvider.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No addresses added yet',
                  style: TextStyle(color: Colors.grey.shade600),
                )
              ],
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ...addressProvider.addresses.map(
              (address) => _buildAddressCard(
                context: context,
                address: address,
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildAddressCard({
    required BuildContext context,
    required ShippingAddress address,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              children: [
                Text(
                  address.name,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                if (address.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ]
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  address.address,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${address.city}, ${address.state}, ${address.zipCode}',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.phone,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                if (!address.isDefault)
                  const PopupMenuItem(
                    value: 'make_default',
                    child: Text('Make Default'),
                  ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              onSelected: (value) async {
                final provider = context.read<ShippingAddressProvider>();
                switch (value) {
                  case 'make_default':
                    await provider.setDefaultaddress(address.id);
                    break;
                  case 'edit':
                    _showAddEditAddressDialog(
                      context,
                      address: address,
                    );
                    break;
                  case 'delete':
                    final shouldDelate = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Address'),
                        content: const Text(
                            'Are you sure you want to delete this address?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if(shouldDelate == true){
                      await provider.deleteAddress(address.id);
                    }
                    break;
                }
              },
            ),
          ),

          if(!address.isDefault)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              child: TextButton(
                  onPressed: (){
                    context.read<ShippingAddressProvider>().setDefaultaddress(address.id);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.yellow,
                  ),
                  child: Text('Set as Default')),
            ),
        ],
      ),
    );
  }

  void _showAddEditAddressDialog(BuildContext context,
      {ShippingAddress? address}) {
    showDialog(
      context: context,
      builder: (context) => AddEditAddressDialog(
        address: address,
      ),
    );
  }
}
