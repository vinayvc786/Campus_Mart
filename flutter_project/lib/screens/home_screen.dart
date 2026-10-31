import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/filter_sort_bottom_sheet.dart';
import 'listing_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Listing> listings;
  final FilterState filterState;
  final Function(FilterState) onFilterChange;
  final Set<String> savedIds;
  final Function(String) onToggleSave;
  final Function() onNavigateSell;

  const HomeScreen({
    super.key,
    required this.listings,
    required this.filterState,
    required this.onFilterChange,
    required this.savedIds,
    required this.onToggleSave,
    required this.onNavigateSell,
  });

  void _openFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSortBottomSheet(
        currentFilter: filterState,
        resultCount: listings.length,
        onApply: onFilterChange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // College badge row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.school, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'SRKR Engg College',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    Text(' • ', style: TextStyle(color: AppColors.outlineVariant)),
                    Text(
                      'Engg \'24-\'28',
                      style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(radius: 3, backgroundColor: AppColors.secondary),
                    SizedBox(width: 4),
                    Text(
                      'SRKR Campus Hub',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Greeting
          Text(
            'Find what you need, Rohan 👋',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),

          // Search and Filter Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.outline, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => onFilterChange(filterState.copyWith(searchQuery: val)),
                          decoration: const InputDecoration(
                            hintText: 'Search books, drafters, calculators...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 13, color: AppColors.outline),
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.mic, color: AppColors.outline, size: 20),
                        onPressed: () {
                          onFilterChange(filterState.copyWith(searchQuery: 'Scientific Calculator'));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: AppColors.onSurface, size: 20),
                  onPressed: () => _openFilter(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Semester Kickoff Hero Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryContainer, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'SEMESTER KICKOFF',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '⚡ Up to 70% Off',
                        style: TextStyle(color: AppColors.onPrimaryContainer, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your next semester, for less',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Buy verified senior notes, mini-drafters & approved tech directly on campus.',
                  style: TextStyle(color: AppColors.onPrimaryContainer, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () => onFilterChange(filterState.copyWith(maxPrice: 500)),
                      child: const Row(
                        children: [
                          Text('Explore Deals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('420+ listed today', style: TextStyle(color: AppColors.onPrimaryContainer, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Categories Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: Theme.of(context).textTheme.labelLarge),
              const Text('Swipe for more', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = filterState.category == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppColors.primaryContainer,
                    backgroundColor: AppColors.surfaceContainerLowest,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.onSurface,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (_) => onFilterChange(filterState.copyWith(category: cat)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Quick Promo Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.currency_rupee, color: AppColors.secondary, size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selling unused sem materials?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
                      ),
                      Text(
                        'Earn cash in minutes from peers',
                        style: TextStyle(fontSize: 11, color: AppColors.onSecondaryContainer),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: onNavigateSell,
                  icon: const Icon(Icons.add_circle, size: 16),
                  label: const Text('List Item', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Featured Deals Header
          Row(
            children: [
              Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 6),
              Text('Featured Semester Deals', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              TextButton(
                onPressed: () => onFilterChange(const FilterState()),
                child: const Row(
                  children: [
                    Text('See all', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2-Column Product Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listings.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final item = listings[index];
              final isFav = savedIds.contains(item.id);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ListingDetailScreen(
                        listing: item,
                        isSaved: isFav,
                        onToggleSave: () => onToggleSave(item.id),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceContainer),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo + Badges
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              item.images[0],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainer),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.condition == Condition.likeNew
                                    ? AppColors.secondaryContainer
                                    : AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                item.condition.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: item.condition == Condition.likeNew
                                      ? AppColors.onSecondaryContainer
                                      : AppColors.onPrimaryFixedVariant,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white.withValues(alpha: 0.9),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  size: 16,
                                  color: isFav ? AppColors.error : AppColors.outline,
                                ),
                                onPressed: () => onToggleSave(item.id),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Info
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '₹${item.price}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '₹${item.originalPrice}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.outline, decoration: TextDecoration.lineThrough),
                                ),
                                const Spacer(),
                                if (item.discountPercent > 0)
                                  Text(
                                    '${item.discountPercent}% off',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${item.seller.name} (${item.seller.department})',
                              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, size: 10, color: AppColors.secondary),
                                  SizedBox(width: 2),
                                  Text(
                                    'Verified Student Seller',
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Hand-to-Hand Campus Pickup Assurance
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.handshake_outlined, color: AppColors.primary, size: 22),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hand-to-Hand Campus Pickup',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Inspect before paying. Instant UPI or cash at campus library & hostel common rooms.',
                        style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
