import React from 'react';

export type NavTab = 'home' | 'saved' | 'sell' | 'profile';

interface BottomNavProps {
  activeTab: NavTab;
  onTabChange: (tab: NavTab) => void;
  savedCount: number;
}

export const BottomNav: React.FC<BottomNavProps> = ({
  activeTab,
  onTabChange,
  savedCount,
}) => {
  return (
    <nav className="fixed bottom-0 left-0 right-0 z-40 pb-safe bg-[#fbf8ff]/85 backdrop-blur-xl border-t border-[#eeedf8] shadow-[0_-4px_20px_rgba(0,0,0,0.05)]">
      <div className="max-w-md mx-auto flex justify-around items-center h-20 px-1">
        {/* Home */}
        <button
          onClick={() => onTabChange('home')}
          className={`flex flex-col items-center justify-center gap-1 min-w-[64px] min-h-[48px] py-1 transition-colors group ${
            activeTab === 'home' ? 'text-[#5b4bdb]' : 'text-[#474554] hover:text-[#1a1b23]'
          }`}
        >
          <div className="relative flex items-center justify-center px-4 py-1 rounded-full group-hover:bg-[#eeedf8] transition-colors">
            <span
              className="material-symbols-outlined text-[24px]"
              style={{ fontVariationSettings: activeTab === 'home' ? "'FILL' 1" : "'FILL' 0" }}
            >
              storefront
            </span>
            {activeTab === 'home' && (
              <span className="absolute top-1 right-2.5 w-1.5 h-1.5 rounded-full bg-[#5b4bdb]"></span>
            )}
          </div>
          <span className="font-label-sm text-label-sm font-semibold tracking-wide">Home</span>
        </button>

        {/* Saved */}
        <button
          onClick={() => onTabChange('saved')}
          className={`flex flex-col items-center justify-center gap-1 min-w-[64px] min-h-[48px] py-1 transition-colors group ${
            activeTab === 'saved' ? 'text-[#5b4bdb]' : 'text-[#474554] hover:text-[#1a1b23]'
          }`}
        >
          <div className="relative flex items-center justify-center px-4 py-1 rounded-full group-hover:bg-[#eeedf8] transition-colors">
            <span
              className="material-symbols-outlined text-[24px]"
              style={{ fontVariationSettings: activeTab === 'saved' ? "'FILL' 1" : "'FILL' 0" }}
            >
              favorite
            </span>
            {savedCount > 0 && (
              <span className="absolute -top-0.5 right-1.5 min-w-[16px] h-4 px-1 rounded-full bg-[#ba1a1a] text-white text-[10px] font-bold flex items-center justify-center shadow-xs">
                {savedCount}
              </span>
            )}
          </div>
          <span className="font-label-sm text-label-sm font-semibold tracking-wide">Saved</span>
        </button>

        {/* Sell */}
        <button
          onClick={() => onTabChange('sell')}
          className={`flex flex-col items-center justify-center gap-1 min-w-[64px] min-h-[48px] py-1 transition-colors group ${
            activeTab === 'sell' ? 'text-[#5b4bdb]' : 'text-[#474554] hover:text-[#1a1b23]'
          }`}
        >
          <div className="flex items-center justify-center w-12 h-8 rounded-full bg-[#5b4bdb] text-white shadow-sm active:scale-95 transition-transform hover:bg-[#422ec2]">
            <span className="material-symbols-outlined text-[22px]">add</span>
          </div>
          <span className="font-label-sm text-label-sm font-semibold tracking-wide">Sell</span>
        </button>

        {/* Profile */}
        <button
          onClick={() => onTabChange('profile')}
          className={`flex flex-col items-center justify-center gap-1 min-w-[64px] min-h-[48px] py-1 transition-colors group ${
            activeTab === 'profile' ? 'text-[#5b4bdb]' : 'text-[#474554] hover:text-[#1a1b23]'
          }`}
        >
          <div className="relative flex items-center justify-center px-4 py-1 rounded-full group-hover:bg-[#eeedf8] transition-colors">
            <span
              className="material-symbols-outlined text-[24px]"
              style={{ fontVariationSettings: activeTab === 'profile' ? "'FILL' 1" : "'FILL' 0" }}
            >
              person
            </span>
          </div>
          <span className="font-label-sm text-label-sm font-semibold tracking-wide">Profile</span>
        </button>
      </div>
    </nav>
  );
};
