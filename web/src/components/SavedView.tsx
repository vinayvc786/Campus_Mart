import React from 'react';
import { Listing } from '../types';

interface SavedViewProps {
  savedListings: Listing[];
  onSelectListing: (listing: Listing) => void;
  onRemoveSaved: (id: string) => void;
  onExplore: () => void;
}

export const SavedView: React.FC<SavedViewProps> = ({
  savedListings,
  onSelectListing,
  onRemoveSaved,
  onExplore,
}) => {
  const totalOriginal = savedListings.reduce((sum, item) => sum + item.originalPrice, 0);
  const totalSelling = savedListings.reduce((sum, item) => sum + item.price, 0);
  const totalSavings = Math.max(0, totalOriginal - totalSelling);

  return (
    <div className="flex flex-col w-full min-h-screen bg-[#fbf8ff] px-4 pt-2 pb-24">
      {/* Header Info */}
      <div className="flex flex-col gap-1 mb-4">
        <h2 className="font-headline-md text-headline-md font-bold text-[#1a1b23]">
          Saved Gear &amp; Books
        </h2>
        <p className="font-body-sm text-[#474554]">
          Items you bookmarked for this semester. Direct chat or inspect on campus.
        </p>
      </div>

      {/* Savings Summary Banner */}
      {savedListings.length > 0 && (
        <div className="bg-gradient-to-r from-[#422ec2] to-[#5b4bdb] rounded-2xl p-4 text-white shadow-md mb-4 flex items-center justify-between">
          <div>
            <span className="text-[11px] uppercase tracking-wider text-[#e0dbff] font-bold">
              Potential Savings
            </span>
            <div className="flex items-baseline gap-2 mt-0.5">
              <span className="text-2xl font-bold font-headline">₹{totalSavings}</span>
              <span className="text-xs text-[#e0dbff]">saved vs showroom MRP</span>
            </div>
          </div>
          <div className="w-10 h-10 rounded-full bg-white/15 flex items-center justify-center">
            <span className="material-symbols-outlined text-[24px]">savings</span>
          </div>
        </div>
      )}

      {/* List of Saved Items */}
      {savedListings.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-16 text-center bg-white rounded-3xl p-8 border border-[#eeedf8] shadow-sm">
          <div className="w-16 h-16 rounded-full bg-[#f4f2fe] flex items-center justify-center text-[#422ec2] mb-3">
            <span className="material-symbols-outlined text-[32px]">bookmark_border</span>
          </div>
          <h3 className="font-title-md text-base font-bold text-[#1a1b23]">
            No saved listings yet
          </h3>
          <p className="text-sm text-[#474554] mt-1 max-w-xs">
            Tap the heart on drafters, calculators, or senior notes to save them for quick campus lookup.
          </p>
          <button
            onClick={onExplore}
            className="mt-4 px-5 py-2.5 rounded-full bg-[#5b4bdb] text-white font-label-md font-bold shadow-sm hover:bg-[#422ec2] transition-colors"
          >
            Explore Deals
          </button>
        </div>
      ) : (
        <div className="flex flex-col gap-3">
          {savedListings.map((item) => (
            <div
              key={item.id}
              className="bg-white rounded-2xl p-3 shadow-sm border border-[#eeedf8] flex gap-3 cursor-pointer hover:border-[#c8c4d7] transition-all group"
              onClick={() => onSelectListing(item)}
            >
              <div className="relative w-24 h-24 rounded-xl overflow-hidden bg-[#eeedf8] shrink-0">
                <img
                  src={item.images[0]}
                  alt={item.title}
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform"
                />
                <span className="absolute top-1 left-1 px-1.5 py-0.2 rounded-md bg-[#6cf8bb] text-[#00714d] text-[10px] font-bold">
                  {item.condition}
                </span>
              </div>

              <div className="flex flex-col justify-between flex-1 min-w-0">
                <div>
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-semibold text-[#422ec2] bg-[#e4dfff] px-2 py-0.2 rounded-full">
                      {item.department}
                    </span>
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        onRemoveSaved(item.id);
                      }}
                      aria-label="Remove from saved"
                      className="text-[#787586] hover:text-[#ba1a1a] p-1 rounded-full hover:bg-[#eeedf8]"
                    >
                      <span className="material-symbols-outlined text-[18px]">delete</span>
                    </button>
                  </div>
                  <h4 className="font-title-md text-sm font-bold text-[#1a1b23] line-clamp-1 mt-1">
                    {item.title}
                  </h4>
                  <p className="text-[11px] text-[#474554] truncate">
                    Seller: {item.seller.name} • {item.location}
                  </p>
                </div>

                <div className="flex items-baseline justify-between mt-2">
                  <div className="flex items-baseline gap-1.5">
                    <span className="text-base font-bold text-[#422ec2] font-headline">
                      ₹{item.price}
                    </span>
                    <span className="text-xs text-[#787586] line-through">
                      ₹{item.originalPrice}
                    </span>
                  </div>
                  <span className="text-xs font-semibold text-[#006c49] flex items-center gap-0.5">
                    View Details
                    <span className="material-symbols-outlined text-[14px]">chevron_right</span>
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
