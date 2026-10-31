import React, { useState } from 'react';
import { Listing } from '../types';

interface ListingDetailViewProps {
  listing: Listing;
  onBack: () => void;
  isSaved: boolean;
  onToggleSave: (id: string) => void;
  onToast: (msg: string) => void;
}

export const ListingDetailView: React.FC<ListingDetailViewProps> = ({
  listing,
  onBack,
  isSaved,
  onToggleSave,
  onToast,
}) => {
  const [activeImageIndex, setActiveImageIndex] = useState(0);
  const [showChatModal, setShowChatModal] = useState(false);
  const [chatMessage, setChatMessage] = useState(
    `Hi ${listing.seller.name}, I saw your listing for "${listing.title}" on Campus Mart. Is it still available for inspection at ${listing.location}?`
  );
  const [isReported, setIsReported] = useState(false);

  const images = listing.images && listing.images.length > 0 ? listing.images : ['/assets/aistudio/Image_1_332b6fe5.jpeg'];

  const handleShare = async () => {
    if (navigator.share) {
      try {
        await navigator.share({
          title: `${listing.title} - Campus Mart`,
          text: `Check out ${listing.title} listed for ₹${listing.price} on Campus Mart!`,
          url: window.location.href,
        });
      } catch {
        // Share cancelled
      }
    } else {
      navigator.clipboard?.writeText(window.location.href);
      onToast('Listing link copied to clipboard!');
    }
  };

  const handleWhatsApp = () => {
    const encoded = encodeURIComponent(
      `Hi ${listing.seller.name}, I'm interested in your "${listing.title}" (Listing #${listing.id}) on Campus Mart. Is it still available?`
    );
    window.open(`https://wa.me/919876543210?text=${encoded}`, '_blank');
  };

  const handleReport = () => {
    setIsReported(true);
    onToast(`Listing #${listing.id} reported to campus moderators for review.`);
  };

  return (
    <div className="flex flex-col w-full min-h-screen bg-[#fbf8ff] pb-32">
      {/* Top Action Row */}
      <div className="flex items-center justify-between py-2 mb-1 px-4">
        <button
          onClick={onBack}
          aria-label="Go Back"
          className="w-10 h-10 flex items-center justify-center rounded-full bg-[#f4f2fe] text-[#1a1b23] hover:bg-[#eeedf8] active:scale-95 transition-transform"
        >
          <span className="material-symbols-outlined text-[20px]">arrow_back</span>
        </button>
        <div className="flex items-center gap-2">
          <button
            onClick={handleShare}
            aria-label="Share listing"
            className="w-10 h-10 flex items-center justify-center rounded-full bg-[#f4f2fe] text-[#1a1b23] hover:bg-[#eeedf8] active:scale-95 transition-all"
          >
            <span className="material-symbols-outlined text-[20px]">share</span>
          </button>
          <button
            onClick={() => onToggleSave(listing.id)}
            aria-label="Save listing"
            className="w-10 h-10 flex items-center justify-center rounded-full bg-[#f4f2fe] text-[#1a1b23] hover:bg-[#eeedf8] active:scale-90 transition-all"
          >
            <span
              className={`material-symbols-outlined text-[20px] transition-colors ${
                isSaved ? 'text-[#ba1a1a]' : 'text-[#787586]'
              }`}
              style={{ fontVariationSettings: isSaved ? "'FILL' 1" : "'FILL' 0" }}
            >
              favorite
            </span>
          </button>
        </div>
      </div>

      <div className="px-4 flex flex-col gap-3">
        {/* Hero Carousel Container */}
        <div className="relative w-full aspect-square rounded-2xl overflow-hidden bg-white shadow-md border border-[#eeedf8]">
          <div className="w-full h-full relative">
            <img
              src={images[activeImageIndex]}
              alt={listing.title}
              className="w-full h-full object-cover transition-opacity duration-200"
            />
          </div>

          {/* Condition Badge overlay */}
          <div className="absolute top-3 left-3 z-10">
            <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-[#6cf8bb] text-[#00714d] font-label-sm text-label-sm font-bold shadow-sm backdrop-blur-md">
              <span className="material-symbols-outlined text-[14px]" style={{ fontVariationSettings: "'FILL' 1" }}>
                verified
              </span>
              {listing.condition} {listing.conditionDetail ? `• ${listing.conditionDetail}` : ''}
            </span>
          </div>

          {/* Pagination Pill */}
          {images.length > 1 && (
            <div className="absolute bottom-3 right-3 z-10 px-2.5 py-0.5 rounded-full bg-[#2f3038]/80 text-[#f1effb] font-label-sm text-label-sm backdrop-blur-sm shadow-sm">
              <span>{activeImageIndex + 1}</span>/{images.length}
            </div>
          )}

          {/* Prev/Next buttons if multiple images */}
          {images.length > 1 && (
            <>
              <button
                onClick={() => setActiveImageIndex((prev) => (prev > 0 ? prev - 1 : images.length - 1))}
                aria-label="Previous photo"
                className="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 rounded-full bg-white/80 backdrop-blur-sm flex items-center justify-center text-[#1a1b23] shadow-md hover:bg-white active:scale-90"
              >
                <span className="material-symbols-outlined text-[18px]">chevron_left</span>
              </button>
              <button
                onClick={() => setActiveImageIndex((prev) => (prev < images.length - 1 ? prev + 1 : 0))}
                aria-label="Next photo"
                className="absolute right-2 top-1/2 -translate-y-1/2 w-8 h-8 rounded-full bg-white/80 backdrop-blur-sm flex items-center justify-center text-[#1a1b23] shadow-md hover:bg-white active:scale-90"
              >
                <span className="material-symbols-outlined text-[18px]">chevron_right</span>
              </button>
            </>
          )}

          {/* Thumbnail dots */}
          {images.length > 1 && (
            <div className="absolute bottom-3 left-1/2 -translate-x-1/2 flex items-center gap-1.5 z-10">
              {images.map((_, i) => (
                <button
                  key={i}
                  onClick={() => setActiveImageIndex(i)}
                  className={`w-2 h-2 rounded-full transition-all ${
                    activeImageIndex === i ? 'w-5 bg-[#5b4bdb]' : 'bg-white/70'
                  }`}
                />
              ))}
            </div>
          )}
        </div>

        {/* Title & Price Block */}
        <div className="bg-white p-4 rounded-2xl shadow-sm border border-[#eeedf8] flex flex-col gap-1.5">
          <div className="flex items-baseline justify-between gap-2">
            <div className="flex items-baseline gap-2">
              <span className="font-headline-lg-mobile text-headline-lg-mobile text-[#422ec2] font-bold">
                ₹{listing.price}
              </span>
              <span className="font-body-md text-body-md text-[#787586] line-through">
                ₹{listing.originalPrice}
              </span>
            </div>
            {listing.discountPercent && (
              <span className="px-2 py-0.5 rounded-md bg-[#66ff8e] text-[#002109] font-label-sm text-label-sm font-bold">
                {listing.discountPercent}% OFF
              </span>
            )}
          </div>
          <h2 className="font-headline-sm text-headline-sm text-[#1a1b23] leading-snug pt-0.5">
            {listing.title}
          </h2>
          <div className="flex items-center gap-1.5 pt-1 text-[#474554] font-body-sm text-body-sm">
            <span className="material-symbols-outlined text-[16px] text-[#422ec2]">location_on</span>
            <span className="font-medium text-[#1a1b23]">{listing.location}</span>
            <span className="text-[#c8c4d7]">•</span>
            <span>{listing.handoverType}</span>
          </div>
        </div>

        {/* Specs Grid */}
        <div className="grid grid-cols-2 gap-2">
          <div className="bg-[#f4f2fe] p-3 rounded-xl flex flex-col gap-0.5">
            <span className="text-[#474554] font-label-sm text-label-sm uppercase tracking-wide">
              Category
            </span>
            <span className="text-[#1a1b23] font-label-lg text-label-lg font-semibold truncate">
              {listing.category}
            </span>
          </div>
          <div className="bg-[#f4f2fe] p-3 rounded-xl flex flex-col gap-0.5">
            <span className="text-[#474554] font-label-sm text-label-sm uppercase tracking-wide">
              For Branch
            </span>
            <span className="text-[#1a1b23] font-label-lg text-label-lg font-semibold truncate">
              {listing.department}
            </span>
          </div>
          <div className="bg-[#f4f2fe] p-3 rounded-xl flex flex-col gap-0.5">
            <span className="text-[#474554] font-label-sm text-label-sm uppercase tracking-wide">
              Semester
            </span>
            <span className="text-[#1a1b23] font-label-lg text-label-lg font-semibold truncate">
              {listing.semester}
            </span>
          </div>
          <div className="bg-[#f4f2fe] p-3 rounded-xl flex flex-col gap-0.5">
            <span className="text-[#474554] font-label-sm text-label-sm uppercase tracking-wide">
              Listed
            </span>
            <span className="text-[#1a1b23] font-label-lg text-label-lg font-semibold truncate">
              {listing.listedTimeAgo}
            </span>
          </div>
        </div>

        {/* Item Description */}
        <div className="bg-white p-4 rounded-2xl shadow-sm border border-[#eeedf8] flex flex-col gap-2">
          <h3 className="font-title-md text-title-md text-[#1a1b23] font-bold">Description</h3>
          <p className="font-body-md text-body-md text-[#474554] leading-relaxed">
            {listing.description}
          </p>

          {/* Inspection Perk Note */}
          {listing.inspectionPerk && (
            <div className="mt-1 p-2.5 rounded-xl bg-[#f4f2fe] flex items-start gap-2 border border-[#e4dfff]">
              <span className="material-symbols-outlined text-[#422ec2] text-[18px] mt-0.5">
                checklist
              </span>
              <p className="font-body-sm text-body-sm text-[#474554]">
                {listing.inspectionPerk}
              </p>
            </div>
          )}
        </div>

        {/* Verified Senior Seller Card */}
        <div className="bg-white p-4 rounded-2xl shadow-sm border border-[#eeedf8] flex flex-col gap-3">
          <div className="flex items-center gap-3">
            <div className="relative">
              <img
                src={listing.seller.avatar}
                alt={listing.seller.name}
                className="w-12 h-12 rounded-full object-cover ring-2 ring-[#5b4bdb]/20"
              />
              {listing.seller.isRollVerified && (
                <span className="absolute -bottom-1 -right-1 w-5 h-5 rounded-full bg-[#006c49] flex items-center justify-center text-white shadow-sm">
                  <span className="material-symbols-outlined text-[13px]" style={{ fontVariationSettings: "'FILL' 1" }}>
                    check
                  </span>
                </span>
              )}
            </div>
            <div className="flex flex-col min-w-0 flex-1">
              <div className="flex items-center gap-1.5">
                <h4 className="font-title-md text-title-md text-[#1a1b23] font-bold truncate">
                  {listing.seller.name}
                </h4>
                <span className="px-1.5 py-0.2 rounded bg-[#e4dfff] text-[#150066] font-label-sm text-label-sm font-semibold">
                  {listing.seller.role}
                </span>
              </div>
              <p className="font-body-sm text-body-sm text-[#474554] truncate">
                {listing.seller.department} {listing.seller.batch} • Roll Verified
              </p>
            </div>
          </div>

          <div className="flex items-center justify-between pt-1 px-1">
            <div className="flex items-center gap-1">
              <span className="material-symbols-outlined text-amber-500 text-[18px]" style={{ fontVariationSettings: "'FILL' 1" }}>
                star
              </span>
              <span className="font-label-lg text-label-lg font-bold text-[#1a1b23]">
                {listing.seller.rating}
              </span>
              <span className="font-body-sm text-body-sm text-[#787586]">
                ({listing.seller.peerSalesCount} peer sales)
              </span>
            </div>
            <div className="flex items-center gap-1 text-[#474554] font-label-md text-label-md">
              <span className="material-symbols-outlined text-[16px] text-[#006c49]">bolt</span>
              <span>Replies in {listing.seller.replyTime}</span>
            </div>
          </div>

          {/* Campus Trust Banner */}
          <div className="p-2.5 bg-[#f4f2fe] rounded-xl flex items-center gap-2">
            <span className="material-symbols-outlined text-[#787586] text-[16px]">verified_user</span>
            <span className="font-label-sm text-label-sm text-[#474554]">
              Campus Safe: Exchange at day-time common areas or library.
            </span>
          </div>
        </div>

        {/* Report Listing */}
        <div className="mt-2 mb-2 flex justify-center">
          <button
            onClick={handleReport}
            disabled={isReported}
            className="inline-flex items-center gap-1 text-[#787586] hover:text-[#ba1a1a] transition-colors font-label-md text-label-md"
          >
            <span className="material-symbols-outlined text-[16px]">flag</span>
            <span>{isReported ? 'Report Submitted' : 'Report this listing'}</span>
          </button>
        </div>
      </div>

      {/* Persistent Sticky Bottom Action Dock */}
      <div className="fixed bottom-0 left-0 right-0 z-40 bg-white/95 backdrop-blur-md px-4 py-3 shadow-[0_-4px_20px_rgba(0,0,0,0.06)] border-t border-[#eeedf8] pb-safe">
        <div className="max-w-md mx-auto flex flex-col gap-1.5">
          <div className="flex items-center gap-2">
            <button
              onClick={() => setShowChatModal(true)}
              className="flex-1 h-12 rounded-xl bg-[#5b4bdb] hover:bg-[#422ec2] active:scale-[0.98] transition-all flex items-center justify-center gap-1.5 text-white font-title-md text-title-md shadow-md"
            >
              <span className="material-symbols-outlined text-[20px]">chat</span>
              <span>In-App Message</span>
            </button>

            <button
              onClick={handleWhatsApp}
              className="flex-[1.5] h-12 rounded-xl bg-[#25D366] hover:bg-[#20bd5a] active:scale-[0.98] transition-all flex items-center justify-center gap-2 text-white font-title-md text-title-md shadow-md"
            >
              <svg className="w-5 h-5 fill-current shrink-0" viewBox="0 0 24 24">
                <path d="M12.031 6.172c-3.181 0-5.767 2.586-5.768 5.766-.001 1.298.38 2.27 1.019 3.287l-.582 2.128 2.182-.573c.978.58 1.911.928 3.145.929 3.178 0 5.767-2.587 5.768-5.766.001-3.187-2.575-5.771-5.764-5.771zm3.392 8.244c-.144.405-.837.774-1.17.824-.312.045-.694.06-2.12-.533-1.498-.62-2.457-2.149-2.532-2.249-.074-.1-1.222-1.626-1.222-3.1 0-1.475.772-2.198 1.045-2.497.273-.299.595-.374.793-.374.198 0 .396.002.57.01.183.009.431-.069.675.518.252.607.86 2.096.935 2.249.074.149.124.324.025.523-.099.198-.149.323-.298.497-.149.174-.313.389-.447.522-.149.149-.305.312-.131.611.174.298.772 1.272 1.657 2.062 1.14 1.018 2.102 1.333 2.4 1.482.298.149.472.124.646-.075.174-.199.744-.869.943-1.168.198-.299.396-.249.669-.149.273.1 1.734.817 2.032.966.298.149.496.224.57.348.075.124.075.723-.069 1.128z" />
                <path d="M12 2C6.477 2 2 6.477 2 12c0 1.89.525 3.66 1.438 5.178L2 22l4.981-1.396C8.423 21.492 10.155 22 12 22c5.523 0 10-4.477 10-10S17.523 2C12 2zm0 18.2c-1.68 0-3.238-.518-4.529-1.402l-.326-.226-2.964.83.829-2.895-.246-.353C3.805 14.823 3.3 13.456 3.3 12c0-4.797 3.903-8.7 8.7-8.7 4.797 0 8.7 3.903 8.7 8.7 0 4.797-3.903 8.7-8.7 8.7z" />
              </svg>
              <span>Chat on WhatsApp</span>
            </button>
          </div>
          <p className="text-center font-body-sm text-[11px] text-[#474554] truncate">
            💬 Prepares chat with {listing.seller.name}: &quot;Hi, I&apos;m interested in your {listing.title}...&quot;
          </p>
        </div>
      </div>

      {/* In-App Direct Chat Simulator Modal */}
      {showChatModal && (
        <div
          className="fixed inset-0 z-50 bg-[#0B0B14]/60 backdrop-blur-sm flex flex-col justify-end p-4 animate-in fade-in"
          onClick={() => setShowChatModal(false)}
        >
          <div
            className="w-full max-w-md mx-auto bg-white rounded-3xl shadow-2xl p-5 flex flex-col gap-3"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between pb-2 border-b border-[#eeedf8]">
              <div className="flex items-center gap-2.5">
                <img
                  src={listing.seller.avatar}
                  alt={listing.seller.name}
                  className="w-9 h-9 rounded-full object-cover"
                />
                <div>
                  <h4 className="font-title-md text-sm font-bold text-[#1a1b23]">
                    {listing.seller.name}
                  </h4>
                  <p className="text-[11px] text-[#006c49] font-medium flex items-center gap-1">
                    <span className="w-1.5 h-1.5 rounded-full bg-[#006c49] animate-pulse"></span>
                    Online in {listing.location}
                  </p>
                </div>
              </div>
              <button
                onClick={() => setShowChatModal(false)}
                className="w-8 h-8 rounded-full bg-[#eeedf8] flex items-center justify-center text-[#474554]"
              >
                <span className="material-symbols-outlined text-[18px]">close</span>
              </button>
            </div>

            <div className="p-3 bg-[#f4f2fe] rounded-xl text-xs text-[#474554] flex items-center justify-between">
              <span>Listing: {listing.title}</span>
              <span className="font-bold text-[#422ec2]">₹{listing.price}</span>
            </div>

            <textarea
              rows={4}
              value={chatMessage}
              onChange={(e) => setChatMessage(e.target.value)}
              className="w-full p-3 bg-[#eeedf8] rounded-xl text-sm text-[#1a1b23] focus:outline-none focus:ring-2 focus:ring-[#5b4bdb] resize-none"
              placeholder="Type your message to the seller..."
            />

            <div className="flex gap-2">
              <button
                type="button"
                onClick={() => {
                  setShowChatModal(false);
                  onToast('Offer & campus meet message sent to seller!');
                }}
                className="flex-1 py-3 rounded-xl bg-[#5b4bdb] text-white font-label-md font-bold hover:bg-[#422ec2] active:scale-98 transition-all flex items-center justify-center gap-1.5 shadow-sm"
              >
                <span className="material-symbols-outlined text-[18px]">send</span>
                <span>Send via Campus Mart</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
