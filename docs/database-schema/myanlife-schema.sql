-- ============================================
-- MyAnLife 資料庫架構設計
-- 創建日期: 2025-11-14
-- ============================================

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
