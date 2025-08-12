import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/shipping_address.dart';
import 'package:furniture_shop_app/providers/shipping_address_provider.dart';
import 'package:provider/provider.dart';

class AddEditAddressDialog extends StatefulWidget {
  final ShippingAddress? address;

  const AddEditAddressDialog({
    super.key,
    this.address,
  });

  @override
  State<AddEditAddressDialog> createState() => _AddEditAddressDialogState();
}

class _AddEditAddressDialogState extends State<AddEditAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipController;
  late final TextEditingController _phoneController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name);
    _addressController = TextEditingController(text: widget.address?.address);
    _cityController = TextEditingController(text: widget.address?.city);
    _stateController = TextEditingController(text: widget.address?.state);
    _zipController = TextEditingController(text: widget.address?.zipCode);
    _phoneController = TextEditingController(text: widget.address?.phone);
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.address == null ? 'Add new Address' : 'Edit Address',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name(e.g., Home, Office)',
                ),
                validator: (value) =>
                value?.isEmpty == true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                ),
                validator: (value) =>
                value?.isEmpty == true ? 'Please enter an address ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                ),
                validator: (value) =>
                value?.isEmpty == true ? 'Please enter a city ' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                      ),
                      validator: (value) =>
                      value?.isEmpty == true
                          ? 'Please enter a state '
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _zipController,
                      decoration: InputDecoration(
                        labelText: 'ZIP Code',
                      ),
                      validator: (value) =>
                      value?.isEmpty == true
                          ? 'Please enter a ZIP Code '
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) =>
                value?.isEmpty == true
                    ? 'Please enter a phone number '
                    : null,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                title: const Text('Set as default address'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() == true) {
                final provider = context.read<ShippingAddressProvider>();
                final newAddress = ShippingAddress(
                  id: widget.address?.id ?? '',
                  name: _nameController.text,
                  address: _addressController.text,
                  city: _cityController.text,
                  state: _cityController.text,
                  zipCode: _zipController.text,
                  phone: _phoneController.text,
                  isDefault: _isDefault,
                );

                if(widget.address != null){
                  await provider.updateAddress(newAddress);
                } else{
                  await provider.addAddresses(newAddress);
                }

                if(context.mounted){
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child: Text(
              widget.address == null ? 'Add' : 'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ))
      ],
    );
  }
}
