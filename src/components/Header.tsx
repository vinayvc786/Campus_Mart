import React, { useState } from 'react';
import { CAMPUS_LOGO, USER_AVATAR } from '../data/mockData';

interface HeaderProps {
  onProfileClick: () => void;
  onHomeClick: () => void;
  showBack?: boolean;
  onBack?: () => void;
  title?: string;
  hasUnreadNotifications?: boolean;
}

export const Header: React.FC<HeaderProps> = ({
  onProfileClick,
  onHomeClick,
  showBack = false,
  onBack,
  title,
  hasUnreadNotifications = true,
}) => {
  const [showNotificationMenu, setShowNotificationMenu] = useState(false);

  return (
    <header className="fixed top-0 left-0 right-0 z-50 pt-safe bg-[#fbf8ff]/85 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] border-b border-[#eeedf8]">
      <div className="max-w-md mx-auto h-16 px-4 flex items-center justify-between gap-2">
        {showBack ? (
          <div className="flex items-center gap-1.5 flex-1 min-w-0">
            <button
              onClick={onBack}
              aria-label="Go Back"
              className="w-10 h-10 -ml-1.5 flex items-center justify-center rounded-full text-[#1a1b23] hover:bg-[#eeedf8] active:bg-[#e8e7f2] transition-colors"
            >
              <span className="material-symbols-outlined text-[24px]">arrow_back</span>
            </button>
            <button onClick={onHomeClick} className="flex items-center gap-2 group text-left">
              <img
                alt="Campus Mart Logo"
                className="h-7 w-auto object-contain"
                src={CAMPUS_LOGO}
              />
              <h1 className="font-title-md text-title-md text-[#1a1b23] truncate font-bold">
                {title || 'Campus Mart'}
              </h1>
            </button>
          </div>
        ) : (
          <button
            onClick={onHomeClick}
            className="flex items-center gap-2 text-left transition-opacity hover:opacity-90 active:scale-98"
          >
            <img
              alt="Campus Mart Logo"
              className="h-8 w-auto object-contain"
              src={CAMPUS_LOGO}
            />
            <span className="font-headline-sm text-headline-sm text-[#1a1b23] font-bold tracking-tight">
              Campus Mart
            </span>
          </button>
        )}

        <div className="flex items-center gap-1 shrink-0">
          <div className="relative">
            <button
              onClick={() => setShowNotificationMenu(!showNotificationMenu)}
              aria-label="Notifications"
              className="w-11 h-11 relative flex items-center justify-center rounded-full text-[#474554] hover:bg-[#eeedf8] active:bg-[#e8e7f2] transition-colors"
            >
              <span className="material-symbols-outlined text-[24px]">notifications</span>
              {hasUnreadNotifications && (
                <span className="absolute top-2.5 right-2.5 w-2 h-2 rounded-full bg-[#ba1a1a] ring-2 ring-[#fbf8ff]"></span>
              )}
            </button>

            {showNotificationMenu && (
              <div className="absolute right-0 top-12 w-80 bg-white rounded-2xl shadow-xl border border-[#e3e1ed] p-3 z-50 animate-in fade-in zoom-in-95 duration-150">
                <div className="flex items-center justify-between pb-2 mb-2 border-b border-[#eeedf8]">
                  <span className="font-title-md text-sm font-bold text-[#1a1b23]">Campus Alerts</span>
                  <span className="text-[11px] font-semibold text-[#422ec2] bg-[#e4dfff] px-2 py-0.5 rounded-full">2 New</span>
                </div>
                <div className="space-y-2">
                  <div className="p-2 rounded-xl bg-[#f4f2fe] flex items-start gap-2.5">
                    <span className="material-symbols-outlined text-[#006c49] text-[18px] mt-0.5">verified</span>
                    <div>
                      <p className="text-xs font-semibold text-[#1a1b23]">Aarav accepted WhatsApp meet</p>
                      <p className="text-[11px] text-[#474554]">Hostel 12 lobby at 5:30 PM today</p>
                      <span className="text-[10px] text-[#787586]">15m ago</span>
                    </div>
                  </div>
                  <div className="p-2 rounded-xl bg-[#fbf8ff] flex items-start gap-2.5">
                    <span className="material-symbols-outlined text-[#422ec2] text-[18px] mt-0.5">local_offer</span>
                    <div>
                      <p className="text-xs font-semibold text-[#1a1b23]">New Drafter listed in SRKR Hub</p>
                      <p className="text-[11px] text-[#474554]">60% off original MRP by Civil senior</p>
                      <span className="text-[10px] text-[#787586]">1h ago</span>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>

          <button
            onClick={onProfileClick}
            aria-label="Profile"
            className="w-11 h-11 flex items-center justify-center rounded-full transition-transform active:scale-95"
          >
            <img
              alt="Profile"
              className="w-8 h-8 rounded-full object-cover ring-2 ring-[#5b4bdb]/20"
              src={USER_AVATAR}
            />
          </button>
        </div>
      </div>
    </header>
  );
};
