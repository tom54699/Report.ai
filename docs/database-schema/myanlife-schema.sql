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
    CONSTRAINT fk_member FOREIGN KEY (member_id) REFERENCES members(id)
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

    CONSTRAINT fk_merchant_task FOREIGN KEY (task_id) REFERENCES merchant_tasks(id)
    -- CONSTRAINT fk_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id) -- 待 merchants 表建立後啟用
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家任務記錄表';

-- 會員表
CREATE TABLE members (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
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

    KEY idx_phone (phone_country_iso, phone_number) COMMENT '電話複合索引',
    KEY idx_is_active (is_active) COMMENT '啟用狀態索引',
    KEY idx_registered_at (registered_at) COMMENT '註冊時間索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='會員表';
