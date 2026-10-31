/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useMemo } from 'react';
import { Header } from './components/Header';
import { BottomNav, NavTab } from './components/BottomNav';
import { FilterSortSheet } from './components/FilterSortSheet';
import { ListingDetailView } from './components/ListingDetailView';
import { SellView } from './components/SellView';
import { SavedView } from './components/SavedView';
import { ProfileView } from './components/ProfileView';
import { Toast } from './components/Toast';
import { INITIAL_LISTINGS, CATEGORIES } from './data/mockData';
import { Listing, FilterState, Category } from './types';

export default function App() {
  const [activeTab, setActiveTab] = useState<NavTab>('home');
  const [selectedListing, setSelectedListing] = useState<Listing | null>(null);
  const [isFilterOpen, setIsFilterOpen] = useState(false);
  const [listings, setListings] = useState<Listing[]>(INITIAL_LISTINGS);
  const [savedIds, setSavedIds] = useState<string[]>(['CM-1001']); // Casio calculator favorited by default as in design
  const [userListings, setUserListings] = useState<Listing[]>([]);
  const [collegeName, setCollegeName] = useState('SRKR Engg College');
  const [isListening, setIsListening] = useState(false);
  const [isDeviceFrame, setIsDeviceFrame] = useState(false); // Quick toggle between mobile frame & full-width

  // Toast state
  const [toastMessage, setToastMessage] = useState('');
  const [toastIcon, setToastIcon] = useState('bookmark_added');
  const [isToastVisible, setIsToastVisible] = useState(false);

  const showToast = (msg: string, icon = 'bookmark_added') => {
    setToastMessage(msg);
    setToastIcon(icon);
    setIsToastVisible(true);
    setTimeout(() => {
      setIsToastVisible(false);
    }, 2800);
  };

  // Filter State
  const [filterState, setFilterState] = useState<FilterState>({
    minPrice: 0,
    maxPrice: 1500,
    condition: 'All',
    department: 'all',
    semester: '',
    sortBy: 'recommended',
    category: 'All',
    searchQuery: '',
  });

  const handleToggleSave = (id: string, e?: React.MouseEvent) => {
    e?.stopPropagation();
    if (savedIds.includes(id)) {
      setSavedIds(savedIds.filter((item) => item !== id));
      showToast('Removed from saved items', 'bookmark_remove');
    } else {
      setSavedIds([...savedIds, id]);
      showToast('Saved to your wishlist!', 'favorite');
    }
  };

  const handlePublishListing = (newListing: Listing) => {
    setListings([newListing, ...listings]);
    setUserListings([newListing, ...userListings]);
    setActiveTab('home');
    setSelectedListing(newListing);
  };

  const handleVoiceSearch = () => {
    setIsListening(true);
    showToast('Listening... Speak gear or course name', 'mic');
    setTimeout(() => {
      setIsListening(false);
      setFilterState((prev) => ({ ...prev, searchQuery: 'Scientific Calculator' }));
      showToast('Found listings for "Scientific Calculator"', 'search');
    }, 1500);
  };

  // Filter and sort listings
  const filteredListings = useMemo(() => {
    let result = [...listings];

    // Search query
    if (filterState.searchQuery.trim()) {
      const q = filterState.searchQuery.toLowerCase();
      result = result.filter(
        (item) =>
          item.title.toLowerCase().includes(q) ||
          item.category.toLowerCase().includes(q) ||
          item.department.toLowerCase().includes(q) ||
          item.description.toLowerCase().includes(q)
      );
    }

    // Category
    if (filterState.category !== 'All') {
      result = result.filter((item) => item.category === filterState.category);
    }

    // Condition
    if (filterState.condition !== 'All') {
      result = result.filter((item) => item.condition === filterState.condition);
    }

    // Price
    result = result.filter(
      (item) => item.price >= filterState.minPrice && item.price <= filterState.maxPrice
    );

    // Department
    if (filterState.department !== 'all') {
      const deptMap: Record<string, string> = {
        mech: 'mech',
        cs: 'comp',
        ee: 'electr',
        civil: 'civil',
        it: 'it',
      };
      const key = deptMap[filterState.department] || filterState.department;
      result = result.filter((item) => item.department.toLowerCase().includes(key));
    }

    // Semester
    if (filterState.semester) {
      result = result.filter((item) =>
        item.semester.toLowerCase().includes(filterState.semester.toLowerCase())
      );
    }

    // Sort
    if (filterState.sortBy === 'low-to-high') {
      result.sort((a, b) => a.price - b.price);
    } else if (filterState.sortBy === 'high-to-low') {
      result.sort((a, b) => b.price - a.price);
    } else if (filterState.sortBy === 'newest') {
      // Keep recent first
    }

    return result;
  }, [listings, filterState]);

  const savedListings = useMemo(() => {
    return listings.filter((item) => savedIds.includes(item.id));
  }, [listings, savedIds]);

  const clearSearch = () => {
    setFilterState((prev) => ({ ...prev, searchQuery: '' }));
  };

  return (
    <div className="min-h-screen bg-[#f4f2fe] flex flex-col items-center justify-start text-[#1a1b23]">
      {/* Top Desktop Frame Switcher / Quick Controls */}
      <div className="w-full bg-[#eeedf8] border-b border-[#e3e1ed] px-4 py-2 flex items-center justify-between text-xs text-[#474554] z-50">
        <div className="flex items-center gap-2">
          <span className="font-bold text-[#422ec2]">Campus Mart Web</span>
          <span className="hidden sm:inline text-[#787586]">• Peer-to-Peer Academic Exchange</span>
        </div>
        <div className="flex items-center gap-2">
          <a
            href="/campus-mart-flutter.zip"
            download="campus-mart-flutter.zip"
            className="px-3 py-1 rounded-full font-semibold transition-colors flex items-center gap-1 bg-white text-[#422ec2] border border-[#c6c0ff] hover:bg-[#e4dfff]"
          >
            <span className="material-symbols-outlined text-[15px]">flutter</span>
            <span>Download Flutter App (.ZIP)</span>
          </a>
          <a
            href="/campus-mart.zip"
            download="campus-mart.zip"
            className="px-3 py-1 rounded-full font-semibold transition-colors flex items-center gap-1 bg-white text-[#006c49] border border-[#6cf8bb] hover:bg-[#6cf8bb]/20"
          >
            <span className="material-symbols-outlined text-[15px]">download</span>
            <span>Web (React) ZIP</span>
          </a>
          <button
            onClick={() => setIsDeviceFrame(!isDeviceFrame)}
            className={`px-3 py-1 rounded-full font-semibold transition-colors flex items-center gap-1 ${
              isDeviceFrame
                ? 'bg-[#5b4bdb] text-white shadow-xs'
                : 'bg-white text-[#474554] hover:bg-[#e4dfff]'
            }`}
          >
            <span className="material-symbols-outlined text-[15px]">
              {isDeviceFrame ? 'smartphone' : 'devices'}
            </span>
            <span>{isDeviceFrame ? 'Phone Frame (390px)' : 'Fluid Responsive'}</span>
          </button>
        </div>
      </div>

      {/* Main Container */}
      <div
        className={`w-full min-h-screen flex flex-col bg-[#fbf8ff] relative transition-all duration-200 ${
          isDeviceFrame
            ? 'max-w-[420px] shadow-2xl my-4 rounded-[36px] overflow-hidden border-[8px] border-[#2f3038]'
            : 'max-w-md shadow-lg sm:border-x sm:border-[#eeedf8]'
        }`}
      >
        {/* Top Header */}
        <Header
          onProfileClick={() => {
            setSelectedListing(null);
            setActiveTab('profile');
          }}
          onHomeClick={() => {
            setSelectedListing(null);
            setActiveTab('home');
          }}
          showBack={selectedListing !== null || activeTab !== 'home'}
          onBack={() => {
            if (selectedListing) {
              setSelectedListing(null);
            } else {
              setActiveTab('home');
            }
          }}
          title={
            selectedListing
              ? 'Listing Details'
              : activeTab === 'sell'
              ? 'Sell'
              : activeTab === 'saved'
              ? 'Saved Items'
              : activeTab === 'profile'
              ? 'Student Profile'
              : 'Campus Mart'
          }
        />

        {/* Views Routing */}
        <main className="flex-1 flex flex-col relative w-full pt-16 pb-20">
          {selectedListing ? (
            <ListingDetailView
              listing={selectedListing}
              onBack={() => setSelectedListing(null)}
              isSaved={savedIds.includes(selectedListing.id)}
              onToggleSave={handleToggleSave}
              onToast={showToast}
            />
          ) : activeTab === 'sell' ? (
            <SellView
              onPublish={handlePublishListing}
              onToast={showToast}
              onCancel={() => setActiveTab('home')}
            />
          ) : activeTab === 'saved' ? (
            <SavedView
              savedListings={savedListings}
              onSelectListing={(listing) => setSelectedListing(listing)}
              onRemoveSaved={(id) => handleToggleSave(id)}
              onExplore={() => setActiveTab('home')}
            />
          ) : activeTab === 'profile' ? (
            <ProfileView
              userListings={userListings}
              onSelectListing={(listing) => setSelectedListing(listing)}
              onToast={showToast}
              currentCollege={collegeName}
              onChangeCollege={(col) => setCollegeName(col)}
            />
          ) : (
            /* Home Marketplace View */
            <div className="flex flex-col w-full pb-6 px-4 space-y-4">
              {/* Friendly Student Greeting & Campus Tag */}
              <div className="flex flex-col gap-1 pt-2">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-1.5 bg-[#e8e7f2] px-2.5 py-1 rounded-full text-[#474554] w-fit shadow-xs">
                    <span
                      className="material-symbols-outlined text-[15px] text-[#422ec2]"
                      style={{ fontVariationSettings: "'FILL' 1" }}
                    >
                      school
                    </span>
                    <span className="font-label-sm text-label-sm font-semibold tracking-wide text-[#1a1b23]">
                      {collegeName}
                    </span>
                    <span className="text-[#c8c4d7] font-body-sm">•</span>
                    <span className="font-label-sm text-label-sm text-[#474554] font-medium">
                      Engg &apos;24-&apos;28
                    </span>
                  </div>
                  <div className="flex items-center gap-1 text-[#006c49] font-label-sm text-label-sm bg-[#6cf8bb]/40 px-2.5 py-1 rounded-full">
                    <span className="w-1.5 h-1.5 rounded-full bg-[#006c49] animate-pulse"></span>
                    <span>Campus Hub</span>
                  </div>
                </div>

                <div className="flex items-baseline justify-between mt-1">
                  <h1 className="font-headline-md text-headline-md font-bold text-[#1a1b23] tracking-tight">
                    Find what you need, Rohan{' '}
                    <span
                      onClick={() => showToast('Welcome back, Rohan! 14 items listed today.')}
                      className="inline-block hover:rotate-12 transition-transform cursor-pointer"
                    >
                      👋
                    </span>
                  </h1>
                </div>
              </div>

              {/* Search & Filter Bar */}
              <div className="flex items-center gap-2">
                <div className="relative flex-1 flex items-center bg-white rounded-xl shadow-xs border border-[#eeedf8] px-3.5 py-2.5 focus-within:ring-2 focus-within:ring-[#5b4bdb]">
                  <span className="material-symbols-outlined text-[#787586] text-[22px] mr-2 shrink-0">
                    search
                  </span>
                  <input
                    value={filterState.searchQuery}
                    onChange={(e) =>
                      setFilterState((prev) => ({ ...prev, searchQuery: e.target.value }))
                    }
                    className="w-full bg-transparent font-body-md text-body-md text-[#1a1b23] placeholder:text-[#787586] focus:outline-none"
                    placeholder="Search books, drafters, calculators..."
                    type="text"
                  />
                  {filterState.searchQuery && (
                    <button
                      onClick={clearSearch}
                      className="text-[#787586] hover:text-[#1a1b23] mr-1 p-0.5 active:scale-95"
                    >
                      <span className="material-symbols-outlined text-[16px]">close</span>
                    </button>
                  )}
                  <button
                    onClick={handleVoiceSearch}
                    aria-label="Voice search"
                    className={`ml-1 p-0.5 active:scale-95 transition-transform ${
                      isListening ? 'text-[#ba1a1a] animate-pulse' : 'text-[#787586] hover:text-[#1a1b23]'
                    }`}
                  >
                    <span className="material-symbols-outlined text-[19px]">mic</span>
                  </button>
                </div>
                <button
                  onClick={() => setIsFilterOpen(true)}
                  aria-label="Filter listings"
                  className="w-11 h-11 flex items-center justify-center bg-[#e8e7f2] rounded-xl text-[#1a1b23] shadow-xs active:scale-95 transition-all hover:bg-[#e4dfff] relative shrink-0"
                >
                  <span className="material-symbols-outlined text-[22px]">tune</span>
                  {(filterState.condition !== 'All' ||
                    filterState.department !== 'all' ||
                    filterState.semester !== '' ||
                    filterState.maxPrice < 1500) && (
                    <span className="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-[#422ec2] rounded-full ring-2 ring-white"></span>
                  )}
                </button>
              </div>

              {/* Active Filter summary tags if any */}
              {(filterState.searchQuery ||
                filterState.condition !== 'All' ||
                filterState.department !== 'all' ||
                filterState.semester !== '' ||
                filterState.category !== 'All') && (
                <div className="flex items-center gap-1.5 flex-wrap pt-0.5">
                  <span className="text-[11px] font-semibold text-[#474554]">Active:</span>
                  {filterState.searchQuery && (
                    <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-[#eeedf8] text-[#1a1b23] text-xs font-medium">
                      &quot;{filterState.searchQuery}&quot;
                      <button onClick={clearSearch}>
                        <span className="material-symbols-outlined text-[14px]">close</span>
                      </button>
                    </span>
                  )}
                  {filterState.category !== 'All' && (
                    <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-[#eeedf8] text-[#1a1b23] text-xs font-medium">
                      {filterState.category}
                      <button
                        onClick={() =>
                          setFilterState((prev) => ({ ...prev, category: 'All' }))
                        }
                      >
                        <span className="material-symbols-outlined text-[14px]">close</span>
                      </button>
                    </span>
                  )}
                  {filterState.condition !== 'All' && (
                    <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-[#6cf8bb]/40 text-[#00714d] text-xs font-bold">
                      {filterState.condition}
                      <button
                        onClick={() =>
                          setFilterState((prev) => ({ ...prev, condition: 'All' }))
                        }
                      >
                        <span className="material-symbols-outlined text-[14px]">close</span>
                      </button>
                    </span>
                  )}
                  <button
                    onClick={() =>
                      setFilterState({
                        minPrice: 0,
                        maxPrice: 1500,
                        condition: 'All',
                        department: 'all',
                        semester: '',
                        sortBy: 'recommended',
                        category: 'All',
                        searchQuery: '',
                      })
                    }
                    className="text-[11px] text-[#422ec2] font-bold hover:underline ml-1"
                  >
                    Clear all
                  </button>
                </div>
              )}

              {/* Hero Semester Deal Card */}
              <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-[#5b4bdb] via-[#422ec2] to-[#5b4bdb] text-white shadow-md p-4">
                <div className="relative z-10 flex flex-col justify-between h-full space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="bg-white/20 backdrop-blur-md font-label-sm text-label-sm px-2.5 py-0.5 rounded-full uppercase tracking-wider text-white font-bold">
                      Semester Kickoff
                    </span>
                    <span className="font-label-sm text-label-sm text-[#e0dbff] bg-white/10 px-2 py-0.5 rounded-full font-semibold">
                      ⚡ Up to 70% Off
                    </span>
                  </div>
                  <div className="max-w-[80%]">
                    <h2 className="font-headline-sm text-headline-sm font-bold text-white leading-snug">
                      Your next semester, for less
                    </h2>
                    <p className="font-body-sm text-body-sm text-[#e0dbff]/90 mt-1 line-clamp-2">
                      Buy verified senior notes, mini-drafters &amp; approved tech directly on campus.
                    </p>
                  </div>
                  <div className="flex items-center gap-2 pt-1">
                    <button
                      onClick={() => {
                        setFilterState((prev) => ({ ...prev, maxPrice: 500 }));
                        showToast('Showing deals under ₹500!');
                      }}
                      className="inline-flex items-center gap-1.5 bg-white text-[#422ec2] font-label-lg text-label-lg font-bold px-3.5 py-1.5 rounded-full shadow-sm active:scale-95 transition-transform"
                    >
                      <span>Explore Deals</span>
                      <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
                    </button>
                    <span className="font-label-sm text-label-sm text-[#e0dbff]">
                      420+ listed today
                    </span>
                  </div>
                </div>

                {/* Decorative ambient graphic overlay */}
                <div className="absolute -right-4 -bottom-6 w-32 h-32 rounded-full bg-white/10 blur-xl pointer-events-none"></div>
                <div className="absolute right-2 bottom-1 opacity-25 pointer-events-none select-none">
                  <span className="material-symbols-outlined text-[100px] text-white">menu_book</span>
                </div>
              </div>

              {/* Category Scrollable Row */}
              <div className="flex flex-col space-y-1.5">
                <div className="flex items-center justify-between">
                  <span className="font-label-lg text-label-lg font-bold text-[#1a1b23]">
                    Categories
                  </span>
                  <span className="font-label-sm text-label-sm text-[#422ec2] font-semibold">
                    Swipe for more
                  </span>
                </div>
                <div className="flex gap-2 overflow-x-auto pb-1 -mx-4 px-4 no-scrollbar">
                  {CATEGORIES.map((cat) => {
                    const isSelected = filterState.category === cat.id;
                    return (
                      <button
                        key={cat.id}
                        onClick={() =>
                          setFilterState((prev) => ({ ...prev, category: cat.id }))
                        }
                        className={`flex items-center gap-1.5 px-3.5 py-2 rounded-full font-label-md text-label-md shrink-0 shadow-xs transition-all active:scale-95 ${
                          isSelected
                            ? 'bg-[#5b4bdb] text-white font-semibold'
                            : 'bg-white text-[#1a1b23] font-medium border border-[#eeedf8] hover:bg-[#eeedf8]'
                        }`}
                      >
                        <span className="material-symbols-outlined text-[18px]">{cat.icon}</span>
                        <span>{cat.label}</span>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Quick Action Promo Banner */}
              <div className="flex items-center justify-between p-3.5 rounded-2xl bg-[#6cf8bb] text-[#002113] shadow-xs">
                <div className="flex items-center gap-2.5 min-w-0 pr-2">
                  <div className="w-9 h-9 rounded-full bg-[#006c49]/15 flex items-center justify-center shrink-0 text-[#006c49]">
                    <span className="material-symbols-outlined text-[20px]">currency_rupee</span>
                  </div>
                  <div className="flex flex-col min-w-0">
                    <span className="font-label-lg text-label-lg font-bold text-[#002113] truncate">
                      Selling unused sem materials?
                    </span>
                    <span className="font-body-sm text-body-sm text-[#00714d] truncate">
                      Earn cash in minutes from peers
                    </span>
                  </div>
                </div>
                <button
                  onClick={() => setActiveTab('sell')}
                  className="shrink-0 flex items-center gap-1 bg-[#006c49] text-white font-label-md text-label-md font-semibold px-3 py-1.5 rounded-xl shadow-xs active:scale-95 transition-transform hover:bg-[#005724]"
                >
                  <span className="material-symbols-outlined text-[16px]">add_circle</span>
                  <span>List Item</span>
                </button>
              </div>

              {/* Section Header */}
              <div className="flex items-center justify-between pt-1">
                <div className="flex items-center gap-2">
                  <span className="w-2 h-4 rounded-full bg-[#5b4bdb]"></span>
                  <h2 className="font-headline-sm text-headline-sm font-bold text-[#1a1b23]">
                    Featured Semester Deals
                  </h2>
                </div>
                <button
                  onClick={() => {
                    setFilterState({
                      minPrice: 0,
                      maxPrice: 1500,
                      condition: 'All',
                      department: 'all',
                      semester: '',
                      sortBy: 'recommended',
                      category: 'All',
                      searchQuery: '',
                    });
                    showToast(`Showing all ${listings.length} campus listings`);
                  }}
                  className="font-label-md text-label-md font-semibold text-[#422ec2] flex items-center gap-0.5 hover:underline"
                >
                  <span>See all</span>
                  <span className="material-symbols-outlined text-[16px]">chevron_right</span>
                </button>
              </div>

              {/* 2-Column Product Grid */}
              {filteredListings.length === 0 ? (
                <div className="py-12 text-center bg-white rounded-3xl p-6 border border-[#eeedf8]">
                  <p className="font-title-md text-sm font-bold text-[#1a1b23]">
                    No matching items found
                  </p>
                  <p className="text-xs text-[#474554] mt-1">
                    Try adjusting your filters or price slider to see more semester gear.
                  </p>
                  <button
                    onClick={() =>
                      setFilterState({
                        minPrice: 0,
                        maxPrice: 1500,
                        condition: 'All',
                        department: 'all',
                        semester: '',
                        sortBy: 'recommended',
                        category: 'All',
                        searchQuery: '',
                      })
                    }
                    className="mt-3 px-4 py-2 rounded-xl bg-[#5b4bdb] text-white text-xs font-bold"
                  >
                    Reset Filters
                  </button>
                </div>
              ) : (
                <div className="grid grid-cols-2 gap-3">
                  {filteredListings.map((listing) => {
                    const isFav = savedIds.includes(listing.id);
                    return (
                      <div
                        key={listing.id}
                        onClick={() => setSelectedListing(listing)}
                        className="flex flex-col rounded-2xl bg-white shadow-xs border border-[#eeedf8] overflow-hidden active:scale-[0.99] transition-all cursor-pointer group hover:border-[#c8c4d7]"
                      >
                        {/* Image + Badges */}
                        <div className="relative w-full aspect-square bg-[#eeedf8] overflow-hidden">
                          <img
                            src={listing.images[0]}
                            alt={listing.title}
                            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                          />
                          {/* Condition Badge */}
                          <span
                            className={`absolute top-2 left-2 px-2 py-0.5 rounded-full font-label-sm text-label-sm font-bold shadow-xs ${
                              listing.condition === 'Like New'
                                ? 'bg-[#6cf8bb] text-[#00714d]'
                                : listing.condition === 'Good'
                                ? 'bg-[#e4dfff] text-[#3e28be]'
                                : 'bg-[#e3e1ed] text-[#474554]'
                            }`}
                          >
                            {listing.condition}
                          </span>

                          {/* Wishlist Heart Button */}
                          <button
                            onClick={(e) => handleToggleSave(listing.id, e)}
                            aria-label="Toggle favorite"
                            className={`wishlist-btn absolute top-2 right-2 w-7 h-7 rounded-full bg-white/90 backdrop-blur-sm flex items-center justify-center shadow-xs active:scale-90 transition-transform ${
                              isFav ? 'text-[#ba1a1a]' : 'text-[#787586] hover:text-[#ba1a1a]'
                            }`}
                          >
                            <span
                              className="material-symbols-outlined text-[17px]"
                              style={{ fontVariationSettings: isFav ? "'FILL' 1" : "'FILL' 0" }}
                            >
                              favorite
                            </span>
                          </button>
                        </div>

                        {/* Content */}
                        <div className="p-2.5 flex flex-col flex-1 justify-between gap-1.5">
                          <div>
                            <div className="flex items-baseline gap-1.5">
                              <span className="font-title-md text-title-md font-bold text-[#1a1b23]">
                                ₹{listing.price}
                              </span>
                              {listing.originalPrice > listing.price && (
                                <span className="font-body-sm text-body-sm text-[#787586] line-through">
                                  ₹{listing.originalPrice}
                                </span>
                              )}
                              {listing.discountPercent && (
                                <span className="font-label-sm text-label-sm text-[#006c49] font-bold">
                                  {listing.discountPercent}% off
                                </span>
                              )}
                            </div>
                            <h3 className="font-label-lg text-label-lg font-semibold text-[#1a1b23] line-clamp-2 leading-tight mt-0.5 group-hover:text-[#422ec2] transition-colors">
                              {listing.title}
                            </h3>
                          </div>

                          <div className="space-y-1 pt-1">
                            <div className="flex items-center gap-1 font-body-sm text-body-sm text-[#474554] truncate">
                              <span className="material-symbols-outlined text-[14px] text-[#787586] shrink-0">
                                person
                              </span>
                              <span className="truncate">
                                {listing.seller.name} ({listing.seller.department})
                              </span>
                            </div>
                            <div className="flex items-center gap-1 bg-[#f4f2fe] px-1.5 py-0.5 rounded-md text-[#005724] font-label-sm text-label-sm font-medium">
                              <span
                                className="material-symbols-outlined text-[13px] text-[#005724]"
                                style={{ fontVariationSettings: "'FILL' 1" }}
                              >
                                verified
                              </span>
                              <span className="truncate">Verified Student Seller</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}

              {/* Trust & Campus Handover Assurance Banner */}
              <div className="mt-2 p-3.5 rounded-2xl bg-[#eeedf8] flex items-center gap-3 border border-[#e3e1ed]">
                <div className="w-10 h-10 rounded-full bg-[#422ec2]/10 flex items-center justify-center text-[#422ec2] shrink-0">
                  <span className="material-symbols-outlined text-[22px]">handshake</span>
                </div>
                <div className="flex flex-col">
                  <span className="font-label-lg text-label-lg font-bold text-[#1a1b23]">
                    Hand-to-Hand Campus Pickup
                  </span>
                  <span className="font-body-sm text-body-sm text-[#474554]">
                    Inspect before paying. Instant UPI or cash at campus library &amp; hostel common rooms.
                  </span>
                </div>
              </div>
            </div>
          )}
        </main>

        {/* Fixed Bottom Navigation Bar */}
        {!selectedListing && (
          <BottomNav
            activeTab={activeTab}
            onTabChange={(tab) => {
              setSelectedListing(null);
              setActiveTab(tab);
            }}
            savedCount={savedIds.length}
          />
        )}

        {/* Filter and Sort Bottom Sheet */}
        <FilterSortSheet
          isOpen={isFilterOpen}
          onClose={() => setIsFilterOpen(false)}
          filterState={filterState}
          onFilterChange={(newF) => setFilterState(newF)}
          resultCount={filteredListings.length}
        />

        {/* Toast Feedback */}
        <Toast isVisible={isToastVisible} message={toastMessage} icon={toastIcon} />
      </div>
    </div>
  );
}
