// ==========================================
// 📈 THE BESPOKE SCORE ALGORITHM
// ==========================================

function calculateBespokeScore(list, allShops = [], allReviews = [], globalLikesCount = {}) {
    let score = 0;
    const shop = allShops.find(s => s.id === list.shop_id);

    // 1. Engagement & Popularity (Max 40 pts)
    const views = list.views || 0;
    const likes = globalLikesCount[list.id] || 0;
    const viewsScore = Math.min(Math.log10(views + 1) * 6, 20); // up to 20 pts
    const likesScore = Math.min(Math.log10(likes + 1) * 12, 20); // up to 20 pts
    score += (viewsScore + likesScore);

    // 2. Quality & Reputation (Max 30 pts)
    const shopReviews = allReviews.filter(r => r.shop_id === list.shop_id);
    const avgRating = shopReviews.length > 0
        ? (shopReviews.reduce((sum, r) => sum + r.rating, 0) / shopReviews.length)
        : 0;

    if (avgRating > 0) {
        const ratingScore = (avgRating / 5) * 20; // up to 20 pts
        const volumeBonus = Math.min(shopReviews.length * 0.5, 10); // up to 10 pts
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

    // Random variance to break exact ties
    score += Math.random() * 0.1;

    return score;
}

function calculateShopScore(shop, allReviews = []) {
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

    score += Math.random() * 0.1; // Tie breaker
    return score;
}
