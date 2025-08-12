import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/cart_item.dart';
import 'package:furniture_shop_app/models/order.dart';
import 'package:furniture_shop_app/models/payment_method.dart';
import 'package:furniture_shop_app/models/shipping_address.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/cart_provider.dart';
import 'package:furniture_shop_app/providers/order_provider.dart';
import 'package:furniture_shop_app/providers/payment_method_provider.dart';
import 'package:furniture_shop_app/providers/shipping_address_provider.dart';
import 'package:furniture_shop_app/screens/profile/payment_method_screen.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  int _currentStep = 0;
  bool addressLoaded = false;
  String? _selectedPaymentMethodId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDefaultAddress();
      _loadDefaultPaymentMethod();
    });
  }

  void _loadDefaultAddress() {
    try {
      final shippingAddressProvider = context.read<ShippingAddressProvider>();
      final authProvider = context.read<AuthProvider>();

      if (authProvider.isLoggedIn) {
        final defaultAddress = shippingAddressProvider.defaultAddress;
        if (defaultAddress != null) {
          _nameController.text = defaultAddress.name;
          _emailController.text = authProvider.userEmail ?? '';
          _addressController.text = defaultAddress.address;
          _cityController.text = defaultAddress.city;
          _stateController.text = defaultAddress.state;
          _zipController.text = defaultAddress.zipCode;
          _phoneController.text = defaultAddress.phone;
        } else {
          _nameController.text = authProvider.userName ?? '';
          _emailController.text = authProvider.userEmail ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error loading default address: $e');
    }
  }

  void _loadDefaultPaymentMethod() {
    final paymentMethodProvider = context.read<PaymentMethodProvider>();
    final defaultMethod = paymentMethodProvider.defaultPaymentMethod;
    if (defaultMethod != null) {
      setState(() {
        _selectedPaymentMethodId = defaultMethod.id;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _processPayment(context);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentStep == 2 ? 'Please Order' : 'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.yellow),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Delivery Information'),
            content: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      }
                      if (!value!.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.home_outlined),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            prefixIcon: Icon(Icons.location_city_outlined),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(
                            labelText: 'State',
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your state';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP Code',
                      prefixIcon: Icon(Icons.pin_outlined),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your ZIP code';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Order Summary'),
            content: Column(
              children: [
                ...widget.cartItems.map((item) => _buildOrderItem(item)),
                const Divider(height: 32),
                _buildPriceRow('Subtotal', widget.total),
                const Divider(height: 8),
                _buildPriceRow('Shipping', 10.0),
                const Divider(height: 8),
                _buildPriceRow(
                  'Total',
                  widget.total + 10.0,
                  isTotal: true,
                ),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Payment'),
            content: _buildPaymentStep(),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }

  void _processPayment(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      setState(() => _currentStep = 0);
      return;
    }

    if (_selectedPaymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final shippingAddress = ShippingAddress(
        id: DateTime.now().toString(),
        name: _nameController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        zipCode: _zipController.text,
        phone: _phoneController.text,
      );

      final paymentMethod = context
          .read<PaymentMethodProvider>()
          .paymentMethods
          .firstWhere((method) => method.id == _selectedPaymentMethodId);

      final orderItems = widget.cartItems
          .map(
            (cartItem) => OrderItem(
              furniture: cartItem.furniture,
              quantity: cartItem.quantity,
              price: cartItem.furniture.price,
            ),
          ).toList();

      final subtotal = widget.total;
      const shippingCost = 10.0;
      const discount = 0.0;
      final total = subtotal + shippingCost - discount;

      final order = Order(
        id: '',
        items: orderItems,
        orderDate: DateTime.now(),
        status: OrderStatus.processing,
        subtotal: subtotal,
        shippingCost: shippingCost,
        discount: discount,
        total: total,
        shippingAddress: shippingAddress,
        paymentMethod: '${paymentMethod.cardType}  ending in ${paymentMethod.cardNumber.substring(paymentMethod.cardNumber.length - 4)}',
        estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
      );

      await context.read<OrderProvider>().addOrder(order);

      context.read<CartProvider>().clear();

      if(context.mounted) {
        Navigator.pop(context);

        await showDialog(
            context: context,
            builder: (context)=> AlertDialog(
              title: Text('Order Placed Successfully!'),
              content: Text('Thank you for your purchase. Your order will be delivered soon'),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.of(context).popUntil((route)=> route.isFirst);
                    },
                    child: const Text('OK'))
              ],
            ),
        );
      }
    } catch (e) {
      if(context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
            'Error placing order : ${e.toString()}'
          ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPaymentStep() {
    return Consumer<PaymentMethodProvider>(
        builder: (context, paymentMethodProvider, child) {
      final paymentMethods = paymentMethodProvider.paymentMethods;

      if (paymentMethods.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No payment methods added',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Add Payment Method',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        children: [
          ...paymentMethods.map((method) => _buildPaymentMethodTile(method)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentMethodScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.yellow,
            ),
            label: const Text(
              'Add New Card',
              style: TextStyle(color: Colors.yellow),
            ),
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.yellow,
                side: BorderSide(
                  color: Colors.yellow,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
          )
        ],
      );
    });
  }

  Widget _buildPaymentMethodTile(PaymentMethod method) {
    final isSelected = _selectedPaymentMethodId == method.id;
    final cardColor = Color(int.parse(method.cardColor));

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.yellow : Colors.grey.shade300!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedPaymentMethodId = method.id;
          });
        },
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.credit_card,
            color: Colors.white,
          ),
        ),
        title: Text(
          '${method.cardType} **** ${method.cardNumber.substring(method.cardNumber.length - 4)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Expires ${method.expiryDate}',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Colors.yellow,
              )
            : null,
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              : TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: isTotal
              ? TextStyle(
                  color: Colors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              : TextStyle(
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(
                  item.furniture.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.furniture.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item.quantity} x \$${item.furniture.price}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                          color: Color(int.parse(
                              item.selectedColor.replaceFirst('#', '0xFF'))),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Text(
            '\$${(item.furniture.price * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          )
        ],
      ),
    );
  }
}
