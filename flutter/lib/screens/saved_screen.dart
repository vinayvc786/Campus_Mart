import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../theme/app_theme.dart';
import 'listing_detail_screen.dart';

class SavedScreen extends StatelessWidget {
  final List<Listing> savedListings;
  final Function(String) onRemoveSaved;
  final VoidCallback onExplore;

  const SavedScreen({
    super.key,
    required this.savedListings,
    required this.onRemoveSaved,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    final totalOriginal = savedListings.fold<int>(0, (sum, i) => sum + i.originalPrice);
    final totalSelling = savedListings.fold<int>(0, (sum, i) => sum + i.price);
    final totalSavings = totalOriginal > totalSelling ? totalOriginal - totalSelling : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Saved Gear & Books', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          const Text(
            'Items you bookmarked for this semester. Direct chat or inspect on campus.',
            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 14),

          // Savings Banner
          if (savedListings.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'POTENTIAL SAVINGS',
                        style: TextStyle(color: AppColors.onPrimaryContainer, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('₹$totalSavings', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(width: 6),
                          const Text('saved vs showroom MRP', style: TextStyle(color: AppColors.onPrimaryContainer, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.savings_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),

          if (savedListings.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.surfaceContainerLow,
                      child: Icon(Icons.bookmark_border, size: 32, color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),
                    const Text('No saved listings yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    const Text('Tap the heart on drafters or notes to save them.', style: TextStyle(color: AppColors.outline, fontSize: 13)),
                    const SizedBox(height: 16),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.primaryContainer),
                      onPressed: onExplore,
                      child: const Text('Explore Deals'),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedListings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = savedListings[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListingDetailScreen(
                          listing: item,
                          isSaved: true,
                          onToggleSave: () => onRemoveSaved(item.id),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceContainer),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.images[0],
                            width: 76,
                            height: 76,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 76, height: 76, color: AppColors.surfaceContainer),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${item.price} • ${item.department}',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.seller.name} • ${item.location}',
                                style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.outline),
                          onPressed: () => onRemoveSaved(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
