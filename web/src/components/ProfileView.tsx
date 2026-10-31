import React, { useState } from 'react';
import { USER_AVATAR } from '../data/mockData';
import { Listing } from '../types';

interface ProfileViewProps {
  userListings: Listing[];
  onSelectListing: (listing: Listing) => void;
  onToast: (msg: string) => void;
  currentCollege: string;
  onChangeCollege: (college: string) => void;
}

export const ProfileView: React.FC<ProfileViewProps> = ({
  userListings,
  onSelectListing,
  onToast,
  currentCollege,
  onChangeCollege,
}) => {
  const [selectedHub, setSelectedHub] = useState(currentCollege);

  const handleSaveHub = (hub: string) => {
    setSelectedHub(hub);
    onChangeCollege(hub);
    onToast(`Switched campus marketplace hub to ${hub}!`);
  };

  return (
    <div className="flex flex-col w-full min-h-screen bg-[#fbf8ff] px-4 pt-2 pb-24">
      {/* Student ID Card */}
      <div className="bg-white rounded-3xl p-5 shadow-sm border border-[#eeedf8] flex flex-col gap-4">
        <div className="flex items-center gap-3.5">
          <div className="relative">
            <img
              src={USER_AVATAR}
              alt="Rohan's profile"
              className="w-16 h-16 rounded-full object-cover ring-4 ring-[#5b4bdb]/15"
            />
            <span className="absolute bottom-0 right-0 w-5 h-5 rounded-full bg-[#006c49] flex items-center justify-center text-white ring-2 ring-white">
              <span className="material-symbols-outlined text-[13px]" style={{ fontVariationSettings: "'FILL' 1" }}>
                verified
              </span>
            </span>
          </div>

          <div className="flex flex-col min-w-0 flex-1">
            <div className="flex items-center gap-1.5">
              <h3 className="font-headline-sm text-lg font-bold text-[#1a1b23] truncate">
                Rohan Varma
              </h3>
              <span className="px-2 py-0.5 rounded-full bg-[#6cf8bb] text-[#00714d] text-[10px] font-bold">
                Student Verified
              </span>
            </div>
            <p className="text-xs text-[#474554] mt-0.5">
              Computer Science &amp; Engg • Batch &apos;24-&apos;28
            </p>
            <p className="text-[11px] text-[#787586] font-mono mt-0.5">
              Roll: 24A91A05XX • SRKREC Bhimavaram
            </p>
          </div>
        </div>

        {/* Stats Row */}
        <div className="grid grid-cols-3 gap-2 pt-2 border-t border-[#eeedf8] text-center">
          <div className="p-2 rounded-xl bg-[#f4f2fe]">
            <span className="block text-lg font-bold text-[#422ec2] font-headline">
              ₹1,250
            </span>
            <span className="text-[11px] text-[#474554]">Total Saved</span>
          </div>
          <div className="p-2 rounded-xl bg-[#f4f2fe]">
            <span className="block text-lg font-bold text-[#422ec2] font-headline">
              {userListings.length}
            </span>
            <span className="text-[11px] text-[#474554]">Active Listings</span>
          </div>
          <div className="p-2 rounded-xl bg-[#f4f2fe]">
            <span className="block text-lg font-bold text-[#006c49] font-headline">
              100%
            </span>
            <span className="text-[11px] text-[#474554]">Peer Rating</span>
          </div>
        </div>
      </div>

      {/* Campus Hub Switcher */}
      <div className="mt-4 bg-white rounded-2xl p-4 shadow-sm border border-[#eeedf8] flex flex-col gap-2.5">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="material-symbols-outlined text-[#422ec2] text-[20px]">
              apartment
            </span>
            <span className="font-title-md text-sm font-bold text-[#1a1b23]">
              Active Campus Hub
            </span>
          </div>
          <span className="text-xs font-semibold text-[#006c49] flex items-center gap-1">
            <span className="w-2 h-2 rounded-full bg-[#006c49] animate-pulse"></span>
            Verified Network
          </span>
        </div>

        <select
          value={selectedHub}
          onChange={(e) => handleSaveHub(e.target.value)}
          className="w-full bg-[#f4f2fe] text-sm text-[#1a1b23] p-3 rounded-xl border border-[#e4dfff] font-medium outline-none cursor-pointer focus:ring-2 focus:ring-[#5b4bdb]"
        >
          <option value="SRKR Engg College">SRKR Engg College (Bhimavaram)</option>
          <option value="IIT Bombay">IIT Bombay (Powai)</option>
          <option value="Andhra University">Andhra University College of Engg</option>
          <option value="NIT Warangal">NIT Warangal</option>
          <option value="BITS Pilani">BITS Pilani Hyderabad Campus</option>
        </select>
        <p className="text-[11px] text-[#787586]">
          Listings and campus pickup zones filter according to your active university hub.
        </p>
      </div>

      {/* My Active Listings */}
      <div className="mt-4 flex flex-col gap-2.5">
        <div className="flex items-center justify-between">
          <span className="font-title-md text-sm font-bold text-[#1a1b23]">
            My Posted Listings ({userListings.length})
          </span>
          <span className="text-xs font-semibold text-[#422ec2]">Live on Hub</span>
        </div>

        {userListings.length === 0 ? (
          <div className="bg-white rounded-2xl p-6 text-center border border-[#eeedf8]">
            <p className="text-sm text-[#474554]">You haven&apos;t posted any items yet.</p>
            <p className="text-xs text-[#787586] mt-0.5">
              Sell extra drafters, calculators, or notes in minutes.
            </p>
          </div>
        ) : (
          <div className="flex flex-col gap-2.5">
            {userListings.map((item) => (
              <div
                key={item.id}
                onClick={() => onSelectListing(item)}
                className="bg-white p-3 rounded-2xl border border-[#eeedf8] shadow-sm flex items-center justify-between cursor-pointer hover:border-[#c6c0ff] transition-all"
              >
                <div className="flex items-center gap-3 min-w-0">
                  <img
                    src={item.images[0]}
                    alt={item.title}
                    className="w-12 h-12 rounded-xl object-cover"
                  />
                  <div className="min-w-0">
                    <h4 className="font-title-md text-sm font-bold text-[#1a1b23] truncate">
                      {item.title}
                    </h4>
                    <p className="text-xs text-[#006c49] font-bold">
                      ₹{item.price}{' '}
                      <span className="text-[10px] text-[#787586] font-normal">
                        ({item.condition})
                      </span>
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-1.5 shrink-0">
                  <span className="px-2 py-0.5 rounded-full bg-[#6cf8bb]/40 text-[#00714d] text-[10px] font-bold">
                    Active
                  </span>
                  <span className="material-symbols-outlined text-[18px] text-[#787586]">
                    chevron_right
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Campus Safety Rules */}
      <div className="mt-4 bg-[#f4f2fe] rounded-2xl p-4 border border-[#e4dfff] flex flex-col gap-2">
        <div className="flex items-center gap-2 text-[#422ec2]">
          <span className="material-symbols-outlined text-[20px]">shield</span>
          <span className="font-title-md text-sm font-bold">Hand-to-Hand Safety Protocol</span>
        </div>
        <ul className="text-xs text-[#474554] space-y-1.5 list-disc pl-4">
          <li>Always meet in open academic areas (Central Library, Canteen, Department porticos).</li>
          <li>Inspect precision calibration or textbook pages before making payment.</li>
          <li>Pay using instant UPI QR or cash directly upon inspection.</li>
        </ul>
      </div>
    </div>
  );
};
