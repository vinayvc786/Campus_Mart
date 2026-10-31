import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../services/api_service.dart';
import 'auth_screen.dart';
import 'listing_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final List<Listing> userListings;
  final String currentCollege;
  final Function(String) onChangeCollege;
  final VoidCallback? onAuthChanged;

  const ProfileScreen({
    super.key,
    required this.userListings,
    required this.currentCollege,
    required this.onChangeCollege,
    this.onAuthChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _openAuth() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
    if (result == true) {
      setState(() {});
      widget.onAuthChanged?.call();
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of Campus Mart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ApiService().logout();
              setState(() {});
              widget.onAuthChanged?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuth = ApiService().isAuthenticated;
    final userName = ApiService().currentUserName;
    final userPhone = ApiService().currentUserPhone;
    final userEmail = ApiService().currentUserEmail;
    final userDept = ApiService().currentUser?['department'] as String? ?? 'Computer Science & Engg';
    final userRoll = ApiService().currentUser?['rollNumber'] as String? ?? '24A91A05XX';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student ID Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Stack(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(userAvatarUrl),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: AppColors.secondary,
                              child: Icon(Icons.check, size: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Verified',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSecondaryContainer),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$userDept • \'24-\'28',
                              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                            Text(
                              'Roll: $userRoll • $userEmail',
                              style: const TextStyle(fontSize: 11, color: AppColors.outline),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.chat_bubble_outline, size: 12, color: AppColors.whatsappGreen),
                                const SizedBox(width: 4),
                                Text(
                                  userPhone,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.surfaceContainer),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('₹1,250', 'Total Saved'),
                      _buildStat('${widget.userListings.length}', 'Active Listings'),
                      _buildStat('100%', 'Peer Rating'),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Auth Action Button (Login / Logout)
                  if (!isAuth)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _openAuth,
                        icon: const Icon(Icons.login, size: 18),
                        label: const Text('Log In / Register Account'),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _logout,
                            icon: const Icon(Icons.logout, size: 18),
                            label: const Text('Log Out'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primaryContainer),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _openAuth,
                            icon: const Icon(Icons.switch_account_outlined, size: 18),
                            label: const Text('Switch'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Campus Hub Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.apartment, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text('Active Campus Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Spacer(),
                      Row(
                        children: [
                          CircleAvatar(radius: 3, backgroundColor: AppColors.secondary),
                          SizedBox(width: 4),
                          Text('Verified Network', style: TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: widget.currentCollege,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'SRKR Engg College', child: Text('SRKR Engg College (Bhimavaram)')),
                          DropdownMenuItem(value: 'IIT Bombay', child: Text('IIT Bombay (Powai)')),
                          DropdownMenuItem(value: 'Andhra University', child: Text('Andhra University (Vizag)')),
                          DropdownMenuItem(value: 'NIT Warangal', child: Text('NIT Warangal')),
                        ],
                        onChanged: (val) => widget.onChangeCollege(val ?? 'SRKR Engg College'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // My Active Listings
          Text('My Posted Listings (${widget.userListings.length})', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (widget.userListings.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: const Column(
                children: [
                  Text('You haven\'t posted any items yet.', style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                  SizedBox(height: 4),
                  Text('Sell extra drafters, calculators, or notes in minutes.', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.userListings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = widget.userListings[index];
                return ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: AppColors.surfaceContainerLowest,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.images.isNotEmpty ? item.images[0] : campusLogoUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 44, height: 44, color: AppColors.surfaceContainer),
                    ),
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(
                    item.isSold ? 'Sold Out' : '₹${item.price} • Active',
                    style: TextStyle(
                      color: item.isSold ? AppColors.outline : AppColors.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListingDetailScreen(
                          listing: item,
                          isSaved: false,
                          onToggleSave: () {},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}
