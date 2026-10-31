import React, { useState } from 'react';
import { Category, Condition, Listing } from '../types';

interface SellViewProps {
  onPublish: (newListing: Listing) => void;
  onToast: (msg: string) => void;
  onCancel: () => void;
}

export const SellView: React.FC<SellViewProps> = ({
  onPublish,
  onToast,
  onCancel,
}) => {
  const [title, setTitle] = useState('Omega Mini Drafter with Case & Clips');
  const [category, setCategory] = useState<Category>('Drafters');
  const [condition, setCondition] = useState<Condition>('Like New');
  const [targetBranch, setTargetBranch] = useState('Engineering First Year (All Branches)');
  const [semester, setSemester] = useState('Sem 1 & Sem 2');
  const [subjectCode, setSubjectCode] = useState('Engg Graphics (EG)');
  const [sellingPrice, setSellingPrice] = useState<number>(450);
  const [originalPrice, setOriginalPrice] = useState<number>(1200);
  const [isNegotiable, setIsNegotiable] = useState(true);
  const [description, setDescription] = useState(
    'Complete Omega 360-degree mini drafter. Protractor head is smoothly calibrated, zero wobble on tightening knob. Includes padded water-resistant carry bag and dual steel clamps.'
  );
  const [location, setLocation] = useState('SRKR Mechanical Block / Central Library, Bhimavaram');
  
  // Default sample uploaded photos
  const [photos, setPhotos] = useState<string[]>([
    '/assets/aistudio/Image_11_f16f3431.jpeg',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCFsBI-jYBDC9S4Ljf6CszniaqmVnVeSSTy2cGVDQQRUzX2AAIUrsPThMKhDA0cTuYenoGdVc1aGAaqs6PJaQHrH-ftuavK4w10gcGZWPi-HmXi9Er9qeGzq_2UtcHUYa7qxK8E74vvThvifUX3EFWsA_1OEqwtVObh-c-J2_foZV3epm-rZpiq-Uu6E6yuG1X4ODzS-eLmTW3WxP709Qa2fodi1c7WiB4UxdRN9jNGmpuPjsx2oZA',
  ]);

  const [isAcademicOpen, setIsAcademicOpen] = useState(true);

  // Calculate savings
  const savings = Math.max(0, originalPrice - sellingPrice);
  const discountPct = originalPrice > 0 ? Math.round((savings / originalPrice) * 100) : 0;

  const handleAddPhoto = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      const reader = new FileReader();
      reader.onload = (uploadEvent) => {
        if (uploadEvent.target?.result) {
          setPhotos([...photos, uploadEvent.target.result as string]);
          onToast('Photo added successfully!');
        }
      };
      reader.readAsDataURL(file);
    }
  };

  const handleRemovePhoto = (index: number) => {
    setPhotos(photos.filter((_, i) => i !== index));
  };

  const handleSaveDraft = () => {
    onToast('Draft progress saved securely to your account!');
  };

  const handlePublish = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) {
      onToast('Please enter a listing title');
      return;
    }

    const newListing: Listing = {
      id: `CM-${Math.floor(1000 + Math.random() * 9000)}`,
      title,
      category,
      condition,
      price: Number(sellingPrice) || 300,
      originalPrice: Number(originalPrice) || Number(sellingPrice),
      discountPercent: discountPct,
      images: photos.length > 0 ? photos : ['/assets/aistudio/Image_1_332b6fe5.jpeg'],
      department: targetBranch,
      semester,
      subjectCode,
      location,
      handoverType: 'Campus Handover',
      listedTimeAgo: 'Just now',
      description,
      isNegotiable,
      isFeatured: true,
      seller: {
        name: 'Rohan V. (You)',
        avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBzbfHDH0nFQfxijNb9v9QxFSxSqYFkYpiCMXWlLG3cwq_5Pxy0xIw6T9wZSqRTAEjO621bZ6rcdcSElmPwI7q6rdJ7O-gae--GdiNmmAJcuFs69-Cb3JspriTBYoqvLtW2fm_0k7hupCi5Z8aNzQt4wVsO7ev8JXKX6ELv7L8z-UUxHPsYR0nJRADOBTAew0RgKrDZh8NoPBV1-hX-a59JDNRQSXDm4MRZyQjrz0CLq7NY1vHD5-O3',
        role: 'Student',
        department: 'Computer Science',
        batch: "'28",
        isRollVerified: true,
        rating: 5.0,
        peerSalesCount: 1,
        replyTime: '~5m',
        phone: '+91 98765 43210',
      },
    };

    onPublish(newListing);
    onToast('🎉 Listing published! Verified peers notified on campus.');
  };

  return (
    <div className="flex flex-col w-full min-h-screen bg-[#fbf8ff] px-4 pt-2 pb-28">
      {/* Sub-header status & actions */}
      <div className="flex items-center justify-between py-2 mb-1">
        <div className="flex items-center gap-2">
          <span className="w-2 h-2 rounded-full bg-[#006c49] animate-pulse"></span>
          <span className="font-label-sm text-label-sm text-[#474554]">Draft saved just now</span>
        </div>
        <button
          onClick={onCancel}
          type="button"
          className="font-label-md text-label-md text-[#474554] hover:text-[#ba1a1a] transition-colors px-2 py-1 rounded-lg"
        >
          Discard
        </button>
      </div>

      {/* Step Progress Indicator */}
      <div className="bg-[#f4f2fe] rounded-2xl p-4 mb-4 shadow-sm border border-[#eeedf8]">
        <div className="flex items-center justify-between mb-2">
          <span className="font-title-md text-title-md text-[#1a1b23] font-bold">
            Step 1 of 2: Item Details
          </span>
          <span className="font-label-sm text-label-sm text-[#422ec2] font-semibold">
            50% Completed
          </span>
        </div>
        <div className="w-full bg-[#e3e1ed] h-2 rounded-full overflow-hidden flex">
          <div className="bg-[#422ec2] h-full w-1/2 rounded-full transition-all duration-500"></div>
        </div>
        <p className="font-body-sm text-body-sm text-[#474554] mt-1.5">
          Next: Meetup timing &amp; campus delivery spot
        </p>
      </div>

      <form className="flex flex-col gap-4" onSubmit={handlePublish}>
        {/* Photo Upload Area */}
        <div className="flex flex-col gap-1.5">
          <div className="flex justify-between items-baseline">
            <label className="font-label-lg text-label-lg text-[#1a1b23]">Item Photos</label>
            <span className="font-label-sm text-label-sm text-[#474554]">
              {photos.length} of 5 uploaded
            </span>
          </div>
          <div className="grid grid-cols-3 gap-2">
            {/* Upload Trigger Box */}
            <label className="relative flex flex-col items-center justify-center aspect-square rounded-2xl bg-[#eeedf8] hover:bg-[#e8e7f2] transition-all cursor-pointer p-2 text-center active:scale-95 border border-dashed border-[#c8c4d7]">
              <div className="w-9 h-9 rounded-full bg-[#e4dfff] flex items-center justify-center text-[#422ec2] mb-1">
                <span className="material-symbols-outlined text-[20px]">add_a_photo</span>
              </div>
              <span className="font-label-sm text-label-sm text-[#422ec2] font-semibold">
                + Add Photo
              </span>
              <span className="font-label-sm text-[10px] text-[#474554] mt-0.5 leading-tight">
                Up to 5 MB
              </span>
              <input accept="image/*" className="sr-only" type="file" onChange={handleAddPhoto} />
            </label>

            {/* Photo Previews */}
            {photos.map((url, idx) => (
              <div
                key={idx}
                className="relative aspect-square rounded-2xl overflow-hidden bg-[#e3e1ed] shadow-sm border border-[#c8c4d7]"
              >
                <img
                  alt={`Item photo ${idx + 1}`}
                  src={url}
                  className="w-full h-full object-cover"
                />
                {idx === 0 && (
                  <span className="absolute bottom-1.5 left-1.5 bg-[#2f3038]/85 text-[#f1effb] font-label-sm text-[10px] px-2 py-0.5 rounded-full font-semibold">
                    Cover
                  </span>
                )}
                <button
                  type="button"
                  aria-label="Remove photo"
                  onClick={() => handleRemovePhoto(idx)}
                  className="absolute top-1.5 right-1.5 w-6 h-6 rounded-full bg-[#2f3038]/80 text-white flex items-center justify-center hover:bg-[#ba1a1a] transition-colors"
                >
                  <span className="material-symbols-outlined text-[15px]">close</span>
                </button>
              </div>
            ))}
          </div>
          <p className="font-body-sm text-body-sm text-[#474554]">
            Clear photos of corners, scale numbers &amp; serial code sell 3x faster.
          </p>
          <button
            type="button"
            onClick={() => onToast('Bundling enabled! You can package multiple items together.')}
            className="mt-0.5 flex items-center gap-1 text-[#422ec2] hover:text-[#5b4bdb] font-label-sm text-label-sm w-fit transition-colors"
          >
            <span className="material-symbols-outlined text-[16px]">library_add</span>
            <span>+ Add Another Item to Bundle (List multiple items together)</span>
          </button>
        </div>

        {/* Title Field */}
        <div className="flex flex-col gap-1.5">
          <div className="flex justify-between items-center">
            <label className="font-label-lg text-label-lg text-[#1a1b23]" htmlFor="listingTitle">
              Listing Title *
            </label>
            <span className="font-label-sm text-label-sm text-[#474554]">
              {title.length}/70
            </span>
          </div>
          <div className="relative flex items-center bg-white rounded-2xl shadow-sm border border-[#eeedf8]">
            <span className="material-symbols-outlined text-[#787586] ml-3.5 text-[20px]">title</span>
            <input
              id="listingTitle"
              maxLength={70}
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="w-full bg-transparent px-3 py-3 font-body-md text-body-md text-[#1a1b23] focus:outline-none placeholder:text-[#787586]"
              placeholder="e.g., Casio FX-991EX Calculator / B.S. Grewal Math"
              type="text"
            />
          </div>
        </div>

        {/* Category Dropdown */}
        <div className="flex flex-col gap-1.5">
          <label className="font-label-lg text-label-lg text-[#1a1b23]" htmlFor="categorySelect">
            Academic Category *
          </label>
          <div className="relative bg-white rounded-2xl shadow-sm border border-[#eeedf8] flex items-center">
            <span className="material-symbols-outlined text-[#422ec2] ml-3.5 text-[22px]">
              architecture
            </span>
            <select
              id="categorySelect"
              value={category}
              onChange={(e) => setCategory(e.target.value as Category)}
              className="w-full appearance-none bg-transparent pl-3 pr-9 py-3 font-body-md text-body-md text-[#1a1b23] focus:outline-none cursor-pointer"
            >
              <option value="Drafters">📐 Drafters &amp; Drawing Kits</option>
              <option value="Calculators">🧮 Scientific Calculators</option>
              <option value="Books">📚 Semester Textbooks &amp; PYQs</option>
              <option value="Lab Records">📝 Lab Records &amp; Manuals</option>
              <option value="Lab Gear">💻 Lab Coats &amp; Safety Glasses</option>
              <option value="Electronics">🖨️ Electronics &amp; Arduino Components</option>
              <option value="Stationery">✏️ Precision Stationery</option>
            </select>
            <span className="material-symbols-outlined text-[#787586] absolute right-3.5 pointer-events-none text-[20px]">
              expand_more
            </span>
          </div>
        </div>

        {/* Condition Selector */}
        <div className="flex flex-col gap-1.5">
          <label className="font-label-lg text-label-lg text-[#1a1b23]">Item Condition *</label>
          <div className="grid grid-cols-2 gap-2">
            {[
              {
                id: 'New',
                title: 'New',
                desc: 'Unopened in factory pack',
                icon: 'verified',
              },
              {
                id: 'Like New',
                title: 'Like New',
                desc: 'Barely used, 0 scratches',
                icon: 'check_circle',
              },
              {
                id: 'Good',
                title: 'Good',
                desc: 'Normal semester wear',
                icon: 'thumb_up',
              },
              {
                id: 'Fair',
                title: 'Fair',
                desc: 'Fully functional & working',
                icon: 'build',
              },
            ].map((cond) => {
              const isSelected = condition === cond.id;
              return (
                <button
                  key={cond.id}
                  type="button"
                  onClick={() => setCondition(cond.id as Condition)}
                  className={`p-3 rounded-2xl text-left transition-all shadow-sm border ${
                    isSelected
                      ? 'bg-[#e4dfff]/40 border-[#422ec2] ring-2 ring-[#422ec2]'
                      : 'bg-white border-[#eeedf8] hover:bg-[#f4f2fe]'
                  }`}
                >
                  <div className="flex items-center gap-1.5 mb-1">
                    <span
                      className={`material-symbols-outlined text-[16px] ${
                        isSelected ? 'text-[#422ec2]' : 'text-[#787586]'
                      }`}
                      style={{ fontVariationSettings: isSelected ? "'FILL' 1" : "'FILL' 0" }}
                    >
                      {cond.icon}
                    </span>
                    <span
                      className={`font-label-sm text-label-sm font-semibold ${
                        isSelected ? 'text-[#422ec2]' : 'text-[#1a1b23]'
                      }`}
                    >
                      {cond.title}
                    </span>
                  </div>
                  <p className="font-body-sm text-[11px] text-[#474554] leading-tight">
                    {cond.desc}
                  </p>
                </button>
              );
            })}
          </div>
        </div>

        {/* Academic Details Section (Grouped & Collapsible) */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-[#eeedf8]">
          <button
            type="button"
            onClick={() => setIsAcademicOpen(!isAcademicOpen)}
            className="flex items-center justify-between w-full cursor-pointer select-none font-label-lg text-label-lg text-[#1a1b23]"
          >
            <div className="flex items-center gap-2">
              <span className="material-symbols-outlined text-[#422ec2] text-[20px]">school</span>
              <span>Academic Relevance</span>
            </div>
            <span
              className={`material-symbols-outlined text-[#787586] transition-transform text-[20px] ${
                isAcademicOpen ? 'rotate-180' : ''
              }`}
            >
              keyboard_arrow_down
            </span>
          </button>

          {isAcademicOpen && (
            <div className="mt-3 flex flex-col gap-3 pt-1 border-t border-[#eeedf8]">
              <div>
                <label className="font-label-sm text-label-sm text-[#474554] mb-1 block">
                  Target Branch / Stream
                </label>
                <div className="bg-[#f4f2fe] rounded-xl px-3 py-2.5">
                  <input
                    value={targetBranch}
                    onChange={(e) => setTargetBranch(e.target.value)}
                    className="w-full bg-transparent font-body-md text-body-md text-[#1a1b23] focus:outline-none"
                    type="text"
                  />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="font-label-sm text-label-sm text-[#474554] mb-1 block">
                    Semester
                  </label>
                  <div className="bg-[#f4f2fe] rounded-xl px-3 py-2.5">
                    <input
                      value={semester}
                      onChange={(e) => setSemester(e.target.value)}
                      className="w-full bg-transparent font-body-md text-body-md text-[#1a1b23] focus:outline-none"
                      type="text"
                    />
                  </div>
                </div>
                <div>
                  <label className="font-label-sm text-label-sm text-[#474554] mb-1 block">
                    Subject Code / Name
                  </label>
                  <div className="bg-[#f4f2fe] rounded-xl px-3 py-2.5">
                    <input
                      value={subjectCode}
                      onChange={(e) => setSubjectCode(e.target.value)}
                      className="w-full bg-transparent font-body-md text-body-md text-[#1a1b23] focus:outline-none"
                      type="text"
                    />
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Pricing & Negotiation */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-[#eeedf8] flex flex-col gap-3">
          <div className="flex items-center gap-2">
            <span className="material-symbols-outlined text-[#006c49] text-[20px]">payments</span>
            <span className="font-label-lg text-label-lg text-[#1a1b23] font-bold">
              Fair Campus Pricing
            </span>
          </div>
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="font-label-sm text-label-sm text-[#1a1b23] mb-1 block">
                Selling Price *
              </label>
              <div className="flex items-center bg-[#f4f2fe] rounded-xl px-3 py-2.5">
                <span className="font-title-md text-title-md text-[#1a1b23] mr-1">₹</span>
                <input
                  type="number"
                  value={sellingPrice}
                  onChange={(e) => setSellingPrice(Number(e.target.value))}
                  className="w-full bg-transparent font-title-md text-title-md text-[#1a1b23] focus:outline-none font-bold"
                />
              </div>
            </div>
            <div>
              <label className="font-label-sm text-label-sm text-[#474554] mb-1 block">
                Original MRP (Optional)
              </label>
              <div className="flex items-center bg-[#f4f2fe] rounded-xl px-3 py-2.5">
                <span className="font-title-md text-title-md text-[#787586] mr-1">₹</span>
                <input
                  type="number"
                  value={originalPrice}
                  onChange={(e) => setOriginalPrice(Number(e.target.value))}
                  className="w-full bg-transparent font-body-md text-body-md text-[#474554] focus:outline-none"
                />
              </div>
            </div>
          </div>

          {/* Price Saving Callout Pill */}
          {savings > 0 && (
            <div className="bg-[#6cf8bb]/30 px-3 py-2 rounded-xl flex items-center justify-between border border-[#6cf8bb]">
              <span className="font-label-sm text-label-sm text-[#00714d] font-semibold">
                Junior saves ₹{savings} ({discountPct}% off new)
              </span>
              <span className="material-symbols-outlined text-[#006c49] text-[18px]">verified</span>
            </div>
          )}

          {/* Price Negotiable Toggle */}
          <div className="flex items-center justify-between pt-1">
            <div className="flex flex-col">
              <span className="font-label-md text-label-md text-[#1a1b23]">Price Negotiable</span>
              <span className="font-body-sm text-body-sm text-[#474554]">
                Open to reasonable student offers
              </span>
            </div>
            <button
              type="button"
              onClick={() => setIsNegotiable(!isNegotiable)}
              className={`w-12 h-7 rounded-full transition-colors relative flex items-center p-1 ${
                isNegotiable ? 'bg-[#422ec2]' : 'bg-[#e3e1ed]'
              }`}
            >
              <div
                className={`w-5 h-5 rounded-full bg-white shadow-md transition-transform ${
                  isNegotiable ? 'translate-x-5' : 'translate-x-0'
                }`}
              />
            </button>
          </div>
        </div>

        {/* Description */}
        <div className="flex flex-col gap-1.5">
          <div className="flex justify-between items-center">
            <label className="font-label-lg text-label-lg text-[#1a1b23]" htmlFor="itemDesc">
              Description
            </label>
            <span className="font-label-sm text-label-sm text-[#474554]">Recommended</span>
          </div>
          <div className="bg-white rounded-2xl shadow-sm border border-[#eeedf8] p-3">
            <textarea
              id="itemDesc"
              rows={3}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Mention condition, missing parts, or where on campus you can meet..."
              className="w-full bg-transparent font-body-md text-body-md text-[#1a1b23] focus:outline-none placeholder:text-[#787586] resize-none"
            />
          </div>
        </div>

        {/* Campus Pickup Location */}
        <div className="flex flex-col gap-1.5">
          <label className="font-label-lg text-label-lg text-[#1a1b23]">Preferred Campus Spot</label>
          <div className="relative bg-white rounded-2xl shadow-sm border border-[#eeedf8] flex items-center px-3 py-2.5">
            <span className="material-symbols-outlined text-[#422ec2] mr-2 text-[20px]">
              location_on
            </span>
            <input
              type="text"
              value={location}
              onChange={(e) => setLocation(e.target.value)}
              placeholder="e.g., Hostel Area / Student Activity Center"
              className="w-full bg-transparent font-body-md text-body-md text-[#1a1b23] focus:outline-none"
            />
          </div>
        </div>

        {/* WhatsApp Contact Card */}
        <div className="bg-[#f4f2fe] rounded-2xl p-4 flex items-start gap-3 shadow-sm border border-[#eeedf8]">
          <div className="w-10 h-10 rounded-full bg-[#25D366]/20 flex items-center justify-center shrink-0 mt-0.5">
            <svg className="w-5 h-5 fill-[#25D366]" viewBox="0 0 24 24">
              <path d="M.057 24l1.687-6.163c-1.041-1.804-1.588-3.849-1.587-5.946.003-6.556 5.338-11.891 11.893-11.891 3.181.001 6.167 1.24 8.413 3.488 2.245 2.248 3.481 5.236 3.48 8.414-.003 6.557-5.338 11.892-11.893 11.892-1.99-.001-3.951-.5-5.688-1.448l-6.305 1.654zm6.597-3.807c1.676.995 3.276 1.591 5.392 1.592 5.448 0 9.886-4.434 9.889-9.885.002-5.462-4.415-9.89-9.881-9.892-5.452 0-9.887 4.434-9.889 9.884-.001 2.225.651 3.891 1.746 5.634l-.999 3.648 3.742-.981z" />
            </svg>
          </div>
          <div className="flex flex-col">
            <span className="font-label-md text-label-md text-[#1a1b23] font-bold">
              Direct WhatsApp Connect
            </span>
            <p className="font-body-sm text-body-sm text-[#474554] mt-0.5">
              Verified campus peers will message you at{' '}
              <span className="font-semibold text-[#1a1b23]">+91 98765 43210</span>. Phone number remains protected behind Campus Auth.
            </p>
          </div>
        </div>

        {/* Sticky Bottom Action Bar */}
        <div className="fixed bottom-0 left-0 right-0 z-40 bg-white/95 backdrop-blur-xl shadow-[0_-4px_20px_rgba(0,0,0,0.06)] border-t border-[#eeedf8] px-4 py-3 pb-safe">
          <div className="max-w-md mx-auto flex items-center gap-3">
            <button
              type="button"
              onClick={handleSaveDraft}
              className="flex-1 py-3 px-4 rounded-xl bg-[#eeedf8] hover:bg-[#e8e7f2] text-[#1a1b23] font-label-lg text-label-lg text-center transition-colors active:scale-98 font-semibold"
            >
              Save Draft
            </button>
            <button
              type="submit"
              className="flex-[2] py-3 px-4 rounded-xl bg-[#422ec2] hover:bg-[#5b4bdb] text-white font-label-lg text-label-lg text-center flex items-center justify-center gap-1.5 shadow-md transition-all active:scale-98 font-bold"
            >
              <span className="material-symbols-outlined text-[20px]">check</span>
              <span>Publish Listing</span>
            </button>
          </div>
        </div>
      </form>
    </div>
  );
};
