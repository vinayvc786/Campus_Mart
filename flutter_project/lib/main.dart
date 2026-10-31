import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/listing.dart';
import 'data/mock_data.dart';
import 'screens/home_screen.dart';
import 'screens/sell_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';

import 'services/api_service.dart';

void main() {
  runApp(const CampusMartApp());
}

class CampusMartApp extends StatelessWidget {
  const CampusMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Mart',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  List<Listing> _listings = List.from(initialListings);
  final List<Listing> _userListings = [];
  final Set<String> _savedIds = {'CM-1001'};
  String _currentCollege = 'SRKR Engg College';
  FilterState _filterState = const FilterState();

  @override
  void initState() {
    super.initState();
    _loadFromBackend();
  }

  Future<void> _loadFromBackend() async {
    try {
      final backendListings = await ApiService().fetchProducts();
      if (backendListings.isNotEmpty && mounted) {
        setState(() {
          _listings = backendListings;
        });
      }
      final myListings = await ApiService().fetchMyProducts();
      if (mounted) {
        setState(() {
          _userListings.clear();
          _userListings.addAll(myListings);
        });
      }
    } catch (e) {
      debugPrint('Backend not active, using initial campus dataset: $e');
    }
  }

  void _toggleSave(String id) {
    setState(() {
      if (_savedIds.contains(id)) {
        _savedIds.remove(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from saved items')),
        );
      } else {
        _savedIds.add(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to your wishlist!')),
        );
      }
    });
  }

  void _onPublish(Listing newListing) async {
    setState(() {
      _listings.insert(0, newListing);
      _userListings.insert(0, newListing);
      _currentIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 Listing published! Verified peers notified on campus.')),
    );

    try {
      final created = await ApiService().createProduct(newListing);
      if (mounted) {
        setState(() {
          final idx = _listings.indexWhere((l) => l.title == newListing.title);
          if (idx != -1) _listings[idx] = created;
          final userIdx = _userListings.indexWhere((l) => l.title == newListing.title);
          if (userIdx != -1) _userListings[userIdx] = created;
        });
      }
    } catch (e) {
      debugPrint('Failed to save listing to backend: $e');
    }
  }

  List<Listing> get _filteredListings {
    var result = List<Listing>.from(_listings);

    if (_filterState.searchQuery.trim().isNotEmpty) {
      final q = _filterState.searchQuery.toLowerCase();
      result = result.where((item) {
        return item.title.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q) ||
            item.department.toLowerCase().contains(q) ||
            item.description.toLowerCase().contains(q);
      }).toList();
    }

    if (_filterState.category != 'All') {
      result = result.where((item) => item.category == _filterState.category).toList();
    }

    if (_filterState.condition != null) {
      result = result.where((item) => item.condition == _filterState.condition).toList();
    }

    result = result.where((item) {
      return item.price >= _filterState.minPrice && item.price <= _filterState.maxPrice;
    }).toList();

    if (_filterState.department != 'all') {
      result = result.where((item) {
        return item.department.toLowerCase().contains(_filterState.department.toLowerCase());
      }).toList();
    }

    if (_filterState.semester.isNotEmpty) {
      result = result.where((item) {
        return item.semester.toLowerCase().contains(_filterState.semester.toLowerCase());
      }).toList();
    }

    if (_filterState.sortBy == 'low-to-high') {
      result.sort((a, b) => a.price.compareTo(b.price));
    }

    return result;
  }

  List<Listing> get _savedListings {
    return _listings.where((item) => _savedIds.contains(item.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              campusLogoUrl,
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.school, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            const Text('Campus Mart'),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No new notifications')),
                  );
                },
              ),
              const Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(radius: 4, backgroundColor: AppColors.error),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _currentIndex = 3),
              child: const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(userAvatarUrl),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            listings: _filteredListings,
            filterState: _filterState,
            onFilterChange: (f) => setState(() => _filterState = f),
            savedIds: _savedIds,
            onToggleSave: _toggleSave,
            onNavigateSell: () => setState(() => _currentIndex = 2),
          ),
          SavedScreen(
            savedListings: _savedListings,
            onRemoveSaved: _toggleSave,
            onExplore: () => setState(() => _currentIndex = 0),
          ),
          SellScreen(
            onPublish: _onPublish,
            onCancel: () => setState(() => _currentIndex = 0),
          ),
          ProfileScreen(
            userListings: _userListings,
            currentCollege: _currentCollege,
            onChangeCollege: (col) => setState(() => _currentCollege = col),
            onAuthChanged: () {
              setState(() {});
              _loadFromBackend();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryFixed,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: _savedIds.isNotEmpty,
                label: Text('${_savedIds.length}'),
                child: const Icon(Icons.favorite_border),
              ),
              selectedIcon: Badge(
                isLabelVisible: _savedIds.isNotEmpty,
                label: Text('${_savedIds.length}'),
                child: const Icon(Icons.favorite, color: AppColors.primary),
              ),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
              label: 'Sell',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
