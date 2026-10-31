import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/listing.dart';
import '../theme/app_theme.dart';

class ListingDetailScreen extends StatefulWidget {
  final Listing listing;
  final bool isSaved;
  final VoidCallback onToggleSave;

  const ListingDetailScreen({
    super.key,
    required this.listing,
    required this.isSaved,
    required this.onToggleSave,
  });

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  int _activeImageIndex = 0;

  void _openWhatsApp() async {
    final message = Uri.encodeComponent(
      "Hi ${widget.listing.seller.name}, I'm interested in your ${widget.listing.title} (#${widget.listing.id}) on Campus Mart. Is it still available?",
    );
    final cleanPhone = widget.listing.seller.phone.replaceAll(RegExp(r'\D'), '');
    final phoneToUse = cleanPhone.isNotEmpty ? cleanPhone : '919876543210';
    final url = Uri.parse("https://wa.me/$phoneToUse?text=$message");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open WhatsApp. Phone: ${widget.listing.seller.phone}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing link copied to clipboard!')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              widget.isSaved ? Icons.favorite : Icons.favorite_border,
              color: widget.isSaved ? AppColors.error : AppColors.onSurface,
            ),
            onPressed: widget.onToggleSave,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel with Badge & Index
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PageView.builder(
                      itemCount: listing.images.length,
                      onPageChanged: (idx) => setState(() => _activeImageIndex = idx),
                      itemBuilder: (context, index) {
                        return Image.network(
                          listing.images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceContainer,
                            child: const Icon(Icons.broken_image, size: 48, color: AppColors.outline),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Condition Badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 14, color: AppColors.onSecondaryContainer),
                        const SizedBox(width: 4),
                        Text(
                          '${listing.condition.label} • ${listing.conditionDetail ?? "1 Sem Used"}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Pagination index
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.inverseSurface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_activeImageIndex + 1}/${listing.images.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inverseOnSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price & Title Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '₹${listing.price}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '₹${listing.originalPrice}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.outline,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF66FF8E),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${listing.discountPercent}% OFF',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002109),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      listing.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          listing.location,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const Text(' • ', style: TextStyle(color: AppColors.outline)),
                        Text(
                          listing.handoverType,
                          style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Specs Grid (2x2)
            Row(
              children: [
                Expanded(child: _buildSpecCard('CATEGORY', listing.category)),
                const SizedBox(width: 8),
                Expanded(child: _buildSpecCard('FOR BRANCH', listing.department)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildSpecCard('SEMESTER', listing.semester)),
                const SizedBox(width: 8),
                Expanded(child: _buildSpecCard('LISTED', listing.listedTimeAgo)),
              ],
            ),
            const SizedBox(height: 10),

            // Description Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      listing.description,
                      style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5),
                    ),
                    if (listing.inspectionPerk != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.checklist, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                listing.inspectionPerk!,
                                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Verified Senior Seller Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(listing.seller.avatar),
                            ),
                            if (listing.seller.isRollVerified)
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: AppColors.secondary,
                                  child: Icon(Icons.check, size: 10, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    listing.seller.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryFixed,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      listing.seller.role,
                                      style: const TextStyle(fontSize: 11, color: AppColors.onPrimaryFixed),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${listing.seller.department} ${listing.seller.batch} • Roll Verified',
                                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              listing.seller.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${listing.seller.peerSalesCount} peer sales)',
                              style: const TextStyle(fontSize: 12, color: AppColors.outline),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.bolt, size: 16, color: AppColors.secondary),
                            const SizedBox(width: 2),
                            Text(
                              'Replies in ${listing.seller.replyTime}',
                              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified_user_outlined, size: 16, color: AppColors.outline),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Campus Safe: Exchange at day-time common areas.',
                              style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: AppColors.surface,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.whatsappGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _openWhatsApp,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Chat on WhatsApp',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '💬 Opens chat with ${listing.seller.name}: "Hi, I\'m interested in your ${listing.title}..."',
              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.outline, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
