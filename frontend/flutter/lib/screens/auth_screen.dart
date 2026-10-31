import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback? onSuccess;

  const AuthScreen({super.key, this.onSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Controllers
  final _emailController = TextEditingController(text: 'rohan@srkr.edu.in');
  final _passwordController = TextEditingController(text: 'password123');
  final _nameController = TextEditingController(text: 'Rohan Varma');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _rollController = TextEditingController(text: '24A91A05XX');
  String _department = 'Computer Science';

  final _departments = [
    'Computer Science',
    'Mechanical Engineering',
    'Civil Engineering',
    'Electrical & Electronics',
    'Information Technology',
    'Electronics & Communication',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = false;
      if (_isLogin) {
        success = await ApiService().login(email: email, password: password);
      } else {
        final name = _nameController.text.trim();
        final phone = _phoneController.text.trim();
        final roll = _rollController.text.trim();

        if (name.isEmpty || phone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in your name and phone number')),
          );
          setState(() => _isLoading = false);
          return;
        }

        success = await ApiService().register(
          name: name,
          email: email,
          password: password,
          phone: phone,
          department: _department,
          rollNumber: roll.isNotEmpty ? roll : '24A91A05XX',
        );
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isLogin
                ? 'Welcome back, ${ApiService().currentUserName}! 👋'
                : 'Account created! Welcome to Campus Mart 🎉'),
            backgroundColor: AppColors.secondary,
          ),
        );
        widget.onSuccess?.call();
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isLogin
                ? 'Login failed. Check your credentials or verify backend is running.'
                : 'Registration failed. Email might already exist.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  void _fillDemoUser() {
    setState(() {
      _isLogin = true;
      _emailController.text = 'rohan@srkr.edu.in';
      _passwordController.text = 'password123';
    });
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Sign In' : 'Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campus Header Banner
            Center(
              child: Column(
                children: [
                  Image.network(
                    campusLogoUrl,
                    height: 56,
                    errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 56, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Campus Mart',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Verified Peer Marketplace for Engineering Students',
                    style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tab Toggle (Login / Register)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isLogin = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isLogin ? AppColors.surfaceContainerLowest : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _isLogin
                              ? const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _isLogin ? AppColors.primary : AppColors.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isLogin = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isLogin ? AppColors.surfaceContainerLowest : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: !_isLogin
                              ? const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: !_isLogin ? AppColors.primary : AppColors.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Register-only fields
            if (!_isLogin) ...[
              const Text('Full Name *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Rohan Varma',
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),

              const Text('WhatsApp Phone Number *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              const Text('Used for direct WhatsApp chat when buyers contact you.',
                  style: TextStyle(fontSize: 11, color: AppColors.outline)),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'e.g. +91 98765 43210',
                  prefixIcon: const Icon(Icons.chat_bubble_outline, color: AppColors.whatsappGreen, size: 20),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),

              const Text('Department *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _department,
                    isExpanded: true,
                    items: _departments.map((dep) {
                      return DropdownMenuItem(value: dep, child: Text(dep));
                    }).toList(),
                    onChanged: (val) => setState(() => _department = val!),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              const Text('College Roll Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _rollController,
                decoration: InputDecoration(
                  hintText: 'e.g. 24A91A05XX',
                  prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Email
            const Text('College Email Address *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'e.g. rohan@srkr.edu.in',
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),

            // Password
            const Text('Password *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        _isLogin ? 'Sign In to Campus Mart' : 'Create Student Account',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Demo Shortcut Button (Login as Rohan Varma)
            if (_isLogin)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primaryContainer),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _isLoading ? null : _fillDemoUser,
                  icon: const Icon(Icons.bolt, color: AppColors.primary, size: 18),
                  label: const Text('1-Tap Demo Sign In (Rohan Varma)'),
                ),
              ),
            const SizedBox(height: 20),

            // Trust notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, size: 20, color: AppColors.secondary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Safe & Verified: Peer marketplace restricted to engineering colleges. Payments happen directly in cash/UPI upon item inspection.',
                      style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
