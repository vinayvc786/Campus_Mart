import React from 'react';

interface ToastProps {
  message: string;
  icon?: string;
  isVisible: boolean;
}

export const Toast: React.FC<ToastProps> = ({ message, icon = 'bookmark_added', isVisible }) => {
  if (!isVisible) return null;

  return (
    <div className="fixed top-20 left-1/2 -translate-x-1/2 z-50 bg-[#2f3038] text-[#f1effb] px-4 py-2.5 rounded-full shadow-xl font-label-md text-label-md flex items-center gap-2 transition-all duration-300 animate-in fade-in slide-in-from-top-2">
      <span className="material-symbols-outlined text-[#66ff8e] text-[18px]">
        {icon}
      </span>
      <span>{message}</span>
    </div>
  );
};
