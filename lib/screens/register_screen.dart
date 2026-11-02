import 'package:flutter/material.dart';
import 'package:flutter_api/utils/string_extensions.dart';
import 'package:flutter_api/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCategory;
  String? _selectedGender;

  final List<String> _categories = [
    'Student',
    'Developer',
    'Designer',
    'Manager',
    'Other',
  ];

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // 1. Check Form validation
    final isFormValid = _formKey.currentState?.validate() ?? false;

    // 2. Check Gender selection
    if (!isFormValid || _selectedGender == null) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your gender'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    // 3. Print the submitted values to console
    print('========================================');
    print('🎉 REGISTRATION FORM SUBMITTED:');
    print('Username : ${_usernameController.text.trim()}');
    print('Email    : ${_emailController.text.trim()}');
    print('Phone    : ${_phoneController.text.trim()}');
    print('Category : $_selectedCategory');
    print('Gender   : $_selectedGender');
    print('========================================');

    // 4. Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // 5. Reset all fields
    _resetForm();
  }

  void _resetForm() {
    FocusScope.of(context).unfocus();
    _usernameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _formKey.currentState?.reset();
    setState(() {
      _selectedCategory = null;
      _selectedGender = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Create an Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Please fill in your details below',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 24),

              // Username Field
              CustomTextFormField(
                controller: _usernameController,
                label: 'Username',
                hint: 'e.g. john_doe',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field with Extension Validation
              CustomTextFormField(
                controller: _emailController,
                label: 'Email',
                hint: 'e.g. john@example.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.trim().isValidEmail) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Number Field with Extension Validation
              CustomTextFormField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'e.g. 0987654321',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!value.trim().isValidPhone) {
                    return 'Please enter a valid phone number (10 digits)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select your category',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Gender Radio Section
              const Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  children: _genderOptions.map((gender) {
                    return RadioListTile<String>(
                      title: Text(gender),
                      value: gender,
                      groupValue: _selectedGender,
                      onChanged: (val) {
                        setState(() {
                          _selectedGender = val;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Registration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
