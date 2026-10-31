import React from 'react';
import { Condition, FilterState } from '../types';

interface FilterSortSheetProps {
  isOpen: boolean;
  onClose: () => void;
  filterState: FilterState;
  onFilterChange: (newFilterState: FilterState) => void;
  resultCount: number;
}

export const FilterSortSheet: React.FC<FilterSortSheetProps> = ({
  isOpen,
  onClose,
  filterState,
  onFilterChange,
  resultCount,
}) => {
  if (!isOpen) return null;

  const handlePriceChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    onFilterChange({
      ...filterState,
      maxPrice: Number(e.target.value),
    });
  };

  const handleConditionSelect = (c: Condition) => {
    onFilterChange({
      ...filterState,
      condition: filterState.condition === c ? 'All' : c,
    });
  };

  const handleSemesterSelect = (sem: string) => {
    onFilterChange({
      ...filterState,
      semester: filterState.semester === sem ? '' : sem,
    });
  };

  const handleReset = () => {
    onFilterChange({
      minPrice: 0,
      maxPrice: 1500,
      condition: 'All',
      department: 'all',
      semester: '',
      sortBy: 'recommended',
      category: 'All',
      searchQuery: '',
    });
  };

  // Count active filters (condition, department, semester, custom price)
  let activeCount = 0;
  if (filterState.condition !== 'All') activeCount++;
  if (filterState.department !== 'all') activeCount++;
  if (filterState.semester !== '') activeCount++;
  if (filterState.maxPrice < 1500) activeCount++;
  if (filterState.sortBy !== 'recommended') activeCount++;

  return (
    <div
      className="fixed inset-0 z-50 bg-[#0B0B14]/50 backdrop-blur-sm transition-opacity duration-300 flex flex-col justify-end"
      onClick={onClose}
    >
      <div
        className="w-full max-w-md mx-auto bg-white rounded-t-3xl shadow-2xl flex flex-col max-h-[85vh] overflow-hidden animate-in slide-in-from-bottom duration-300"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Drag Handle & Top Header */}
        <div className="flex flex-col items-center pt-3 px-4 pb-2 shrink-0 bg-white border-b border-[#eeedf8]">
          <div className="w-10 h-1 rounded-full bg-[#e3e1ed] mb-3"></div>
          <div className="flex items-center justify-between w-full">
            <div className="flex items-center gap-2">
              <h2 className="font-headline-sm text-headline-sm text-[#1a1b23] font-bold">
                Filter &amp; Sort
              </h2>
              {activeCount > 0 && (
                <span className="px-2 py-0.5 rounded-full bg-[#e4dfff] text-[#3e28be] font-label-sm text-label-sm font-semibold">
                  {activeCount} active
                </span>
              )}
            </div>
            <div className="flex items-center gap-2">
              <button
                onClick={handleReset}
                className="font-label-md text-label-md text-[#422ec2] font-semibold hover:opacity-80 active:scale-95 transition-transform"
              >
                Reset All
              </button>
              <button
                onClick={onClose}
                aria-label="Close Filter Sheet"
                className="w-8 h-8 rounded-full flex items-center justify-center bg-[#eeedf8] text-[#474554] hover:bg-[#e8e7f2] transition-colors active:scale-95"
              >
                <span className="material-symbols-outlined text-[18px]">close</span>
              </button>
            </div>
          </div>
        </div>

        {/* Scrollable Filter Options Body */}
        <div className="flex-1 overflow-y-auto px-4 py-3 flex flex-col gap-5">
          {/* Section: Price Range */}
          <div className="flex flex-col gap-2">
            <div className="flex items-center justify-between">
              <span className="font-title-md text-title-md text-[#1a1b23] font-bold">Price Range</span>
              <span className="font-label-md text-label-md text-[#422ec2] font-semibold">
                ₹{filterState.minPrice} - ₹{filterState.maxPrice}
              </span>
            </div>
            {/* Visual Range Track & Slider */}
            <div className="relative w-full pt-3 pb-1">
              <input
                type="range"
                min="100"
                max="1500"
                step="50"
                value={filterState.maxPrice}
                onChange={handlePriceChange}
                className="w-full h-2 bg-[#eeedf8] rounded-lg appearance-none cursor-pointer accent-[#5b4bdb]"
              />
              <div className="flex justify-between items-center text-[#474554] font-body-sm text-body-sm mt-2">
                <span>₹100 (Min)</span>
                <span>₹1,500 (Max)</span>
              </div>
            </div>
          </div>

          {/* Section: Condition Selector (Pill chips) */}
          <div className="flex flex-col gap-2">
            <span className="font-title-md text-title-md text-[#1a1b23] font-bold">Condition</span>
            <div className="grid grid-cols-4 gap-2">
              {(['New', 'Like New', 'Good', 'Fair'] as Condition[]).map((cond) => {
                const isSelected = filterState.condition === cond;
                return (
                  <button
                    key={cond}
                    type="button"
                    onClick={() => handleConditionSelect(cond)}
                    className={`h-9 rounded-full font-label-md text-label-md font-semibold transition-all flex items-center justify-center gap-1 ${
                      isSelected
                        ? 'bg-[#5b4bdb] text-white shadow-xs'
                        : 'bg-[#eeedf8] text-[#474554] hover:bg-[#e8e7f2]'
                    }`}
                  >
                    {isSelected && (
                      <span className="material-symbols-outlined text-[15px]">check</span>
                    )}
                    {cond}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Section: Academic Filters */}
          <div className="flex flex-col gap-4">
            <div className="flex flex-col gap-1.5">
              <span className="font-title-md text-title-md text-[#1a1b23] font-bold">
                Department / Branch
              </span>
              <div className="relative w-full">
                <select
                  value={filterState.department}
                  onChange={(e) =>
                    onFilterChange({ ...filterState, department: e.target.value })
                  }
                  className="w-full h-12 bg-[#eeedf8] rounded-xl px-4 font-body-md text-body-md text-[#1a1b23] appearance-none outline-none focus:ring-2 focus:ring-[#5b4bdb] cursor-pointer pr-10"
                >
                  <option value="all">All Departments</option>
                  <option value="mech">Mechanical Engineering</option>
                  <option value="cs">Computer Science &amp; Engg</option>
                  <option value="ee">Electrical Engineering</option>
                  <option value="civil">Civil Engineering</option>
                  <option value="it">Information Technology</option>
                </select>
                <span className="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-[#474554] pointer-events-none">
                  expand_more
                </span>
              </div>
            </div>

            {/* Semester Pills */}
            <div className="flex flex-col gap-1.5">
              <span className="font-label-lg text-label-lg text-[#1a1b23] font-semibold">
                Semester Relevance
              </span>
              <div className="flex items-center gap-2 overflow-x-auto pb-1 no-scrollbar">
                {['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Sem 5', 'Sem 6'].map((sem) => {
                  const isSelected = filterState.semester === sem;
                  return (
                    <button
                      key={sem}
                      type="button"
                      onClick={() => handleSemesterSelect(sem)}
                      className={`px-4 py-1.5 rounded-full font-label-sm text-label-sm font-semibold whitespace-nowrap transition-all flex items-center gap-1 ${
                        isSelected
                          ? 'bg-[#e4dfff] text-[#3e28be] font-bold shadow-xs'
                          : 'bg-[#eeedf8] text-[#474554] hover:bg-[#e8e7f2]'
                      }`}
                    >
                      {isSelected && (
                        <span className="material-symbols-outlined text-[14px]">check</span>
                      )}
                      {sem}
                    </button>
                  );
                })}
              </div>
            </div>
          </div>

          {/* Section: Sort By */}
          <div className="flex flex-col gap-2">
            <span className="font-title-md text-title-md text-[#1a1b23] font-bold">Sort By</span>
            <div className="flex flex-col gap-2">
              {[
                { id: 'recommended', label: 'Recommended for your batch' },
                { id: 'low-to-high', label: 'Price: Low to High' },
                { id: 'high-to-low', label: 'Price: High to Low' },
                { id: 'newest', label: 'Newest First' },
              ].map((opt) => {
                const isSelected = filterState.sortBy === opt.id;
                return (
                  <label
                    key={opt.id}
                    onClick={() =>
                      onFilterChange({
                        ...filterState,
                        sortBy: opt.id as FilterState['sortBy'],
                      })
                    }
                    className={`flex items-center justify-between p-3 rounded-xl transition-colors cursor-pointer ${
                      isSelected
                        ? 'bg-[#e4dfff]/30 border border-[#c6c0ff]'
                        : 'bg-[#f4f2fe] hover:bg-[#eeedf8]'
                    }`}
                  >
                    <span
                      className={`font-body-md text-body-md ${
                        isSelected ? 'text-[#422ec2] font-bold' : 'text-[#1a1b23] font-medium'
                      }`}
                    >
                      {opt.label}
                    </span>
                    <input
                      type="radio"
                      name="sortOption"
                      checked={isSelected}
                      readOnly
                      className="w-4 h-4 text-[#422ec2] accent-[#422ec2]"
                    />
                  </label>
                );
              })}
            </div>
          </div>
        </div>

        {/* Sticky Bottom Action Button */}
        <div className="p-4 bg-white border-t border-[#eeedf8] shadow-lg shrink-0">
          <button
            onClick={onClose}
            className="w-full h-12 rounded-xl bg-[#5b4bdb] text-white font-label-lg text-label-lg font-bold shadow-md hover:bg-[#422ec2] active:scale-[0.98] transition-all flex items-center justify-center gap-2"
          >
            <span>Show {resultCount} Results</span>
            <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
          </button>
        </div>
      </div>
    </div>
  );
};
