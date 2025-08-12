import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/payment_method.dart';
import 'package:furniture_shop_app/providers/payment_method_provider.dart';
import 'package:provider/provider.dart';

class AddEditCardDialog extends StatefulWidget {
  final PaymentMethod? method;

  const AddEditCardDialog({
    super.key,
    this.method,
  });

  @override
  State<AddEditCardDialog> createState() => _AddEditCardDialogState();
}

class _AddEditCardDialogState extends State<AddEditCardDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cardTypeController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _cardHolderNameController;
  late bool _isDefault;
  String _selectColor = '0XFF1A237E';

  @override
  void initState() {
    super.initState();
    _cardTypeController = TextEditingController(text: widget.method?.cardType);
    _cardNumberController =
        TextEditingController(text: widget.method?.cardNumber);
    _expiryDateController =
        TextEditingController(text: widget.method?.expiryDate);
    _cardHolderNameController =
        TextEditingController(text: widget.method?.cardHolderName);
    _isDefault = widget.method?.isDefault ?? false;
    _selectColor = widget.method?.cardColor ?? '0XFF1A237E';
  }

  @override
  void dispose() {
    _cardTypeController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cardHolderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.method == null ? 'Add New Card' : 'Edit Card',
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
              DropdownButtonFormField<String>(
                value: _cardTypeController.text.isEmpty
                    ? 'Visa'
                    : _cardTypeController.text,
                decoration: const InputDecoration(
                  labelText: 'Card Type',
                ),
                items: ['Visa', 'MasterCard', 'American Express']
                    .map((type) =>
                    DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _cardTypeController.text = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                ),
                validator: (value) =>
                value?.isEmpty == true ? 'Please enter card number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                ),
                validator: (value) =>
                value?.isEmpty == true ? 'Please enter expiry date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardHolderNameController,
                decoration: const InputDecoration(
                  labelText: 'Card Holder Name',
                ),
                validator: (value) =>
                value?.isEmpty == true
                    ? 'Please enter card holder name'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectColor,
                decoration: const InputDecoration(
                  labelText: 'Card Color',
                ),
                items: [
                  DropdownMenuItem(
                    value: '0XFF1A237E',
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(0xFF1A237E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Blue'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: '0XFFB71C1C',
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(0xFFB71C1C),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Red'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: '0XFF1B5E20',
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(0xFF1B5E20),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Green'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(
                          () {
                        _selectColor = value;
                      },
                    );
                  }
                },
              ),
              const SizedBox(width: 16),
              CheckboxListTile(
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                title: Text('Set as default card'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
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
            onPressed: _saveCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child: Text(
              widget.method == null ? 'Add' : 'Save',
              style: const TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  void _saveCard() {
    if (_formKey.currentState?.validate() == true) {
      final provider = context.read<PaymentMethodProvider>();
      final method = PaymentMethod(
        id: widget.method?.id?? '',
        cardType: _cardTypeController.text,
        cardNumber: _cardNumberController.text,
        expiryDate: _expiryDateController.text,
        cardHolderName: _cardHolderNameController.text,
        cardColor: _selectColor,
      isDefault: _isDefault,
      );

      if(widget.method != null){
        provider.updatePaymentMethod(method);
      } else {
        provider.addPaymentMethod(method);
      }
      Navigator.pop(context);
    }
  }
}
