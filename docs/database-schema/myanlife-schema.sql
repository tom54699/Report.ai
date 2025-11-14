-- ============================================
-- MyAnLife 資料庫架構設計
-- 創建日期: 2025-11-14
-- ============================================

-- 橫幅類型表
CREATE TABLE banner_type (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    title VARCHAR(50) NOT NULL COMMENT '類型標題',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='橫幅類型表';

-- 橫幅表
CREATE TABLE banner (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    title VARCHAR(100) NOT NULL COMMENT '橫幅標題',
    type_id BIGINT UNSIGNED NOT NULL COMMENT '類型ID',
    url VARCHAR(500) COMMENT '連結網址',
    image VARCHAR(500) NOT NULL COMMENT '圖片路徑',
    sort_order INT DEFAULT 0 COMMENT '排序順序',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',
    is_top TINYINT(1) DEFAULT 0 COMMENT '是否置頂(0:否 1:是)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_type_id (type_id) COMMENT '類型索引',
    KEY idx_sort_order (sort_order) COMMENT '排序索引',
    KEY idx_is_active (is_active) COMMENT '啟用狀態索引',

    CONSTRAINT fk_banner_type FOREIGN KEY (type_id) REFERENCES banner_type(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='橫幅表';

-- 新聞類型表
CREATE TABLE news_type (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    title VARCHAR(50) NOT NULL COMMENT '類型標題',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='新聞類型表';

-- 新聞表
CREATE TABLE news (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    type_id BIGINT UNSIGNED NOT NULL COMMENT '類型ID',
    title VARCHAR(200) NOT NULL COMMENT '新聞標題',
    description VARCHAR(100) COMMENT '新聞摘要',
    content TEXT NOT NULL COMMENT '新聞內容',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否啟用(0:否 1:是)',
    is_top TINYINT(1) DEFAULT 0 COMMENT '是否置頂(0:否 1:是)',
    publish_time TIMESTAMP NULL COMMENT '發布時間',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    KEY idx_type_id (type_id) COMMENT '類型索引',
    KEY idx_is_active (is_active) COMMENT '啟用狀態索引',
    KEY idx_publish_time (publish_time) COMMENT '發布時間索引',

    CONSTRAINT fk_news_type FOREIGN KEY (type_id) REFERENCES news_type(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='新聞表';
