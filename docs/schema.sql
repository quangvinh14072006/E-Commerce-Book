-- =====================================================================
-- CSDL website bán sách (MySQL 8.0+, InnoDB, utf8mb4)
-- Thứ tự tạo bảng: bảng được tham chiếu (cha) tạo TRƯỚC, bảng có FK (con) tạo SAU.
-- Quy ước: id BIGINT UNSIGNED (khớp $table->id() của Laravel), có created_at/updated_at.
-- =====================================================================

DROP DATABASE IF EXISTS bookstore;
CREATE DATABASE bookstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bookstore;

-- =====================================================================
-- 1. NHÓM NGƯỜI DÙNG
-- =====================================================================

CREATE TABLE roles (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL,              -- 'admin', 'customer'
    description VARCHAR(255) NULL,
    created_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_roles_name UNIQUE (name)
) ENGINE=InnoDB;

CREATE TABLE users (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id     BIGINT UNSIGNED NOT NULL,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL,
    password    VARCHAR(255) NOT NULL,              -- lưu hash (bcrypt/argon2), KHÔNG lưu plain text
    phone       VARCHAR(20)  NULL,
    avatar_url  VARCHAR(500) NULL,
    status      ENUM('active','locked') NOT NULL DEFAULT 'active',
    email_verified_at TIMESTAMP NULL,
    remember_token    VARCHAR(100) NULL,            -- Laravel dùng cột này
    created_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  TIMESTAMP NULL,                     -- soft delete
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

CREATE TABLE addresses (
    id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id        BIGINT UNSIGNED NOT NULL,
    recipient_name VARCHAR(100) NOT NULL,
    phone          VARCHAR(20)  NOT NULL,
    province       VARCHAR(100) NOT NULL,
    district       VARCHAR(100) NOT NULL,
    ward           VARCHAR(100) NOT NULL,
    street_address VARCHAR(255) NOT NULL,           -- số nhà, tên đường
    is_default     TINYINT(1)   NOT NULL DEFAULT 0,
    created_at     TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_addresses_user (user_id),
    CONSTRAINT fk_addresses_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 2. NHÓM SẢN PHẨM
-- =====================================================================

CREATE TABLE publishers (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    website    VARCHAR(255) NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_publishers_name UNIQUE (name)
) ENGINE=InnoDB;

CREATE TABLE authors (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    biography  TEXT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_authors_name (name)                   -- không UNIQUE vì có thể trùng tên tác giả
) ENGINE=InnoDB;

CREATE TABLE categories (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parent_id   BIGINT UNSIGNED NULL,               -- danh mục cha (NULL = danh mục gốc)
    name        VARCHAR(100) NOT NULL,
    slug        VARCHAR(120) NOT NULL,              -- dùng cho URL: /category/van-hoc
    description VARCHAR(500) NULL,
    created_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_categories_slug UNIQUE (slug),
    CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE books (
    id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    publisher_id     BIGINT UNSIGNED NULL,
    title            VARCHAR(255) NOT NULL,
    slug             VARCHAR(280) NOT NULL,
    isbn             VARCHAR(20)  NULL,
    description      TEXT NULL,
    price            DECIMAL(12,2) NOT NULL,        -- giá niêm yết
    sale_price       DECIMAL(12,2) NULL,            -- giá khuyến mãi (NULL = không giảm)
    stock_quantity   INT UNSIGNED NOT NULL DEFAULT 0,
    page_count       SMALLINT UNSIGNED NULL,
    language         VARCHAR(30)  NULL DEFAULT 'Tiếng Việt',
    publication_year SMALLINT UNSIGNED NULL,
    cover_type       ENUM('paperback','hardcover') NULL,
    status           ENUM('draft','active','hidden') NOT NULL DEFAULT 'active',
    sold_count       INT UNSIGNED NOT NULL DEFAULT 0,       -- denormalize để sort "bán chạy"
    rating_avg       DECIMAL(3,2) NOT NULL DEFAULT 0.00,    -- denormalize từ reviews
    rating_count     INT UNSIGNED NOT NULL DEFAULT 0,
    created_at       TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at       TIMESTAMP NULL,                -- soft delete: giữ lại để order_items cũ vẫn tham chiếu được
    CONSTRAINT uq_books_slug UNIQUE (slug),
    CONSTRAINT uq_books_isbn UNIQUE (isbn),         -- MySQL cho phép nhiều NULL trong UNIQUE
    INDEX idx_books_publisher (publisher_id),
    INDEX idx_books_status_price (status, price),
    FULLTEXT INDEX ft_books_title (title),
    CONSTRAINT fk_books_publisher FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON DELETE SET NULL,
    CONSTRAINT chk_books_price CHECK (price >= 0),
    CONSTRAINT chk_books_sale_price CHECK (sale_price IS NULL OR (sale_price >= 0 AND sale_price <= price))
) ENGINE=InnoDB;

-- Bảng trung gian N-N: 1 sách có nhiều tác giả, 1 tác giả viết nhiều sách
CREATE TABLE book_author (
    book_id    BIGINT UNSIGNED NOT NULL,
    author_id  BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id, author_id),               -- khóa chính kép: chống trùng cặp
    INDEX idx_book_author_author (author_id),       -- tra ngược: tác giả -> sách
    CONSTRAINT fk_ba_book   FOREIGN KEY (book_id)   REFERENCES books(id)   ON DELETE CASCADE,
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Bảng trung gian N-N: 1 sách thuộc nhiều danh mục
CREATE TABLE book_categories (
    book_id     BIGINT UNSIGNED NOT NULL,
    category_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id, category_id),
    INDEX idx_bc_category (category_id),
    CONSTRAINT fk_bc_book     FOREIGN KEY (book_id)     REFERENCES books(id)      ON DELETE CASCADE,
    CONSTRAINT fk_bc_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE book_images (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    book_id    BIGINT UNSIGNED NOT NULL,
    image_url  VARCHAR(500) NOT NULL,
    is_primary TINYINT(1)   NOT NULL DEFAULT 0,     -- ảnh bìa chính
    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_book_images_book (book_id),
    CONSTRAINT fk_book_images_book FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 3. NHÓM GIỎ HÀNG
-- =====================================================================

CREATE TABLE carts (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id       BIGINT UNSIGNED NULL,             -- NULL = khách chưa đăng nhập (giỏ theo session)
    session_token VARCHAR(100) NULL,
    created_at    TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_carts_user UNIQUE (user_id),      -- mỗi user 1 giỏ
    CONSTRAINT uq_carts_session UNIQUE (session_token),
    CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cart_items (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cart_id    BIGINT UNSIGNED NOT NULL,
    book_id    BIGINT UNSIGNED NOT NULL,
    quantity   INT UNSIGNED NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_cart_items UNIQUE (cart_id, book_id),   -- 1 sách chỉ 1 dòng, thêm nữa thì tăng quantity
    CONSTRAINT fk_ci_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_ci_book FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    CONSTRAINT chk_ci_qty CHECK (quantity > 0)
    -- Không lưu giá ở đây: giỏ hàng luôn hiển thị GIÁ HIỆN TẠI của books
) ENGINE=InnoDB;

-- =====================================================================
-- 4. NHÓM GIẢM GIÁ (tạo trước orders vì orders tham chiếu coupons)
-- =====================================================================

CREATE TABLE coupons (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code                VARCHAR(50) NOT NULL,
    description         VARCHAR(255) NULL,
    discount_type       ENUM('percent','fixed') NOT NULL,
    discount_value      DECIMAL(12,2) NOT NULL,     -- percent: 10 = 10%; fixed: số tiền VND
    max_discount_amount DECIMAL(12,2) NULL,         -- trần giảm khi dùng percent
    min_order_amount    DECIMAL(12,2) NOT NULL DEFAULT 0,
    usage_limit         INT UNSIGNED NULL,          -- NULL = không giới hạn lượt dùng
    starts_at           DATETIME NULL,
    expires_at          DATETIME NULL,
    is_active           TINYINT(1) NOT NULL DEFAULT 1,
    created_at          TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_coupons_code UNIQUE (code),
    CONSTRAINT chk_coupons_value CHECK (discount_value > 0),
    CONSTRAINT chk_coupons_percent CHECK (discount_type <> 'percent' OR discount_value <= 100)
) ENGINE=InnoDB;

-- =====================================================================
-- 5. NHÓM ĐƠN HÀNG
-- =====================================================================

CREATE TABLE orders (
    id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_code       VARCHAR(30) NOT NULL,          -- mã hiển thị cho khách: BK20261114-0001
    user_id          BIGINT UNSIGNED NULL,          -- SET NULL nếu xóa user: vẫn giữ đơn để đối soát
    coupon_id        BIGINT UNSIGNED NULL,
    -- SNAPSHOT địa chỉ nhận hàng: copy từ addresses tại thời điểm đặt,
    -- để sau này user sửa/xóa địa chỉ thì đơn cũ không bị đổi theo.
    recipient_name   VARCHAR(100) NOT NULL,
    recipient_phone  VARCHAR(20)  NOT NULL,
    shipping_address VARCHAR(500) NOT NULL,         -- địa chỉ đầy đủ đã ghép sẵn
    subtotal         DECIMAL(12,2) NOT NULL,        -- tổng tiền hàng
    discount_amount  DECIMAL(12,2) NOT NULL DEFAULT 0,
    shipping_fee     DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount     DECIMAL(12,2) NOT NULL,        -- = subtotal - discount_amount + shipping_fee
    status           ENUM('pending','confirmed','shipping','delivered','cancelled','returned')
                     NOT NULL DEFAULT 'pending',
    note             VARCHAR(500) NULL,
    cancelled_reason VARCHAR(255) NULL,
    created_at       TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_orders_code UNIQUE (order_code),
    INDEX idx_orders_user_created (user_id, created_at),
    INDEX idx_orders_status (status),
    CONSTRAINT fk_orders_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE SET NULL,
    CONSTRAINT fk_orders_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE SET NULL,
    CONSTRAINT chk_orders_amounts CHECK (subtotal >= 0 AND discount_amount >= 0 AND shipping_fee >= 0 AND total_amount >= 0)
) ENGINE=InnoDB;

CREATE TABLE order_items (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id   BIGINT UNSIGNED NOT NULL,
    book_id    BIGINT UNSIGNED NULL,
    -- SNAPSHOT: giá và tên sách tại thời điểm mua. Giá sách đổi sau này KHÔNG ảnh hưởng đơn cũ.
    book_title VARCHAR(255) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    quantity   INT UNSIGNED NOT NULL,
    line_total DECIMAL(12,2) NOT NULL,              -- = unit_price * quantity
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_oi_order (order_id),
    INDEX idx_oi_book (book_id),
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_oi_book  FOREIGN KEY (book_id)  REFERENCES books(id)  ON DELETE SET NULL,
    CONSTRAINT chk_oi_qty CHECK (quantity > 0)
) ENGINE=InnoDB;

CREATE TABLE order_status_histories (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id   BIGINT UNSIGNED NOT NULL,
    from_status VARCHAR(20) NULL,                   -- NULL khi tạo đơn lần đầu
    to_status   VARCHAR(20) NOT NULL,
    changed_by  BIGINT UNSIGNED NULL,               -- admin/khách đã đổi trạng thái
    note        VARCHAR(255) NULL,
    created_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_osh_order (order_id, created_at),
    CONSTRAINT fk_osh_order FOREIGN KEY (order_id)   REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_osh_user  FOREIGN KEY (changed_by) REFERENCES users(id)  ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE coupon_usages (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    coupon_id       BIGINT UNSIGNED NOT NULL,
    user_id         BIGINT UNSIGNED NULL,
    order_id        BIGINT UNSIGNED NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL,         -- số tiền thực tế đã giảm cho đơn này
    used_at         TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_cu_order UNIQUE (order_id),       -- 1 đơn chỉ áp 1 mã
    INDEX idx_cu_coupon_user (coupon_id, user_id),
    CONSTRAINT fk_cu_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
    CONSTRAINT fk_cu_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE SET NULL,
    CONSTRAINT fk_cu_order  FOREIGN KEY (order_id)  REFERENCES orders(id)  ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 6. NHÓM THANH TOÁN & VẬN CHUYỂN
-- =====================================================================

CREATE TABLE payments (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id        BIGINT UNSIGNED NOT NULL,
    method          ENUM('cod','bank_transfer','momo','vnpay') NOT NULL DEFAULT 'cod',
    amount          DECIMAL(12,2) NOT NULL,
    status          ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
    transaction_ref VARCHAR(100) NULL,              -- mã giao dịch của cổng thanh toán (COD thì NULL)
    paid_at         DATETIME NULL,                  -- COD: thời điểm shipper thu tiền
    created_at      TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_payments_order (order_id),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE shipments (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id      BIGINT UNSIGNED NOT NULL,
    carrier       VARCHAR(100) NULL,                -- GHN, GHTK, Viettel Post...
    tracking_code VARCHAR(100) NULL,
    status        ENUM('preparing','shipping','delivered','failed','returned') NOT NULL DEFAULT 'preparing',
    shipped_at    DATETIME NULL,
    delivered_at  DATETIME NULL,
    created_at    TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_shipments_order (order_id),
    INDEX idx_shipments_tracking (tracking_code),
    CONSTRAINT fk_shipments_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 7. NHÓM TƯƠNG TÁC
-- =====================================================================

CREATE TABLE reviews (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id       BIGINT UNSIGNED NOT NULL,
    book_id       BIGINT UNSIGNED NOT NULL,
    order_item_id BIGINT UNSIGNED NULL,             -- liên kết dòng đơn hàng để xác nhận "đã mua"
    rating        TINYINT UNSIGNED NOT NULL,
    comment       TEXT NULL,
    status        ENUM('pending','approved','hidden') NOT NULL DEFAULT 'approved',
    created_at    TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_reviews_user_book UNIQUE (user_id, book_id),   -- mỗi user đánh giá 1 sách 1 lần
    INDEX idx_reviews_book_status (book_id, status),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_reviews_book FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    CONSTRAINT fk_reviews_oi   FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE SET NULL,
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE wishlists (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id    BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_wishlists_user UNIQUE (user_id),
    CONSTRAINT fk_wishlists_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE wishlist_items (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    wishlist_id BIGINT UNSIGNED NOT NULL,
    book_id     BIGINT UNSIGNED NOT NULL,
    created_at  TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_wishlist_items UNIQUE (wishlist_id, book_id),
    CONSTRAINT fk_wi_wishlist FOREIGN KEY (wishlist_id) REFERENCES wishlists(id) ON DELETE CASCADE,
    CONSTRAINT fk_wi_book     FOREIGN KEY (book_id)     REFERENCES books(id)     ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 8. NHÓM QUẢN LÝ KHO
-- =====================================================================
-- Sổ cái kho: mỗi lần tồn kho đổi là 1 dòng, KHÔNG sửa/xóa dòng cũ (chỉ thêm).
-- books.stock_quantity là số tồn hiện tại; bảng này là lịch sử giải thích vì sao nó đổi.
CREATE TABLE inventory_movements (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    book_id         BIGINT UNSIGNED NOT NULL,
    movement_type   ENUM('import','sale','cancel_restock','return_restock','adjustment') NOT NULL,
    quantity_change INT NOT NULL,                   -- có dấu: +50 nhập kho, -2 bán
    quantity_after  INT UNSIGNED NOT NULL,          -- tồn sau khi đổi, để đối soát
    order_id        BIGINT UNSIGNED NULL,           -- nếu phát sinh từ đơn hàng
    note            VARCHAR(255) NULL,
    created_by      BIGINT UNSIGNED NULL,
    created_at      TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_im_book_created (book_id, created_at),
    INDEX idx_im_order (order_id),
    CONSTRAINT fk_im_book  FOREIGN KEY (book_id)    REFERENCES books(id)  ON DELETE CASCADE,
    CONSTRAINT fk_im_order FOREIGN KEY (order_id)   REFERENCES orders(id) ON DELETE SET NULL,
    CONSTRAINT fk_im_user  FOREIGN KEY (created_by) REFERENCES users(id)  ON DELETE SET NULL,
    CONSTRAINT chk_im_nonzero CHECK (quantity_change <> 0)
) ENGINE=InnoDB;

-- =====================================================================
-- DỮ LIỆU MẪU TỐI THIỂU
-- =====================================================================
INSERT INTO roles (name, description) VALUES
 ('admin', 'Quản trị viên'),
 ('customer', 'Khách hàng');

INSERT INTO categories (name, slug) VALUES
 ('Văn học', 'van-hoc'),
 ('Kinh tế', 'kinh-te'),
 ('Công nghệ thông tin', 'cong-nghe-thong-tin');
