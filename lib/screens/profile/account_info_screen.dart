import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/user.dart';
import 'package:furniture_shop_app/providers/auth_provider.dart';
import 'package:furniture_shop_app/providers/user_provider.dart';
import 'package:furniture_shop_app/widgets/auth_widgets.dart';
import 'package:provider/provider.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user == null) {
      userProvider.setUser(User(
        name: auth.userName,
        email: auth.userEmail,
        numberSince: DateTime.now(),
      ));
    }

    _nameController =
        TextEditingController(text: userProvider.user?.name ?? auth.userName);
    _emailController =
        TextEditingController(text: userProvider.user?.email ?? auth.userEmail);
    _phoneController =
        TextEditingController(text: userProvider.user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges(){
    if(_formKey.currentState?.validate() ?? false){
      _formKey.currentState?.save();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Profile updated successfully'),
        backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Account Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if(_isEditing){
                  _saveChanges();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
              child: Text(
                _isEditing ? 'Save' : 'Edit',
                style: TextStyle(
                  color: Colors.yellow.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ))
        ],
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        final user = userProvider.user;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          backgroundImage: user?.profileImage != null
                              ? NetworkImage(user!.profileImage!)
                              : const AssetImage('assets/images/profile.png')
                                  as ImageProvider,
                        ),
                        if (_isEditing)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameController,
                    enabled: _isEditing,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  AuthTextField(
                    label: 'Email',
                    hint: 'Enter your  email',
                    controller: _emailController,
                    enabled: _isEditing,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter your email';
                      }
                      if(!value.contains('@')){
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: 'Phone',
                    hint: 'Enter your phone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    enabled: _isEditing,
                  ),
                  if(!_isEditing)...[
                    const SizedBox(height: 32),
                    _buildInfoCard(
                      title: 'Account Status',
                      content: user?.isActive == true ? 'Active' : 'Inactive',
                      icon: Icons.check_circle,
                      color: user?.isActive == true ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 32),
                    _buildInfoCard(
                      title: 'Member Since',
                      content: user?.numberSince != null
                          ? '${user?.numberSince!.month}/${user?.numberSince!.year}'
                      : 'N/A',

                      icon: Icons.calendar_today,
                      color: Colors.yellow,
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard ({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
