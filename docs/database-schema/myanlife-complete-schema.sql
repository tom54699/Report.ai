-- =====================================================
-- MyAnLife 完整資料庫架構設計
-- 創建日期: 2025-11-14
-- 最後更新: 2025-11-18
-- 描述: 包含所有系統模組的完整資料庫架構
-- =====================================================

-- =====================================================
-- 第一部分：基礎內容管理系統
-- =====================================================

-- 橫幅分類表
CREATE TABLE banner_categories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    name VARCHAR(50) NOT NULL COMMENT '分類名稱',
    description VARCHAR(255) COMMENT '分類描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='橫幅分類表';

-- 橫幅表
CREATE TABLE banners (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    title VARCHAR(100) NOT NULL COMMENT '橫幅標題',
    category_id BIGINT UNSIGNED NOT NULL COMMENT '分類ID',
    url VARCHAR(500) COMMENT '連結網址',
    image_url VARCHAR(500) NOT NULL COMMENT '圖片路徑',
    sort_order INT DEFAULT 0 COMMENT '排序順序',
    is_published TINYINT(1) DEFAULT 1 COMMENT '是否發布(0:否 1:是)',
    is_top TINYINT(1) DEFAULT 0 COMMENT '是否置頂(0:否 1:是)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_category_id (category_id) COMMENT '分類索引',
    KEY idx_sort_order (sort_order) COMMENT '排序索引',
    KEY idx_is_published (is_published) COMMENT '發布狀態索引',

    CONSTRAINT fk_banner_category FOREIGN KEY (category_id) REFERENCES banner_categories(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='橫幅表';

-- 新聞分類表
CREATE TABLE news_categories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    name VARCHAR(50) NOT NULL COMMENT '分類名稱',
    description VARCHAR(255) COMMENT '分類描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='新聞分類表';

-- 新聞表
CREATE TABLE news (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    category_id BIGINT UNSIGNED NOT NULL COMMENT '分類ID',
    title VARCHAR(200) NOT NULL COMMENT '新聞標題',
    description VARCHAR(100) COMMENT '新聞摘要',
    content TEXT NOT NULL COMMENT '新聞內容',
    is_published TINYINT(1) DEFAULT 1 COMMENT '是否發布(0:否 1:是)',
    is_top TINYINT(1) DEFAULT 0 COMMENT '是否置頂(0:否 1:是)',
    publish_time TIMESTAMP NULL COMMENT '發布時間',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_category_id (category_id) COMMENT '分類索引',
    KEY idx_is_published (is_published) COMMENT '發布狀態索引',
    KEY idx_publish_time (publish_time) COMMENT '發布時間索引',

    CONSTRAINT fk_news_category FOREIGN KEY (category_id) REFERENCES news_categories(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='新聞表';

-- 黃頁分類表
CREATE TABLE yellow_page_categories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    name VARCHAR(100) NOT NULL COMMENT '分類名稱',
    description VARCHAR(255) COMMENT '分類描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='黃頁分類表';

-- 黃頁表
CREATE TABLE yellow_pages (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    name VARCHAR(255) NOT NULL COMMENT '商家名稱',
    category_id BIGINT UNSIGNED NOT NULL COMMENT '分類ID',
    image_url VARCHAR(500) COMMENT '商家圖片',
    is_published TINYINT(1) DEFAULT 0 COMMENT '是否上架(0:否 1:是)',

    -- 聯絡資訊
    country_iso CHAR(2) NOT NULL COMMENT '國家代碼(ISO 3166-1 alpha-2)',
    phone_number VARCHAR(30) NOT NULL COMMENT '電話號碼(不含國碼)',
    email VARCHAR(255) COMMENT '聯絡信箱',
    region VARCHAR(100) COMMENT '地區',
    address VARCHAR(255) COMMENT '地址',
    google_plus_code VARCHAR(50) COMMENT 'Google Map Plus Code',
    website VARCHAR(500) COMMENT '商家官網',

    -- 商家簡介
    description VARCHAR(500) COMMENT '商家簡介',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_category_id (category_id) COMMENT '分類索引',
    KEY idx_is_published (is_published) COMMENT '上架狀態索引',
    KEY idx_country_iso (country_iso) COMMENT '國家索引',
    KEY idx_region (region) COMMENT '地區索引',

    CONSTRAINT fk_yellowpage_category FOREIGN KEY (category_id) REFERENCES yellow_page_categories(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='黃頁表';

-- 公益活動分類表
CREATE TABLE charity_activity_categories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    name VARCHAR(100) NOT NULL COMMENT '分類名稱',
    description VARCHAR(255) COMMENT '分類描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公益活動分類表';

-- 公益活動表
CREATE TABLE charity_activities (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    name VARCHAR(255) NOT NULL COMMENT '活動名稱',
    category_id BIGINT UNSIGNED NOT NULL COMMENT '分類ID',
    start_date DATETIME NOT NULL COMMENT '開始時間',
    end_date DATETIME NOT NULL COMMENT '結束時間',
    is_published TINYINT(1) DEFAULT 0 COMMENT '是否上架(0:否 1:是)',
    cover_image_url VARCHAR(500) COMMENT '封面圖片',
    image_url VARCHAR(500) COMMENT '活動圖片',
    content TEXT COMMENT '活動內容',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_category_id (category_id) COMMENT '分類索引',
    KEY idx_is_published (is_published) COMMENT '上架狀態索引',
    KEY idx_start_date (start_date) COMMENT '開始時間索引',
    KEY idx_end_date (end_date) COMMENT '結束時間索引',
    KEY idx_date_range (start_date, end_date) COMMENT '日期範圍複合索引',

    CONSTRAINT fk_charity_activity_category FOREIGN KEY (category_id) REFERENCES charity_activity_categories(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公益活動表';

-- 職缺表
CREATE TABLE vacancies (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    title VARCHAR(255) NOT NULL COMMENT '職缺名稱',
    department VARCHAR(100) NOT NULL COMMENT '部門',
    region VARCHAR(100) NOT NULL COMMENT '地區',
    is_published TINYINT(1) DEFAULT 0 COMMENT '是否上架(0:否 1:是)',
    description TEXT NOT NULL COMMENT '職缺內容',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_is_published (is_published) COMMENT '上架狀態索引',
    KEY idx_department (department) COMMENT '部門索引',
    KEY idx_region (region) COMMENT '地區索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='職缺表';

-- =====================================================
-- 第二部分：會員系統
-- =====================================================

-- 會員表
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    member_id BIGINT UNSIGNED UNIQUE COMMENT '中央會員系統ID',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT '會員信箱(登入帳號)',
    nickname VARCHAR(100) NOT NULL COMMENT '暱稱',
    password_hash VARCHAR(255) NOT NULL COMMENT '密碼雜湊值',

    -- 基本資料
    gender VARCHAR(20) COMMENT '性別',
    birthday DATE COMMENT '生日',

    -- 國籍與電話
    nationality_iso CHAR(2) COMMENT '國籍代碼(ISO 3166-1 alpha-2)',
    phone_country_iso CHAR(2) NOT NULL COMMENT '電話國碼(ISO 3166-1 alpha-2)',
    phone_number VARCHAR(30) NOT NULL COMMENT '聯絡電話(不含國碼)',

    -- 地址
    region VARCHAR(100) COMMENT '區域',
    address VARCHAR(255) COMMENT '地址',

    -- 系統設定
    preferences JSON COMMENT '偏好設定',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',

    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '註冊時間',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_member_id (member_id) COMMENT '中央會員ID索引',
    KEY idx_phone (phone_country_iso, phone_number) COMMENT '電話複合索引',
    KEY idx_is_active (is_active) COMMENT '啟用狀態索引',
    KEY idx_registered_at (registered_at) COMMENT '註冊時間索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='會員表';

-- =====================================================
-- 第三部分：任務系統
-- =====================================================

-- 會員任務表
CREATE TABLE member_tasks (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    name VARCHAR(255) NOT NULL COMMENT '任務名稱',
    description VARCHAR(500) COMMENT '任務描述',
    task_type VARCHAR(50) NOT NULL COMMENT '任務類型',
    reward_points INT UNSIGNED DEFAULT 0 COMMENT '獎勵金幣數量',
    reward_special VARCHAR(100) COMMENT '特別獎勵',
    limit_per_user INT UNSIGNED DEFAULT 1 COMMENT '每位會員可完成次數',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_is_active (is_active) COMMENT '啟用狀態索引',
    KEY idx_task_type (task_type) COMMENT '任務類型索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='會員任務表';

-- 商家任務表
CREATE TABLE merchant_tasks (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    name VARCHAR(255) NOT NULL COMMENT '任務名稱',
    description VARCHAR(500) COMMENT '任務描述',
    task_type VARCHAR(50) NOT NULL COMMENT '任務類型',
    reward_points INT UNSIGNED DEFAULT 0 COMMENT '獎勵金幣數量',
    reward_special VARCHAR(100) COMMENT '特別獎勵',
    limit_per_merchant INT UNSIGNED DEFAULT 1 COMMENT '每位商家可完成次數',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_is_active (is_active) COMMENT '啟用狀態索引',
    KEY idx_task_type (task_type) COMMENT '任務類型索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家任務表';

-- 會員任務記錄表
CREATE TABLE member_task_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    task_id BIGINT UNSIGNED NOT NULL COMMENT '任務ID',
    member_id BIGINT UNSIGNED NOT NULL COMMENT '會員ID',
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '完成時間',
    reward_points INT UNSIGNED DEFAULT 0 COMMENT '實際獲得金幣',
    reward_special VARCHAR(100) COMMENT '實際獲得特別獎勵',

    KEY idx_task_id (task_id) COMMENT '任務索引',
    KEY idx_member_id (member_id) COMMENT '會員索引',
    KEY idx_completed_at (completed_at) COMMENT '完成時間索引',
    KEY idx_member_task (member_id, task_id) COMMENT '會員任務複合索引',

    CONSTRAINT fk_member_task FOREIGN KEY (task_id) REFERENCES member_tasks(id),
    CONSTRAINT fk_log_user FOREIGN KEY (member_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='會員任務記錄表';

-- 商家任務記錄表
CREATE TABLE merchant_task_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    task_id BIGINT UNSIGNED NOT NULL COMMENT '任務ID',
    merchant_id BIGINT UNSIGNED NOT NULL COMMENT '商家ID',
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '完成時間',
    reward_points INT UNSIGNED DEFAULT 0 COMMENT '實際獲得金幣',
    reward_special VARCHAR(100) COMMENT '實際獲得特別獎勵',

    KEY idx_task_id (task_id) COMMENT '任務索引',
    KEY idx_merchant_id (merchant_id) COMMENT '商家索引',
    KEY idx_completed_at (completed_at) COMMENT '完成時間索引',
    KEY idx_merchant_task (merchant_id, task_id) COMMENT '商家任務複合索引',

    CONSTRAINT fk_merchant_task FOREIGN KEY (task_id) REFERENCES merchant_tasks(id),
    CONSTRAINT fk_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家任務記錄表';

-- =====================================================
-- 第四部分：商家系統
-- =====================================================

-- 商家主表
CREATE TABLE merchants (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '商家 ID',

    -- 帳號資訊
    account_email VARCHAR(255) NOT NULL UNIQUE COMMENT '商家帳號信箱',
    password_hash VARCHAR(255) NOT NULL COMMENT '密碼雜湊',

    -- 商家基本資訊
    merchant_name VARCHAR(255) NOT NULL COMMENT '公司/商家名稱',
    owner_name VARCHAR(100) COMMENT '負責人姓名',
    category VARCHAR(50) NOT NULL COMMENT '商家類型(travel/food/hotel/entertainment)',

    -- 聯絡資訊
    contact_person VARCHAR(100) COMMENT '聯絡人',
    contact_phone_country_iso CHAR(2) COMMENT '聯絡電話國碼(ISO 3166-1 alpha-2)',
    contact_phone VARCHAR(50) COMMENT '聯絡電話',
    contact_email VARCHAR(255) COMMENT '聯絡信箱',

    -- 社群媒體
    fb_link VARCHAR(255) COMMENT 'Facebook 連結',
    line_id VARCHAR(100) COMMENT 'Line ID',
    website VARCHAR(255) COMMENT '官方網站',

    -- 證照資訊
    has_license TINYINT(1) DEFAULT 0 COMMENT '是否有營業執照(0:否 1:是)',
    license_number VARCHAR(100) COMMENT '營業執照號碼',
    license_image VARCHAR(255) COMMENT '營業執照圖片',

    -- 商家類型
    store_type VARCHAR(20) DEFAULT 'single' COMMENT '單店/連鎖(single/chain)',

    -- 品牌形象
    logo_image VARCHAR(255) COMMENT '商家 Logo',
    banner_image VARCHAR(255) COMMENT '橫幅圖片',
    intro_text TEXT COMMENT '商家簡介',

    -- 財務設定
    commission_rate DECIMAL(5,2) COMMENT '平台抽成比例(%)',
    settlement_cycle VARCHAR(20) COMMENT '結算週期(weekly/monthly)',
    bank_account VARCHAR(100) COMMENT '收款帳號',

    -- 狀態
    status VARCHAR(20) DEFAULT 'pending' COMMENT '審核狀態(pending/approved/rejected/suspended)',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',

    -- 軟刪除
    deleted_at TIMESTAMP NULL COMMENT '刪除時間',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_email (account_email),
    KEY idx_status (status),
    KEY idx_category (category),
    KEY idx_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家主表';

-- 店家表
CREATE TABLE stores (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '店家 ID',

    merchant_id BIGINT UNSIGNED NOT NULL COMMENT '所屬商家 ID',

    -- 店家基本資訊
    store_name VARCHAR(255) NOT NULL COMMENT '店家名稱',
    store_code VARCHAR(50) COMMENT '店家代碼(分店編號)',

    -- 地址資訊
    country_iso CHAR(2) COMMENT '國家代碼(ISO 3166-1 alpha-2)',
    region VARCHAR(100) COMMENT '地區/城市',
    address VARCHAR(255) COMMENT '詳細地址',
    google_map_url VARCHAR(500) COMMENT 'Google Map 連結',
    latitude DECIMAL(10,8) COMMENT '緯度',
    longitude DECIMAL(11,8) COMMENT '經度',

    -- 聯絡資訊
    phone_country_iso CHAR(2) COMMENT '電話國碼(ISO 3166-1 alpha-2)',
    phone_number VARCHAR(50) COMMENT '店家電話',
    store_email VARCHAR(255) COMMENT '店家信箱',

    -- 營業資訊
    business_hours JSON COMMENT '營業時間(JSON格式)',

    -- 店家圖片
    storefront_image VARCHAR(255) COMMENT '店面照片',
    gallery_images JSON COMMENT '店內圖片集',

    -- 特色說明
    features TEXT COMMENT '店家特色',
    facilities JSON COMMENT '設施設備(停車場/wifi等)',

    -- 交通方式
    transportation TEXT COMMENT '交通方式說明',

    -- 狀態
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否營業中(0:否 1:是)',

    -- 軟刪除
    deleted_at TIMESTAMP NULL COMMENT '刪除時間',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_store_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
    KEY idx_merchant (merchant_id),
    KEY idx_region (region),
    KEY idx_active (is_active),
    KEY idx_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='店家表';

-- =====================================================
-- 第五部分：商品系統
-- =====================================================

-- 商品分類表
CREATE TABLE product_categories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '分類 ID',

    category_name VARCHAR(100) NOT NULL COMMENT '分類名稱',
    category_type VARCHAR(50) NOT NULL COMMENT '大類別(travel/food/hotel/entertainment)',
    description TEXT COMMENT '分類描述',
    icon VARCHAR(255) COMMENT '分類圖示',
    sort_order INT DEFAULT 0 COMMENT '排序',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_type (category_type),
    KEY idx_sort (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分類表(管理員管理)';

-- 商品主表
CREATE TABLE products (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '商品 ID',

    merchant_id BIGINT UNSIGNED NOT NULL COMMENT '所屬商家 ID',
    category_id BIGINT UNSIGNED COMMENT '商品分類 ID',

    -- 基本資訊
    product_name VARCHAR(255) NOT NULL COMMENT '商品名稱',
    subtitle VARCHAR(255) COMMENT '副標題',
    cover_image VARCHAR(255) COMMENT '封面圖片',
    gallery_images JSON COMMENT '圖片集',
    promo_video VARCHAR(500) COMMENT '宣傳影片',

    -- 價格設定
    original_price DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT '原價(0表示免費)',
    selling_price DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT '售價(0表示免費)',
    currency CHAR(3) DEFAULT 'MMK' COMMENT '幣別',

    -- 庫存設定
    total_quantity INT COMMENT '總數量(NULL表示不限)',
    available_quantity INT COMMENT '剩餘數量',
    purchase_limit_per_user INT COMMENT '每人限購數量',

    -- 使用設定
    valid_from DATE COMMENT '使用開始日期',
    valid_to DATE COMMENT '使用結束日期',
    usage_scope TEXT COMMENT '使用範圍說明',
    usage_method VARCHAR(20) DEFAULT 'qrcode' COMMENT '使用方式(electronic/qrcode/voucher)',

    -- 推廣設定
    promotion_start DATETIME COMMENT '推廣開始時間',
    promotion_end DATETIME COMMENT '推廣結束時間',

    -- 折扣資訊
    discount_type VARCHAR(50) COMMENT '優惠類型(percentage/fixed_amount/buy_one_get_one等)',
    discount_value DECIMAL(10,2) COMMENT '折扣數值',
    discount_description TEXT COMMENT '優惠說明',

    -- 商品詳情
    description TEXT COMMENT '商品詳細說明',
    features TEXT COMMENT '商品特色',
    includes JSON COMMENT '費用包含項目',
    excludes JSON COMMENT '費用不包含項目',
    extra_fees JSON COMMENT '可能的額外費用',

    -- 使用須知
    usage_notes TEXT COMMENT '使用說明',
    terms TEXT COMMENT '使用條款',
    transportation TEXT COMMENT '交通方式',

    -- 退款政策
    cancellation_policy_type VARCHAR(50) DEFAULT 'non_refundable' COMMENT '退款政策類型(non_refundable/full_refund/partial_refund/flexible)',
    cancellation_days_before INT COMMENT '使用前幾天可退款',
    cancellation_refund_percentage DECIMAL(5,2) COMMENT '退款百分比(0-100)',
    cancellation_notes TEXT COMMENT '退款政策補充說明',

    -- 預訂設定
    is_booking_required TINYINT(1) DEFAULT 0 COMMENT '是否需要預訂(0:否 1:是)',
    booking_notice_days INT COMMENT '需提前幾天預訂',

    -- 審核與狀態
    review_status VARCHAR(20) DEFAULT 'draft' COMMENT '審核狀態(draft/pending/approved/rejected)',
    reject_reason TEXT COMMENT '拒絕原因',
    is_published TINYINT(1) DEFAULT 0 COMMENT '是否上架(0:否 1:是)',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',

    -- 統計資訊
    view_count INT DEFAULT 0 COMMENT '瀏覽次數',
    purchase_count INT DEFAULT 0 COMMENT '購買次數',
    rating_average DECIMAL(3,2) COMMENT '平均評分',
    rating_count INT DEFAULT 0 COMMENT '評分人數',

    -- 軟刪除
    deleted_at TIMESTAMP NULL COMMENT '刪除時間',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
    published_at TIMESTAMP COMMENT '上架時間',

    CONSTRAINT fk_product_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES product_categories(id) ON DELETE SET NULL,
    KEY idx_merchant (merchant_id),
    KEY idx_category (category_id),
    KEY idx_merchant_status (merchant_id, review_status, is_published),
    KEY idx_merchant_created (merchant_id, created_at),
    KEY idx_status (review_status, is_published),
    KEY idx_price (selling_price),
    KEY idx_valid_date (valid_from, valid_to),
    KEY idx_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品主表';

-- 美食優惠券子表
CREATE TABLE food_products (
    product_id BIGINT UNSIGNED PRIMARY KEY COMMENT '商品 ID',

    cuisine_type VARCHAR(100) COMMENT '菜系類型',
    meal_type VARCHAR(50) COMMENT '用餐時段(breakfast/lunch/dinner/afternoon_tea/all_day)',
    serving_size INT COMMENT '適用人數',
    menu_items TEXT COMMENT '菜單項目',
    dietary_info VARCHAR(255) COMMENT '飲食資訊(素食/清真等)',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_food_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='美食優惠券子表';

-- 旅遊優惠券子表
CREATE TABLE travel_products (
    product_id BIGINT UNSIGNED PRIMARY KEY COMMENT '商品 ID',

    travelers INT COMMENT '適用人數',
    days INT COMMENT '天數',
    nights INT COMMENT '夜數',
    destinations TEXT COMMENT '目的地',
    itinerary TEXT COMMENT '行程說明',
    tour_type VARCHAR(20) COMMENT '旅遊類型(group/private/self_guided)',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_travel_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='旅遊優惠券子表';

-- 住宿優惠券子表
CREATE TABLE hotel_products (
    product_id BIGINT UNSIGNED PRIMARY KEY COMMENT '商品 ID',

    room_type VARCHAR(100) COMMENT '房型',
    guest_capacity INT COMMENT '可住人數',
    bed_type VARCHAR(50) COMMENT '床型',
    room_size DECIMAL(5,2) COMMENT '房間坪數',
    nights_included INT COMMENT '包含住宿夜數',
    check_in_time VARCHAR(20) COMMENT '入住時間',
    check_out_time VARCHAR(20) COMMENT '退房時間',
    amenities JSON COMMENT '房間設施',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_hotel_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='住宿優惠券子表';

-- 休閒娛樂優惠券子表
CREATE TABLE entertainment_products (
    product_id BIGINT UNSIGNED PRIMARY KEY COMMENT '商品 ID',

    activity_type VARCHAR(100) COMMENT '活動類型',
    participant_limit INT COMMENT '參與人數限制',
    duration_minutes INT COMMENT '活動時長(分鐘)',
    age_restriction VARCHAR(50) COMMENT '年齡限制',
    difficulty_level VARCHAR(20) COMMENT '難度等級(easy/medium/hard)',
    equipment_provided TINYINT(1) COMMENT '是否提供設備(0:否 1:是)',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_entertainment_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='休閒娛樂優惠券子表';

-- 商品與店家關聯表
CREATE TABLE product_stores (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    product_id BIGINT UNSIGNED NOT NULL COMMENT '商品 ID',
    store_id BIGINT UNSIGNED NOT NULL COMMENT '適用店家 ID',
    is_primary TINYINT(1) DEFAULT 0 COMMENT '是否為主要店家(0:否 1:是)',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',

    CONSTRAINT fk_ps_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_ps_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
    UNIQUE KEY uk_product_store (product_id, store_id),
    KEY idx_product (product_id),
    KEY idx_store (store_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品與店家關聯表';

-- =====================================================
-- 第六部分：訂單系統
-- =====================================================

-- 訂單主表
CREATE TABLE orders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '訂單流水號',

    -- 訂單基本資訊
    order_number VARCHAR(50) NOT NULL UNIQUE COMMENT '訂單編號',
    member_id BIGINT UNSIGNED NOT NULL COMMENT '會員 ID',
    merchant_id BIGINT UNSIGNED COMMENT '商家 ID',

    -- 金額與付款
    total_amount DECIMAL(10,2) NOT NULL COMMENT '訂單總金額',
    discount_amount DECIMAL(10,2) DEFAULT 0 COMMENT '折扣金額',
    final_amount DECIMAL(10,2) NOT NULL COMMENT '實付金額',
    currency CHAR(3) DEFAULT 'MMK' COMMENT '幣別',
    payment_method VARCHAR(50) COMMENT '付款方式(kbzpay/aya_pay/credit_card等)',
    payment_status VARCHAR(20) DEFAULT 'pending' COMMENT '付款狀態(pending/paid/failed/refunded)',

    -- 聯絡資訊
    contact_name VARCHAR(100) COMMENT '聯絡人姓名',
    contact_email VARCHAR(255) COMMENT '聯絡人信箱',
    phone_country_iso CHAR(2) COMMENT '電話國碼(ISO 3166-1 alpha-2)',
    phone_number VARCHAR(20) COMMENT '聯絡電話',

    -- 訂單狀態
    order_status VARCHAR(20) DEFAULT 'pending' COMMENT '訂單狀態(pending/confirmed/completed/cancelled)',
    notes TEXT COMMENT '備註',

    -- 時間記錄
    confirmed_at TIMESTAMP COMMENT '確認時間',
    completed_at TIMESTAMP COMMENT '完成時間',
    cancelled_at TIMESTAMP COMMENT '取消時間',
    cancellation_reason TEXT COMMENT '取消原因',

    -- 軟刪除
    deleted_at TIMESTAMP NULL COMMENT '刪除時間',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_order_member FOREIGN KEY (member_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE SET NULL,
    KEY idx_member (member_id),
    KEY idx_merchant (merchant_id),
    KEY idx_member_created (member_id, created_at),
    KEY idx_member_status (member_id, order_status),
    KEY idx_order_number (order_number),
    KEY idx_status (order_status, payment_status),
    KEY idx_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='訂單主表';

-- 訂單明細表
CREATE TABLE order_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '訂單明細 ID',

    order_id BIGINT UNSIGNED NOT NULL COMMENT '訂單 ID',
    product_id BIGINT UNSIGNED NOT NULL COMMENT '商品 ID',

    -- 商品快照
    product_name VARCHAR(255) NOT NULL COMMENT '商品名稱',
    product_image VARCHAR(255) COMMENT '商品圖片',

    -- 價格資訊
    unit_price DECIMAL(10,2) NOT NULL COMMENT '單價',
    quantity INT NOT NULL DEFAULT 1 COMMENT '數量',
    subtotal DECIMAL(10,2) NOT NULL COMMENT '小計',

    -- 折扣資訊
    promo_code_id BIGINT UNSIGNED COMMENT '使用的折扣碼 ID',
    discount_amount DECIMAL(10,2) DEFAULT 0 COMMENT '折扣金額',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',

    CONSTRAINT fk_oi_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_oi_promo FOREIGN KEY (promo_code_id) REFERENCES promo_codes(id) ON DELETE SET NULL,
    KEY idx_order (order_id),
    KEY idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='訂單明細表';

-- 支付記錄表
CREATE TABLE payments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '支付 ID',

    order_id BIGINT UNSIGNED NOT NULL COMMENT '訂單 ID',

    -- 支付資訊
    payment_method VARCHAR(50) NOT NULL COMMENT '付款方式(kbzpay/aya_pay/credit_card等)',
    payment_amount DECIMAL(10,2) NOT NULL COMMENT '付款金額',
    currency CHAR(3) DEFAULT 'MMK' COMMENT '幣別',

    -- 支付狀態
    payment_status VARCHAR(20) DEFAULT 'pending' COMMENT '支付狀態(pending/processing/completed/failed/refunded)',

    -- 第三方支付資訊
    transaction_id VARCHAR(255) COMMENT '第三方交易 ID',
    payment_gateway VARCHAR(50) COMMENT '支付閘道',
    gateway_response JSON COMMENT '閘道回應資料',

    -- 時間紀錄
    paid_at TIMESTAMP COMMENT '付款完成時間',
    refunded_at TIMESTAMP COMMENT '退款時間',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    KEY idx_order (order_id),
    KEY idx_status (payment_status),
    KEY idx_transaction (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付記錄表';

-- 訂單狀態記錄表
CREATE TABLE order_status_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '記錄 ID',

    order_id BIGINT UNSIGNED NOT NULL COMMENT '訂單 ID',

    -- 狀態變更
    from_status VARCHAR(20) COMMENT '原狀態(pending/confirmed/completed/cancelled)',
    to_status VARCHAR(20) NOT NULL COMMENT '新狀態(pending/confirmed/completed/cancelled)',

    -- 支付狀態變更(可選)
    from_payment_status VARCHAR(20) COMMENT '原支付狀態(pending/paid/failed/refunded)',
    to_payment_status VARCHAR(20) COMMENT '新支付狀態(pending/paid/failed/refunded)',

    -- 操作資訊
    operator_type VARCHAR(20) DEFAULT 'system' COMMENT '操作者類型(system/member/merchant/admin)',
    operator_id BIGINT UNSIGNED COMMENT '操作者 ID',
    operator_name VARCHAR(100) COMMENT '操作者名稱',

    -- 變更原因
    reason TEXT COMMENT '狀態變更原因',
    notes TEXT COMMENT '備註',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '變更時間',

    CONSTRAINT fk_log_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    KEY idx_order (order_id),
    KEY idx_status (to_status),
    KEY idx_date (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='訂單狀態記錄表';

-- =====================================================
-- 第七部分：用戶持有與核銷系統
-- =====================================================

-- 用戶持有商品表
CREATE TABLE user_products (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '持有 ID',

    member_id BIGINT UNSIGNED NOT NULL COMMENT '會員 ID',
    product_id BIGINT UNSIGNED NOT NULL COMMENT '商品 ID',
    order_id BIGINT UNSIGNED COMMENT '訂單 ID',

    -- QR Code 資訊（動態生成方案）
    unique_code VARCHAR(100) NOT NULL UNIQUE COMMENT '唯一識別碼(固定不變)',
    qr_temp_token VARCHAR(255) COMMENT '臨時 QR token(5分鐘有效)',
    qr_temp_token_expires_at TIMESTAMP COMMENT 'QR token 過期時間',

    -- 使用狀態
    status VARCHAR(20) DEFAULT 'active' COMMENT '狀態(active/redeemed/expired/cancelled)',
    quantity INT DEFAULT 1 COMMENT '數量',

    -- 有效期限
    valid_from DATE COMMENT '有效開始日期',
    valid_to DATE COMMENT '有效結束日期',

    -- 核銷資訊
    redeemed_at TIMESTAMP COMMENT '核銷時間',
    redeemed_store_id BIGINT UNSIGNED COMMENT '核銷店家',
    redeemed_by BIGINT UNSIGNED COMMENT '核銷員工 ID(未來可擴充)',

    -- 系統紀錄
    acquired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '取得時間',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_up_member FOREIGN KEY (member_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_up_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_up_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    CONSTRAINT fk_up_store FOREIGN KEY (redeemed_store_id) REFERENCES stores(id) ON DELETE SET NULL,
    KEY idx_member (member_id),
    KEY idx_product (product_id),
    KEY idx_member_status (member_id, status),
    KEY idx_member_valid (member_id, valid_to),
    KEY idx_unique_code (unique_code),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用戶持有商品表';

-- 核銷記錄表
CREATE TABLE redemptions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '核銷 ID',

    user_product_id BIGINT UNSIGNED NOT NULL COMMENT '用戶商品 ID',
    member_id BIGINT UNSIGNED NOT NULL COMMENT '會員 ID',
    product_id BIGINT UNSIGNED NOT NULL COMMENT '商品 ID',
    store_id BIGINT UNSIGNED NOT NULL COMMENT '核銷店家 ID',

    -- 核銷資訊
    unique_code VARCHAR(100) NOT NULL COMMENT '唯一識別碼',
    redemption_method VARCHAR(20) DEFAULT 'qr_scan' COMMENT '核銷方式(qr_scan/manual/system)',

    -- 核銷人員(未來可擴充員工系統)
    staff_id BIGINT UNSIGNED COMMENT '核銷員工 ID',
    staff_name VARCHAR(100) COMMENT '核銷員工姓名',

    -- 核銷裝置
    device_info JSON COMMENT '裝置資訊',
    ip_address VARCHAR(45) COMMENT 'IP 位址',

    -- 備註
    notes TEXT COMMENT '核銷備註',

    -- 系統紀錄
    redeemed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '核銷時間',

    CONSTRAINT fk_red_user_product FOREIGN KEY (user_product_id) REFERENCES user_products(id) ON DELETE CASCADE,
    CONSTRAINT fk_red_member FOREIGN KEY (member_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_red_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_red_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
    KEY idx_user_product (user_product_id),
    KEY idx_member (member_id),
    KEY idx_store (store_id),
    KEY idx_store_date (store_id, redeemed_at),
    KEY idx_date (redeemed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='核銷記錄表';

-- =====================================================
-- 第八部分：促銷系統
-- =====================================================

-- 折扣碼表
CREATE TABLE promo_codes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '折扣碼流水號',

    -- 基本設定
    code VARCHAR(50) NOT NULL UNIQUE COMMENT '折扣碼',
    group_id INT COMMENT '折扣碼分組 ID',
    prefix VARCHAR(20) COMMENT '折扣碼前綴',
    suffix_length INT COMMENT '隨機後綴長度(3-20字元)',
    char_set VARCHAR(20) DEFAULT 'mixed' COMMENT '字元集(mixed/alpha/numeric)',

    -- 折扣設定
    discount_type VARCHAR(20) NOT NULL COMMENT '折扣類型(fixed/percentage)',
    discount_amount DECIMAL(10,2) NOT NULL COMMENT '折扣金額或百分比',

    -- 商品設定
    limited_product_id BIGINT UNSIGNED COMMENT '限定商品 ID(NULL表示通用)',

    -- 使用限制
    quantity INT DEFAULT 1 COMMENT '折扣碼可使用總數量',
    used_count INT DEFAULT 0 COMMENT '已使用次數',
    usage_limit INT DEFAULT 1 COMMENT '每位使用者可使用次數',
    min_spending DECIMAL(10,2) DEFAULT 0 COMMENT '最低消費金額',

    -- 時間設定
    start_date DATETIME NOT NULL COMMENT '折扣碼開始日期',
    end_date DATETIME NOT NULL COMMENT '折扣碼結束日期',

    -- 狀態
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_promo_product FOREIGN KEY (limited_product_id) REFERENCES products(id) ON DELETE SET NULL,
    KEY idx_code (code),
    KEY idx_active (is_active),
    KEY idx_dates (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='折扣碼表';

-- =====================================================
-- 第九部分：審核與評分系統
-- =====================================================

-- 商品審核記錄表
CREATE TABLE product_reviews (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '審核 ID',

    product_id BIGINT UNSIGNED NOT NULL COMMENT '商品 ID',
    reviewer_id BIGINT UNSIGNED COMMENT '審核人員 ID(管理員)',

    -- 審核資訊
    review_status VARCHAR(20) NOT NULL COMMENT '審核狀態(pending/approved/rejected/revision_required)',
    reviewer_notes TEXT COMMENT '審核意見',
    reject_reason TEXT COMMENT '拒絕原因',

    -- 審核前後快照(可選)
    product_snapshot JSON COMMENT '商品資料快照',

    -- 系統紀錄
    reviewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '審核時間',

    CONSTRAINT fk_review_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    KEY idx_product (product_id),
    KEY idx_status (review_status),
    KEY idx_date (reviewed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品審核記錄表';

-- 商品評分表
CREATE TABLE product_ratings (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '評分 ID',

    product_id BIGINT UNSIGNED NOT NULL COMMENT '商品 ID',
    member_id BIGINT UNSIGNED NOT NULL COMMENT '會員 ID',
    order_id BIGINT UNSIGNED COMMENT '訂單 ID',

    -- 評分資訊
    rating INT NOT NULL COMMENT '評分(1-5)',
    review_text TEXT COMMENT '評價內容',
    images JSON COMMENT '評價圖片',

    -- 隱私設定
    is_anonymous TINYINT(1) DEFAULT 0 COMMENT '是否匿名(0:否 1:是)',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_rating_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_rating_member FOREIGN KEY (member_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_rating_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    UNIQUE KEY uk_member_order_product (member_id, order_id, product_id),
    KEY idx_product (product_id),
    KEY idx_member (member_id),
    KEY idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品評分表';

-- =====================================================
-- 第十部分：用戶與商家偏好設定
-- =====================================================

-- 會員偏好設定表
CREATE TABLE user_preferences (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '偏好設定 ID',
    user_id BIGINT UNSIGNED NOT NULL UNIQUE COMMENT '會員 ID',

    -- 偏好設定
    currency CHAR(3) DEFAULT 'MMK' COMMENT '偏好幣別(ISO 4217)',
    lang CHAR(5) DEFAULT 'my-MM' COMMENT '偏好語言(ISO 639-1 + ISO 3166-1)',
    newsletter_subscription TINYINT(1) DEFAULT 0 COMMENT '是否訂閱電子報(0:否 1:是)',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_user_preference FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='會員偏好設定表';

-- 商家偏好設定表
CREATE TABLE merchant_preferences (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '偏好設定 ID',
    merchant_id BIGINT UNSIGNED NOT NULL UNIQUE COMMENT '商家 ID',

    -- 偏好設定
    currency CHAR(3) DEFAULT 'MMK' COMMENT '偏好幣別(ISO 4217)',
    lang CHAR(5) DEFAULT 'my-MM' COMMENT '偏好語言(ISO 639-1 + ISO 3166-1)',
    newsletter_subscription TINYINT(1) DEFAULT 0 COMMENT '是否訂閱電子報(0:否 1:是)',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    CONSTRAINT fk_merchant_preference FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家偏好設定表';

-- =====================================================
-- 第十一部分：管理員系統
-- =====================================================

-- 管理員表(各國運營團隊)
CREATE TABLE admins (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '管理員 ID',

    -- Laravel 標準認證欄位
    name VARCHAR(100) NOT NULL COMMENT '姓名',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT '信箱(登入帳號)',
    email_verified_at TIMESTAMP NULL COMMENT 'Email 驗證時間',
    password VARCHAR(255) NOT NULL COMMENT '密碼雜湊值',
    remember_token VARCHAR(100) COMMENT 'Remember Token',

    -- 聯絡資訊
    phone_country_iso CHAR(2) COMMENT '電話國碼(ISO 3166-1 alpha-2)',
    phone_number VARCHAR(30) COMMENT '聯絡電話(不含國碼)',

    -- 運營團隊專屬欄位
    country_iso CHAR(2) NOT NULL COMMENT '所屬國家(ISO 3166-1 alpha-2)',
    department VARCHAR(50) COMMENT '部門(customer_service/operation/marketing/finance/tech)',

    -- 偏好設定
    lang CHAR(5) DEFAULT 'en-US' COMMENT '介面語言',
    timezone VARCHAR(50) DEFAULT 'UTC' COMMENT '時區',

    -- 頭像
    avatar VARCHAR(500) COMMENT '頭像 URL',

    -- 狀態管理
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:停用 1:啟用)',
    is_super_admin TINYINT(1) DEFAULT 0 COMMENT '是否為超級管理員(0:否 1:是)',

    -- 登入記錄
    last_login_at TIMESTAMP NULL COMMENT '最後登入時間',
    last_login_ip VARCHAR(45) COMMENT '最後登入 IP',

    -- 系統紀錄
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_country (country_iso),
    KEY idx_email (email),
    KEY idx_is_active (is_active),
    KEY idx_department (department)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理員表(各國運營團隊)';

-- =====================================================
-- 第十二部分：權限管理系統 (Laravel Permission)
-- =====================================================

-- 角色表
CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '角色 ID',
    name VARCHAR(255) NOT NULL COMMENT '角色名稱(唯一識別碼)',
    guard_name VARCHAR(255) NOT NULL COMMENT '守衛名稱',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    UNIQUE KEY uk_role_name_guard (name, guard_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 權限表
CREATE TABLE permissions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '權限 ID',
    name VARCHAR(255) NOT NULL COMMENT '權限名稱(唯一識別碼)',
    guard_name VARCHAR(255) NOT NULL COMMENT '守衛名稱',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    UNIQUE KEY uk_permission_name_guard (name, guard_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='權限表';

-- 模型擁有權限表 (多態關聯)
CREATE TABLE model_has_permissions (
    permission_id BIGINT UNSIGNED NOT NULL COMMENT '權限 ID',
    model_type VARCHAR(255) NOT NULL COMMENT '模型類型(App\\Models\\Admin等)',
    model_id BIGINT UNSIGNED NOT NULL COMMENT '模型 ID',

    PRIMARY KEY (permission_id, model_id, model_type),
    KEY idx_model (model_id, model_type),

    CONSTRAINT fk_mhp_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='模型擁有權限表';

-- 模型擁有角色表 (多態關聯)
CREATE TABLE model_has_roles (
    role_id BIGINT UNSIGNED NOT NULL COMMENT '角色 ID',
    model_type VARCHAR(255) NOT NULL COMMENT '模型類型(App\\Models\\Admin等)',
    model_id BIGINT UNSIGNED NOT NULL COMMENT '模型 ID',

    PRIMARY KEY (role_id, model_id, model_type),
    KEY idx_model (model_id, model_type),

    CONSTRAINT fk_mhr_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='模型擁有角色表';

-- 角色擁有權限表
CREATE TABLE role_has_permissions (
    permission_id BIGINT UNSIGNED NOT NULL COMMENT '權限 ID',
    role_id BIGINT UNSIGNED NOT NULL COMMENT '角色 ID',

    PRIMARY KEY (permission_id, role_id),

    CONSTRAINT fk_rhp_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE,
    CONSTRAINT fk_rhp_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色擁有權限表';
