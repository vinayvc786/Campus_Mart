import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../theme/app_theme.dart';

class FilterSortBottomSheet extends StatefulWidget {
  final FilterState currentFilter;
  final int resultCount;
  final Function(FilterState) onApply;

  const FilterSortBottomSheet({
    super.key,
    required this.currentFilter,
    required this.resultCount,
    required this.onApply,
  });

  @override
  State<FilterSortBottomSheet> createState() => _FilterSortBottomSheetState();
}

class _FilterSortBottomSheetState extends State<FilterSortBottomSheet> {
  late double _maxPrice;
  late Condition? _selectedCondition;
  late String _selectedDepartment;
  late String _selectedSemester;
  late String _selectedSortBy;

  @override
  void initState() {
    super.initState();
    _maxPrice = widget.currentFilter.maxPrice.toDouble();
    _selectedCondition = widget.currentFilter.condition;
    _selectedDepartment = widget.currentFilter.department;
    _selectedSemester = widget.currentFilter.semester;
    _selectedSortBy = widget.currentFilter.sortBy;
  }

  void _resetAll() {
    setState(() {
      _maxPrice = 1500;
      _selectedCondition = null;
      _selectedDepartment = 'all';
      _selectedSemester = '';
      _selectedSortBy = 'recommended';
    });
  }

  int get _activeCount {
    int count = 0;
    if (_selectedCondition != null) count++;
    if (_selectedDepartment != 'all') count++;
    if (_selectedSemester.isNotEmpty) count++;
    if (_maxPrice < 1500) count++;
    if (_selectedSortBy != 'recommended') count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle & Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Filter & Sort',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(width: 8),
                      if (_activeCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$_activeCount active',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimaryFixedVariant,
                            ),
                          ),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: _resetAll,
                        child: const Text(
                          'Reset All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.surfaceContainer),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price Range
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price Range', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '₹200 - ₹${_maxPrice.toInt()}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _maxPrice,
                      min: 200,
                      max: 1500,
                      divisions: 13,
                      activeColor: AppColors.primaryContainer,
                      onChanged: (val) => setState(() => _maxPrice = val),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹200 (Min)', style: TextStyle(fontSize: 12, color: AppColors.outline)),
                        Text('₹1,500 (Max)', style: TextStyle(fontSize: 12, color: AppColors.outline)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Condition Selector
                    Text('Condition', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: Condition.values.map((cond) {
                        final isSelected = _selectedCondition == cond;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: FilterChip(
                              label: Text(cond.label),
                              selected: isSelected,
                              showCheckmark: false,
                              selectedColor: AppColors.primaryContainer,
                              backgroundColor: AppColors.surfaceContainer,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.onSurface,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onSelected: (_) {
                                setState(() {
                                  _selectedCondition = isSelected ? null : cond;
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Department / Branch
                    Text('Department / Branch', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDepartment,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All Departments')),
                            DropdownMenuItem(value: 'mech', child: Text('Mechanical Engineering')),
                            DropdownMenuItem(value: 'cs', child: Text('Computer Science & Engg')),
                            DropdownMenuItem(value: 'ee', child: Text('Electrical Engineering')),
                            DropdownMenuItem(value: 'civil', child: Text('Civil Engineering')),
                          ],
                          onChanged: (val) => setState(() => _selectedDepartment = val ?? 'all'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Semester Relevance
                    Text('Semester Relevance', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Sem 5', 'Sem 6'].map((sem) {
                          final isSelected = _selectedSemester == sem;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(sem),
                              selected: isSelected,
                              selectedColor: AppColors.primaryFixed,
                              backgroundColor: AppColors.surfaceContainer,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? AppColors.onPrimaryFixedVariant : AppColors.onSurface,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onSelected: (_) {
                                setState(() {
                                  _selectedSemester = isSelected ? '' : sem;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sort By
                    Text('Sort By', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    _buildSortRadio('recommended', 'Recommended for your batch'),
                    _buildSortRadio('low-to-high', 'Price: Low to High'),
                    _buildSortRadio('newest', 'Newest First'),
                  ],
                ),
              ),
            ),

            // Sticky Bottom CTA Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    widget.onApply(widget.currentFilter.copyWith(
                      maxPrice: _maxPrice.toInt(),
                      condition: _selectedCondition,
                      clearCondition: _selectedCondition == null,
                      department: _selectedDepartment,
                      semester: _selectedSemester,
                      sortBy: _selectedSortBy,
                    ));
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Show ${widget.resultCount} Results',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortRadio(String value, String title) {
    final isSelected = _selectedSortBy == value;
    return InkWell(
      onTap: () => setState(() => _selectedSortBy = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryFixed.withValues(alpha: 0.3) : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AppColors.primaryFixedDim) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.onSurface,
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedSortBy,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _selectedSortBy = val!),
            ),
          ],
        ),
      ),
    );
  }
}
