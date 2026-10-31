import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../services/api_service.dart';

class SellScreen extends StatefulWidget {
  final Function(Listing) onPublish;
  final VoidCallback onCancel;

  const SellScreen({
    super.key,
    required this.onPublish,
    required this.onCancel,
  });

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _titleController = TextEditingController(text: 'Omega Mini Drafter with Case & Clips');
  final _sellingPriceController = TextEditingController(text: '450');
  final _originalPriceController = TextEditingController(text: '1200');
  final _descController = TextEditingController(
    text: 'Complete Omega 360-degree mini drafter. Protractor head is smoothly calibrated, zero wobble on tightening knob. Includes padded water-resistant carry bag and dual steel clamps.',
  );
  final _spotController = TextEditingController(text: 'SRKR Mechanical Block / Central Library, Bhimavaram');
  final _branchController = TextEditingController(text: 'Engineering First Year (All Branches)');
  final _semController = TextEditingController(text: 'Sem 1 & Sem 2');
  final _subjectController = TextEditingController(text: 'Engg Graphics (EG)');
  final _phoneController = TextEditingController(text: ApiService().currentUserPhone);

  String _selectedCategory = 'Drafters';
  Condition _selectedCondition = Condition.likeNew;
  bool _isNegotiable = true;
  bool _isAcademicOpen = true;

  final List<String> _photos = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCFsBI-jYBDC9S4Ljf6CszniaqmVnVeSSTy2cGVDQQRUzX2AAIUrsPThMKhDA0cTuYenoGdVc1aGAaqs6PJaQHrH-ftuavK4w10gcGZWPi-HmXi9Er9qeGzq_2UtcHUYa7qxK8E74vvThvifUX3EFWsA_1OEqwtVObh-c-J2_foZV3epm-rZpiq-Uu6E6yuG1X4ODzS-eLmTW3WxP709Qa2fodi1c7WiB4UxdRN9jNGmpuPjsx2oZA',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuARog2td9ulqtV85YWDgIuggmN_to2BgD6qPajN-AtIrJNUSXwdaOzYeCRrQwzIrIIl98TzHjFLJJtGIpR9-GDn0czDAXq5V5U9G28a-fH_Z-9-OM0dactb9TUF9--TJH0VSF5iXrebvNbqrvy1Ir18RGV2rDK4KXFyuqNSPhkan0CyKMoJfTmdDQILbdoLb6t90w8aO1-amlM-yuhT_-NjiMlwC3OcyI0JSzah_2vjKBhG1uzKu3QX',
  ];

  int get _savings {
    final orig = int.tryParse(_originalPriceController.text) ?? 0;
    final sell = int.tryParse(_sellingPriceController.text) ?? 0;
    return orig > sell ? orig - sell : 0;
  }

  int get _discountPct {
    final orig = int.tryParse(_originalPriceController.text) ?? 0;
    if (orig <= 0) return 0;
    return ((_savings / orig) * 100).round();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a listing title')),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your WhatsApp contact number')),
      );
      return;
    }

    final newListing = Listing(
      id: 'CM-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: _titleController.text.trim(),
      category: _selectedCategory,
      condition: _selectedCondition,
      price: int.tryParse(_sellingPriceController.text) ?? 400,
      originalPrice: int.tryParse(_originalPriceController.text) ?? 1000,
      discountPercent: _discountPct,
      images: _photos.isNotEmpty
          ? _photos
          : ['https://lh3.googleusercontent.com/aida-public/AB6AXuCFsBI-jYBDC9S4Ljf6CszniaqmVnVeSSTy2cGVDQQRUzX2AAIUrsPThMKhDA0cTuYenoGdVc1aGAaqs6PJaQHrH-ftuavK4w10gcGZWPi-HmXi9Er9qeGzq_2UtcHUYa7qxK8E74vvThvifUX3EFWsA_1OEqwtVObh-c-J2_foZV3epm-rZpiq-Uu6E6yuG1X4ODzS-eLmTW3WxP709Qa2fodi1c7WiB4UxdRN9jNGmpuPjsx2oZA'],
      department: _branchController.text.trim(),
      semester: _semController.text.trim(),
      subjectCode: _subjectController.text.trim(),
      seller: Seller(
        name: ApiService().currentUserName.isNotEmpty ? ApiService().currentUserName : 'Rohan Varma (You)',
        avatar: userAvatarUrl,
        role: 'Student',
        department: _branchController.text.trim(),
        batch: "'28",
        isRollVerified: true,
        rating: 5.0,
        peerSalesCount: 1,
        replyTime: '~5m',
        phone: _phoneController.text.trim(),
      ),
      location: _spotController.text.trim(),
      handoverType: 'Campus Pickup',
      listedTimeAgo: 'Just now',
      description: _descController.text.trim(),
      isNegotiable: _isNegotiable,
      isFeatured: true,
    );

    widget.onPublish(newListing);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-header status & actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: AppColors.secondary),
                  SizedBox(width: 6),
                  Text('Draft saved just now', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                ],
              ),
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Discard', style: TextStyle(color: AppColors.onSurfaceVariant)),
              ),
            ],
          ),

          // Step Progress
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Step 1 of 2: Item Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('50% Completed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                const LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: AppColors.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: 6),
                const Text('Next: Meetup timing & campus delivery spot', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Photo Upload Area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Item Photos', style: Theme.of(context).textTheme.labelLarge),
              Text('${_photos.length} of 5 uploaded', style: const TextStyle(fontSize: 12, color: AppColors.outline)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Add photo button
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sample photo attached from library!')),
                  );
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: AppColors.primary, size: 24),
                      SizedBox(height: 4),
                      Text('+ Add Photo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text('Up to 5 MB', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Uploaded Photos
              ..._photos.asMap().entries.map((entry) {
                final idx = entry.key;
                final url = entry.value;
                return Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(url, width: 90, height: 90, fit: BoxFit.cover),
                      ),
                      if (idx == 0)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.inverseSurface.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 9)),
                          ),
                        ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _photos.removeAt(idx)),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Clear photos of corners, scale numbers & serial code sell 3x faster.', style: TextStyle(fontSize: 11, color: AppColors.outline)),
          const SizedBox(height: 16),

          // Listing Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Listing Title *', style: Theme.of(context).textTheme.labelLarge),
              Text('${_titleController.text.length}/70', style: const TextStyle(fontSize: 11, color: AppColors.outline)),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            maxLength: 70,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: const Icon(Icons.title, color: AppColors.outline),
              filled: true,
              fillColor: AppColors.surfaceContainerLowest,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),

          // Academic Category
          Text('Academic Category *', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: categories.where((c) => c != 'All').map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Item Condition (2x2 Grid)
          Text('Item Condition *', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: Condition.values.map((cond) {
              final isSelected = _selectedCondition == cond;
              return InkWell(
                onTap: () => setState(() => _selectedCondition = cond),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryFixed.withValues(alpha: 0.3) : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 14,
                            color: isSelected ? AppColors.primary : AppColors.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            cond.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.primary : AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cond.description,
                        style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Collapsible Academic Relevance
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(() => _isAcademicOpen = !_isAcademicOpen),
                    child: Row(
                      children: [
                        const Icon(Icons.school, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text('Academic Relevance', style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Icon(_isAcademicOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.outline),
                      ],
                    ),
                  ),
                  if (_isAcademicOpen) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _branchController,
                      decoration: const InputDecoration(
                        labelText: 'Target Branch / Stream',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _semController,
                            decoration: const InputDecoration(
                              labelText: 'Semester',
                              filled: true,
                              fillColor: AppColors.surfaceContainerLow,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _subjectController,
                            decoration: const InputDecoration(
                              labelText: 'Subject Code / Name',
                              filled: true,
                              fillColor: AppColors.surfaceContainerLow,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Pricing & Negotiation Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.payments_outlined, color: AppColors.secondary, size: 20),
                      SizedBox(width: 6),
                      Text('Fair Campus Pricing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _sellingPriceController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Selling Price *',
                            prefixText: '₹ ',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLow,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _originalPriceController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Original MRP (Optional)',
                            prefixText: '₹ ',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLow,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_savings > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Junior saves ₹$_savings ($_discountPct% off new)',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSecondaryContainer),
                          ),
                          const Spacer(),
                          const Icon(Icons.verified, size: 14, color: AppColors.secondary),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price Negotiable', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('Open to reasonable student offers', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                        ],
                      ),
                      Switch(
                        value: _isNegotiable,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _isNegotiable = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text('Description', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Mention condition, missing parts, or where on campus you can meet...',
              filled: true,
              fillColor: AppColors.surfaceContainerLowest,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // Preferred Campus Spot
          Text('Preferred Campus Spot', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          TextField(
            controller: _spotController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.surfaceContainerLowest,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // Your WhatsApp Contact Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your WhatsApp Contact Number *', style: Theme.of(context).textTheme.labelLarge),
              const Row(
                children: [
                  Icon(Icons.lock_outline, size: 12, color: AppColors.secondary),
                  SizedBox(width: 2),
                  Text('Campus peers only', style: TextStyle(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'e.g. +91 98765 43210',
              prefixIcon: const Icon(Icons.chat_bubble_outline, color: AppColors.whatsappGreen),
              filled: true,
              fillColor: AppColors.surfaceContainerLowest,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 4),
          const Text('Buyers will click "Chat on WhatsApp" to message this number directly.',
              style: TextStyle(fontSize: 11, color: AppColors.outline)),
          const SizedBox(height: 16),

          // Direct WhatsApp card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline, color: AppColors.whatsappGreen, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Direct WhatsApp Connect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                        'Verified campus peers will message you at ${_phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : "+91 98765 43210"}. Phone number remains protected.',
                        style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Publish Listing Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _submit,
              icon: const Icon(Icons.rocket_launch, size: 20),
              label: const Text(
                'Publish Listing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
