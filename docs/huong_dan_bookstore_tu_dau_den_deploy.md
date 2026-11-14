# BookStore từ con số 0 đến deploy

> **Stack:** React (Vite) · Tailwind CSS v4 · Laravel (REST API + Sanctum) · MySQL  
> **Dành cho:** người lần đầu làm một website hoàn chỉnh, đi từ máy trống đến website chạy bằng HTTPS trên Internet.  
> **Cách dùng:** làm tuần tự từng **Chặng**. Mỗi chặng kết thúc bằng một ✅ **Checkpoint**; chưa thấy đúng kết quả thì chưa sang chặng sau.

File roadmap của bạn là **bản đồ** (cần làm những gì, vì sao). File này là **đường đi** (gõ lệnh nào, viết code nào, thấy gì thì biết là đúng). Hai file dùng song song: gặp khái niệm lạ thì quay lại roadmap.

---

## 0. Đọc trước khi bắt đầu

### 0.1. Bạn sẽ làm ra gì (MVP)

| Vai trò | Chức năng |
|---|---|
| Khách (chưa đăng nhập) | Xem, tìm, lọc, sắp xếp, phân trang sách; xem chi tiết sách |
| Customer | Đăng ký/đăng nhập/đăng xuất; giỏ hàng; đặt hàng COD; xem đơn của mình; huỷ đơn đang chờ |
| Admin | CRUD sách (có ảnh) và danh mục; xem mọi đơn; đổi trạng thái đơn |

Chưa làm trong MVP: voucher, review, wishlist, thanh toán online, email/queue, báo cáo. Danh sách "để sau" nằm ở Phụ lục C.

### 0.2. Các quyết định đã chốt sẵn

Người mới hay kẹt vì phải chọn quá nhiều thứ. Dưới đây là lựa chọn đơn giản nhất mà vẫn đúng và an toàn.

| Câu hỏi | Chọn | Lý do |
|---|---|---|
| Cấu trúc repo | 1 repo, 2 thư mục `backend/` và `frontend/` | Dễ quản lý, dễ deploy |
| Ngôn ngữ frontend | JavaScript | Bớt một lớp phải học |
| Đăng nhập | Laravel Sanctum kiểu SPA (cookie + session) | Không phải tự giữ token trong trình duyệt |
| Frontend gọi API thế nào | Luôn gọi đường dẫn tương đối `/api/v1/...` (cùng origin) | Dev: Vite proxy. Production: Nginx. Không dính CORS, cookie đơn giản |
| Kiểu tiền | Số nguyên (đồng) | VND không có phần lẻ, không lo sai số số thực |
| Giỏ hàng | Bảng `cart_items` gắn với user (phải đăng nhập mới thêm giỏ) | Ít bảng, ít nhánh xử lý |
| Thanh toán | COD | Đủ để có luồng mua hàng trọn vẹn |
| Deploy | 1 VPS Ubuntu + Nginx + PHP-FPM + MySQL, 1 tên miền, HTTPS Let's Encrypt | Ít thành phần nhất mà vẫn là "deploy thật" |
| Build frontend | Trên máy bạn rồi upload thư mục `dist` | VPS nhỏ không cần cài Node |

### 0.3. Phiên bản

- Tại thời điểm viết (11/2026), Laravel 13 yêu cầu **PHP từ 8.3 trở lên**; một số bản vá 13.x có thể đòi PHP 8.4. Hướng dẫn này dùng **PHP 8.4**.
- Node.js: bản LTS mới nhất. Composer 2.x. MySQL 8.x.
- Luôn đối chiếu với `composer.json` (mục `require.php`) và tài liệu chính thức nếu lệnh nào báo lỗi khác với mô tả: <https://laravel.com/docs/installation>, <https://vite.dev/guide/>, <https://tailwindcss.com/docs/installation/using-vite>.

> **Độ tin cậy:** các lệnh và code ở đây được viết theo tài liệu chính thức và thực tế triển khai Laravel/React, nhưng chưa được chạy lại từng dòng trên máy của bạn. Nếu một bước khác với mô tả, hãy dùng Phụ lục A (bảng lỗi thường gặp) và đối chiếu phiên bản.

### 0.4. Quy ước trong tài liệu

- `yourdomain.com` và `IP_VPS` là chỗ bạn thay bằng giá trị thật của mình.
- Lệnh bắt đầu bằng `cd ...` giả định bạn đang ở thư mục gốc `BookStore/` nếu không nói khác.
- Khi kẹt: (1) đọc **toàn bộ** thông báo lỗi, (2) xác định lỗi nằm ở tầng nào (trình duyệt → tab Network; Laravel → `backend/storage/logs/laravel.log`; Nginx → `/var/log/nginx/error.log`), (3) tìm nguyên văn lỗi kèm tên framework và phiên bản, (4) chỉ đổi **một** thứ mỗi lần thử.

### 0.5. Lộ trình và thời gian ước lượng

Ước lượng cho người mới làm một mình, bán thời gian. Làm nhóm thì chia theo chặng.

| Chặng | Nội dung | Ước lượng |
|---|---|---|
| 0 | Cài công cụ | 0,5 ngày |
| 1 | Chốt phạm vi MVP | 0,5 ngày |
| 2 | Repo và Git | 1–2 giờ |
| 3 | Khởi tạo Laravel + MySQL | 0,5 ngày |
| 4 | Khởi tạo React + Tailwind, nối được với Laravel | 0,5 ngày |
| 5 | Database: migration, model, seeder | 1 ngày |
| 6 | API đăng ký / đăng nhập | 1 ngày |
| 7 | API danh mục và sách | 1 ngày |
| 8 | React: layout, đăng nhập, danh sách và chi tiết sách | 2–3 ngày |
| 9 | Giỏ hàng (API + React) | 1–2 ngày |
| 10 | Đặt hàng và đơn hàng (API + React) | 2–3 ngày |
| 11 | Trang Admin (API + React) | 2–3 ngày |
| 12 | Kiểm thử và rà soát bảo mật | 1–2 ngày |
| 13–16 | Chuẩn bị VPS, deploy, HTTPS, smoke test, backup | 2–3 ngày |

---

## Chặng 0. Cài công cụ

**Cần có:**

| Công cụ | Gợi ý |
|---|---|
| Trình soạn code | Visual Studio Code |
| Git | <https://git-scm.com> |
| Node.js | Bản LTS từ <https://nodejs.org> |
| PHP + Composer + MySQL | Windows: **Laragon** (bản Full, chọn PHP ≥ 8.3; nếu bản kèm theo cũ hơn, thêm PHP mới trong Laragon). macOS: Laravel Herd hoặc Homebrew. Ubuntu: `apt` |
| Xem database | HeidiSQL (đi kèm Laragon), DBeaver hoặc TablePlus |
| Gọi thử API | Postman hoặc Thunder Client (extension VS Code) |

Trên Windows hãy mở **terminal của Laragon** (hoặc đảm bảo PHP/Composer/MySQL đã nằm trong PATH).

✅ **Checkpoint:** chạy các lệnh sau, tất cả đều in ra phiên bản:

```bash
node -v
npm -v
php -v          # phải từ 8.3 trở lên
composer -V     # 2.x
mysql --version
git --version
```

---

## Chặng 1. Chốt phạm vi MVP (không code)

Không cần vẽ cả bộ UML trước khi code. Chỉ cần chốt các quy tắc dưới đây và ghi vào `README.md` của repo. (Nếu môn học yêu cầu Use Case/ERD/Sequence thì vẽ song song bằng draw.io; roadmap của bạn đã mô tả cách vẽ.)

### 1.1. Quy tắc nghiệp vụ

| Chủ đề | Quy tắc |
|---|---|
| Xem sách | Ai cũng xem được; chỉ hiện sách `is_active = true` |
| Giỏ hàng, đặt hàng | Phải đăng nhập |
| Giá | **Luôn lấy từ database**, không bao giờ tin giá hay tổng tiền do React gửi lên |
| Phí giao hàng | Cố định 30.000đ (hằng số trong code) |
| Tồn kho | Trừ khi tạo đơn; hoàn lại khi đơn bị huỷ |
| Trạng thái đơn | `pending → confirmed → shipping → completed`; `pending` hoặc `confirmed` có thể sang `cancelled` |
| Customer huỷ đơn | Chỉ khi đơn đang `pending` |
| Xoá sách | Thực chất là **ẩn** (`is_active = false`) để không mất lịch sử |
| Quyền Admin | Cột `role` trong bảng `users` (`customer` hoặc `admin`) |

### 1.2. Bảng dữ liệu của MVP

| Bảng | Mục đích |
|---|---|
| `users` | Tài khoản (thêm cột `role`) |
| `categories` | Danh mục |
| `books` | Sách (mỗi sách thuộc đúng 1 danh mục; tác giả, nhà xuất bản là cột chữ) |
| `cart_items` | Giỏ hàng: (user, sách, số lượng) |
| `orders` | Đơn hàng |
| `order_items` | Dòng sản phẩm của đơn, **lưu snapshot** tên và giá tại thời điểm mua |

Laravel còn tự tạo `sessions`, `cache`, `jobs`... Cứ để nguyên.

### 1.3. Danh sách API (tiền tố `/api/v1`)

| Method | Đường dẫn | Ai gọi được | Mô tả |
|---|---|---|---|
| POST | `/register`, `/login` | Khách | Đăng ký, đăng nhập |
| POST | `/logout` | Đã đăng nhập | Đăng xuất |
| GET | `/me` | Đã đăng nhập | Người dùng hiện tại |
| GET | `/categories` | Ai cũng được | Danh mục |
| GET | `/books`, `/books/{id}` | Ai cũng được | Danh sách (tìm, lọc, sắp xếp, phân trang), chi tiết |
| GET/POST | `/cart`, `/cart/items` | Customer | Xem giỏ, thêm vào giỏ |
| PATCH/DELETE | `/cart/items/{id}` | Customer | Sửa số lượng, xoá dòng |
| GET/POST | `/orders` | Customer | Đơn của tôi, tạo đơn |
| GET | `/orders/{id}` | Customer | Chi tiết đơn **của chính mình** |
| POST | `/orders/{id}/cancel` | Customer | Huỷ đơn đang chờ |
| CRUD | `/admin/books`, `/admin/categories` | Admin | Quản lý sách, danh mục |
| GET/PATCH | `/admin/orders`, `/admin/orders/{id}/status` | Admin | Xem và đổi trạng thái đơn |

### 1.4. Định dạng phản hồi thống nhất

- Thành công: `{ "data": ... }`; danh sách có thêm `meta` (phân trang).
- Lỗi validation (HTTP 422): `{ "message": "...", "errors": { "field": ["..."] } }`.
- Mã trạng thái: 200/201 thành công, 401 chưa đăng nhập, 403 không đủ quyền, 404 không tìm thấy, 422 dữ liệu sai, 419 lỗi CSRF.

✅ **Checkpoint:** 3 bảng 1.1–1.3 đã nằm trong `README.md`.

---

## Chặng 2. Repo và Git

> Nếu nhóm đã có sẵn repo, hãy `git clone` repo đó thay vì `git init`, rồi làm tiếp từ bước tạo thư mục `backend` ở Chặng 3.

```bash
mkdir BookStore
cd BookStore
git init -b main
```

Tạo file `.gitignore` ở thư mục gốc:

```gitignore
.DS_Store
Thumbs.db
.idea/
.vscode/
*.log
```

(`backend/` và `frontend/` sẽ có `.gitignore` riêng do Laravel và Vite tự tạo, đã loại `vendor`, `node_modules`, `.env`.)

```bash
git add .
git commit -m "chore: init repository"
# Tạo repo rỗng trên GitHub, rồi:
git remote add origin <url-repo-cua-ban>
git push -u origin main
git switch -c develop
git push -u origin develop
```

**Quy trình nhánh:** `main` (bản ổn định, dùng để deploy) ← `develop` (tích hợp) ← `feature/ten-chuc-nang`. Mỗi chức năng một nhánh, xong thì mở Pull Request vào `develop`. Commit nhỏ, đặt tên rõ (`feat: add cart api`, `fix: validate stock`).

**Nếu làm nhóm:** chốt Chặng 1 (đặc biệt bảng API và dạng JSON) trước, rồi chia theo **lát cắt dọc** thay vì theo tầng: mỗi người nhận một chức năng đi từ database đến giao diện (ví dụ: Auth + Catalog / Cart + Orders / Admin). Frontend có thể dùng dữ liệu giả theo đúng dạng JSON đã chốt trong lúc backend chưa xong.

✅ **Checkpoint:** repo có trên GitHub với hai nhánh `main` và `develop`.

---

## Chặng 3. Khởi tạo Laravel và nối MySQL

### 3.1. Tạo project

```bash
cd BookStore
composer create-project laravel/laravel backend
cd backend
php artisan --version     # phải bắt đầu bằng "Laravel Framework 13" (hoặc bản bạn chọn)
```

### 3.2. Tạo database và chỉnh `.env`

Tạo database `bookstore` bằng HeidiSQL/DBeaver, hoặc bằng lệnh:

```bash
mysql -u root -p -e "CREATE DATABASE bookstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

(Laragon mặc định user `root`, mật khẩu rỗng: bỏ `-p` hoặc nhấn Enter khi được hỏi.)

M�� `backend/.env`, sửa các dòng sau (Laravel mới mặc định dùng SQLite nên các dòng `DB_*` có thể đang bị comment):

```env
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bookstore
DB_USERNAME=root
DB_PASSWORD=

SANCTUM_STATEFUL_DOMAINS=localhost:5173
```

> `SANCTUM_STATEFUL_DOMAINS` cho Sanctum biết các request đến từ `localhost:5173` (React dev server) là request "của giao diện mình", được dùng cookie/session.

```bash
php artisan migrate
```

### 3.3. Bật API và Sanctum

Laravel mới **không có sẵn** `routes/api.php`. Lệnh sau tạo file đó và cài Sanctum:

```bash
php artisan install:api
```

Nếu được hỏi có chạy migration không, chọn **yes**.

M�� `bootstrap/app.php`, trong `withMiddleware(...)` thêm dòng `statefulApi()` (giữ nguyên phần còn lại của file):

```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->statefulApi();
})
```

### 3.4. Route thử nghiệm

Thay toàn bộ `backend/routes/api.php` bằng:

```php
<?php

use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    // Route thử nghiệm. XOÁ sau Chặng 7 (route dùng closure sẽ làm `route:cache` báo lỗi).
    Route::get('/ping', fn () => ['ok' => true]);
});
```

```bash
php artisan serve
```

✅ **Checkpoint:** mở `http://127.0.0.1:8000/api/v1/ping` thấy `{"ok":true}`; mở `http://127.0.0.1:8000/up` thấy trang xanh (health check của Laravel); `php artisan migrate:status` hiện các migration đã chạy trên MySQL.

```bash
cd ..
git add .
git commit -m "chore: init laravel backend"
```

---

## Chặng 4. Khởi tạo React + Tailwind và nối với Laravel

### 4.1. Tạo project

```bash
cd BookStore
npm create vite@latest frontend -- --template react
```

Nếu được hỏi về tuỳ chọn thử nghiệm (ví dụ rolldown) hoặc "Install and start now?", chọn **No**.

```bash
cd frontend
npm install
npm install tailwindcss @tailwindcss/vite react-router-dom axios
```

### 4.2. Cấu hình Tailwind v4 và proxy

M�� `frontend/vite.config.js`, **giữ nguyên plugin React đã có**, thêm 3 chỗ đánh dấu `// THÊM`:

```js
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite"; // THÊM

export default defineConfig({
  plugins: [react(), tailwindcss()], // THÊM tailwindcss()
  server: {
    // THÊM: mọi request tới /api, /sanctum, /storage được chuyển sang Laravel
    proxy: {
      "/api": "http://127.0.0.1:8000",
      "/sanctum": "http://127.0.0.1:8000",
      "/storage": "http://127.0.0.1:8000",
    },
  },
});
```

> Dùng `127.0.0.1` thay vì `localhost` trong proxy: Node mới có thể phân giải `localhost` thành `::1` (IPv6) trong khi `php artisan serve` chỉ lắng nghe IPv4, gây lỗi `ECONNREFUSED`.

Thay toàn bộ nội dung `frontend/src/index.css` bằng đúng một dòng:

```css
@import "tailwindcss";
```

Xoá `src/App.css` (không dùng nữa). Tailwind v4 không cần `tailwind.config.js`.

### 4.3. Kiểm tra React gọi được Laravel

Thay `frontend/src/App.jsx` tạm thời bằng:

```jsx
import { useEffect, useState } from "react";
import axios from "axios";

export default function App() {
  const [result, setResult] = useState("đang gọi API...");

  useEffect(() => {
    axios
      .get("/api/v1/ping")
      .then((res) => setResult(JSON.stringify(res.data)))
      .catch((err) => setResult("Lỗi: " + err.message));
  }, []);

  return <h1 className="p-6 text-2xl font-bold text-blue-600">API: {result}</h1>;
}
```

M�� hai terminal:

```bash
# Terminal 1
cd backend && php artisan serve

# Terminal 2
cd frontend && npm run dev
```

✅ **Checkpoint:** mở `http://localhost:5173` thấy chữ xanh, đậm, và `API: {"ok":true}`. (Chữ xanh đậm chứng tỏ Tailwind chạy; `{"ok":true}` chứng tỏ React → proxy → Laravel thông.) Console trình duyệt không có lỗi đỏ.

```bash
cd ..
git add .
git commit -m "chore: init react frontend with tailwind and proxy"
```

---

## Chặng 5. Database: migration, model, seeder

### 5.1. Tạo model và migration

Chạy **từng lệnh một** (không dán cả cụm), vì tên file migration có timestamp:

```bash
cd backend
php artisan make:model Category -m
php artisan make:model Book -mf
php artisan make:model CartItem -m
php artisan make:model Order -m
php artisan make:model OrderItem -m
```

M�� thư mục `database/migrations` và kiểm tra thứ tự tên file: `categories` → `books` → `cart_items` → `orders` → `order_items` (sau file `users`). Nếu hai file trùng giây và bị xếp sai thứ tự, đổi số timestamp ở đầu tên file cho đúng thứ tự. Khoá ngoại cần bảng cha tồn tại trước.

### 5.2. Viết migration

Thêm cột `role` vào migration có sẵn `..._create_users_table.php` (ngay sau cột `password`):

```php
$table->string('role', 20)->default('customer');
```

`create_categories_table`:

```php
Schema::create('categories', function (Blueprint $table) {
    $table->id();
    $table->string('name')->unique();
    $table->timestamps();
});
```

`create_books_table`:

```php
Schema::create('books', function (Blueprint $table) {
    $table->id();
    $table->foreignId('category_id')->constrained()->restrictOnDelete();
    $table->string('title');
    $table->string('author');
    $table->string('publisher')->nullable();
    $table->string('isbn', 20)->nullable()->unique();
    $table->text('description')->nullable();
    $table->unsignedInteger('price');           // đồng
    $table->unsignedInteger('stock')->default(0);
    $table->string('image_path')->nullable();
    $table->boolean('is_active')->default(true);
    $table->timestamps();
});
```

`create_cart_items_table`:

```php
Schema::create('cart_items', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->foreignId('book_id')->constrained()->cascadeOnDelete();
    $table->unsignedSmallInteger('quantity');
    $table->timestamps();
    $table->unique(['user_id', 'book_id']);     // mỗi sách chỉ 1 dòng trong giỏ
});
```

`create_orders_table`:

```php
Schema::create('orders', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->restrictOnDelete();
    $table->string('code', 20)->unique();
    $table->string('status', 20)->default('pending')->index();
    $table->string('receiver_name');
    $table->string('receiver_phone', 20);
    $table->string('shipping_address');
    $table->string('note')->nullable();
    $table->string('payment_method', 20)->default('cod');
    $table->unsignedBigInteger('subtotal');
    $table->unsignedInteger('shipping_fee');
    $table->unsignedBigInteger('total');
    $table->timestamps();
});
```

`create_order_items_table`:

```php
Schema::create('order_items', function (Blueprint $table) {
    $table->id();
    $table->foreignId('order_id')->constrained()->cascadeOnDelete();
    $table->foreignId('book_id')->nullable()->constrained()->nullOnDelete();
    $table->string('title_snapshot');           // tên sách tại thời điểm mua
    $table->unsignedInteger('unit_price');      // giá tại thời điểm mua
    $table->unsignedSmallInteger('quantity');
    $table->unsignedBigInteger('line_total');
    $table->timestamps();
});
```

### 5.3. Viết model

`app/Models/Category.php` (giữ phần `namespace`/`use HasFactory` do Laravel tạo, chỉ thêm nội dung trong class):

```php
protected $fillable = ['name'];

public function books()
{
    return $this->hasMany(Book::class);
}
```

`app/Models/Book.php`:

```php
protected $fillable = [
    'category_id', 'title', 'author', 'publisher', 'isbn',
    'description', 'price', 'stock', 'image_path', 'is_active',
];

protected function casts(): array
{
    return ['is_active' => 'boolean', 'price' => 'integer', 'stock' => 'integer'];
}

public function category()
{
    return $this->belongsTo(Category::class);
}
```

`app/Models/CartItem.php`:

```php
protected $fillable = ['book_id', 'quantity'];

public function book()
{
    return $this->belongsTo(Book::class);
}
```

`app/Models/Order.php`:

```php
public const SHIPPING_FEE = 30000;

protected $fillable = [
    'user_id', 'code', 'status', 'receiver_name', 'receiver_phone',
    'shipping_address', 'note', 'payment_method', 'subtotal', 'shipping_fee', 'total',
];

public function user()
{
    return $this->belongsTo(User::class);
}

public function items()
{
    return $this->hasMany(OrderItem::class);
}
```

`app/Models/OrderItem.php`:

```php
protected $fillable = ['book_id', 'title_snapshot', 'unit_price', 'quantity', 'line_total'];

public function order()
{
    return $this->belongsTo(Order::class);
}
```

`app/Models/User.php`: thêm hai quan hệ. **Không** thêm `role` vào `$fillable` (nếu thêm, người dùng có thể tự gửi `role=admin` lúc đăng ký):

```php
public function cartItems()
{
    return $this->hasMany(CartItem::class);
}

public function orders()
{
    return $this->hasMany(Order::class);
}
```

### 5.4. Factory và seeder

`database/factories/BookFactory.php`, trong `definition()`:

```php
return [
    'category_id' => \App\Models\Category::inRandomOrder()->value('id'),
    'title' => fake()->sentence(3),
    'author' => fake()->name(),
    'publisher' => fake()->company(),
    'description' => fake()->paragraph(4),
    'price' => fake()->numberBetween(50, 300) * 1000,
    'stock' => fake()->numberBetween(0, 50),
    'is_active' => true,
];
```

`database/seeders/DatabaseSeeder.php`, trong `run()`:

```php
foreach (['Công nghệ', 'Kinh tế', 'Văn học', 'Thiếu nhi', 'Kỹ năng sống'] as $name) {
    \App\Models\Category::create(['name' => $name]);
}

\App\Models\User::factory()->create([
    'name' => 'Admin',
    'email' => 'admin@bookstore.test',
    'password' => 'password',
    'role' => 'admin',
]);

\App\Models\User::factory()->create([
    'name' => 'Khách Test',
    'email' => 'user@bookstore.test',
]);

\App\Models\Book::factory()->count(30)->create();
```

> Mật khẩu `password` chỉ dùng khi phát triển trên máy bạn. **Không bao giờ chạy seeder này trên production** (Chặng 14 có cách tạo admin an toàn).

```bash
php artisan migrate:fresh --seed
```

✅ **Checkpoint:** trong HeidiSQL/DBeaver thấy 6 bảng của bạn, `books` có 30 dòng, `users` có 2 dòng với `role` là `admin` và `customer`. Hoặc: `php artisan tinker` rồi gõ `App\Models\Book::count()` → `30`.

```bash
cd ..
git add .
git commit -m "feat: database schema, models and seeders"
```

---

## Chặng 6. API đăng ký / đăng nhập

### 6.1. Controller

```bash
cd backend
php artisan make:controller Api/AuthController
```

`app/Http/Controllers/Api/AuthController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'confirmed', Password::min(8)],
        ]);

        $user = User::create($data); // password tự được băm nhờ cast 'hashed' của User
        Auth::login($user);
        $request->session()->regenerate();

        return $this->userResponse($user, 201);
    }

    public function login(Request $request): JsonResponse
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        if (! Auth::attempt($credentials)) {
            throw ValidationException::withMessages([
                'email' => ['Email hoặc mật khẩu không đúng.'],
            ]);
        }

        $request->session()->regenerate();

        return $this->userResponse($request->user());
    }

    public function logout(Request $request): Response
    {
        Auth::guard('web')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->noContent();
    }

    public function me(Request $request): JsonResponse
    {
        return $this->userResponse($request->user());
    }

    private function userResponse(User $user, int $status = 200): JsonResponse
    {
        return response()->json(['data' => $user->only('id', 'name', 'email', 'role')], $status);
    }
}
```

### 6.2. Middleware chỉ cho Admin (dùng ở Chặng 11)

```bash
php artisan make:middleware EnsureUserIsAdmin
```

`app/Http/Middleware/EnsureUserIsAdmin.php`:

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserIsAdmin
{
    public function handle(Request $request, Closure $next): Response
    {
        if ($request->user()?->role !== 'admin') {
            abort(403, 'Bạn không có quyền thực hiện thao tác này.');
        }

        return $next($request);
    }
}
```

Đăng ký bí danh `admin` trong `bootstrap/app.php`:

```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->statefulApi();
    $middleware->alias([
        'admin' => \App\Http\Middleware\EnsureUserIsAdmin::class,
    ]);
})
```

### 6.3. Khai báo route

`routes/api.php`:

```php
<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::get('/ping', fn () => ['ok' => true]); // xoá sau Chặng 7

    Route::post('/register', [AuthController::class, 'register'])->middleware('throttle:10,1');
    Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:10,1');

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me', [AuthController::class, 'me']);
    });
});
```

`throttle:10,1` = tối đa 10 lần/phút cho mỗi IP, chống dò mật khẩu.

> **Cách đăng nhập hoạt động (nên hiểu một lần):** (1) React gọi `GET /sanctum/csrf-cookie` để nhận cookie `XSRF-TOKEN`; (2) React `POST /api/v1/login`, Axios tự gửi cookie đó kèm header `X-XSRF-TOKEN`; (3) Laravel kiểm tra, tạo session và trả cookie `laravel_session`; (4) các request sau trình duyệt tự gửi cookie, `auth:sanctum` nhận ra người dùng.

> **Không thử đăng nhập bằng Postman ngay:** request không có `Origin`/`Referer` từ `localhost:5173` sẽ không được coi là "stateful" nên Laravel báo `Session store not set on request`. Hãy thử đăng nhập từ giao diện React ở Chặng 8, và dùng Feature test (Chặng 12) để kiểm thử các API cần đăng nhập.

✅ **Checkpoint:** `php artisan route:list --path=api/v1` liệt kê `register`, `login`, `logout`, `me`.

```bash
cd ..
git add .
git commit -m "feat: auth api with sanctum spa"
```

---

## Chặng 7. API danh mục và sách

```bash
cd backend
php artisan make:controller Api/CategoryController
php artisan make:controller Api/BookController
php artisan make:resource BookResource
```

### 7.1. `BookResource`

`app/Http/Resources/BookResource.php`, trong `toArray()`:

```php
return [
    'id' => $this->id,
    'title' => $this->title,
    'author' => $this->author,
    'publisher' => $this->publisher,
    'isbn' => $this->isbn,
    'description' => $this->description,
    'price' => $this->price,
    'stock' => $this->stock,
    'is_active' => $this->is_active,
    // Đường dẫn tương đối: chạy đúng cả khi dev (Vite proxy) lẫn production (Nginx)
    'image_url' => $this->image_path ? '/storage/'.$this->image_path : null,
    'category' => $this->whenLoaded('category', fn () => [
        'id' => $this->category->id,
        'name' => $this->category->name,
    ]),
];
```

Resource là lớp "định dạng JSON": quyết định chính xác trường nào được trả ra, nên không lộ nhầm dữ liệu.

### 7.2. `CategoryController`

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;

class CategoryController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => Category::orderBy('name')->get(['id', 'name']),
        ]);
    }
}
```

### 7.3. `BookController` (công khai)

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\BookResource;
use App\Models\Book;
use Illuminate\Http\Request;

class BookController extends Controller
{
    public function index(Request $request)
    {
        $query = Book::query()->with('category')->where('is_active', true);

        if ($search = $request->query('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('author', 'like', "%{$search}%");
            });
        }

        if ($categoryId = $request->query('category_id')) {
            $query->where('category_id', $categoryId);
        }

        // Chỉ cho phép các kiểu sắp xếp có trong danh sách này (không ghép chuỗi người dùng gửi vào SQL)
        $sorts = [
            'newest' => ['created_at', 'desc'],
            'price_asc' => ['price', 'asc'],
            'price_desc' => ['price', 'desc'],
            'title' => ['title', 'asc'],
        ];
        [$column, $direction] = $sorts[$request->query('sort', 'newest')] ?? $sorts['newest'];

        return BookResource::collection(
            $query->orderBy($column, $direction)->paginate(12)->withQueryString()
        );
    }

    public function show(int $id)
    {
        $book = Book::with('category')->where('is_active', true)->findOrFail($id);

        return new BookResource($book);
    }
}
```

### 7.4. Route

Trong `routes/api.php`: **xoá** route `/ping`, thêm import và 3 route công khai (đặt trong group `v1`, trước group `auth:sanctum`):

```php
use App\Http\Controllers\Api\BookController;
use App\Http\Controllers\Api\CategoryController;

Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/books', [BookController::class, 'index']);
Route::get('/books/{id}', [BookController::class, 'show'])->whereNumber('id');
```

✅ **Checkpoint:** mở trình duyệt:

- `http://127.0.0.1:8000/api/v1/categories` → danh sách 5 danh mục.
- `http://127.0.0.1:8000/api/v1/books` → JSON có `data` (12 sách) và `meta` (`current_page`, `last_page`, `total`...).
- `.../books?search=a&sort=price_asc&category_id=1` → kết quả lọc đúng, giá tăng dần.
- `.../books/9999` → 404.

```bash
cd ..
git add .
git commit -m "feat: catalog api"
```

---

## Chặng 8. React: layout, đăng nhập, danh sách và chi tiết sách

### 8.1. Cấu trúc thư mục

```text
frontend/src/
├── components/    TextField.jsx, Pagination.jsx
├── contexts/      AuthContext.jsx
├── layouts/       MainLayout.jsx
├── pages/         ProductsPage.jsx, ProductDetailPage.jsx, LoginPage.jsx, RegisterPage.jsx, ...
├── routes/        RequireAuth.jsx
├── services/      api.js, authService.js, bookService.js, cartService.js, orderService.js, adminService.js
├── utils/         format.js, errors.js
├── App.jsx
├── main.jsx
└── index.css
```

### 8.2. Lớp gọi API (`services/`)

`services/api.js`:

```js
import axios from "axios";

const api = axios.create({
  baseURL: "/api/v1",
  withCredentials: true,
  withXSRFToken: true,
  headers: { Accept: "application/json" },
});

// Lấy cookie CSRF trước khi đăng nhập/đăng ký (đường dẫn nằm ngoài /api/v1)
export const getCsrfCookie = () => axios.get("/sanctum/csrf-cookie", { withCredentials: true });

export default api;
```

> Header `Accept: application/json` rất quan trọng: thiếu nó Laravel có thể trả trang HTML hoặc chuyển hướng thay vì JSON lỗi.

`services/authService.js`:

```js
import api, { getCsrfCookie } from "./api";

export const getMe = () => api.get("/me");

export const login = async (payload) => {
  await getCsrfCookie();
  return api.post("/login", payload);
};

export const register = async (payload) => {
  await getCsrfCookie();
  return api.post("/register", payload);
};

export const logout = () => api.post("/logout");
```

`services/bookService.js`:

```js
import api from "./api";

export const getCategories = () => api.get("/categories");
export const getBooks = (params = {}) => api.get("/books", { params });
export const getBook = (id) => api.get(`/books/${id}`);
```

`services/cartService.js` (dùng ở Chặng 9):

```js
import api from "./api";

export const getCart = () => api.get("/cart");
export const addToCart = (book_id, quantity = 1) => api.post("/cart/items", { book_id, quantity });
export const updateCartItem = (id, quantity) => api.patch(`/cart/items/${id}`, { quantity });
export const removeCartItem = (id) => api.delete(`/cart/items/${id}`);
```

`services/orderService.js` (dùng ở Chặng 10):

```js
import api from "./api";

export const createOrder = (payload) => api.post("/orders", payload);
export const getOrders = (params = {}) => api.get("/orders", { params });
export const getOrder = (id) => api.get(`/orders/${id}`);
export const cancelOrder = (id) => api.post(`/orders/${id}/cancel`);
```

### 8.3. Tiện ích

`utils/format.js`:

```js
const money = new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" });
export const formatMoney = (value) => money.format(value);
export const formatDate = (iso) => new Date(iso).toLocaleString("vi-VN");
```

`utils/errors.js`:

```js
// Lỗi theo từng ô nhập: { email: ["..."] }
export const apiErrors = (err) => err.response?.data?.errors ?? {};

// Thông báo chung
export const apiMessage = (err) =>
  err.response?.data?.message ?? "Có lỗi xảy ra, vui lòng thử lại.";
```

### 8.4. Trạng thái đăng nhập toàn ứng dụng

`contexts/AuthContext.jsx`:

```jsx
import { createContext, useContext, useEffect, useState } from "react";
import * as authService from "../services/authService";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  // Khi mở trang: hỏi Laravel xem cookie hiện tại đã đăng nhập chưa
  useEffect(() => {
    authService
      .getMe()
      .then((res) => setUser(res.data.data))
      .catch(() => setUser(null))
      .finally(() => setLoading(false));
  }, []);

  const login = async (payload) => {
    const res = await authService.login(payload);
    setUser(res.data.data);
  };

  const register = async (payload) => {
    const res = await authService.register(payload);
    setUser(res.data.data);
  };

  const logout = async () => {
    await authService.logout();
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, register, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
```

`routes/RequireAuth.jsx`:

```jsx
import { Navigate } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext.jsx";

// Chỉ để điều hướng giao diện. Quyền thật luôn do Laravel kiểm tra.
export default function RequireAuth({ role, children }) {
  const { user, loading } = useAuth();

  if (loading) return <p className="p-6">Đang tải...</p>;
  if (!user) return <Navigate to="/login" replace />;
  if (role && user.role !== role) return <Navigate to="/" replace />;

  return children;
}
```

### 8.5. Component dùng chung

`components/TextField.jsx`:

```jsx
export default function TextField({ label, error, ...props }) {
  return (
    <label className="block">
      <span className="text-sm font-medium">{label}</span>
      <input className="mt-1 w-full rounded border bg-white px-3 py-2" {...props} />
      {error && <span className="text-sm text-red-600">{error[0]}</span>}
    </label>
  );
}
```

`components/Pagination.jsx`:

```jsx
export default function Pagination({ meta, onChange }) {
  if (!meta || meta.last_page <= 1) return null;

  return (
    <div className="mt-6 flex items-center justify-center gap-3">
      <button
        className="rounded border bg-white px-3 py-1 disabled:opacity-40"
        disabled={meta.current_page <= 1}
        onClick={() => onChange(meta.current_page - 1)}
      >
        Trước
      </button>
      <span>
        Trang {meta.current_page} / {meta.last_page}
      </span>
      <button
        className="rounded border bg-white px-3 py-1 disabled:opacity-40"
        disabled={meta.current_page >= meta.last_page}
        onClick={() => onChange(meta.current_page + 1)}
      >
        Sau
      </button>
    </div>
  );
}
```

### 8.6. Layout

`layouts/MainLayout.jsx`:

```jsx
import { Link, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext.jsx";

export default function MainLayout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const onLogout = async () => {
    await logout();
    navigate("/");
  };

  return (
    <div className="min-h-screen bg-gray-50 text-gray-900">
      <header className="border-b bg-white">
        <nav className="mx-auto flex max-w-6xl items-center gap-4 p-4">
          <Link to="/" className="text-xl font-bold">
            BookStore
          </Link>
          <div className="ml-auto flex items-center gap-4 text-sm">
            <Link to="/cart">Giỏ hàng</Link>
            {user ? (
              <>
                <Link to="/orders">Đơn hàng</Link>
                {user.role === "admin" && <Link to="/admin/books">Quản trị</Link>}
                <span className="text-gray-500">{user.name}</span>
                <button onClick={onLogout}>Đăng xuất</button>
              </>
            ) : (
              <>
                <Link to="/login">Đăng nhập</Link>
                <Link to="/register">Đăng ký</Link>
              </>
            )}
          </div>
        </nav>
      </header>
      <main className="mx-auto max-w-6xl p-4">
        <Outlet />
      </main>
    </div>
  );
}
```

### 8.7. Trang đăng nhập và đăng ký

`pages/LoginPage.jsx`:

```jsx
import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import TextField from "../components/TextField.jsx";
import { useAuth } from "../contexts/AuthContext.jsx";
import { apiErrors, apiMessage } from "../utils/errors.js";

export default function LoginPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ email: "", password: "" });
  const [errors, setErrors] = useState({});
  const [message, setMessage] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const onChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const onSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    setErrors({});
    setMessage("");
    try {
      await login(form);
      navigate("/");
    } catch (err) {
      setErrors(apiErrors(err));
      if (!err.response?.data?.errors) setMessage(apiMessage(err));
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <form onSubmit={onSubmit} className="mx-auto max-w-sm space-y-4 rounded bg-white p-6 shadow">
      <h1 className="text-xl font-bold">Đăng nhập</h1>
      {message && <p className="text-red-600">{message}</p>}
      <TextField label="Email" name="email" type="email" value={form.email} onChange={onChange} error={errors.email} />
      <TextField label="Mật khẩu" name="password" type="password" value={form.password} onChange={onChange} error={errors.password} />
      <button disabled={submitting} className="w-full rounded bg-blue-600 py-2 text-white disabled:opacity-50">
        {submitting ? "Đang xử lý..." : "Đăng nhập"}
      </button>
      <p className="text-sm">
        Chưa có tài khoản? <Link to="/register" className="text-blue-600">Đăng ký</Link>
      </p>
    </form>
  );
}
```

`pages/RegisterPage.jsx`: sao chép `LoginPage`, đổi tên component thành `RegisterPage`, dùng `register` thay cho `login`, state ban đầu `{ name: "", email: "", password: "", password_confirmation: "" }` và thêm 2 ô `TextField` cho `name` và `password_confirmation` (nhãn "Họ tên", "Nhập lại mật khẩu"). Lỗi của `password_confirmation` do Laravel gắn vào khoá `password`, nên hiển thị `errors.password` là đủ.

### 8.8. Danh sách sách (có tìm kiếm, lọc, sắp xếp, phân trang)

`pages/ProductsPage.jsx`:

```jsx
import { useEffect, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import Pagination from "../components/Pagination.jsx";
import { getBooks, getCategories } from "../services/bookService";
import { formatMoney } from "../utils/format.js";

export default function ProductsPage() {
  const [params, setParams] = useSearchParams();
  const [categories, setCategories] = useState([]);
  const [view, setView] = useState({ status: "loading", books: [], meta: null });
  const [search, setSearch] = useState(params.get("search") ?? "");

  useEffect(() => {
    getCategories()
      .then((res) => setCategories(res.data.data))
      .catch(() => {});
  }, []);

  // Mỗi khi bộ lọc trên URL đổi thì tải lại danh sách
  useEffect(() => {
    let ignore = false;
    setView((v) => ({ ...v, status: "loading" }));
    getBooks(Object.fromEntries(params))
      .then((res) => {
        if (ignore) return;
        const books = res.data.data;
        setView({ status: books.length ? "success" : "empty", books, meta: res.data.meta });
      })
      .catch(() => {
        if (!ignore) setView({ status: "error", books: [], meta: null });
      });
    return () => {
      ignore = true;
    };
  }, [params]);

  const update = (changes) => {
    const next = new URLSearchParams(params);
    Object.entries(changes).forEach(([key, value]) => (value ? next.set(key, value) : next.delete(key)));
    if (!("page" in changes)) next.delete("page"); // đổi bộ lọc thì về trang 1
    setParams(next);
  };

  return (
    <div>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          update({ search });
        }}
        className="mb-6 flex flex-wrap gap-3"
      >
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Tìm theo tên sách hoặc tác giả"
          className="min-w-64 flex-1 rounded border bg-white px-3 py-2"
        />
        <select
          value={params.get("category_id") ?? ""}
          onChange={(e) => update({ category_id: e.target.value })}
          className="rounded border bg-white px-3 py-2"
        >
          <option value="">Tất cả danh mục</option>
          {categories.map((c) => (
            <option key={c.id} value={c.id}>{c.name}</option>
          ))}
        </select>
        <select
          value={params.get("sort") ?? "newest"}
          onChange={(e) => update({ sort: e.target.value })}
          className="rounded border bg-white px-3 py-2"
        >
          <option value="newest">Mới nhất</option>
          <option value="price_asc">Giá tăng dần</option>
          <option value="price_desc">Giá giảm dần</option>
          <option value="title">Tên A-Z</option>
        </select>
        <button className="rounded bg-blue-600 px-4 py-2 text-white">Tìm</button>
      </form>

      {view.status === "loading" && <p>Đang tải...</p>}
      {view.status === "error" && <p className="text-red-600">Không tải được danh sách. Vui lòng thử lại.</p>}
      {view.status === "empty" && <p>Không tìm thấy sách phù hợp.</p>}

      {view.status === "success" && (
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {view.books.map((book) => (
            <Link key={book.id} to={`/books/${book.id}`} className="rounded bg-white p-3 shadow hover:shadow-md">
              {book.image_url ? (
                <img src={book.image_url} alt={book.title} className="mb-3 h-48 w-full rounded object-cover" />
              ) : (
                <div className="mb-3 flex h-48 items-center justify-center rounded bg-gray-200 text-gray-500">Chưa có ảnh</div>
              )}
              <h2 className="line-clamp-2 font-semibold">{book.title}</h2>
              <p className="text-sm text-gray-500">{book.author}</p>
              <p className="mt-1 font-bold text-blue-600">{formatMoney(book.price)}</p>
            </Link>
          ))}
        </div>
      )}

      <Pagination meta={view.meta} onChange={(page) => update({ page })} />
    </div>
  );
}
```

Trang này xử lý đủ **bốn trạng thái** mà roadmap nhắc: loading, success, empty, error. Hãy làm quen với mẫu này vì trang nào lấy dữ liệu cũng cần.

### 8.9. Chi tiết sách

`pages/ProductDetailPage.jsx`:

```jsx
import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext.jsx";
import { addToCart } from "../services/cartService";
import { getBook } from "../services/bookService";
import { apiMessage } from "../utils/errors.js";
import { formatMoney } from "../utils/format.js";

export default function ProductDetailPage() {
  const { id } = useParams();
  const { user } = useAuth();
  const navigate = useNavigate();
  const [book, setBook] = useState(null);
  const [status, setStatus] = useState("loading");
  const [quantity, setQuantity] = useState(1);
  const [message, setMessage] = useState("");

  useEffect(() => {
    setStatus("loading");
    getBook(id)
      .then((res) => {
        setBook(res.data.data);
        setStatus("success");
      })
      .catch((err) => setStatus(err.response?.status === 404 ? "notfound" : "error"));
  }, [id]);

  const onAdd = async () => {
    if (!user) return navigate("/login");
    try {
      await addToCart(book.id, quantity);
      setMessage("Đã thêm vào giỏ hàng.");
    } catch (err) {
      setMessage(apiMessage(err));
    }
  };

  if (status === "loading") return <p>Đang tải...</p>;
  if (status === "notfound") return <p>Không tìm thấy sách.</p>;
  if (status === "error") return <p className="text-red-600">Có lỗi xảy ra.</p>;

  return (
    <div className="grid gap-6 rounded bg-white p-6 shadow md:grid-cols-2">
      {book.image_url ? (
        <img src={book.image_url} alt={book.title} className="w-full rounded object-cover" />
      ) : (
        <div className="flex h-80 items-center justify-center rounded bg-gray-200 text-gray-500">Chưa có ảnh</div>
      )}
      <div className="space-y-3">
        <h1 className="text-2xl font-bold">{book.title}</h1>
        <p className="text-gray-600">Tác giả: {book.author}</p>
        {book.category && <p className="text-gray-600">Danh mục: {book.category.name}</p>}
        <p className="text-2xl font-bold text-blue-600">{formatMoney(book.price)}</p>
        <p>{book.stock > 0 ? `Còn ${book.stock} cuốn` : "Hết hàng"}</p>
        <p className="whitespace-pre-line">{book.description}</p>
        {book.stock > 0 && (
          <div className="flex items-center gap-3">
            <input
              type="number"
              min="1"
              max={book.stock}
              value={quantity}
              onChange={(e) => setQuantity(Number(e.target.value))}
              className="w-20 rounded border px-2 py-1"
            />
            <button onClick={onAdd} className="rounded bg-blue-600 px-4 py-2 text-white">
              Thêm vào giỏ
            </button>
          </div>
        )}
        {message && <p className="text-sm">{message}</p>}
      </div>
    </div>
  );
}
```

### 8.10. Ghép routing

Tạo tạm các trang chưa làm bằng một dòng (ví dụ `export default function CartPage() { return <p>Sắp có</p>; }`) hoặc chỉ khai báo route khi trang đã tồn tại. `App.jsx` cho chặng này:

```jsx
import { Route, Routes } from "react-router-dom";
import MainLayout from "./layouts/MainLayout.jsx";
import LoginPage from "./pages/LoginPage.jsx";
import ProductDetailPage from "./pages/ProductDetailPage.jsx";
import ProductsPage from "./pages/ProductsPage.jsx";
import RegisterPage from "./pages/RegisterPage.jsx";

export default function App() {
  return (
    <Routes>
      <Route element={<MainLayout />}>
        <Route path="/" element={<ProductsPage />} />
        <Route path="/books/:id" element={<ProductDetailPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="*" element={<p>Không tìm thấy trang.</p>} />
      </Route>
    </Routes>
  );
}
```

`main.jsx`:

```jsx
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import "./index.css";
import App from "./App.jsx";
import { AuthProvider } from "./contexts/AuthContext.jsx";

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <BrowserRouter>
      <AuthProvider>
        <App />
      </AuthProvider>
    </BrowserRouter>
  </StrictMode>
);
```

✅ **Checkpoint** (chạy cả hai server):

1. Trang chủ hiện lưới sách 4 cột (desktop), co về 1 cột khi thu nhỏ cửa sổ; tìm kiếm, lọc danh mục, sắp xếp, phân trang đều hoạt động và URL đổi theo (`?search=...&page=2`).
2. Bấm vào một sách → trang chi tiết; vào `/books/9999` → "Không tìm thấy sách".
3. Đăng nhập bằng `user@bookstore.test` / `password` → thanh trên hiện tên bạn. **Tải lại trang (F5) vẫn còn đăng nhập.** Mở DevTools → Network thấy `csrf-cookie` trả 204, `login` trả 200; tab Application → Cookies có `laravel_session` và `XSRF-TOKEN`.
4. Đăng nhập sai mật khẩu → hiện lỗi dưới ô email (lỗi 422 từ Laravel).
5. Đăng ký tài khoản mới → tự đăng nhập; đăng xuất → thanh trên về "Đăng nhập / Đăng ký".

```bash
git add .
git commit -m "feat: react layout, auth and catalog pages"
```

---

## Chặng 9. Giỏ hàng (API + React)

### 9.1. Backend

```bash
cd backend
php artisan make:controller Api/CartController
```

`app/Http/Controllers/Api/CartController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\BookResource;
use App\Models\Book;
use App\Models\Order;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class CartController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        return response()->json(['data' => $this->payload($request)]);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'book_id' => ['required', 'integer', 'exists:books,id'],
            'quantity' => ['required', 'integer', 'min:1', 'max:99'],
        ]);

        $book = Book::where('is_active', true)->findOrFail($data['book_id']);

        $item = $request->user()->cartItems()->firstOrNew(['book_id' => $book->id]);
        $newQuantity = ($item->quantity ?? 0) + $data['quantity'];

        if ($newQuantity > $book->stock) {
            throw ValidationException::withMessages([
                'quantity' => ["Chỉ còn {$book->stock} cuốn trong kho."],
            ]);
        }

        $item->quantity = $newQuantity;
        $item->save();

        return response()->json(['data' => $this->payload($request)], 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $data = $request->validate([
            'quantity' => ['required', 'integer', 'min:1', 'max:99'],
        ]);

        // Chỉ tìm trong giỏ của chính người dùng này
        $item = $request->user()->cartItems()->with('book')->findOrFail($id);

        if ($data['quantity'] > $item->book->stock) {
            throw ValidationException::withMessages([
                'quantity' => ["Chỉ còn {$item->book->stock} cuốn trong kho."],
            ]);
        }

        $item->update($data);

        return response()->json(['data' => $this->payload($request)]);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $request->user()->cartItems()->findOrFail($id)->delete();

        return response()->json(['data' => $this->payload($request)]);
    }

    // Giá luôn được tính lại từ database mỗi lần trả giỏ hàng
    private function payload(Request $request): array
    {
        $items = $request->user()->cartItems()->with('book')->orderBy('id')->get()->map(fn ($item) => [
            'id' => $item->id,
            'quantity' => $item->quantity,
            'line_total' => $item->quantity * $item->book->price,
            'book' => BookResource::make($item->book)->resolve(),
        ]);

        $subtotal = $items->sum('line_total');

        return [
            'items' => $items->values(),
            'subtotal' => $subtotal,
            'shipping_fee' => Order::SHIPPING_FEE,
            'total' => $subtotal + Order::SHIPPING_FEE,
        ];
    }
}
```

Trong `routes/api.php`, thêm import `CartController` và 4 route **bên trong** group `auth:sanctum`:

```php
Route::get('/cart', [CartController::class, 'index']);
Route::post('/cart/items', [CartController::class, 'store']);
Route::patch('/cart/items/{id}', [CartController::class, 'update'])->whereNumber('id');
Route::delete('/cart/items/{id}', [CartController::class, 'destroy'])->whereNumber('id');
```

### 9.2. Frontend

`pages/CartPage.jsx`:

```jsx
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getCart, removeCartItem, updateCartItem } from "../services/cartService";
import { apiMessage } from "../utils/errors.js";
import { formatMoney } from "../utils/format.js";

export default function CartPage() {
  const [cart, setCart] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    getCart()
      .then((res) => setCart(res.data.data))
      .catch((err) => setError(apiMessage(err)));
  }, []);

  // Mọi thao tác đều trả về giỏ hàng mới nhất từ server
  const run = async (action) => {
    setError("");
    try {
      const res = await action();
      setCart(res.data.data);
    } catch (err) {
      setError(apiMessage(err));
    }
  };

  if (!cart) return <p>{error || "Đang tải..."}</p>;

  if (cart.items.length === 0) {
    return (
      <p>
        Giỏ hàng đang trống. <Link to="/" className="text-blue-600">Tiếp tục mua sắm</Link>
      </p>
    );
  }

  return (
    <div className="space-y-4">
      <h1 className="text-xl font-bold">Giỏ hàng</h1>
      {error && <p className="text-red-600">{error}</p>}

      <div className="divide-y rounded bg-white shadow">
        {cart.items.map((item) => (
          <div key={item.id} className="flex flex-wrap items-center gap-4 p-4">
            <div className="min-w-48 flex-1">
              <Link to={`/books/${item.book.id}`} className="font-semibold">{item.book.title}</Link>
              <p className="text-sm text-gray-500">{formatMoney(item.book.price)}</p>
            </div>
            <div className="flex items-center gap-2">
              <button
                className="rounded border px-2 disabled:opacity-40"
                disabled={item.quantity <= 1}
                onClick={() => run(() => updateCartItem(item.id, item.quantity - 1))}
              >
                −
              </button>
              <span>{item.quantity}</span>
              <button
                className="rounded border px-2"
                onClick={() => run(() => updateCartItem(item.id, item.quantity + 1))}
              >
                +
              </button>
            </div>
            <p className="w-32 text-right font-semibold">{formatMoney(item.line_total)}</p>
            <button className="text-red-600" onClick={() => run(() => removeCartItem(item.id))}>
              Xoá
            </button>
          </div>
        ))}
      </div>

      <div className="ml-auto max-w-sm space-y-1 rounded bg-white p-4 shadow">
        <div className="flex justify-between"><span>Tạm tính</span><span>{formatMoney(cart.subtotal)}</span></div>
        <div className="flex justify-between"><span>Phí giao hàng</span><span>{formatMoney(cart.shipping_fee)}</span></div>
        <div className="flex justify-between text-lg font-bold"><span>Tổng</span><span>{formatMoney(cart.total)}</span></div>
        <Link to="/checkout" className="mt-3 block rounded bg-blue-600 py-2 text-center text-white">
          Đặt hàng
        </Link>
      </div>
    </div>
  );
}
```

Thêm vào `App.jsx` (import `RequireAuth` và `CartPage`):

```jsx
<Route path="/cart" element={<RequireAuth><CartPage /></RequireAuth>} />
```

✅ **Checkpoint:**

1. Chưa đăng nhập, bấm "Thêm vào giỏ" → chuyển sang trang đăng nhập.
2. Đăng nhập, thêm 2 cuốn → `/cart` hiện đúng dòng, tạm tính, phí giao hàng, tổng.
3. Nút +/− đổi số lượng; tăng vượt số lượng tồn kho → hiện thông báo lỗi, số lượng không đổi; "Xoá" bỏ dòng.
4. Bảng `cart_items` trong database có dòng tương ứng; trong tab Network, request thêm giỏ **chỉ** gửi `book_id` và `quantity`, không có giá.

```bash
git add .
git commit -m "feat: cart api and page"
```

---

## Chặng 10. Đặt hàng và đơn hàng (API + React)

Đây là phần nghiệp vụ quan trọng nhất. Ghi nhớ ba nguyên tắc: **server tự tính tiền**, **mọi thay đổi nhiều bước nằm trong một transaction**, **chỉ xem được đơn của chính mình**.

### 10.1. Service đổi trạng thái đơn (dùng chung cho Customer huỷ đơn và Admin)

Tạo thư mục và file `backend/app/Services/OrderStatusService.php`:

```php
<?php

namespace App\Services;

use App\Models\Book;
use App\Models\Order;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class OrderStatusService
{
    // Bảng chuyển trạng thái hợp lệ (khớp quy tắc ở Chặng 1)
    public const TRANSITIONS = [
        'pending' => ['confirmed', 'cancelled'],
        'confirmed' => ['shipping', 'cancelled'],
        'shipping' => ['completed'],
        'completed' => [],
        'cancelled' => [],
    ];

    public function change(Order $order, string $to): Order
    {
        return DB::transaction(function () use ($order, $to) {
            // Đọc lại và khoá đơn để hai người không đổi trạng thái cùng lúc
            $order = Order::with('items')->whereKey($order->id)->lockForUpdate()->firstOrFail();

            if (! in_array($to, self::TRANSITIONS[$order->status] ?? [], true)) {
                throw ValidationException::withMessages([
                    'status' => ["Không thể chuyển đơn từ '{$order->status}' sang '{$to}'."],
                ]);
            }

            if ($to === 'cancelled') {
                foreach ($order->items as $item) {
                    if ($item->book_id) {
                        Book::whereKey($item->book_id)->increment('stock', $item->quantity);
                    }
                }
            }

            $order->update(['status' => $to]);

            return $order;
        });
    }
}
```

### 10.2. `OrderResource`

```bash
php artisan make:resource OrderResource
```

Trong `toArray()`:

```php
return [
    'id' => $this->id,
    'code' => $this->code,
    'status' => $this->status,
    'receiver_name' => $this->receiver_name,
    'receiver_phone' => $this->receiver_phone,
    'shipping_address' => $this->shipping_address,
    'note' => $this->note,
    'payment_method' => $this->payment_method,
    'subtotal' => $this->subtotal,
    'shipping_fee' => $this->shipping_fee,
    'total' => $this->total,
    'created_at' => $this->created_at->toIso8601String(),
    'items' => $this->whenLoaded('items', fn () => $this->items->map(fn ($item) => [
        'id' => $item->id,
        'book_id' => $item->book_id,
        'title' => $item->title_snapshot,
        'unit_price' => $item->unit_price,
        'quantity' => $item->quantity,
        'line_total' => $item->line_total,
    ])),
    'user' => $this->whenLoaded('user', fn () => [
        'id' => $this->user->id,
        'name' => $this->user->name,
        'email' => $this->user->email,
    ]),
];
```

### 10.3. `OrderController`

```bash
php artisan make:controller Api/OrderController
```

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\OrderResource;
use App\Models\Book;
use App\Models\Order;
use App\Services\OrderStatusService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        return OrderResource::collection(
            $request->user()->orders()->latest('id')->paginate(10)
        );
    }

    public function show(Request $request, int $id)
    {
        // Tìm trong đơn của CHÍNH người dùng này: đơn của người khác sẽ ra 404
        $order = $request->user()->orders()->with('items')->findOrFail($id);

        return new OrderResource($order);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'receiver_name' => ['required', 'string', 'max:255'],
            'receiver_phone' => ['required', 'regex:/^(0|\+84)[0-9]{9,10}$/'],
            'shipping_address' => ['required', 'string', 'max:255'],
            'note' => ['nullable', 'string', 'max:255'],
        ]);
        $user = $request->user();

        $order = DB::transaction(function () use ($data, $user) {
            // Khoá dòng giỏ hàng và dòng sách: hai request cùng lúc không thể tạo đơn trùng hay bán lố tồn kho
            $cartItems = $user->cartItems()->lockForUpdate()->get();

            if ($cartItems->isEmpty()) {
                throw ValidationException::withMessages(['cart' => ['Giỏ hàng đang trống.']]);
            }

            $books = Book::whereIn('id', $cartItems->pluck('book_id'))
                ->lockForUpdate()->get()->keyBy('id');

            $subtotal = 0;
            $lines = [];

            foreach ($cartItems as $cartItem) {
                $book = $books[$cartItem->book_id];

                if (! $book->is_active) {
                    throw ValidationException::withMessages([
                        'cart' => ["\"{$book->title}\" không còn được bán."],
                    ]);
                }
                if ($book->stock < $cartItem->quantity) {
                    throw ValidationException::withMessages([
                        'cart' => ["\"{$book->title}\" chỉ còn {$book->stock} cuốn."],
                    ]);
                }

                $lineTotal = $book->price * $cartItem->quantity;
                $subtotal += $lineTotal;

                // Snapshot: đơn hàng giữ nguyên tên và giá lúc mua
                $lines[] = [
                    'book_id' => $book->id,
                    'title_snapshot' => $book->title,
                    'unit_price' => $book->price,
                    'quantity' => $cartItem->quantity,
                    'line_total' => $lineTotal,
                ];

                $book->decrement('stock', $cartItem->quantity);
            }

            $order = Order::create([
                'user_id' => $user->id,
                'code' => 'BS'.now()->format('ymd').strtoupper(Str::random(5)),
                'status' => 'pending',
                'receiver_name' => $data['receiver_name'],
                'receiver_phone' => $data['receiver_phone'],
                'shipping_address' => $data['shipping_address'],
                'note' => $data['note'] ?? null,
                'payment_method' => 'cod',
                'subtotal' => $subtotal,
                'shipping_fee' => Order::SHIPPING_FEE,
                'total' => $subtotal + Order::SHIPPING_FEE,
            ]);

            $order->items()->createMany($lines);
            $user->cartItems()->delete(); // chỉ xoá giỏ khi mọi bước trên đã thành công

            return $order;
        });

        return (new OrderResource($order->load('items')))->response()->setStatusCode(201);
    }

    public function cancel(Request $request, int $id, OrderStatusService $service)
    {
        $order = $request->user()->orders()->findOrFail($id);

        if ($order->status !== 'pending') {
            throw ValidationException::withMessages([
                'status' => ['Chỉ huỷ được đơn đang chờ xác nhận.'],
            ]);
        }

        $service->change($order, 'cancelled');

        return new OrderResource($order->fresh('items'));
    }
}
```

Nếu có lỗi (hết hàng, giỏ rỗng...) ở bất kỳ bước nào trong transaction, mọi thay đổi (trừ kho, tạo đơn) được **rollback**, và người dùng nhận lỗi 422. Bấm "Đặt hàng" hai lần liên tiếp thì lần hai thấy giỏ trống nên không tạo đơn trùng.

Route (bên trong group `auth:sanctum`, nhớ import `OrderController`):

```php
Route::get('/orders', [OrderController::class, 'index']);
Route::post('/orders', [OrderController::class, 'store'])->middleware('throttle:10,1');
Route::get('/orders/{id}', [OrderController::class, 'show'])->whereNumber('id');
Route::post('/orders/{id}/cancel', [OrderController::class, 'cancel'])->whereNumber('id');
```

### 10.4. Frontend

Thêm vào cuối `utils/format.js`:

```js
export const STATUS_LABELS = {
  pending: "Chờ xác nhận",
  confirmed: "Đã xác nhận",
  shipping: "Đang giao",
  completed: "Hoàn thành",
  cancelled: "Đã huỷ",
};
```

`pages/CheckoutPage.jsx`:

```jsx
import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import TextField from "../components/TextField.jsx";
import { useAuth } from "../contexts/AuthContext.jsx";
import { getCart } from "../services/cartService";
import { createOrder } from "../services/orderService";
import { apiErrors, apiMessage } from "../utils/errors.js";
import { formatMoney } from "../utils/format.js";

export default function CheckoutPage() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [cart, setCart] = useState(null);
  const [form, setForm] = useState({
    receiver_name: user?.name ?? "",
    receiver_phone: "",
    shipping_address: "",
    note: "",
  });
  const [errors, setErrors] = useState({});
  const [message, setMessage] = useState("");
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    getCart()
      .then((res) => setCart(res.data.data))
      .catch((err) => setMessage(apiMessage(err)));
  }, []);

  const onChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const onSubmit = async (e) => {
    e.preventDefault();
    if (submitting) return; // chống bấm liên tục (server vẫn tự bảo vệ)
    setSubmitting(true);
    setErrors({});
    setMessage("");
    try {
      const res = await createOrder(form); // KHÔNG gửi giá hay tổng tiền
      navigate(`/orders/${res.data.data.id}`);
    } catch (err) {
      const fieldErrors = apiErrors(err);
      setErrors(fieldErrors);
      setMessage(fieldErrors.cart?.[0] ?? (Object.keys(fieldErrors).length ? "" : apiMessage(err)));
    } finally {
      setSubmitting(false);
    }
  };

  if (!cart) return <p>{message || "Đang tải..."}</p>;

  if (cart.items.length === 0) {
    return (
      <p>
        Giỏ hàng đang trống. <Link to="/" className="text-blue-600">Tiếp tục mua sắm</Link>
      </p>
    );
  }

  return (
    <div className="grid gap-6 md:grid-cols-2">
      <form onSubmit={onSubmit} className="space-y-4 rounded bg-white p-6 shadow">
        <h1 className="text-xl font-bold">Thông tin nhận hàng</h1>
        {message && <p className="text-red-600">{message}</p>}
        <TextField label="Người nhận" name="receiver_name" value={form.receiver_name} onChange={onChange} error={errors.receiver_name} />
        <TextField label="Số điện thoại" name="receiver_phone" value={form.receiver_phone} onChange={onChange} error={errors.receiver_phone} />
        <TextField label="Địa chỉ" name="shipping_address" value={form.shipping_address} onChange={onChange} error={errors.shipping_address} />
        <TextField label="Ghi chú (không bắt buộc)" name="note" value={form.note} onChange={onChange} error={errors.note} />
        <p className="text-sm text-gray-600">Thanh toán khi nhận hàng (COD).</p>
        <button disabled={submitting} className="w-full rounded bg-blue-600 py-2 text-white disabled:opacity-50">
          {submitting ? "Đang đặt hàng..." : "Xác nhận đặt hàng"}
        </button>
      </form>

      <div className="space-y-2 rounded bg-white p-6 shadow">
        <h2 className="font-bold">Đơn hàng của bạn</h2>
        {cart.items.map((item) => (
          <div key={item.id} className="flex justify-between text-sm">
            <span>{item.book.title} × {item.quantity}</span>
            <span>{formatMoney(item.line_total)}</span>
          </div>
        ))}
        <hr />
        <div className="flex justify-between"><span>Phí giao hàng</span><span>{formatMoney(cart.shipping_fee)}</span></div>
        <div className="flex justify-between text-lg font-bold"><span>Tổng</span><span>{formatMoney(cart.total)}</span></div>
        <p className="text-xs text-gray-500">Số tiền cuối cùng do máy chủ tính lại khi đặt hàng.</p>
      </div>
    </div>
  );
}
```

`pages/OrdersPage.jsx`:

```jsx
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import Pagination from "../components/Pagination.jsx";
import { getOrders } from "../services/orderService";
import { STATUS_LABELS, formatDate, formatMoney } from "../utils/format.js";

export default function OrdersPage() {
  const [page, setPage] = useState(1);
  const [view, setView] = useState({ status: "loading", orders: [], meta: null });

  useEffect(() => {
    setView((v) => ({ ...v, status: "loading" }));
    getOrders({ page })
      .then((res) =>
        setView({ status: res.data.data.length ? "success" : "empty", orders: res.data.data, meta: res.data.meta })
      )
      .catch(() => setView({ status: "error", orders: [], meta: null }));
  }, [page]);

  if (view.status === "loading") return <p>Đang tải...</p>;
  if (view.status === "error") return <p className="text-red-600">Không tải được danh sách đơn hàng.</p>;
  if (view.status === "empty") return <p>Bạn chưa có đơn hàng nào.</p>;

  return (
    <div className="space-y-4">
      <h1 className="text-xl font-bold">Đơn hàng của tôi</h1>
      <div className="divide-y rounded bg-white shadow">
        {view.orders.map((order) => (
          <Link key={order.id} to={`/orders/${order.id}`} className="flex flex-wrap justify-between gap-2 p-4 hover:bg-gray-50">
            <span className="font-semibold">{order.code}</span>
            <span className="text-sm text-gray-500">{formatDate(order.created_at)}</span>
            <span>{STATUS_LABELS[order.status]}</span>
            <span className="font-semibold">{formatMoney(order.total)}</span>
          </Link>
        ))}
      </div>
      <Pagination meta={view.meta} onChange={setPage} />
    </div>
  );
}
```

`pages/OrderDetailPage.jsx`:

```jsx
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { cancelOrder, getOrder } from "../services/orderService";
import { apiMessage } from "../utils/errors.js";
import { STATUS_LABELS, formatDate, formatMoney } from "../utils/format.js";

export default function OrderDetailPage() {
  const { id } = useParams();
  const [order, setOrder] = useState(null);
  const [status, setStatus] = useState("loading");
  const [error, setError] = useState("");

  useEffect(() => {
    getOrder(id)
      .then((res) => {
        setOrder(res.data.data);
        setStatus("success");
      })
      .catch((err) => setStatus(err.response?.status === 404 ? "notfound" : "error"));
  }, [id]);

  const onCancel = async () => {
    if (!confirm("Bạn chắc chắn muốn huỷ đơn này?")) return;
    try {
      const res = await cancelOrder(id);
      setOrder(res.data.data);
    } catch (err) {
      setError(apiMessage(err));
    }
  };

  if (status === "loading") return <p>Đang tải...</p>;
  if (status === "notfound") return <p>Không tìm thấy đơn hàng.</p>;
  if (status === "error") return <p className="text-red-600">Có lỗi xảy ra.</p>;

  return (
    <div className="space-y-4 rounded bg-white p-6 shadow">
      <h1 className="text-xl font-bold">Đơn {order.code}</h1>
      <p>Trạng thái: <b>{STATUS_LABELS[order.status]}</b> · {formatDate(order.created_at)}</p>
      <p>Người nhận: {order.receiver_name} · {order.receiver_phone}</p>
      <p>Địa chỉ: {order.shipping_address}</p>
      <div className="divide-y">
        {order.items.map((item) => (
          <div key={item.id} className="flex justify-between py-2">
            <span>{item.title} × {item.quantity}</span>
            <span>{formatMoney(item.line_total)}</span>
          </div>
        ))}
      </div>
      <p>Phí giao hàng: {formatMoney(order.shipping_fee)}</p>
      <p className="text-lg font-bold">Tổng: {formatMoney(order.total)}</p>
      {error && <p className="text-red-600">{error}</p>}
      {order.status === "pending" && (
        <button onClick={onCancel} className="rounded border border-red-600 px-4 py-2 text-red-600">
          Huỷ đơn
        </button>
      )}
    </div>
  );
}
```

Thêm 3 route (đều bọc `RequireAuth`) cho `/checkout`, `/orders`, `/orders/:id` vào `App.jsx` (bản đầy đủ ở Chặng 11).

✅ **Checkpoint:**

1. Từ giỏ hàng → "Đặt hàng" → điền thông tin → xác nhận → sang trang chi tiết đơn, trạng thái "Chờ xác nhận", tổng = tạm tính + 30.000đ.
2. Trong database: `orders` có 1 dòng, `order_items` có đúng số dòng, `books.stock` đã giảm đúng số lượng, `cart_items` của bạn đã trống.
3. Đổi giá một sách trong database rồi xem lại đơn cũ: **giá trong đơn cũ không đổi** (nhờ snapshot).
4. Huỷ đơn `pending` → trạng thái "Đã huỷ", `books.stock` được cộng lại.
5. Đăng nhập tài khoản khác, mở `/orders/<id đơn của người kia>` → "Không tìm thấy đơn hàng".
6. Cố tình đặt khi tồn kho không đủ (sửa `stock` trong database) → báo lỗi, **không** có đơn nào được tạo và kho không đổi.

```bash
git add .
git commit -m "feat: checkout and orders"
```

---

## Chặng 11. Trang Admin (API + React)

### 11.1. Backend

```bash
cd backend
php artisan make:controller Api/AdminBookController
php artisan make:controller Api/AdminCategoryController
php artisan make:controller Api/AdminOrderController
```

`AdminBookController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\BookResource;
use App\Models\Book;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;

class AdminBookController extends Controller
{
    public function index(Request $request)
    {
        $query = Book::with('category')->latest('id');

        if ($search = $request->query('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")->orWhere('author', 'like', "%{$search}%");
            });
        }

        return BookResource::collection($query->paginate(15)->withQueryString());
    }

    public function show(Book $book)
    {
        return new BookResource($book->load('category'));
    }

    public function store(Request $request)
    {
        $data = $this->prepare($request, $request->validate($this->rules()));
        $book = Book::create($data);

        return (new BookResource($book->load('category')))->response()->setStatusCode(201);
    }

    public function update(Request $request, Book $book)
    {
        $data = $this->prepare($request, $request->validate($this->rules($book)), $book);
        $book->update($data);

        return new BookResource($book->load('category'));
    }

    // "Xoá" = ẩn khỏi cửa hàng, giữ lại dữ liệu cho lịch sử đơn hàng
    public function destroy(Book $book)
    {
        $book->update(['is_active' => false]);

        return response()->noContent();
    }

    private function rules(?Book $book = null): array
    {
        return [
            'category_id' => ['required', 'exists:categories,id'],
            'title' => ['required', 'string', 'max:255'],
            'author' => ['required', 'string', 'max:255'],
            'publisher' => ['nullable', 'string', 'max:255'],
            'isbn' => ['nullable', 'string', 'max:20', Rule::unique('books', 'isbn')->ignore($book?->id)],
            'description' => ['nullable', 'string'],
            'price' => ['required', 'integer', 'min:0'],
            'stock' => ['required', 'integer', 'min:0'],
            'is_active' => ['sometimes', 'boolean'],
            'image' => ['nullable', 'image', 'mimes:jpg,jpeg,png,webp', 'max:2048'], // tối đa 2 MB
        ];
    }

    private function prepare(Request $request, array $data, ?Book $book = null): array
    {
        unset($data['image']);

        if ($request->hasFile('image')) {
            if ($book?->image_path) {
                Storage::disk('public')->delete($book->image_path);
            }
            // Laravel tự đặt tên file ngẫu nhiên: không tin tên file người dùng gửi
            $data['image_path'] = $request->file('image')->store('books', 'public');
        }

        return $data;
    }
}
```

`AdminCategoryController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class AdminCategoryController extends Controller
{
    public function index()
    {
        return response()->json(['data' => Category::withCount('books')->orderBy('name')->get()]);
    }

    public function store(Request $request)
    {
        $data = $request->validate(['name' => ['required', 'string', 'max:255', 'unique:categories,name']]);

        return response()->json(['data' => Category::create($data)], 201);
    }

    public function update(Request $request, Category $category)
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255', Rule::unique('categories', 'name')->ignore($category->id)],
        ]);
        $category->update($data);

        return response()->json(['data' => $category]);
    }

    public function destroy(Category $category)
    {
        if ($category->books()->exists()) {
            throw ValidationException::withMessages([
                'category' => ['Danh mục đang có sách, không thể xoá.'],
            ]);
        }

        $category->delete();

        return response()->noContent();
    }
}
```

`AdminOrderController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\OrderResource;
use App\Models\Order;
use App\Services\OrderStatusService;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class AdminOrderController extends Controller
{
    public function index(Request $request)
    {
        $query = Order::with('user')->latest('id');

        if ($status = $request->query('status')) {
            $query->where('status', $status);
        }
        if ($code = $request->query('code')) {
            $query->where('code', 'like', "%{$code}%");
        }

        return OrderResource::collection($query->paginate(15)->withQueryString());
    }

    public function show(Order $order)
    {
        return new OrderResource($order->load(['items', 'user']));
    }

    public function updateStatus(Request $request, Order $order, OrderStatusService $service)
    {
        $data = $request->validate([
            'status' => ['required', Rule::in(array_keys(OrderStatusService::TRANSITIONS))],
        ]);

        $updated = $service->change($order, $data['status']);

        return new OrderResource($updated->load(['items', 'user']));
    }
}
```

Route: trong group `auth:sanctum`, thêm group `admin` (import 3 controller mới):

```php
Route::middleware('admin')->prefix('admin')->group(function () {
    Route::apiResource('books', AdminBookController::class);
    Route::apiResource('categories', AdminCategoryController::class)->except('show');
    Route::get('/orders', [AdminOrderController::class, 'index']);
    Route::get('/orders/{order}', [AdminOrderController::class, 'show']);
    Route::patch('/orders/{order}/status', [AdminOrderController::class, 'updateStatus']);
});
```

Để dùng upload ảnh khi phát triển, tạo liên kết thư mục lưu ảnh (chạy một lần):

```bash
php artisan storage:link
```

### 11.2. Frontend

`services/adminService.js`:

```js
import api from "./api";

export const adminGetBooks = (params = {}) => api.get("/admin/books", { params });
export const adminGetBook = (id) => api.get(`/admin/books/${id}`);
export const adminSaveBook = (id, formData) => {
  if (id) {
    // PHP không đọc được dữ liệu multipart gửi bằng PUT, nên giả lập PUT qua POST
    formData.append("_method", "PUT");
    return api.post(`/admin/books/${id}`, formData);
  }
  return api.post("/admin/books", formData);
};
export const adminHideBook = (id) => api.delete(`/admin/books/${id}`);

export const adminGetCategories = () => api.get("/admin/categories");
export const adminCreateCategory = (name) => api.post("/admin/categories", { name });
export const adminUpdateCategory = (id, name) => api.patch(`/admin/categories/${id}`, { name });
export const adminDeleteCategory = (id) => api.delete(`/admin/categories/${id}`);

export const adminGetOrders = (params = {}) => api.get("/admin/orders", { params });
export const adminUpdateOrderStatus = (id, status) => api.patch(`/admin/orders/${id}/status`, { status });
```

`pages/admin/AdminBooksPage.jsx`:

```jsx
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import Pagination from "../../components/Pagination.jsx";
import { adminGetBooks, adminHideBook } from "../../services/adminService";
import { apiMessage } from "../../utils/errors.js";
import { formatMoney } from "../../utils/format.js";

export default function AdminBooksPage() {
  const [page, setPage] = useState(1);
  const [view, setView] = useState({ status: "loading", books: [], meta: null });
  const [error, setError] = useState("");

  const load = () =>
    adminGetBooks({ page })
      .then((res) =>
        setView({ status: res.data.data.length ? "success" : "empty", books: res.data.data, meta: res.data.meta })
      )
      .catch(() => setView({ status: "error", books: [], meta: null }));

  useEffect(() => {
    load();
  }, [page]); // eslint-disable-line react-hooks/exhaustive-deps

  const hide = async (book) => {
    if (!confirm(`Ẩn sách "${book.title}" khỏi cửa hàng?`)) return;
    try {
      await adminHideBook(book.id);
      load();
    } catch (err) {
      setError(apiMessage(err));
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-bold">Quản lý sách</h1>
        <Link to="/admin/books/new" className="rounded bg-blue-600 px-4 py-2 text-white">Thêm sách</Link>
      </div>
      {error && <p className="text-red-600">{error}</p>}
      {view.status === "loading" && <p>Đang tải...</p>}
      {view.status === "error" && <p className="text-red-600">Không tải được dữ liệu.</p>}
      {view.status === "empty" && <p>Chưa có sách nào.</p>}
      {view.status === "success" && (
        <div className="overflow-x-auto rounded bg-white shadow">
          <table className="w-full text-left text-sm">
            <thead className="border-b bg-gray-100">
              <tr><th className="p-3">Tên sách</th><th>Giá</th><th>Tồn</th><th>Trạng thái</th><th></th></tr>
            </thead>
            <tbody>
              {view.books.map((book) => (
                <tr key={book.id} className="border-b">
                  <td className="p-3">{book.title}</td>
                  <td>{formatMoney(book.price)}</td>
                  <td>{book.stock}</td>
                  <td>{book.is_active ? "Đang bán" : "Đã ẩn"}</td>
                  <td className="space-x-3 pr-3 text-right">
                    <Link to={`/admin/books/${book.id}`} className="text-blue-600">Sửa</Link>
                    {book.is_active && <button onClick={() => hide(book)} className="text-red-600">Ẩn</button>}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      <Pagination meta={view.meta} onChange={setPage} />
    </div>
  );
}
```

`pages/admin/AdminBookFormPage.jsx` (dùng cho cả thêm mới và sửa):

```jsx
import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import TextField from "../../components/TextField.jsx";
import { adminGetBook, adminSaveBook } from "../../services/adminService";
import { getCategories } from "../../services/bookService";
import { apiErrors, apiMessage } from "../../utils/errors.js";

const EMPTY = {
  category_id: "", title: "", author: "", publisher: "", isbn: "",
  description: "", price: "", stock: "", is_active: true,
};

export default function AdminBookFormPage() {
  const { id } = useParams(); // undefined khi thêm mới
  const navigate = useNavigate();
  const [form, setForm] = useState(EMPTY);
  const [image, setImage] = useState(null);
  const [categories, setCategories] = useState([]);
  const [errors, setErrors] = useState({});
  const [message, setMessage] = useState("");

  useEffect(() => {
    getCategories().then((res) => setCategories(res.data.data));
    if (id) {
      adminGetBook(id).then((res) => {
        const b = res.data.data;
        setForm({
          category_id: b.category?.id ?? "", title: b.title, author: b.author,
          publisher: b.publisher ?? "", isbn: b.isbn ?? "", description: b.description ?? "",
          price: b.price, stock: b.stock, is_active: b.is_active,
        });
      });
    }
  }, [id]);

  const onChange = (e) => {
    const { name, value, type, checked } = e.target;
    setForm({ ...form, [name]: type === "checkbox" ? checked : value });
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    setErrors({});
    setMessage("");

    const data = new FormData();
    Object.entries(form).forEach(([key, value]) => {
      // Laravel chỉ chấp nhận boolean dạng 1/0 trong FormData, không nhận "true"/"false"
      data.append(key, key === "is_active" ? (value ? 1 : 0) : value ?? "");
    });
    if (image) data.append("image", image);

    try {
      await adminSaveBook(id, data);
      navigate("/admin/books");
    } catch (err) {
      setErrors(apiErrors(err));
      setMessage(apiMessage(err));
    }
  };

  return (
    <form onSubmit={onSubmit} className="mx-auto max-w-xl space-y-4 rounded bg-white p-6 shadow">
      <h1 className="text-xl font-bold">{id ? "Sửa sách" : "Thêm sách"}</h1>
      {message && <p className="text-red-600">{message}</p>}

      <label className="block">
        <span className="text-sm font-medium">Danh mục</span>
        <select name="category_id" value={form.category_id} onChange={onChange} className="mt-1 w-full rounded border bg-white px-3 py-2">
          <option value="">-- Chọn danh mục --</option>
          {categories.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
        </select>
        {errors.category_id && <span className="text-sm text-red-600">{errors.category_id[0]}</span>}
      </label>

      <TextField label="Tên sách" name="title" value={form.title} onChange={onChange} error={errors.title} />
      <TextField label="Tác giả" name="author" value={form.author} onChange={onChange} error={errors.author} />
      <TextField label="Nhà xuất bản" name="publisher" value={form.publisher} onChange={onChange} error={errors.publisher} />
      <TextField label="ISBN" name="isbn" value={form.isbn} onChange={onChange} error={errors.isbn} />
      <TextField label="Giá (đồng)" name="price" type="number" min="0" value={form.price} onChange={onChange} error={errors.price} />
      <TextField label="Tồn kho" name="stock" type="number" min="0" value={form.stock} onChange={onChange} error={errors.stock} />

      <label className="block">
        <span className="text-sm font-medium">Mô tả</span>
        <textarea name="description" rows="4" value={form.description} onChange={onChange} className="mt-1 w-full rounded border bg-white px-3 py-2" />
      </label>

      <label className="block">
        <span className="text-sm font-medium">Ảnh bìa (jpg, png, webp, tối đa 2 MB)</span>
        <input type="file" accept="image/*" onChange={(e) => setImage(e.target.files[0] ?? null)} className="mt-1 block" />
        {errors.image && <span className="text-sm text-red-600">{errors.image[0]}</span>}
      </label>

      <label className="flex items-center gap-2">
        <input type="checkbox" name="is_active" checked={form.is_active} onChange={onChange} />
        <span>Đang bán</span>
      </label>

      <button className="w-full rounded bg-blue-600 py-2 text-white">Lưu</button>
    </form>
  );
}
```

**Hai trang còn lại tự làm theo đúng mẫu `ProductsPage`/`AdminBooksPage`** (đã có đủ service):

| Trang | Đường dẫn | Gọi API | Hiển thị / thao tác |
|---|---|---|---|
| `AdminOrdersPage` | `/admin/orders` | `adminGetOrders({ page, status })` | Bảng: mã đơn, tên khách (`order.user.name`), ngày, tổng, trạng thái. Mỗi dòng có `<select>` chỉ liệt kê trạng thái kế tiếp hợp lệ (`pending → confirmed/cancelled`, `confirmed → shipping/cancelled`, `shipping → completed`); chọn xong gọi `adminUpdateOrderStatus`. Lỗi 422 hiện bằng `apiMessage`. |
| `AdminCategoriesPage` | `/admin/categories` | `adminGetCategories`, `adminCreateCategory`, `adminUpdateCategory`, `adminDeleteCategory` | Danh sách danh mục kèm `books_count`; ô thêm mới; nút sửa tên; nút xoá (lỗi "Danh mục đang có sách" từ server hiện ra). |

> Danh sách trạng thái kế tiếp ở giao diện chỉ để tiện bấm. Quy tắc chuyển trạng thái **thật** nằm trong `OrderStatusService` ở server.

### 11.3. `App.jsx` hoàn chỉnh

```jsx
import { Route, Routes } from "react-router-dom";
import MainLayout from "./layouts/MainLayout.jsx";
import RequireAuth from "./routes/RequireAuth.jsx";
import CartPage from "./pages/CartPage.jsx";
import CheckoutPage from "./pages/CheckoutPage.jsx";
import LoginPage from "./pages/LoginPage.jsx";
import OrderDetailPage from "./pages/OrderDetailPage.jsx";
import OrdersPage from "./pages/OrdersPage.jsx";
import ProductDetailPage from "./pages/ProductDetailPage.jsx";
import ProductsPage from "./pages/ProductsPage.jsx";
import RegisterPage from "./pages/RegisterPage.jsx";
import AdminBookFormPage from "./pages/admin/AdminBookFormPage.jsx";
import AdminBooksPage from "./pages/admin/AdminBooksPage.jsx";
import AdminCategoriesPage from "./pages/admin/AdminCategoriesPage.jsx";
import AdminOrdersPage from "./pages/admin/AdminOrdersPage.jsx";

const customer = (page) => <RequireAuth>{page}</RequireAuth>;
const admin = (page) => <RequireAuth role="admin">{page}</RequireAuth>;

export default function App() {
  return (
    <Routes>
      <Route element={<MainLayout />}>
        <Route path="/" element={<ProductsPage />} />
        <Route path="/books/:id" element={<ProductDetailPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />

        <Route path="/cart" element={customer(<CartPage />)} />
        <Route path="/checkout" element={customer(<CheckoutPage />)} />
        <Route path="/orders" element={customer(<OrdersPage />)} />
        <Route path="/orders/:id" element={customer(<OrderDetailPage />)} />

        <Route path="/admin/books" element={admin(<AdminBooksPage />)} />
        <Route path="/admin/books/new" element={admin(<AdminBookFormPage />)} />
        <Route path="/admin/books/:id" element={admin(<AdminBookFormPage />)} />
        <Route path="/admin/categories" element={admin(<AdminCategoriesPage />)} />
        <Route path="/admin/orders" element={admin(<AdminOrdersPage />)} />

        <Route path="*" element={<p>Không tìm thấy trang.</p>} />
      </Route>
    </Routes>
  );
}
```

✅ **Checkpoint:**

1. Đăng nhập `admin@bookstore.test` / `password` → thanh trên có mục "Quản trị". Đăng nhập tài khoản customer → **không** có mục này, và gõ tay `/admin/books` sẽ bị đưa về trang chủ.
2. Thêm sách mới có ảnh → xuất hiện ở trang chủ kèm ảnh; sửa sách (không chọn ảnh mới) → ảnh cũ giữ nguyên; chọn ảnh mới → ảnh đổi.
3. "Ẩn" một sách → biến mất khỏi trang chủ nhưng vẫn còn trong bảng admin với trạng thái "Đã ẩn"; đơn cũ có sách đó vẫn xem được.
4. Admin đổi trạng thái đơn theo đúng thứ tự; chuyển sai thứ tự (ví dụ `pending → completed` bằng Postman/DevTools) bị server từ chối 422.
5. **Kiểm tra quyền ở server:** đăng nhập bằng customer rồi gọi `GET /api/v1/admin/orders` (dán đường dẫn vào thanh địa chỉ trình duyệt) → `403`. Chưa đăng nhập → `401`.

```bash
cd ..
git add .
git commit -m "feat: admin area"
```

---

## Chặng 12. Kiểm thử và rà soát bảo mật

### 12.1. Test tự động cho các điểm dễ sai nhất

```bash
cd backend
php artisan make:test CheckoutTest
```

`tests/Feature/CheckoutTest.php` (thay toàn bộ nội dung):

```php
<?php

namespace Tests\Feature;

use App\Models\Book;
use App\Models\Category;
use App\Models\Order;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class CheckoutTest extends TestCase
{
    use RefreshDatabase;

    private function shipping(array $extra = []): array
    {
        return $extra + [
            'receiver_name' => 'An',
            'receiver_phone' => '0900000000',
            'shipping_address' => '1 Nguyễn Huệ, Quận 1',
        ];
    }

    private function makeBook(array $attributes = []): Book
    {
        Category::firstOrCreate(['name' => 'Test']);

        return Book::factory()->create($attributes);
    }

    public function test_server_calculates_total_and_reduces_stock(): void
    {
        $user = User::factory()->create();
        $book = $this->makeBook(['price' => 100000, 'stock' => 5]);
        $user->cartItems()->create(['book_id' => $book->id, 'quantity' => 2]);
        Sanctum::actingAs($user);

        // Client cố tình gửi total giả: server phải bỏ qua
        $this->postJson('/api/v1/orders', $this->shipping(['total' => 1]))
            ->assertCreated()
            ->assertJsonPath('data.total', 230000); // 2 x 100.000 + 30.000 phí giao hàng

        $this->assertSame(3, $book->fresh()->stock);
        $this->assertSame(0, $user->cartItems()->count());
    }

    public function test_cannot_order_more_than_stock(): void
    {
        $user = User::factory()->create();
        $book = $this->makeBook(['stock' => 1]);
        $user->cartItems()->create(['book_id' => $book->id, 'quantity' => 2]);
        Sanctum::actingAs($user);

        $this->postJson('/api/v1/orders', $this->shipping())->assertStatus(422);

        $this->assertSame(0, Order::count());
        $this->assertSame(1, $book->fresh()->stock);
    }

    public function test_empty_cart_is_rejected(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/v1/orders', $this->shipping())->assertStatus(422);
    }

    public function test_cancel_restores_stock(): void
    {
        $user = User::factory()->create();
        $book = $this->makeBook(['stock' => 5]);
        $user->cartItems()->create(['book_id' => $book->id, 'quantity' => 2]);
        Sanctum::actingAs($user);

        $orderId = $this->postJson('/api/v1/orders', $this->shipping())->json('data.id');
        $this->assertSame(3, $book->fresh()->stock);

        $this->postJson("/api/v1/orders/{$orderId}/cancel")->assertOk();
        $this->assertSame(5, $book->fresh()->stock);
    }

    public function test_user_cannot_view_another_users_order(): void
    {
        $owner = User::factory()->create();
        $order = Order::create([
            'user_id' => $owner->id, 'code' => 'TEST1', 'status' => 'pending',
            'receiver_name' => 'A', 'receiver_phone' => '0900000000', 'shipping_address' => 'x',
            'payment_method' => 'cod', 'subtotal' => 1, 'shipping_fee' => 0, 'total' => 1,
        ]);

        Sanctum::actingAs(User::factory()->create());

        $this->getJson("/api/v1/orders/{$order->id}")->assertNotFound();
    }

    public function test_customer_cannot_use_admin_api(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->getJson('/api/v1/admin/orders')->assertForbidden();
    }

    public function test_guest_cannot_see_cart(): void
    {
        $this->getJson('/api/v1/cart')->assertUnauthorized();
    }
}
```

```bash
php artisan test
```

> **An toàn dữ liệu:** `RefreshDatabase` **xoá sạch** database mà test đang dùng. Mặc định `phpunit.xml` của Laravel mới dùng SQLite in-memory (cần extension `pdo_sqlite`, Laragon đã bật sẵn). Nếu `phpunit.xml` của bạn trỏ tới MySQL, hãy tạo database riêng `bookstore_test` và trỏ vào đó; **tuyệt đối không** để test chạy trên database `bookstore` đang có dữ liệu.

### 12.2. Rà soát thủ công

| Việc cần thử | Kết quả đúng |
|---|---|
| Gọi `/api/v1/cart`, `/api/v1/orders` khi chưa đăng nhập | 401 |
| Customer gọi `/api/v1/admin/...` | 403 |
| Customer mở đơn của người khác | 404 |
| Tạo đơn khi sửa request gửi thêm `total`, `price` | Bị bỏ qua, tổng do server tính |
| Đăng ký với `role=admin` trong body (DevTools → Edit and resend) | Vẫn là `customer` |
| `GET /api/v1/books?sort=price;DROP TABLE` | Dùng kiểu sắp xếp mặc định, không lỗi SQL |
| Upload file `.php` hoặc ảnh > 2 MB ở form sách | Bị từ chối 422 |
| Đăng nhập sai 11 lần trong 1 phút | Lần thứ 11 trả 429 |
| Đặt hàng khi hết hàng | 422, không tạo đơn, kho không đổi |

### 12.3. Kiểm tra gói phụ thuộc và bản build

```bash
cd backend && composer audit
cd ../frontend && npm audit && npm run build
```

`npm run build` phải thành công (tạo thư mục `frontend/dist`). Xem `npm audit` và `composer audit` để biết gói nào có lỗ hổng đã công bố; cập nhật những gói quan trọng trước khi deploy.

✅ **Checkpoint:** `php artisan test` xanh toàn bộ; bảng 12.2 đạt hết; `npm run build` không lỗi.

```bash
cd ..
git add .
git commit -m "test: checkout and authorization tests"
git switch main && git merge develop && git push origin main && git switch develop
```

---

# PHẦN DEPLOY

M� hình triển khai: **một VPS, một tên miền**. Nginx phục vụ file tĩnh của React ở mọi đường dẫn, và chuyển `/api/...` cùng `/sanctum/...` sang Laravel (PHP-FPM). Vì giao diện và API cùng một origin nên **không cần cấu hình CORS** và cookie đăng nhập hoạt động đơn giản.

```text
Trình duyệt ──HTTPS──> Nginx ──┬─ /api, /sanctum ─> PHP-FPM ─> Laravel ─> MySQL
                               ├─ /storage/*     ─> ảnh upload
                               └─ mọi đường dẫn khác ─> frontend/dist (React)
```

---

## Chặng 13. Chuẩn bị VPS và tên miền

### 13.1. Mua dịch vụ

- **VPS:** Ubuntu 24.04 LTS, tối thiểu 1 vCPU và 2 GB RAM (1 GB vẫn chạy được nếu bật swap ở 13.4). Chọn máy chủ gần người dùng (Việt Nam hoặc Singapore).
- **Tên miền:** mua ở nhà đăng ký bất kỳ.

### 13.2. Trỏ tên miền về VPS

Trong trang quản lý DNS của tên miền, tạo bản ghi **A**: `yourdomain.com` → `IP_VPS`. Chờ vài phút đến vài giờ rồi kiểm tra từ máy bạn:

```bash
nslookup yourdomain.com     # phải ra đúng IP_VPS
```

### 13.3. Đăng nhập và tạo user riêng

```bash
ssh root@IP_VPS
adduser deploy
usermod -aG sudo deploy
exit

ssh deploy@IP_VPS
sudo apt update && sudo apt upgrade -y
```

Từ đây dùng user `deploy`, không làm việc thường ngày bằng `root`. Khi quen, hãy chuyển sang đăng nhập bằng SSH key và tắt đăng nhập bằng mật khẩu.

### 13.4. Cài phần mềm

```bash
sudo apt install -y nginx mysql-server git unzip curl software-properties-common

# PHP 8.4 (thay số nếu project của bạn yêu cầu phiên bản khác)
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y php8.4-fpm php8.4-cli php8.4-mysql php8.4-mbstring php8.4-xml \
  php8.4-curl php8.4-zip php8.4-bcmath php8.4-intl php8.4-gd

php -v
```

Composer (nên đối chiếu chữ ký theo hướng dẫn tại <https://getcomposer.org/download/>):

```bash
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
rm composer-setup.php
composer -V
```

Firewall — **cho phép SSH trước khi bật**, nếu không bạn sẽ tự khoá mình ngoài VPS:

```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo ufw status
```

Nếu VPS chỉ có 1 GB RAM, thêm swap để `composer install` không bị hết bộ nhớ:

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

Cho phép upload ảnh lớn hơn mặc định của PHP:

```bash
printf "upload_max_filesize=5M\npost_max_size=8M\n" | sudo tee /etc/php/8.4/fpm/conf.d/99-bookstore.ini
sudo systemctl restart php8.4-fpm
```

### 13.5. Tạo database và user cho ứng dụng

```bash
sudo mysql
```

```sql
CREATE DATABASE bookstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'bookstore_user'@'localhost' IDENTIFIED BY 'MAT_KHAU_RAT_MANH';
GRANT ALL PRIVILEGES ON bookstore.* TO 'bookstore_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Dùng mật khẩu dài, ngẫu nhiên (lưu trong trình quản lý mật khẩu). Ứng dụng chỉ dùng user `bookstore_user`, **không** dùng `root` của MySQL.

### 13.6. Lấy mã nguồn về VPS

Với repo private, tạo "deploy key" chỉ-đọc:

```bash
ssh-keygen -t ed25519 -C "bookstore-deploy" -f ~/.ssh/bookstore_deploy -N ""
cat ~/.ssh/bookstore_deploy.pub
```

Sao chép dòng in ra, vào GitHub: repo → **Settings → Deploy keys → Add deploy key** (không tick "Allow write access"). Rồi cấu hình SSH dùng key đó:

```bash
cat >> ~/.ssh/config <<'EOF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/bookstore_deploy
  IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config

sudo mkdir -p /var/www/bookstore
sudo chown deploy:deploy /var/www/bookstore
git clone git@github.com:TEN_TAI_KHOAN/TEN_REPO.git /var/www/bookstore
```

(Repo public thì clone bằng địa chỉ `https://...` là đủ.)

✅ **Checkpoint:** `php -v` ra 8.4; `composer -V` ra 2.x; `sudo systemctl status nginx` và `sudo systemctl status mysql` đang `active (running)`; thư mục `/var/www/bookstore/backend` và `/var/www/bookstore/frontend` có mã nguồn; truy cập `http://yourdomain.com` thấy trang chào mặc định của Nginx.

---

## Chặng 14. Deploy Backend (Laravel)

```bash
cd /var/www/bookstore/backend
composer install --no-dev --optimize-autoloader
cp .env.example .env
php artisan key:generate
nano .env
```

Các giá trị cần sửa trong `.env` production:

```env
APP_NAME=BookStore
APP_ENV=production
APP_DEBUG=false
APP_URL=https://yourdomain.com
LOG_LEVEL=warning

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bookstore
DB_USERNAME=bookstore_user
DB_PASSWORD="MAT_KHAU_RAT_MANH"

SESSION_DRIVER=database
SESSION_SECURE_COOKIE=true
SANCTUM_STATEFUL_DOMAINS=yourdomain.com
```

Lưu ý quan trọng:

- `APP_DEBUG=false` là bắt buộc. Nếu để `true`, lỗi sẽ in ra cả cấu hình và mật khẩu cho bất kỳ ai.
- `SANCTUM_STATEFUL_DOMAINS` phải **khớp đúng** tên miền người dùng gõ trên trình duyệt (không có `https://`).
- `APP_KEY` do `key:generate` tạo ra; giữ ổn định, **không** chạy lại sau khi đã có người dùng.
- Mật khẩu có ký tự đặc biệt thì đặt trong dấu ngoặc kép như trên.
- File `.env` không bao giờ được commit lên Git.

Tạo bảng:

```bash
php artisan migrate --force
```

Phân quyền để PHP-FPM (chạy bằng user `www-data`) ghi được log, cache và ảnh upload, mà không mở quyền ghi cho cả project:

```bash
cd /var/www/bookstore/backend
sudo chown -R deploy:www-data storage bootstrap/cache
sudo find storage bootstrap/cache -type d -exec chmod 2775 {} +
sudo find storage bootstrap/cache -type f -exec chmod 664 {} +
```

Tạo tài khoản Admin thật bằng mật khẩu mạnh (**không** chạy `db:seed`, vì seeder tạo tài khoản `admin@bookstore.test` / `password`):

```bash
php artisan tinker
```

```php
App\Models\User::forceCreate([
    'name' => 'Admin',
    'email' => 'admin@yourdomain.com',
    'password' => 'MAT_KHAU_ADMIN_MANH',
    'role' => 'admin',
]);
exit
```

> Đừng chạy `php artisan` bằng `sudo`: file log/cache tạo ra sẽ thuộc về `root` và PHP-FPM không ghi được nữa (lỗi "could not be opened in append mode").

✅ **Checkpoint:** `php artisan migrate:status` hiện toàn bộ migration là `Ran`; trong MySQL (`sudo mysql bookstore -e "select email, role from users;"`) có đúng 1 user admin của bạn. (Chưa test qua trình duyệt được vì chưa cấu hình Nginx; sang chặng sau.)

---

## Chặng 15. Deploy Frontend, cấu hình Nginx và HTTPS

### 15.1. Build và upload frontend

Thực hiện **trên máy của bạn** (không phải trên VPS):

```bash
cd frontend
npm ci
npm run build
ssh deploy@IP_VPS "rm -rf /var/www/bookstore/frontend/dist"
scp -r dist deploy@IP_VPS:/var/www/bookstore/frontend/
```

Frontend gọi API bằng đường dẫn tương đối `/api/v1`, nên **không có biến môi trường nào** phải đổi khi build cho production. Thư mục `dist` nằm ngoài Git (đã được `.gitignore` của Vite loại) nên `git pull` sau này không đụng tới nó.

### 15.2. Cấu hình Nginx

Trên VPS:

```bash
sudo nano /etc/nginx/sites-available/bookstore
```

Dán nội dung sau (thay `yourdomain.com`; nếu bạn dùng PHP phiên bản khác 8.4 thì sửa tên socket `php8.4-fpm.sock`):

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name yourdomain.com;

    root /var/www/bookstore/frontend/dist;
    index index.html;

    client_max_body_size 5M;

    # Laravel: API và route lấy cookie CSRF của Sanctum
    location ~ ^/(api|sanctum)/ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME /var/www/bookstore/backend/public/index.php;
        fastcgi_param SCRIPT_NAME /index.php;
        fastcgi_param DOCUMENT_ROOT /var/www/bookstore/backend/public;
    }

    # Ảnh sách do Admin upload
    location /storage/ {
        alias /var/www/bookstore/backend/storage/app/public/;
        expires 7d;
        access_log off;
    }

    # File build của Vite có tên băm nên cache được lâu
    location /assets/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        try_files $uri =404;
    }

    # React Router: mọi đường dẫn khác trả về index.html (để F5 không bị 404)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Chặn các file ẩn (.env, .git, ...)
    location ~ /\.(?!well-known) {
        deny all;
    }
}
```

Chỉ `public/index.php` của Laravel được thực thi qua web; phần còn lại của `backend/` (gồm `.env`, `vendor`) **không** nằm trong thư mục web nên không thể tải về.

Bật cấu hình:

```bash
sudo ln -s /etc/nginx/sites-available/bookstore /etc/nginx/sites-enabled/bookstore
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t                     # phải báo "syntax is ok" và "test is successful"
sudo systemctl reload nginx
```

Thử trước khi có HTTPS: `curl -i http://yourdomain.com/api/v1/categories` phải trả `200` và JSON danh mục (rỗng `{"data":[]}` cũng được vì mới có database trống).

### 15.3. Bật HTTPS (Let's Encrypt)

DNS phải đã trỏ đúng về VPS (Chặng 13.2).

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com
```

Chọn chuyển hướng HTTP sang HTTPS khi được hỏi. Certbot tự sửa file cấu hình Nginx và tự gia hạn chứng chỉ. Kiểm tra gia hạn:

```bash
sudo certbot renew --dry-run
```

### 15.4. Tối ưu Laravel (làm sau khi `.env` đã đúng)

```bash
cd /var/www/bookstore/backend
php artisan optimize          # cache config, route, event, view
sudo systemctl reload php8.4-fpm
```

> Sau khi cache cấu hình, **sửa `.env` sẽ không có tác dụng** cho đến khi chạy lại `php artisan optimize` (hoặc `php artisan config:clear` để huỷ cache).

✅ **Checkpoint:**

1. `https://yourdomain.com` mở ra trang chủ BookStore (danh sách sách trống vì database mới; có ổ khoá HTTPS hợp lệ).
2. Mở `http://yourdomain.com` tự chuyển sang `https://`.
3. Mở trực tiếp `https://yourdomain.com/cart`, bấm F5 → vẫn hiện trang (không 404).
4. Đăng nhập bằng tài khoản admin vừa tạo → thấy mục "Quản trị".

---

## Chặng 16. Kiểm tra sau deploy, backup và bảo trì

### 16.1. Smoke test trên production

Lần lượt, bằng trình duyệt (cả điện thoại nếu có):

1. Đăng nhập Admin → tạo 1 danh mục → thêm 1 sách có ảnh → ảnh hiển thị ở trang chủ.
2. Đăng xuất, đăng ký một tài khoản customer thật.
3. Tìm sách, xem chi tiết, thêm vào giỏ, đặt hàng COD.
4. Xem lịch sử đơn và chi tiết đơn.
5. Đăng nhập Admin → thấy đơn mới → chuyển `pending → confirmed → shipping → completed`.
6. Kiểm tra kỹ thuật: DevTools → Console không có lỗi đỏ; Network không có request nào tới `localhost`; không có cảnh báo mixed content; `https://yourdomain.com/.env` và `https://yourdomain.com/.git/config` đều **không** trả nội dung.
7. Cố tình gây lỗi (ví dụ đặt khi hết hàng) → người dùng thấy thông báo thân thiện, không thấy stack trace.

### 16.2. Backup tự động

Tạo file thông tin đăng nhập MySQL riêng cho script (không để mật khẩu trong lệnh):

```bash
nano ~/.my.cnf
```

```ini
[client]
user=bookstore_user
password=MAT_KHAU_RAT_MANH
```

```bash
chmod 600 ~/.my.cnf
nano ~/backup.sh
```

```bash
#!/bin/bash
set -e
DIR=/home/deploy/backups
DATE=$(date +%F)
mkdir -p "$DIR"
mysqldump --single-transaction --no-tablespaces bookstore | gzip > "$DIR/db-$DATE.sql.gz"
tar -czf "$DIR/uploads-$DATE.tar.gz" -C /var/www/bookstore/backend/storage/app public
find "$DIR" -type f -mtime +14 -delete    # giữ 14 ngày gần nhất
```

```bash
chmod +x ~/backup.sh
~/backup.sh && ls -lh ~/backups
crontab -e
```

Thêm dòng sau vào crontab (chạy lúc 2 giờ sáng mỗi ngày):

```cron
0 2 * * * /home/deploy/backup.sh
```

**Backup chỉ nằm trên chính VPS thì chưa đủ an toàn** (VPS hỏng là mất cả hai). Định kỳ chép thư mục `~/backups` về máy khác hoặc dịch vụ lưu trữ đám mây, ví dụ từ máy của bạn: `scp -r deploy@IP_VPS:/home/deploy/backups .`

**Thử restore ít nhất một lần** (backup chưa từng thử khôi phục thì chưa thể tin cậy):

```bash
sudo mysql -e "CREATE DATABASE bookstore_restore_test CHARACTER SET utf8mb4;"
gunzip < ~/backups/db-YYYY-MM-DD.sql.gz | sudo mysql bookstore_restore_test
sudo mysql bookstore_restore_test -e "select count(*) from books;"
sudo mysql -e "DROP DATABASE bookstore_restore_test;"
```

### 16.3. Quy trình cập nhật phiên bản mới

Backend (trên VPS):

```bash
~/backup.sh                                  # luôn backup trước khi cập nhật
cd /var/www/bookstore
git pull origin main
cd backend
composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan optimize
sudo systemctl reload php8.4-fpm
```

Frontend (trên máy của bạn):

```bash
cd frontend
npm ci && npm run build
ssh deploy@IP_VPS "rm -rf /var/www/bookstore/frontend/dist"
scp -r dist deploy@IP_VPS:/var/www/bookstore/frontend/
```

### 16.4. Khi bản mới bị lỗi (rollback)

1. Xem log để biết lỗi gì: `tail -n 100 /var/www/bookstore/backend/storage/logs/laravel.log` và `sudo tail -n 50 /var/log/nginx/error.log`.
2. Quay về commit tốt gần nhất: `git log --oneline` rồi `git checkout <mã-commit-tốt>` trong `/var/www/bookstore`, chạy lại `composer install --no-dev --optimize-autoloader` và `php artisan optimize`. (Sau khi sửa xong, quay lại `git checkout main`.)
3. Nếu migration của bản lỗi đã sửa hoặc xoá dữ liệu, khôi phục database từ backup vừa tạo ở bước đầu của 16.3.
4. Với frontend: build lại từ commit tốt rồi upload lại `dist`.

### 16.5. Việc định kỳ

| Tần suất | Việc |
|---|---|
| Hằng ngày | Backup tự chạy; thỉnh thoảng xem `laravel.log` có lỗi lạ không |
| Hằng tuần | Kiểm tra dung lượng đĩa (`df -h`), RAM (`free -h`) |
| Hằng tháng | `sudo apt update && sudo apt upgrade`; `composer audit` và `npm audit`; thử restore backup |
| Khi cần | `sudo certbot renew --dry-run` để chắc chắn HTTPS vẫn tự gia hạn |

✅ **Checkpoint cuối:** smoke test 16.1 đạt; `~/backups` có file `.sql.gz` và `.tar.gz` mới; đã thử restore thành công; bạn biết lệnh cập nhật và rollback.

---

## Phụ lục A. Lỗi thường gặp và cách xử lý

| Hiện tượng | Nguyên nhân thường gặp | Cách xử lý |
|---|---|---|
| `419` / `CSRF token mismatch` khi đăng nhập | Chưa gọi `/sanctum/csrf-cookie` trước `POST`; `SANCTUM_STATEFUL_DOMAINS` không khớp địa chỉ trên thanh URL | Dev: `localhost:5173`; production: `yourdomain.com`. Truy cập bằng `localhost`, không dùng `127.0.0.1:5173` |
| Đăng nhập xong nhưng `/me` vẫn `401` | Thiếu `$middleware->statefulApi()`; thiếu `withCredentials`; stateful domain sai | Đối chiếu Chặng 3.3, `api.js` (Chặng 8.2) và `.env` |
| `Session store not set on request` | Gọi API đăng nhập từ Postman/curl (không phải request "stateful") | Thử đăng nhập từ giao diện React; test API bằng Feature test |
| Vite báo `ECONNREFUSED` ở proxy | `php artisan serve` chưa chạy, hoặc proxy dùng `localhost` bị phân giải IPv6 | Chạy backend; dùng `http://127.0.0.1:8000` trong `vite.config.js` |
| Lỗi validate lại trả về trang HTML / chuyển hướng | Thiếu header `Accept: application/json` | Kiểm tra `api.js` |
| `SQLSTATE[HY000] [2002] Connection refused` | MySQL chưa chạy, hoặc sai `DB_HOST`/`DB_PORT` | Bật MySQL; sửa `.env` (production nhớ `php artisan optimize` lại) |
| `SQLSTATE[42S02] Base table or view not found` | Chưa chạy migration | `php artisan migrate` (production: thêm `--force`) |
| `SQLSTATE[23000] ... foreign key constraint fails` | Migration sai thứ tự; hoặc xoá bản ghi đang được bảng khác tham chiếu | Kiểm tra thứ tự file migration (Chặng 5.1); xoá dữ liệu con trước |
| Ảnh không hiện khi dev | Chưa `php artisan storage:link`, hoặc thiếu `/storage` trong proxy | Chạy lệnh; kiểm tra `vite.config.js` |
| Ảnh `404` trên production | Sai đường dẫn `alias` trong Nginx, hoặc thiếu quyền đọc | Kiểm tra file thật ở `backend/storage/app/public/books/`; kiểm tra quyền thư mục |
| `Unable to prepare route ... for serialization. Uses Closure` khi `optimize` | Còn route dùng closure (route `/ping`) | Xoá route `/ping` (Chặng 7.4) |
| `500` trên production | Nhiều nguyên nhân | Đọc `storage/logs/laravel.log` trước tiên; kiểm tra quyền `storage`, nội dung `.env`, đã `migrate` chưa |
| `could not be opened in append mode` (log) | Quyền thư mục `storage`, hoặc từng chạy `artisan` bằng `sudo` | Làm lại phân quyền ở Chặng 14 |
| `502 Bad Gateway` | PHP-FPM không chạy hoặc sai tên socket | `sudo systemctl status php8.4-fpm`; `ls /run/php/` rồi sửa `fastcgi_pass` |
| `/api/...` trả `404` kiểu trang Nginx | Nginx không khớp location | `sudo nginx -t`; kiểm tra regex `^/(api|sanctum)/` |
| `/api/...` trả `404` JSON "route could not be found" | Laravel nhận sai đường dẫn | Kiểm tra 3 dòng `fastcgi_param` (`SCRIPT_FILENAME`, `SCRIPT_NAME`, `DOCUMENT_ROOT`) và `php artisan route:list` trên server |
| F5 ở `/cart`, `/orders/3` bị `404` | Thiếu `try_files ... /index.html` | Kiểm tra `location /` |
| `413 Request Entity Too Large` | Giới hạn upload | `client_max_body_size` (Nginx) và `upload_max_filesize`, `post_max_size` (PHP) |
| Đăng nhập được nhưng mất đăng nhập ngay trên production | `SESSION_SECURE_COOKIE=true` nhưng đang truy cập bằng HTTP; hoặc stateful domain không khớp | Truy cập bằng HTTPS; kiểm tra `.env` rồi `php artisan optimize` |
| Sửa `.env` production không có tác dụng | Cấu hình đang được cache | `php artisan optimize` |
| Giao diện không có style Tailwind | Thiếu plugin `tailwindcss()` trong `vite.config.js` hoặc thiếu `@import "tailwindcss";` | Đối chiếu Chặng 4.2 |
| Sau deploy vẫn thấy giao diện cũ | Chưa upload `dist` mới hoặc trình duyệt cache | Upload lại; `Ctrl+Shift+R` |

## Phụ lục B. `routes/api.php` hoàn chỉnh

```php
<?php

use App\Http\Controllers\Api\AdminBookController;
use App\Http\Controllers\Api\AdminCategoryController;
use App\Http\Controllers\Api\AdminOrderController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BookController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\OrderController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    // Công khai
    Route::get('/categories', [CategoryController::class, 'index']);
    Route::get('/books', [BookController::class, 'index']);
    Route::get('/books/{id}', [BookController::class, 'show'])->whereNumber('id');

    Route::post('/register', [AuthController::class, 'register'])->middleware('throttle:10,1');
    Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:10,1');

    // Cần đăng nhập
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me', [AuthController::class, 'me']);

        Route::get('/cart', [CartController::class, 'index']);
        Route::post('/cart/items', [CartController::class, 'store']);
        Route::patch('/cart/items/{id}', [CartController::class, 'update'])->whereNumber('id');
        Route::delete('/cart/items/{id}', [CartController::class, 'destroy'])->whereNumber('id');

        Route::get('/orders', [OrderController::class, 'index']);
        Route::post('/orders', [OrderController::class, 'store'])->middleware('throttle:10,1');
        Route::get('/orders/{id}', [OrderController::class, 'show'])->whereNumber('id');
        Route::post('/orders/{id}/cancel', [OrderController::class, 'cancel'])->whereNumber('id');

        // Chỉ Admin
        Route::middleware('admin')->prefix('admin')->group(function () {
            Route::apiResource('books', AdminBookController::class);
            Route::apiResource('categories', AdminCategoryController::class)->except('show');
            Route::get('/orders', [AdminOrderController::class, 'index']);
            Route::get('/orders/{order}', [AdminOrderController::class, 'show']);
            Route::patch('/orders/{order}/status', [AdminOrderController::class, 'updateStatus']);
        });
    });
});
```

## Phụ lục C. Sau khi MVP chạy ổn: nên làm gì tiếp

Làm từng việc một, mỗi việc theo vòng "yêu cầu → database → API → React → test → commit". Phần mô tả chi tiết của hầu hết mục dưới đây có trong roadmap của bạn.

| Việc | Ghi chú |
|---|---|
| Hồ sơ cá nhân, sổ địa chỉ, đổi mật khẩu | Thêm bảng `addresses` |
| Tách bảng tác giả, nhà xuất bản; nhiều ảnh cho một sách | Quan hệ nhiều-nhiều; bảng `book_images` |
| Voucher | Kiểm tra hạn dùng, giá trị tối thiểu, lượt dùng; **tính ở server** |
| Đánh giá, wishlist | Chỉ cho đánh giá khi đã mua (tuỳ chính sách) |
| Email xác nhận đơn | Cần Queue + worker (Supervisor) để không làm chậm request |
| Thanh toán online | Xác minh chữ ký callback/webhook ở server, xử lý webhook theo kiểu idempotent; không tin trang "thanh toán thành công" của frontend |
| Lịch sử trạng thái đơn, báo cáo doanh thu | Bảng `order_status_histories` |
| TanStack Query, React Hook Form | Khi số trang gọi API nhiều lên |
| Test E2E (Playwright), CI/CD, môi trường staging | Khi đã có người dùng thật |
| Giám sát (uptime, log tập trung), CDN, Redis | Chỉ khi **đo được** vấn đề, đừng thêm cho "có công nghệ" |

---

*Hết. Chúc bạn deploy thành công. Khi gặp lỗi, hãy quay lại quy trình ở mục 0.4: đọc kỹ lỗi → xác định tầng → xem log → tìm đúng phiên bản → đổi từng thứ một.*
