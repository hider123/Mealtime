import React, { useState, useEffect, useCallback } from 'react';
import { Camera, Mic, Tag, Home, Gift, X, Sparkles, Rocket, LoaderCircle, ShoppingCart, Coins, QrCode, CheckCircle, Box, Star, PlusCircle, User } from 'lucide-react';

// --- MOCK DATA ---
const initialPosts = [
  { id: 1, user: { name: '愛吃的小明', avatar: 'https://placehold.co/100x100/f97316/ffffff?text=明' }, title: '巷口那間不起眼的拉麵', description: '這碗豚骨拉麵的湯頭濃郁得不可思議，叉燒入口即化，麵條Q彈有勁。每一口都是純粹的幸福感，絕對是深夜裡最溫暖的慰藉。', media: { type: 'photo', url: 'https://images.unsplash.com/photo-1557872943-16a5ac26437e?q=80&w=800' }, tags: ['#療癒', '#濃郁', '#深夜食堂'], isFlare: false, timestamp: '5分鐘前' },
  { id: 2, user: { name: '甜點獵人-Alice', avatar: 'https://placehold.co/100x100/ec4899/ffffff?text=A' }, title: '我願意為它排隊的草莓千層！', description: '酥脆的派皮與柔滑的卡士達醬完美結合，新鮮草莓的酸甜滋味在口中爆發。這不只是甜點，這是藝術品！', media: { type: 'photo', url: 'https://images.unsplash.com/photo-1565003029241-95334d4b6c69?q=80&w=800' }, tags: ['#必吃', '#少女心', '#排隊美食'], isFlare: true, timestamp: '30分鐘前' },
];

const allTags = ['#療癒', '#Q彈', '#酥脆', '#濃郁', '#多汁', '#入口即化', '#深夜食堂', '#罪惡', '#必吃', '#CP值高', '#異國風味', '#微醺'];

const partnerRewards = [
    { id: 'reward-1', storeName: '轉角那間人氣咖啡廳', rewardName: '冰拿鐵一杯', cost: 300, image: 'https://images.unsplash.com/photo-1579989018111-4b59a42149a4?q=80&w=800' },
    { id: 'reward-2', storeName: '阿嬤的巷口雞蛋糕', rewardName: '原味雞蛋糕一份', cost: 150, image: 'https://images.unsplash.com/photo-1628109325558-29000721a243?q=80&w=800' },
    { id: 'reward-3', storeName: '老張牛肉麵館', rewardName: '紅燒牛肉麵一碗', cost: 500, image: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=800', isRare: true },
];

// --- COMPONENTS ---

const FlareBorder = ({ children }) => ( <div className="p-1 rounded-3xl bg-gradient-to-br from-amber-400 via-red-500 to-fuchsia-500 animate-pulse-slow shadow-2xl shadow-red-500/30">{children}</div> );

const PostCard = ({ post }) => {
  const cardContent = (
    <div className="bg-white rounded-2xl overflow-hidden shadow-lg flex flex-col h-full transform transition-transform duration-300 hover:scale-[1.02]">
      {post.media.type === 'photo' && <img src={post.media.url} alt={post.title} className="w-full h-48 object-cover" onError={(e) => { e.target.onerror = null; e.target.src='https://placehold.co/600x400/e2e8f0/94a3b8?text=圖片載入失敗'; }}/>}
      {post.media.type === 'audio' && <div className="w-full h-48 bg-slate-800 flex items-center justify-center"><div className="text-center text-white"><Mic size={48} className="mx-auto" /><p className="mt-2 font-semibold">錄音分享</p><p className="text-sm text-slate-300">點擊播放聲音</p></div></div>}
      <div className="p-4 flex-grow flex flex-col">
        <div className="flex items-center mb-3"><img src={post.user.avatar} alt={post.user.name} className="w-10 h-10 rounded-full mr-3 border-2 border-slate-200" /><div><p className="font-bold text-slate-800">{post.user.name}</p><p className="text-xs text-slate-500">{post.timestamp}</p></div></div>
        <h3 className="font-bold text-lg text-slate-900 mb-2">{post.title}</h3>
        <p className="text-slate-600 text-sm mb-4 flex-grow">{post.description}</p>
        <div className="flex flex-wrap gap-2">{post.tags.map(tag => ( <span key={tag} className="bg-slate-100 text-slate-600 text-xs font-semibold px-2.5 py-1 rounded-full">{tag}</span> ))}</div>
      </div>
    </div>
  );
  return post.isFlare ? <FlareBorder>{cardContent}</FlareBorder> : cardContent;
};

const Feed = ({ posts }) => ( <div className="p-4 space-y-6">{posts.map(post => <PostCard key={post.id} post={post} />)}</div> );

const VoucherModal = ({ voucher, onClose, onConfirmUse }) => {
    if (!voucher) return null;
    return (
        <div className="fixed inset-0 bg-black bg-opacity-60 z-50 flex items-center justify-center p-4" onClick={onClose}>
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm overflow-hidden transform transition-all" onClick={e => e.stopPropagation()}>
                <div className="p-6 bg-slate-50 text-center"><h2 className="text-xl font-bold text-slate-800">{voucher.storeName}</h2><p className="text-slate-600">電子兌換券</p></div>
                <div className="p-6 text-center">
                    <h3 className="text-3xl font-bold text-orange-500 mb-4">{voucher.rewardName}</h3>
                    {voucher.isUsed ? (<div className="flex flex-col items-center text-green-500"><CheckCircle size={80} /><p className="text-xl font-bold mt-4">已兌換</p></div>) : (<div className="flex justify-center"><img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=GourmetSurpriseCatcher-Voucher-12345" alt="QR Code" className="rounded-lg" /></div>)}
                    <p className="text-xs text-slate-400 mt-4">兌換日期: {new Date(voucher.redeemDate).toLocaleDateString()}</p>
                </div>
                <div className="p-4 bg-slate-100">{!voucher.isUsed ? (<button onClick={() => onConfirmUse(voucher.id)} className="w-full bg-green-500 text-white font-bold py-3 rounded-lg hover:bg-green-600 transition-colors">店家核銷</button>) : (<button onClick={onClose} className="w-full bg-slate-400 text-white font-bold py-3 rounded-lg">關閉</button>)}</div>
            </div>
        </div>
    );
};

const BlindBoxModal = ({ isOpen, isOpening, prize, onClose }) => {
    if (!isOpen) return null;
    return (
        <div className="fixed inset-0 bg-black bg-opacity-70 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm text-center p-8 transform transition-all relative">
                {!prize ? ( <> <h2 className="text-2xl font-bold text-slate-800 mb-4">開啟盲盒中...</h2> <Box className={`mx-auto text-purple-500 ${isOpening ? 'animate-bounce' : ''}`} size={80} /> <p className="text-slate-500 mt-4">祝您好運！</p> </> ) : ( <> <button onClick={onClose} className="absolute top-4 right-4 text-slate-400 hover:text-slate-600"><X size={24} /></button> <h2 className="text-2xl font-bold text-slate-800 mb-2">恭喜您抽中！</h2> {prize.isRare && <div className="flex items-center justify-center gap-2 text-yellow-500 font-bold mb-2"><Star size={16} /><span>稀有獎品</span><Star size={16} /></div>} <img src={prize.image} alt={prize.rewardName} className="w-full h-40 object-cover rounded-lg my-4 shadow-lg" /> <h3 className="text-3xl font-bold text-orange-500">{prize.rewardName}</h3> <p className="text-slate-600">{prize.storeName}</p> <button onClick={onClose} className="mt-6 w-full bg-orange-500 text-white font-bold py-3 rounded-lg hover:bg-orange-600 transition-colors">太棒了！</button> </> )}
            </div>
        </div>
    );
};

// 新的獨立盲盒頁面
const BlindBoxView = ({ gCoins, onOpenBlindBox }) => {
    const blindBoxPrice = 100;
    return (
        <div className="p-4 flex flex-col items-center justify-center h-[calc(100vh-140px)]">
            <div className="bg-gradient-to-br from-purple-500 to-indigo-600 p-8 rounded-3xl shadow-2xl text-white text-center w-full max-w-md">
                <h2 className="text-3xl font-bold mb-2">美食盲盒</h2>
                <p className="text-md opacity-80 mb-6">用驚喜，遇見下一個驚喜！</p>
                <Box size={96} className="mx-auto mb-6 text-purple-200" />
                <p className="text-lg mb-2">每次開啟都有機會獲得</p>
                <p className="font-bold text-2xl text-yellow-300 mb-6">價值 500 元的稀有大獎！</p>
                <button onClick={() => onOpenBlindBox(blindBoxPrice)} disabled={gCoins < blindBoxPrice} className="w-full bg-white text-purple-600 font-bold py-4 rounded-xl shadow-md hover:bg-purple-100 transition-colors disabled:bg-slate-300 disabled:text-slate-500 disabled:cursor-not-allowed text-lg">
                    花費 {blindBoxPrice} 美食幣開啟
                </button>
            </div>
        </div>
    );
};


const RewardsView = ({ gCoins, transactions, onRedeem, myVouchers, onVoucherClick }) => {
    const signalFlarePrice = 50;
    return (
        <div className="p-4 space-y-6">
            {myVouchers.length > 0 && (
                <div className="bg-white p-4 rounded-2xl shadow-md">
                    <h3 className="text-lg font-bold text-slate-800 mb-4">我的兌換券</h3>
                    <div className="grid grid-cols-2 gap-4">{myVouchers.map(voucher => (<button key={voucher.id} onClick={() => onVoucherClick(voucher)} className={`p-4 rounded-lg text-left transition-all transform hover:scale-105 ${voucher.isUsed ? 'bg-slate-200 opacity-60' : 'bg-amber-100'}`}><p className="font-bold text-amber-800">{voucher.rewardName}</p><p className="text-sm text-amber-700">{voucher.storeName}</p>{voucher.isUsed && <p className="text-xs font-bold text-slate-500 mt-2">已使用</p>}</button>))}</div>
                </div>
            )}
            <div className="bg-white p-4 rounded-2xl shadow-md">
                <h3 className="text-lg font-bold text-slate-800 mb-4">店家好康兌換</h3>
                <div className="space-y-4">{partnerRewards.map(reward => (<div key={reward.id} className="flex items-center justify-between bg-slate-50 p-4 rounded-lg"><div className="flex items-center gap-4"><img src={reward.image} alt={reward.rewardName} className="w-12 h-12 rounded-lg object-cover" /><div><p className="font-bold text-slate-700">{reward.rewardName}</p><p className="text-sm text-slate-500">{reward.storeName}</p></div></div><button onClick={() => onRedeem('partnerReward', reward.cost, reward)} disabled={gCoins < reward.cost} className="flex items-center gap-2 bg-green-500 text-white font-bold text-sm px-4 py-2 rounded-lg shadow hover:bg-green-600 transition-colors disabled:bg-slate-300 disabled:cursor-not-allowed"><ShoppingCart size={16} /> {reward.cost}</button></div>))}</div>
            </div>
            <div className="bg-white p-4 rounded-2xl shadow-md">
                <h3 className="text-lg font-bold text-slate-800 mb-4">App 內功能兌換</h3>
                <div className="flex items-center justify-between bg-slate-50 p-4 rounded-lg"><div className="flex items-center gap-4"><Rocket size={24} className="text-red-500" /><div><p className="font-bold text-slate-700">美食訊號彈</p><p className="text-sm text-slate-500">讓你的發現被更多人看見！</p></div></div><button onClick={() => onRedeem('signalFlare', signalFlarePrice, null)} disabled={gCoins < signalFlarePrice} className="flex items-center gap-2 bg-orange-500 text-white font-bold text-sm px-4 py-2 rounded-lg shadow hover:bg-orange-600 transition-colors disabled:bg-slate-300 disabled:cursor-not-allowed"><ShoppingCart size={16} /> {signalFlarePrice}</button></div>
            </div>
            <div className="bg-white p-4 rounded-2xl shadow-md">
                <h3 className="text-lg font-bold text-slate-800 mb-4">交易紀錄</h3>
                <div className="space-y-3 max-h-48 overflow-y-auto">{transactions.length > 0 ? transactions.map(tx => (<div key={tx.id} className="flex justify-between items-center text-sm"><div><p className="font-semibold text-slate-700">{tx.description}</p><p className="text-xs text-slate-400">{new Date(tx.id).toLocaleString()}</p></div><p className={`font-bold ${tx.amount > 0 ? 'text-green-500' : 'text-red-500'}`}>{tx.amount > 0 ? `+${tx.amount}` : tx.amount}</p></div>)) : (<p className="text-center text-slate-500 py-4">尚無交易紀錄</p>)}</div>
            </div>
        </div>
    );
};

const ProfileView = () => (
    <div className="p-4 text-center h-[calc(100vh-140px)] flex flex-col justify-center items-center">
        <User size={64} className="text-slate-400 mb-4" />
        <h2 className="text-2xl font-bold text-slate-700">個人檔案</h2>
        <p className="text-slate-500">這個頁面正在施工中！</p>
        <p className="text-slate-500 mt-2">未來您可以在這裡看到您的勳章牆和美食護照。</p>
    </div>
);


const CreatePanel = ({ isOpen, onClose, onCreatePost, signalFlaresLeft }) => {
  const [step, setStep] = useState(1);
  const [captureMode, setCaptureMode] = useState(null);
  const [selectedTags, setSelectedTags] = useState([]);
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [isGenerating, setIsGenerating] = useState(false);

  const resetState = useCallback(() => { setStep(1); setCaptureMode(null); setSelectedTags([]); setTitle(''); setDescription(''); setIsGenerating(false); }, []);
  useEffect(() => { if (!isOpen) { const timer = setTimeout(() => { resetState(); }, 300); return () => clearTimeout(timer); } }, [isOpen, resetState]);
  const handleCaptureSelect = (mode) => { setCaptureMode(mode); setStep(2); };
  const toggleTag = (tag) => { setSelectedTags(prev => prev.includes(tag) ? prev.filter(t => t !== tag) : [...prev, tag]); };

  const handleGenerateDescription = async () => {
      if (selectedTags.length === 0) { setDescription("請先選擇至少一個標籤，AI 才能為您服務喔！"); return; }
      setIsGenerating(true); setDescription('');
      const prompt = `你是一位美食部落客，請根據以下標籤，為一道美食寫一段大約 50-70 字的生動描述，要讓人感覺驚喜又美味。標籤：${selectedTags.join(', ')}。請直接輸出描述文字，不要包含標題或開頭問候語。`;
      try {
        const payload = { contents: [{ role: "user", parts: [{ text: prompt }] }] };
        const apiKey = ""; 
        const apiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=${apiKey}`;
        const response = await fetch(apiUrl, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) });
        if (!response.ok) { throw new Error(`API 請求失敗，狀態碼：${response.status}`); }
        const result = await response.json();
        if (result.candidates?.[0]?.content?.parts?.[0]?.text) { setDescription(result.candidates[0].content.parts[0].text.trim()); } 
        else { throw new Error("從 API 收到的回應格式不正確。"); }
      } catch (error) { console.error("AI 描述生成失敗:", error); setDescription("哎呀，AI 小秘書暫時罷工了... 請稍後再試，或自己手動填寫也很棒喔！"); } 
      finally { setIsGenerating(false); }
  };

  const handleSubmit = (isFlare) => {
    if (!title || !description) { alert("請填寫標題和描述喔！"); return; }
    const newPost = { id: Date.now(), user: { name: '我', avatar: 'https://placehold.co/100x100/34d399/ffffff?text=我' }, title, description, media: { type: captureMode }, tags: selectedTags, isFlare, timestamp: '剛剛' };
    onCreatePost(newPost);
    onClose();
  };

  return (
    <div className={`fixed inset-0 bg-black bg-opacity-50 z-40 transition-opacity duration-300 ${isOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'}`} onClick={onClose}>
      <div className={`fixed bottom-0 left-0 right-0 bg-slate-50 rounded-t-3xl shadow-2xl p-6 transform transition-transform duration-300 ${isOpen ? 'translate-y-0' : 'translate-y-full'}`} onClick={e => e.stopPropagation()}>
        <button onClick={onClose} className="absolute top-4 right-4 text-slate-400 hover:text-slate-600"><X size={24} /></button>
        {step === 1 && (<div><h2 className="text-2xl font-bold text-center text-slate-800 mb-6">捕捉美食驚喜！</h2><div className="grid grid-cols-3 gap-4 text-center"><button onClick={() => handleCaptureSelect('photo')} className="p-4 bg-white rounded-2xl shadow-md hover:shadow-lg transition-shadow transform hover:-translate-y-1"><Camera size={32} className="mx-auto text-rose-500" /><span className="mt-2 block font-semibold text-slate-700">拍照</span></button><button onClick={() => handleCaptureSelect('audio')} className="p-4 bg-white rounded-2xl shadow-md hover:shadow-lg transition-shadow transform hover:-translate-y-1"><Mic size={32} className="mx-auto text-sky-500" /><span className="mt-2 block font-semibold text-slate-700">錄音</span></button><button onClick={() => handleCaptureSelect('tags')} className="p-4 bg-white rounded-2xl shadow-md hover:shadow-lg transition-shadow transform hover:-translate-y-1"><Tag size={32} className="mx-auto text-amber-500" /><span className="mt-2 block font-semibold text-slate-700">貼標籤</span></button></div></div>)}
        {step === 2 && (<div><button onClick={() => setStep(1)} className="text-sm text-slate-500 hover:text-slate-800 mb-4">&larr; 返回選擇</button><h2 className="text-2xl font-bold text-slate-800 mb-4">分享您的發現</h2><div className="mb-4"><h3 className="font-semibold text-slate-700 mb-2">心情 / 口感標籤</h3><div className="flex flex-wrap gap-2">{allTags.map(tag => (<button key={tag} onClick={() => toggleTag(tag)} className={`px-3 py-1.5 text-sm rounded-full transition-colors ${selectedTags.includes(tag) ? 'bg-orange-500 text-white font-bold shadow' : 'bg-white text-slate-600 hover:bg-slate-200'}`}>{tag}</button>))}</div></div><div className="mb-4"><button onClick={handleGenerateDescription} disabled={isGenerating} className="w-full flex items-center justify-center gap-2 text-sm font-bold bg-gradient-to-r from-purple-500 to-indigo-500 text-white px-4 py-2.5 rounded-lg shadow-md hover:shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed">{isGenerating ? <LoaderCircle size={18} className="animate-spin" /> : <Sparkles size={18} />}{isGenerating ? 'AI 正在為您撰寫中...' : '讓 AI 當您的美食秘書'}</button></div><div className="space-y-4 mb-6"><input type="text" value={title} onChange={e => setTitle(e.target.value)} placeholder="下個標題，讓驚喜更動人" className="w-full p-3 bg-white rounded-lg border border-slate-300 focus:ring-2 focus:ring-orange-400 focus:border-orange-400 outline-none" /><textarea value={description} onChange={e => setDescription(e.target.value)} placeholder="AI 生成的描述會出現在這裡，您也可以自己修改..." rows="4" className="w-full p-3 bg-white rounded-lg border border-slate-300 focus:ring-2 focus:ring-orange-400 focus:border-orange-400 outline-none"></textarea></div><div className="grid grid-cols-2 gap-4"><button onClick={() => handleSubmit(false)} className="w-full bg-white text-orange-500 font-bold py-3 px-4 rounded-xl shadow-md hover:bg-orange-50 transition-colors border-2 border-orange-500">一般分享</button><button onClick={() => handleSubmit(true)} disabled={signalFlaresLeft <= 0} className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-red-500 to-orange-500 text-white font-bold py-3 px-4 rounded-xl shadow-lg hover:shadow-xl transition-all transform hover:scale-105 disabled:from-slate-400 disabled:to-slate-500 disabled:cursor-not-allowed"><Rocket size={20} />發射訊號槍 ({signalFlaresLeft})</button></div>{signalFlaresLeft <= 0 && <p className="text-xs text-center text-slate-500 mt-2">今日訊號彈已用完！</p>}</div>)}
      </div>
    </div>
  );
};

const FooterNav = ({ onSwitchView, currentView }) => (
  <div className="fixed bottom-0 left-0 right-0 bg-white/80 backdrop-blur-sm shadow-[0_-2px_10px_rgba(0,0,0,0.05)]">
    <div className="flex justify-around items-center h-16">
      <button onClick={() => onSwitchView('feed')} className={`flex flex-col items-center gap-1 transition-colors w-full py-2 ${currentView === 'feed' ? 'text-orange-500' : 'text-slate-500 hover:text-orange-500'}`}><Home size={24} /><span className="text-xs font-semibold">動態</span></button>
      <button onClick={() => onSwitchView('rewards')} className={`flex flex-col items-center gap-1 transition-colors w-full py-2 ${currentView === 'rewards' ? 'text-orange-500' : 'text-slate-500 hover:text-orange-500'}`}><Gift size={24} /><span className="text-xs font-semibold">獎勵</span></button>
      <button onClick={() => onSwitchView('blindbox')} className={`flex flex-col items-center gap-1 transition-colors w-full py-2 ${currentView === 'blindbox' ? 'text-orange-500' : 'text-slate-500 hover:text-orange-500'}`}><Box size={24} /><span className="text-xs font-semibold">盲盒</span></button>
      <button onClick={() => onSwitchView('profile')} className={`flex flex-col items-center gap-1 transition-colors w-full py-2 ${currentView === 'profile' ? 'text-orange-500' : 'text-slate-500 hover:text-orange-500'}`}><User size={24} /><span className="text-xs font-semibold">個人</span></button>
    </div>
  </div>
);

export default function App() {
  const [posts, setPosts] = useState(initialPosts);
  const [view, setView] = useState('feed');
  const [isCreatePanelOpen, setIsCreatePanelOpen] = useState(false);
  const [signalFlaresLeft, setSignalFlaresLeft] = useState(1);
  const [gCoins, setGCoins] = useState(350);
  const [transactions, setTransactions] = useState([]);
  const [myVouchers, setMyVouchers] = useState([]);
  const [selectedVoucher, setSelectedVoucher] = useState(null);
  const [isBlindBoxOpen, setIsBlindBoxOpen] = useState(false);
  const [isOpeningBox, setIsOpeningBox] = useState(false);
  const [blindBoxPrize, setBlindBoxPrize] = useState(null);

  const addTransaction = (description, amount) => { setTransactions(prev => [{ id: Date.now(), description, amount }, ...prev]); };

  const handleCreatePost = (newPost) => {
    if (newPost.isFlare) { if(signalFlaresLeft > 0) { setSignalFlaresLeft(prev => prev - 1); } else { alert("訊號彈已用完！"); newPost.isFlare = false; } }
    setPosts(prevPosts => [newPost, ...prevPosts]);
    const rewardAmount = 10;
    setGCoins(prev => prev + rewardAmount);
    addTransaction('分享貼文獎勵', rewardAmount);
    setView('feed');
  };

  const handleRedeem = (itemType, cost, rewardData) => {
    if (gCoins < cost) { alert("美食幣不足！"); return; }
    if (itemType === 'signalFlare') {
        setSignalFlaresLeft(prev => prev + 1);
        setGCoins(prev => prev - cost);
        addTransaction('兌換美食訊號彈', -cost);
        alert("成功兌換一枚美食訊號彈！");
    } else if (itemType === 'partnerReward') {
        setGCoins(prev => prev - cost);
        const newVoucher = { id: `voucher-${Date.now()}`, ...rewardData, redeemDate: Date.now(), isUsed: false };
        setMyVouchers(prev => [newVoucher, ...prev]);
        addTransaction(`兌換 "${rewardData.rewardName}"`, -cost);
        alert(`成功兌換！您可以在「我的兌換券」中找到它。`);
    }
  };

  const handleOpenBlindBox = (cost) => {
      if (gCoins < cost) { alert("美食幣不足！"); return; }
      setGCoins(prev => prev - cost);
      addTransaction('開啟美食盲盒', -cost);
      setIsBlindBoxOpen(true);
      setIsOpeningBox(true);
      setBlindBoxPrize(null);

      setTimeout(() => {
          const prizePool = [...partnerRewards];
          const prize = prizePool[Math.floor(Math.random() * prizePool.length)];
          setBlindBoxPrize(prize);
          const newVoucher = { id: `voucher-${Date.now()}`, ...prize, redeemDate: Date.now(), isUsed: false };
          setMyVouchers(prev => [newVoucher, ...prev]);
          setIsOpeningBox(false);
      }, 2000);
  };

  const handleCloseBlindBox = () => { setIsBlindBoxOpen(false); };
  const handleVoucherClick = (voucher) => { setSelectedVoucher(voucher); };
  const handleCloseVoucher = () => { setSelectedVoucher(null); };
  const handleConfirmVoucherUse = (voucherId) => {
      setMyVouchers(prev => prev.map(v => v.id === voucherId ? {...v, isUsed: true} : v));
      setSelectedVoucher(prev => prev ? {...prev, isUsed: true} : null);
  };

  const renderView = () => {
    switch (view) {
      case 'feed': return <Feed posts={posts} />;
      case 'rewards': return <RewardsView gCoins={gCoins} transactions={transactions} onRedeem={handleRedeem} myVouchers={myVouchers} onVoucherClick={handleVoucherClick} />;
      case 'blindbox': return <BlindBoxView gCoins={gCoins} onOpenBlindBox={handleOpenBlindBox} />;
      case 'profile': return <ProfileView />;
      default: return <Feed posts={posts} />;
    }
  };

  return (
    <div className="font-sans bg-slate-100 min-h-screen pb-20 relative">
        <header className="sticky top-0 bg-white/80 backdrop-blur-sm shadow-sm z-10 flex justify-between items-center px-4 py-3">
            <div className="flex items-center gap-2">
                 <img src="https://placehold.co/32x32/f97316/ffffff?text=G" alt="Logo" className="rounded-lg"/>
                 <h1 className="text-lg font-bold text-slate-800">美食驚喜捕捉器</h1>
            </div>
            <div className="flex items-center gap-4">
                <div className="flex items-center gap-2 bg-slate-100 px-3 py-1.5 rounded-full">
                    <Coins size={18} className="text-amber-500" /><span className="font-bold text-slate-700">{gCoins}</span>
                </div>
                <button onClick={() => setIsCreatePanelOpen(true)} className="text-orange-500">
                    <PlusCircle size={28} />
                </button>
            </div>
        </header>
        <main>{renderView()}</main>
        <FooterNav onSwitchView={setView} currentView={view} />
        <CreatePanel isOpen={isCreatePanelOpen} onClose={() => setIsCreatePanelOpen(false)} onCreatePost={handleCreatePost} signalFlaresLeft={signalFlaresLeft} />
        <VoucherModal voucher={selectedVoucher} onClose={handleCloseVoucher} onConfirmUse={handleConfirmVoucherUse} />
        <BlindBoxModal isOpen={isBlindBoxOpen} isOpening={isOpeningBox} prize={blindBoxPrize} onClose={handleCloseBlindBox} />
    </div>
  );
}
