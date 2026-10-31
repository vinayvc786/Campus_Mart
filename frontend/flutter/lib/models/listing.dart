enum Condition { newCondition, likeNew, good, fair }

extension ConditionExtension on Condition {
  String get label {
    switch (this) {
      case Condition.newCondition:
        return 'New';
      case Condition.likeNew:
        return 'Like New';
      case Condition.good:
        return 'Good';
      case Condition.fair:
        return 'Fair';
    }
  }

  String get description {
    switch (this) {
      case Condition.newCondition:
        return 'Unopened in factory pack';
      case Condition.likeNew:
        return 'Barely used, 0 scratches';
      case Condition.good:
        return 'Normal semester wear';
      case Condition.fair:
        return 'Fully functional & working';
    }
  }

  static Condition fromString(String? val) {
    if (val == null) return Condition.good;
    final lower = val.toLowerCase().replaceAll(' ', '');
    if (lower.contains('new') && !lower.contains('like')) return Condition.newCondition;
    if (lower.contains('like')) return Condition.likeNew;
    if (lower.contains('good')) return Condition.good;
    if (lower.contains('fair')) return Condition.fair;
    return Condition.likeNew;
  }
}

class Seller {
  final String? id;
  final String name;
  final String avatar;
  final String role;
  final String department;
  final String batch;
  final bool isRollVerified;
  final double rating;
  final int peerSalesCount;
  final String replyTime;
  final String phone;

  const Seller({
    this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.department,
    required this.batch,
    required this.isRollVerified,
    required this.rating,
    required this.peerSalesCount,
    required this.replyTime,
    required this.phone,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Campus Seller',
      avatar: json['avatar'] as String? ?? '',
      role: json['role'] as String? ?? 'Student',
      department: json['department'] as String? ?? 'Engineering',
      batch: json['batch'] as String? ?? "'28",
      isRollVerified: json['isRollVerified'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      peerSalesCount: (json['peerSalesCount'] as num?)?.toInt() ?? 0,
      replyTime: json['replyTime'] as String? ?? '~5m',
      phone: json['phone'] as String? ?? '+91 98765 43210',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'role': role,
      'department': department,
      'batch': batch,
      'isRollVerified': isRollVerified,
      'rating': rating,
      'peerSalesCount': peerSalesCount,
      'replyTime': replyTime,
      'phone': phone,
    };
  }
}

class Listing {
  final String id;
  final String title;
  final String category;
  final Condition condition;
  final String? conditionDetail;
  final int price;
  final int originalPrice;
  final int discountPercent;
  final List<String> images;
  final String department;
  final String semester;
  final String? subjectCode;
  final String? sellerId;
  final Seller seller;
  final String location;
  final String handoverType;
  final String listedTimeAgo;
  final String description;
  final String? inspectionPerk;
  final bool isNegotiable;
  final bool isFeatured;
  final bool isSold;

  const Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.condition,
    this.conditionDetail,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.images,
    required this.department,
    required this.semester,
    this.subjectCode,
    this.sellerId,
    required this.seller,
    required this.location,
    required this.handoverType,
    required this.listedTimeAgo,
    required this.description,
    this.inspectionPerk,
    this.isNegotiable = true,
    this.isFeatured = false,
    this.isSold = false,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Item',
      category: json['category'] as String? ?? 'Stationery',
      condition: ConditionExtension.fromString(json['condition'] as String?),
      conditionDetail: json['conditionDetail'] as String?,
      price: (json['price'] as num?)?.toInt() ?? 0,
      originalPrice: (json['originalPrice'] as num?)?.toInt() ?? 0,
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      department: json['department'] as String? ?? 'All Branches',
      semester: json['semester'] as String? ?? 'All Semesters',
      subjectCode: json['subjectCode'] as String?,
      sellerId: json['sellerId'] as String?,
      seller: json['seller'] != null
          ? Seller.fromJson(json['seller'] as Map<String, dynamic>)
          : const Seller(
              name: 'Campus Seller',
              avatar: '',
              role: 'Student',
              department: 'Engineering',
              batch: "'28",
              isRollVerified: true,
              rating: 5.0,
              peerSalesCount: 1,
              replyTime: '~5m',
              phone: '+91 98765 43210',
            ),
      location: json['location'] as String? ?? 'Campus',
      handoverType: json['handoverType'] as String? ?? 'In-person handover',
      listedTimeAgo: json['listedTimeAgo'] as String? ?? 'Recently',
      description: json['description'] as String? ?? '',
      inspectionPerk: json['inspectionPerk'] as String?,
      isNegotiable: json['isNegotiable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isSold: json['isSold'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'condition': condition.label,
      'conditionDetail': conditionDetail,
      'price': price,
      'originalPrice': originalPrice,
      'images': images,
      'department': department,
      'semester': semester,
      'subjectCode': subjectCode,
      'location': location,
      'handoverType': handoverType,
      'description': description,
      'inspectionPerk': inspectionPerk,
      'isNegotiable': isNegotiable,
      'isFeatured': isFeatured,
      'phone': seller.phone,
    };
  }

  Listing copyWith({
    String? id,
    String? title,
    String? category,
    Condition? condition,
    String? conditionDetail,
    int? price,
    int? originalPrice,
    int? discountPercent,
    List<String>? images,
    String? department,
    String? semester,
    String? subjectCode,
    String? sellerId,
    Seller? seller,
    String? location,
    String? handoverType,
    String? listedTimeAgo,
    String? description,
    String? inspectionPerk,
    bool? isNegotiable,
    bool? isFeatured,
    bool? isSold,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      conditionDetail: conditionDetail ?? this.conditionDetail,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      images: images ?? this.images,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      subjectCode: subjectCode ?? this.subjectCode,
      sellerId: sellerId ?? this.sellerId,
      seller: seller ?? this.seller,
      location: location ?? this.location,
      handoverType: handoverType ?? this.handoverType,
      listedTimeAgo: listedTimeAgo ?? this.listedTimeAgo,
      description: description ?? this.description,
      inspectionPerk: inspectionPerk ?? this.inspectionPerk,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      isFeatured: isFeatured ?? this.isFeatured,
      isSold: isSold ?? this.isSold,
    );
  }
}

class FilterState {
  final int minPrice;
  final int maxPrice;
  final Condition? condition;
  final String department;
  final String semester;
  final String sortBy;
  final String category;
  final String searchQuery;

  const FilterState({
    this.minPrice = 0,
    this.maxPrice = 1500,
    this.condition,
    this.department = 'all',
    this.semester = '',
    this.sortBy = 'recommended',
    this.category = 'All',
    this.searchQuery = '',
  });

  FilterState copyWith({
    int? minPrice,
    int? maxPrice,
    Condition? condition,
    bool clearCondition = false,
    String? department,
    String? semester,
    String? sortBy,
    String? category,
    String? searchQuery,
  }) {
    return FilterState(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      condition: clearCondition ? null : (condition ?? this.condition),
      department: department ?? this.department,
      semester: semester ?? this.semester,
      sortBy: sortBy ?? this.sortBy,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
