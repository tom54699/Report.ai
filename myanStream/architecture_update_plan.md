# myanStream 技術架構頁面更新計劃書

## 📋 現狀分析

### 現有 Tabs 結構
1. ✅ 系統總覽
2. ✅ 自架 Docker
3. ✅ AWS ECS
4. ✅ 完整流程
5. ✅ 資料庫設計
6. ✅ 方案比較

### 現有技術棧（需要更新）
```
- SRS (RTMP Server)
- FFmpeg
- Laravel Octane  ← 需要改為分層架構
- Docker
- AWS ECS (選配)
- WebSocket
- MySQL
- Redis
```

### 問題點
1. **技術棧過於簡化：** 只列出 Laravel Octane，沒有體現「核心交易系統」和「即時/整合層」的分離
2. **缺少後端架構分層說明：** 沒有說明為什麼要分層、各層負責什麼
3. **系統層（非功能需求）放錯位置：** 目前在 features.html，應該放在技術架構

---

## 🎯 更新目標

### 1. 反映分層架構設計
- 明確區分「核心交易系統（Laravel）」和「即時/整合層（Go/Node.js）」
- 說明各層的職責、技術選型理由、通訊方式

### 2. 補充系統層設計
- 從 features.html 移過來的內容（即時系統、可用性、安全性、可觀測性）
- 放在技術架構更合理

### 3. 更新技術棧說明
- 從單一框架改為多層架構
- 補充 Event Bus（Redis Streams/Kafka/RabbitMQ）的選擇

---

## 📊 新的 Tabs 結構規劃

### 方案 A：擴充現有結構（推薦）

```
1. 系統總覽                    （保留，更新技術棧說明）
2. 後端架構分層 ⭐ NEW         （核心：Laravel + Go/Node.js 分層設計）
3. 自架 Docker                 （保留，更新 docker-compose 配置）
4. AWS ECS                     （保留，更新服務拆分）
5. 完整流程                    （保留，更新事件流）
6. 資料庫設計                  （保留）
7. 系統層設計 ⭐ NEW          （即時性、可用性、安全性、可觀測性）
8. 方案比較                    （保留，更新成本估算）
```

**優點：**
- 結構清晰，循序漸進
- 先講分層設計理念，再講部署方案
- 系統層獨立成一個 tab，便於查閱

**缺點：**
- tabs 數量增加到 8 個（可接受）

---

### 方案 B：合併整合（備選）

```
1. 系統總覽                    （保留，更新技術棧）
2. 後端架構設計 ⭐ 合併        （包含：分層設計 + 系統層）
3. 部署方案 - Docker           （保留）
4. 部署方案 - AWS ECS          （保留）
5. 完整流程                    （保留）
6. 資料庫設計                  （保留）
7. 方案比較                    （保留）
```

**優點：**
- tabs 數量控制在 7 個
- 後端架構設計集中在一個 tab

**缺點：**
- 單一 tab 內容過多，不易閱讀
- 分層設計和系統層雖然都是技術，但關注點不同，合併不太合適

---

## ✅ 建議採用：方案 A

原因：
1. 「後端架構分層」和「系統層設計」關注點不同，分開更清晰
2. 8 個 tabs 數量合理，不會造成閱讀困擾
3. 便於後續擴充（如：前端架構、測試策略等）

---

## 📝 各 Tab 詳細內容規劃

### Tab 1: 系統總覽（更新）

**現有內容：**
- 核心概念（一推多發、職責分離）
- 核心組件角色（SRS、Laravel、FFmpeg）
- 架構優勢

**需要更新：**

1. **更新技術棧說明**
   ```diff
   - Laravel Octane (單一後端)
   + 核心交易系統：Laravel + Queue/Job
   + 即時整合層：Go/Node.js + WebSocket
   + Event Bus：Redis Streams / RabbitMQ
   ```

2. **更新架構總覽圖**
   ```
   [使用者 App]
        ↓
   [即時層 (Go/Node.js)]  ← WebSocket、留言匯流
        ↓
   [Event Bus (Redis Streams)]
        ↓
   [核心層 (Laravel)]  ← 商品、訂單、金流、報表
        ↓
   [DB (MySQL) + Cache (Redis)]
   ```

3. **補充分層架構說明**
   - 為什麼要分層？
   - 各層的職責
   - 通訊方式

---

### Tab 2: 後端架構分層 ⭐ NEW

**核心目標：** 說明「核心交易系統」和「即時/整合層」分離的設計

#### 2.1 為什麼要分層？

```
直播電商系統的特性：
✅ 核心交易邏輯複雜（商品、訂單、金流、物流、會員、權限）
✅ 即時性要求高（留言收單、WebSocket 推送、多平台訊息匯流）
✅ IO 密集（多平台 API 輪詢、長連線）

單一框架全包的問題：
❌ Laravel 處理長連線/WebSocket 不是強項
❌ Go/Node.js 處理複雜商務邏輯、ORM、權限不如成熟 Web 框架
❌ 混在一起難以水平擴展（交易層和即時層的擴展需求不同）

分層架構的優勢：
✅ 各層使用最適合的技術棧
✅ 獨立擴展（即時層需要更多實例，交易層可能不需要）
✅ 職責清晰、易維護
```

#### 2.2 核心交易系統（Laravel）

**負責模組：**
- 商品/SKU/庫存管理
- 訂單系統（OMS）
- 會員/權限（RBAC）
- 報表與數據分析
- 金流回調處理
- 物流出貨流程
- 管理後台 API

**技術選型：**
- Framework: Laravel 11+
- Queue: Redis + Horizon
- DB: MySQL 8.0 / PostgreSQL
- Cache/Lock: Redis
- Search: Elasticsearch (可選)

**為什麼選 Laravel？**
```
✅ 商務邏輯多、資料表多、CRUD 多
✅ ORM (Eloquent) 開發速度快
✅ 權限套件成熟（Spatie Permission）
✅ Queue/Job 系統完善
✅ 生態系統豐富（金流、物流套件）
```

**架構圖：**
```
┌─────────────────────────────────────┐
│      Laravel Core (Octane)          │
├─────────────────────────────────────┤
│ - Product / SKU / Inventory         │
│ - Order Management (OMS)            │
│ - User / RBAC                       │
│ - Payment Callback                  │
│ - Shipping / Logistics              │
│ - Reports / Analytics               │
│ - Admin API                         │
└─────────────────────────────────────┘
         ↓                ↑
    [MySQL/PG]      [Redis Cache]
```

#### 2.3 即時層/整合層（Go/Node.js）

**負責模組：**
- 多平台留言匯流（FB/IG/YouTube/LINE/TikTok 輪詢）
- WebSocket 推送（直播間即時訂單、競標、抽獎）
- 多平台訊息中心（私訊匯流、分派、同步）
- SSE (Server-Sent Events) 推送（可選）

**技術選型方案：**

**方案 1: Go (Gin/Fiber) - 推薦**
```
✅ 併發處理強（goroutine）
✅ 記憶體占用低
✅ 適合 IO 密集、長連線場景
✅ 部署簡單（單一 binary）
```

**方案 2: Node.js (NestJS)**
```
✅ 事件驅動、非阻塞 IO
✅ WebSocket 生態成熟
✅ 開發速度快（TypeScript）
✅ 團隊若熟悉 JS 可選
```

**架構圖：**
```
┌──────────────────────────────────────────┐
│   Realtime Gateway (Go/Node.js)          │
├──────────────────────────────────────────┤
│                                          │
│  ┌─────────────┐   ┌─────────────┐     │
│  │  Connector  │   │ WS Gateway  │     │
│  │   Service   │   │             │     │
│  └─────────────┘   └─────────────┘     │
│        ↓                  ↑              │
│   [平台 API]          [Client WS]       │
│  FB/IG/YouTube         App/Web          │
└──────────────────────────────────────────┘
```

#### 2.4 典型架構流程

**完整數據流：**
```
1. 留言收單流程：
   [FB/IG API]
      ↓ (輪詢 2-5秒)
   [Connector Service (Go/Node.js)]
      ↓ (解析留言)
   [Event Bus (Redis Streams)]
      ↓ (發布事件: order.created)
   [Laravel Queue Worker]
      ↓ (處理暫存單、扣庫存)
   [MySQL]
      ↓ (通知事件: order.confirmed)
   [WS Gateway (Go/Node.js)]
      ↓ (推送)
   [App WebSocket]

2. 訂單更新推送：
   [Laravel Core]
      ↓ (訂單狀態變更)
   [Event Bus]
      ↓ (發布事件: order.status_changed)
   [WS Gateway]
      ↓ (推送給相關連線)
   [App/Web Client]
```

**Event Bus 選擇：**
```
┌─────────────────┬──────────────┬─────────────┬──────────────┐
│                 │ Redis Streams│  RabbitMQ   │    Kafka     │
├─────────────────┼──────────────┼─────────────┼──────────────┤
│ 適合規模        │ 中小型       │ 中大型      │ 大型         │
│ 複雜度          │ 簡單         │ 中等        │ 複雜         │
│ 持久化          │ 有           │ 有          │ 有           │
│ 順序保證        │ ✅           │ ✅          │ ✅           │
│ 推薦場景        │ MVP/初期     │ 成長期      │ 企業級       │
└─────────────────┴──────────────┴─────────────┴──────────────┘

建議：
- 初期：Redis Streams（已有 Redis，學習成本低）
- 成長：RabbitMQ（功能完整、易運維）
- 大規模：Kafka（高吞吐、分散式）
```

#### 2.5 服務通訊方式

**Laravel ←→ Go/Node.js 通訊：**
```
1. Event Bus (推薦)
   Laravel → Redis Streams → Go/Node.js
   - 解耦、非同步
   - 可重試、可追蹤

2. HTTP API (同步)
   Go/Node.js → Laravel API
   - 查詢資料（商品、庫存）
   - 簡單直接

3. gRPC (進階)
   - 效能更好
   - 需要額外學習成本
```

#### 2.6 部署架構

**Docker Compose 環境：**
```yaml
services:
  # 核心交易層
  laravel-core:
    image: laravel-app
    ports: ["8000:8000"]

  laravel-worker:
    image: laravel-app
    command: php artisan queue:work

  # 即時層
  realtime-gateway:
    image: go-realtime  # or node-realtime
    ports: ["3000:3000"]

  # Event Bus
  redis:
    image: redis:7-alpine

  # 資料庫
  mysql:
    image: mysql:8.0
```

**AWS ECS 環境：**
```
- Laravel Core Service (2-10 Tasks)
- Laravel Queue Worker (1-5 Tasks)
- Realtime Gateway (2-10 Tasks) ← 可獨立擴展
- Redis (ElastiCache)
- MySQL (RDS)
```

---

### Tab 3: 自架 Docker（更新）

**需要更新：**
1. docker-compose.yml 改為分層架構
2. 加入 realtime-gateway 服務
3. 加入 Redis Streams 作為 Event Bus
4. 更新網路配置

**新的 docker-compose.yml 結構：**
```yaml
version: '3.8'

services:
  # === 媒體層 ===
  srs:
    image: ossrs/srs:5
    ports:
      - "1935:1935"
      - "1985:1985"
    networks:
      - myanstream

  # === 核心交易層 ===
  laravel-core:
    build: ./laravel
    ports:
      - "8000:8000"
    environment:
      - APP_ENV=production
      - REDIS_HOST=redis
      - DB_HOST=mysql
    networks:
      - myanstream

  laravel-worker:
    build: ./laravel
    command: php artisan queue:work
    environment:
      - REDIS_HOST=redis
      - DB_HOST=mysql
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - myanstream

  # === 即時/整合層 ===
  realtime-gateway:
    build: ./realtime-gateway  # Go or Node.js
    ports:
      - "3000:3000"
    environment:
      - REDIS_HOST=redis
      - LARAVEL_API=http://laravel-core:8000
    networks:
      - myanstream

  # === Event Bus ===
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    networks:
      - myanstream

  # === 資料庫 ===
  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_DATABASE=myanstream
      - MYSQL_ROOT_PASSWORD=secret
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - myanstream

networks:
  myanstream:

volumes:
  mysql_data:
```

---

### Tab 4: AWS ECS（更新）

**需要更新：**
1. 服務拆分（加入 Realtime Gateway Service）
2. 更新 Security Groups
3. 更新 Auto Scaling 策略

**新的 ECS 服務結構：**
```
┌─────────────────────────────────────────┐
│           AWS ECS Cluster               │
├─────────────────────────────────────────┤
│                                         │
│  SRS Service (1-3 Tasks)                │
│  Laravel Core Service (2-10 Tasks)      │
│  Laravel Worker Service (1-5 Tasks)     │
│  Realtime Gateway Service (2-10 Tasks) ⭐ NEW
│  FFmpeg Tasks (按需啟動)                │
│                                         │
└─────────────────────────────────────────┘
         ↓              ↓
    [RDS MySQL]   [ElastiCache Redis]
```

---

### Tab 5: 完整流程（更新）

**需要更新事件流：**

**舊的流程：**
```
App → SRS → Laravel Webhook → FFmpeg
```

**新的流程（含分層架構）：**
```
Phase 1: 留言收單
  [FB/IG 留言]
       ↓
  [Realtime Gateway - Connector Service] (Go/Node.js 輪詢)
       ↓
  [Redis Streams: comment.received]
       ↓
  [Laravel Queue Worker: 解析留言 → 建立暫存單]
       ↓
  [MySQL: 儲存暫存單]
       ↓
  [Redis Streams: order.created]
       ↓
  [Realtime Gateway - WS] (推送給 App)
       ↓
  [App WebSocket: 顯示即時訂單]

Phase 2: 訂單處理
  [買家補資料]
       ↓
  [Laravel Core API: 更新訂單]
       ↓
  [Laravel Core: 呼叫金流 API]
       ↓
  [金流 Webhook 回調]
       ↓
  [Laravel Queue Worker: 更新訂單狀態]
       ↓
  [Redis Streams: order.paid]
       ↓
  [WS 推送: 通知倉庫]
```

---

### Tab 6: 資料庫設計（保留）

**保持不變**

---

### Tab 7: 系統層設計 ⭐ NEW

**內容來源：** 從 features.html 移過來

**包含內容：**

#### 7.1 即時系統
- WebSocket / Server-Sent Events
- 消息隊列（Redis Pub/Sub, RabbitMQ, AWS SQS）
- 事件驅動（Event-Driven Architecture）

#### 7.2 可用性與擴展
- 多租戶隔離（Multi-Tenancy）
- 水平擴展（Horizontal Scaling）
- 快取策略（Redis）
- 限流（Rate Limiting）
- 重試與死信隊列（DLQ）

#### 7.3 安全性
- OAuth / Token 管理
- Webhook 驗證
- 敏感資料加密
- 稽核（Audit Log）

#### 7.4 可觀測性（Observability）
- 指標（Metrics）: CPU/Memory/QPS/錯誤率
- 日誌（Logs）: 集中式日誌管理（ELK）
- 追蹤（Tracing）: 分散式追蹤

#### 7.5 告警（Alerting）
- 關鍵事件告警（漏單、推播失敗、金流回調失敗、API 錯誤率）
- 通知渠道（Slack / Email / SMS / PagerDuty）

---

### Tab 8: 方案比較（更新）

**需要更新：**
1. 成本估算（加入 Realtime Gateway 的成本）
2. 複雜度評估（分層架構 vs 單體架構）

**新增對比項目：**
```
┌──────────────┬────────────────┬─────────────────┐
│   對比項目   │ 單體架構       │  分層架構       │
├──────────────┼────────────────┼─────────────────┤
│ 技術複雜度   │ 低             │ 中              │
│ 開發成本     │ 低             │ 中              │
│ 維運成本     │ 中             │ 中              │
│ 擴展性       │ 受限           │ 優秀            │
│ 即時性能     │ 一般           │ 優秀            │
│ 適合規模     │ MVP/小型       │ 中大型          │
└──────────────┴────────────────┴─────────────────┘
```

---

## 🔧 技術棧更新總覽

### 更新前
```
- SRS (RTMP Server)
- FFmpeg
- Laravel Octane
- Docker
- AWS ECS (選配)
- WebSocket
- MySQL
- Redis
```

### 更新後
```
媒體層:
- SRS (RTMP Server)
- FFmpeg

核心交易層:
- Laravel 11+ (Octane)
- Queue: Redis + Horizon
- DB: MySQL 8.0 / PostgreSQL
- Cache: Redis

即時/整合層:
- Go (Gin/Fiber) 或 Node.js (NestJS)
- WebSocket Gateway
- Platform Connectors

Event Bus:
- Redis Streams (初期)
- RabbitMQ (成長期)
- Kafka (大規模)

部署:
- Docker Compose (開發/小型)
- AWS ECS (生產環境)
```

---

## 📅 實施步驟

### Phase 1: 更新現有 Tabs（1-2 小時）
1. 更新「系統總覽」- 技術棧說明
2. 更新「自架 Docker」- docker-compose.yml
3. 更新「AWS ECS」- 服務拆分
4. 更新「完整流程」- 事件流
5. 更新「方案比較」- 成本估算

### Phase 2: 新增分層架構 Tab（1-2 小時）
1. 為什麼要分層
2. 核心交易系統（Laravel）
3. 即時/整合層（Go/Node.js）
4. 典型架構流程
5. Event Bus 選擇
6. 服務通訊方式
7. 部署架構

### Phase 3: 新增系統層設計 Tab（30 分鐘）
1. 從 features.html 複製內容
2. 調整格式適配 architecture.html
3. 補充圖表

### Phase 4: 測試與優化（30 分鐘）
1. 檢查所有連結
2. 測試 tab 切換
3. 檢查 Mermaid 圖表渲染
4. 調整排版

---

## 💡 建議與注意事項

### 建議
1. **保持漸進式：** 先完成 Phase 1 和 2，再做 Phase 3
2. **圖表為主：** 分層架構部分多用圖表，少用文字
3. **實務導向：** 強調實務經驗（如：為什麼用輪詢而非 Webhooks）
4. **成本透明：** 在方案比較中明確列出分層架構的額外成本

### 注意事項
1. **避免過度設計：** 不要讓架構看起來太複雜嚇到人
2. **提供選擇：** Go vs Node.js 都列出，讓用戶選擇
3. **標註階段：** 明確哪些是 MVP 階段、哪些是成長階段
4. **保持一致：** 確保 architecture.html 和 features.html 的描述一致

---

## ✅ 預期成果

完成後的 architecture.html 將會：
1. ✅ 清楚說明為什麼要分層（不是為了炫技，而是實務需求）
2. ✅ 提供完整的技術選型依據（Laravel 負責什麼、Go/Node.js 負責什麼）
3. ✅ 包含實務的部署配置（docker-compose、ECS）
4. ✅ 補充系統層設計（從功能頁面移過來）
5. ✅ 保持文件的可讀性和實用性

---

## 🤔 需要確認的問題

1. **Event Bus 選擇：** 預設推薦 Redis Streams，還是直接推薦 RabbitMQ？
2. **Go vs Node.js：** 兩個都列出讓用戶選，還是明確推薦其中一個？
3. **部署複雜度：** 是否需要補充 K8s 部署方案？（可能太複雜）
4. **圖表數量：** Mermaid 圖表會很多，是否需要控制數量？

---

**準備好開始實施了嗎？** 🚀
