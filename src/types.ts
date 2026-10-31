export type Condition = 'New' | 'Like New' | 'Good' | 'Fair';

export type Category = 
  | 'All'
  | 'Books'
  | 'Drafters'
  | 'Calculators'
  | 'Lab Records'
  | 'Manuals'
  | 'Stationery'
  | 'Electronics'
  | 'Lab Gear';

export interface Seller {
  name: string;
  avatar: string;
  role: string;
  department: string;
  batch: string;
  isRollVerified: boolean;
  rating: number;
  peerSalesCount: number;
  replyTime: string;
  phone: string;
}

export interface Listing {
  id: string;
  title: string;
  category: Category;
  condition: Condition;
  conditionDetail?: string;
  price: number;
  originalPrice: number;
  discountPercent?: number;
  images: string[];
  department: string;
  semester: string;
  subjectCode?: string;
  seller: Seller;
  location: string;
  handoverType: string;
  listedTimeAgo: string;
  description: string;
  inspectionPerk?: string;
  isNegotiable: boolean;
  isFeatured?: boolean;
}

export interface FilterState {
  minPrice: number;
  maxPrice: number;
  condition: Condition | 'All';
  department: string;
  semester: string;
  sortBy: 'recommended' | 'low-to-high' | 'high-to-low' | 'newest';
  category: Category;
  searchQuery: string;
}
