// ==========================================
// 📈 THE BESPOKE SCORE ALGORITHM
// ==========================================

let bespokeScoreCache = new WeakMap();
let shopScoreCache = new WeakMap();

function clearAlgorithmCache() {
    bespokeScoreCache = new WeakMap();
    shopScoreCache = new WeakMap();
}

function calculateBespokeScore(list, allShops = [], allReviews = [], globalLikesCount = {}, userFavoriteShops = []) {
    if (bespokeScoreCache.has(list)) {
        return bespokeScoreCache.get(list);
    }

    let score = 0;
    const shop = allShops.find(s => s && s.id === list.shop_id);

    // 1. Engagement & Popularity (Max 40 pts)
    const views = list.views || 0;
    const likes = globalLikesCount[list.id] || 0;
    // slightly reduced weight on views so random variance can overtake it sometimes
    const viewsScore = Math.min(Math.log10(views + 1) * 4, 15); 
    const likesScore = Math.min(Math.log10(likes + 1) * 10, 20); 
    score += (viewsScore + likesScore);

    // 2. Quality & Reputation (Max 30 pts)
    const shopReviews = allReviews.filter(r => r.shop_id === list.shop_id);
    const avgRating = shopReviews.length > 0
        ? (shopReviews.reduce((sum, r) => sum + r.rating, 0) / shopReviews.length)
        : 0;
    
    if (avgRating > 0) {
        const ratingScore = (avgRating / 5) * 20; 
        const volumeBonus = Math.min(shopReviews.length * 0.5, 10); 
        score += (ratingScore + volumeBonus);
    } else {
        score += 15; // Baseline for new shops
    }

    // 3. Recency & Freshness (Max 15 pts)
    if (list.created_at) {
        const ageDays = (new Date() - new Date(list.created_at)) / (1000 * 60 * 60 * 24);
        const recencyScore = Math.max(0, 15 * Math.pow(0.85, ageDays)); // Exponential decay
        score += recencyScore;
    }

    // 4. Shop Profile Quality (Max 15 pts)
    let profileScore = 0;
    if (shop) {
        if (shop.profile_image && shop.profile_image !== 'undefined') profileScore += 5;
        if (shop.banner_image && shop.banner_image !== 'undefined') profileScore += 5;
        if (shop.description && shop.description.length > 20) profileScore += 5;
    }
    score += profileScore;

    // 5. Offers and Discounts (Max 20 pts)
    if (list.original_price && parseFloat(list.original_price) > parseFloat(list.price)) {
        const discountPct = (parseFloat(list.original_price) - parseFloat(list.price)) / parseFloat(list.original_price);
        score += Math.min(discountPct * 100 * 0.4, 20); 
    }

    // 6. Heavy Random Variance (up to 30 pts) 
    // This ensures a massive shuffle on every single page refresh while keeping top items generally high.
    score += Math.random() * 30;

    // 7. Favorite Shop Multiplier (5.0x Boost)
    if (userFavoriteShops && userFavoriteShops.includes(list.shop_id)) {
        score *= 5.0;
    }

    bespokeScoreCache.set(list, score);
    return score;
}

function calculateShopScore(shop, allReviews = [], userFavoriteShops = []) {
    if (shopScoreCache.has(shop)) {
        return shopScoreCache.get(shop);
    }

    let score = 0;
    const shopReviews = allReviews.filter(r => r.shop_id === shop.id);
    const avgRating = shopReviews.length > 0 ? (shopReviews.reduce((sum, r) => sum + r.rating, 0) / shopReviews.length) : 0;
    
    // 1. Reputation (Max 50 pts)
    if (avgRating > 0) {
        const ratingScore = (avgRating / 5) * 35; 
        const volumeBonus = Math.min(shopReviews.length * 1, 15); 
        score += (ratingScore + volumeBonus);
    } else {
        score += 20; // Baseline for new shops
    }

    // 2. Profile Quality (Max 30 pts)
    if (shop.profile_image && shop.profile_image !== 'undefined') score += 10;
    if (shop.banner_image && shop.banner_image !== 'undefined') score += 10;
    if (shop.description && shop.description.length > 20) score += 10;

    // Heavy random variance
    score += Math.random() * 20;

    // 3. Favorite Shop Dominance (Guarantee top position)
    if (userFavoriteShops && userFavoriteShops.includes(shop.id)) {
        score += 10000;
    }

    shopScoreCache.set(shop, score);
    return score;
}
