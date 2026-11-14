# LỘ TRÌNH XÂY DỰNG WEBSITE THƯƠNG MẠI ĐIỆN TỬ

> **Stack:** React + Tailwind CSS + Laravel REST API + MySQL  
> **Ví dụ xuyên suốt:** Website bán sách `BookStore`  
> **Mục tiêu:** Đi từ ý tưởng, phân tích nghiệp vụ, thiết kế, lập trình, kiểm thử đến triển khai (Deploy), vận hành và bảo trì.

---

## MỤC LỤC

- [0. Cách sử dụng tài liệu và phương pháp tự tìm lời giải](#0-cách-sử-dụng-tài-liệu-và-phương-pháp-tự-tìm-lời-giải)
- [1. Tổng quan kiến trúc và thứ tự thực hiện](#1-tổng-quan-kiến-trúc-và-thứ-tự-thực-hiện)
- [2. Giai đoạn 1 – Phân tích yêu cầu](#2-giai-đoạn-1--phân-tích-yêu-cầu)
- [3. Giai đoạn 2 – Phân tích nghiệp vụ và thiết kế luồng](#3-giai-đoạn-2--phân-tích-nghiệp-vụ-và-thiết-kế-luồng)
- [4. Giai đoạn 3 – Thiết kế kiến trúc hệ thống và API](#4-giai-đoạn-3--thiết-kế-kiến-trúc-hệ-thống-và-api)
- [5. Giai đoạn 4 – Thiết kế UI/UX](#5-giai-đoạn-4--thiết-kế-uiux)
- [6. Giai đoạn 5 – Thiết kế Database và ERD](#6-giai-đoạn-5--thiết-kế-database-và-erd)
- [7. Giai đoạn 6 – Khởi tạo dự án, môi trường và Git](#7-giai-đoạn-6--khởi-tạo-dự-án-môi-trường-và-git)
- [8. Giai đoạn 7 – Xây dựng Backend Laravel](#8-giai-đoạn-7--xây-dựng-backend-laravel)
- [9. Giai đoạn 8 – Xây dựng Frontend React và Tailwind](#9-giai-đoạn-8--xây-dựng-frontend-react-và-tailwind)
- [10. Giai đoạn 9 – Tích hợp Frontend với Backend](#10-giai-đoạn-9--tích-hợp-frontend-với-backend)
- [11. Giai đoạn 10 – Hoàn thiện nghiệp vụ thương mại điện tử](#11-giai-đoạn-10--hoàn-thiện-nghiệp-vụ-thương-mại-điện-tử)
- [12. Giai đoạn 11 – Kiểm thử toàn hệ thống](#12-giai-đoạn-11--kiểm-thử-toàn-hệ-thống)
- [13. Giai đoạn 12 – Bảo mật và tối ưu hiệu năng](#13-giai-đoạn-12--bảo-mật-và-tối-ưu-hiệu-năng)
- [14. Giai đoạn 13 – Chuẩn bị Production](#14-giai-đoạn-13--chuẩn-bị-production)
- [15. Giai đoạn 14 – Deploy Backend Laravel](#15-giai-đoạn-14--deploy-backend-laravel)
- [16. Giai đoạn 15 – Deploy Frontend React](#16-giai-đoạn-15--deploy-frontend-react)
- [17. Giai đoạn 16 – Kiểm tra sau Deploy và bảo trì](#17-giai-đoạn-16--kiểm-tra-sau-deploy-và-bảo-trì)
- [18. Lộ trình code theo module và Sprint](#18-lộ-trình-code-theo-module-và-sprint)
- [19. Quy trình tìm kiếm và xử lý lỗi kỹ thuật](#19-quy-trình-tìm-kiếm-và-xử-lý-lỗi-kỹ-thuật)
- [20. Bộ tài liệu cần lưu trong dự án](#20-bộ-tài-liệu-cần-lưu-trong-dự-án)
- [21. Checklist tổng trước khi công bố website](#21-checklist-tổng-trước-khi-công-bố-website)
- [22. Nguồn tài liệu chính thức](#22-nguồn-tài-liệu-chính-thức)

---

# 0. Cách sử dụng tài liệu và phương pháp tự tìm lời giải

Tài liệu này không phải danh sách lệnh để sao chép một lần. Hãy dùng nó như **bản đồ triển khai dự án**. Mỗi giai đoạn cần có đầu vào, công việc, đầu ra và điều kiện nghiệm thu rõ ràng.

## 0.1. Quy tắc học và làm theo từng vòng nhỏ

Với mỗi chức năng, hãy đi theo vòng lặp sau:

1. **Hiểu yêu cầu:** Chức năng dành cho ai? Người dùng bắt đầu từ đâu? Kết quả mong muốn là gì?
2. **Tìm tài liệu:** Xác định khái niệm, API hoặc kỹ thuật cần sử dụng; ưu tiên tài liệu chính thức.
3. **Thiết kế:** Phác thảo luồng dữ liệu, API, bảng dữ liệu và giao diện liên quan.
4. **Code phần nhỏ nhất:** Không viết một lúc toàn bộ module.
5. **Chạy thử:** Kiểm tra ngay sau khi code một phần.
6. **Kiểm thử trường hợp lỗi:** Dữ liệu thiếu, sai, không có quyền, tài nguyên không tồn tại, kết nối lỗi.
7. **Ghi lại:** Cập nhật README, tài liệu API, ghi chú quyết định kỹ thuật và Git commit.

Ví dụ với chức năng danh sách sách:

- Chốt dữ liệu một quyển sách cần hiển thị.
- Thiết kế `books` và quan hệ với `categories`.
- Viết Migration, Model, dữ liệu mẫu.
- Tạo API `GET /api/v1/books`.
- Kiểm tra API bằng Postman.
- Tạo `bookService.js` ở React.
- Gọi API trong trang danh sách.
- Hiển thị Loading, Error, Empty và Success.
- Kiểm tra tìm kiếm, lọc và phân trang.
- Commit khi chức năng ổn định.

## 0.2. Cách tìm kiếm tài liệu kỹ thuật hiệu quả

Không nên tìm bằng câu quá chung như `làm website bán hàng`. Hãy tìm theo **công nghệ + phiên bản + tác vụ + lỗi hoặc kết quả mong muốn**.

Công thức tìm kiếm:

```text
[framework/library] + [version] + [specific task] + [official docs/example/error]
```

Ví dụ:

```text
Laravel 13 Form Request validation official documentation
React Vite Tailwind CSS 4 installation official docs
Laravel Sanctum SPA authentication React Axios CSRF official docs
MySQL foreign key constraint InnoDB documentation
```

### Thứ tự ưu tiên nguồn tìm kiếm

1. **Tài liệu chính thức:** Định nghĩa, cấu hình, API, yêu cầu phiên bản.
2. **GitHub Issues / Discussions của dự án:** Lỗi cụ thể đã được xác nhận, cách khắc phục và phiên bản bị ảnh hưởng.
3. **Stack Overflow:** Tình huống thực tế; phải xem ngày đăng, phiên bản và câu trả lời được xác nhận.
4. **Bài viết kỹ thuật có mã nguồn:** Dùng để tham khảo cách tổ chức hoặc ví dụ.
5. **Video:** Hữu ích khi cần quan sát thao tác công cụ, nhưng không nên xem là nguồn duy nhất.

Không lấy một tutorial cũ làm chuẩn nếu phiên bản trong video khác phiên bản đang cài. Ví dụ, hướng dẫn Tailwind CSS v3 có cấu hình khác Tailwind CSS v4; hướng dẫn Laravel 10/11 có thể khác Laravel mới hơn.

### Cách lọc kết quả Google

Có thể dùng các cú pháp:

| Cú pháp | Công dụng | Ví dụ |
|---|---|---|
| `site:` | Chỉ tìm trong một website | `site:laravel.com/docs sanctum SPA` |
| `"..."` | Tìm đúng cụm từ | `"SQLSTATE[23000]" Laravel` |
| `-từ` | Loại kết quả không mong muốn | `Laravel Sanctum SPA -JWT` |
| `filetype:` | Tìm loại file | `ecommerce ERD filetype:pdf` |
| `after:` | Giới hạn kết quả mới hơn | `Tailwind CSS Vite after:2025-01-01` |
| `OR` | Tìm một trong nhiều cụm | `Laravel queue OR job worker` |

### Cách đánh giá một hướng dẫn trước khi áp dụng

- Hướng dẫn dùng phiên bản nào?
- Phiên bản đó có khớp `package.json`, `composer.json` và môi trường của dự án không?
- Tác giả có giải thích nguyên nhân hay chỉ đưa lệnh?
- Có dùng API đã bị deprecated không?
- Hướng dẫn có đề cập bảo mật, lỗi và trường hợp ngoại lệ không?
- Có thể đối chiếu với tài liệu chính thức không?
- Có phù hợp với kiến trúc React SPA gọi Laravel API không, hay thực chất là Laravel Blade render giao diện?

## 0.3. Cách đặt câu hỏi khi tìm kiếm hoặc hỏi AI

Một câu hỏi kỹ thuật tốt cần cung cấp:

- Công nghệ và phiên bản.
- Mục tiêu cụ thể.
- Cấu trúc hoặc đoạn code liên quan.
- Kết quả mong đợi.
- Kết quả thực tế.
- Thông báo lỗi đầy đủ.
- Những cách đã thử.

Mẫu câu hỏi:

```text
Mình dùng React [version] + Vite [version] + Tailwind [version],
Laravel [version], PHP [version], MySQL [version].

Mục tiêu: [mô tả]
Cấu trúc hiện tại: [đường dẫn/file]
Đoạn code liên quan: [code tối thiểu]
Kết quả mong đợi: [expected]
Kết quả thực tế: [actual]
Lỗi: [full error]
Đã thử: [các cách đã thử]

Hãy giải thích nguyên nhân trước, sau đó đề xuất cách sửa phù hợp với đúng phiên bản.
```

**Không gửi lên AI hoặc diễn đàn:** mật khẩu, API key, file `.env`, token thật, dữ liệu khách hàng, thông tin thanh toán hoặc dữ liệu riêng tư.

---

# 1. Tổng quan kiến trúc và thứ tự thực hiện

## 1.1. Stack công nghệ

| Thành phần | Công nghệ | Trách nhiệm |
|---|---|---|
| Frontend | React | Component, giao diện, tương tác, điều hướng |
| CSS | Tailwind CSS | Utility-first styling, responsive UI |
| Build tool | Vite | Dev server, build tài nguyên frontend |
| Routing | React Router | Điều hướng trang SPA |
| HTTP client | Axios hoặc Fetch | Gọi API Laravel |
| Server state | TanStack Query (nếu cần) | Cache, loading, refetch dữ liệu API |
| Backend | Laravel | REST API, nghiệp vụ, xác thực, phân quyền |
| ORM | Eloquent | Truy vấn và quan hệ dữ liệu |
| Database | MySQL | Lưu trữ dữ liệu nghiệp vụ |
| Authentication | Laravel Sanctum | Session/cookie cho SPA hoặc API token cho client phù hợp |
| Testing | PHPUnit/Pest, Vitest, Playwright | Unit, integration, end-to-end |
| Deployment | VPS/Cloud + Nginx hoặc nền tảng hosting | Đưa website lên Internet |

> Chọn phiên bản tương thích với nhau trước khi khởi tạo. Không mặc định rằng phiên bản mới nhất của mọi thư viện luôn tương thích với nhau. Kiểm tra yêu cầu PHP, Node.js, Composer và package peer dependencies từ tài liệu của từng công nghệ.

## 1.2. Kiến trúc Client – Server

```text
CUSTOMER / ADMIN
       |
       v
REACT + TAILWIND (FRONTEND)
Pages / Components / Hooks / State / API Services
       |
       | HTTP Request / JSON Response
       v
LARAVEL REST API (BACKEND)
Routes -> Middleware -> Controller -> Request Validation
       -> Service/Domain Logic -> Eloquent Model
       |
       v
MYSQL DATABASE
```

Luồng lấy danh sách sách:

1. Người dùng mở `ProductsPage`.
2. React gọi `bookService.getBooks()`.
3. Axios gửi `GET /api/v1/books`.
4. Laravel Router tìm route phù hợp.
5. Middleware thực hiện các kiểm tra cần thiết.
6. Controller nhận request và gọi tầng xử lý.
7. Eloquent truy vấn MySQL.
8. API Resource định dạng JSON.
9. Laravel trả HTTP Response.
10. React nhận dữ liệu và render danh sách.

## 1.3. Nguyên tắc phân chia trách nhiệm

- React **không kết nối trực tiếp** MySQL.
- React không được quyết định giá cuối cùng, quyền Admin, tồn kho hoặc trạng thái thanh toán.
- Laravel phải kiểm tra lại dữ liệu quan trọng từ phía server.
- Database phải có khóa, ràng buộc và chỉ mục phù hợp.
- API phải có quy tắc đặt tên, cấu trúc response và mã lỗi thống nhất.
- Mỗi module cần có kiểm thử tối thiểu trước khi ghép vào luồng tổng.

## 1.4. Trình tự tổng thể 16 giai đoạn

1. Phân tích yêu cầu.
2. Phân tích nghiệp vụ và sơ đồ luồng.
3. Thiết kế kiến trúc và API.
4. Thiết kế UI/UX.
5. Thiết kế Database/ERD.
6. Khởi tạo dự án, môi trường và Git.
7. Xây dựng Backend.
8. Xây dựng Frontend.
9. Tích hợp Frontend – Backend.
10. Hoàn thiện nghiệp vụ thương mại điện tử.
11. Kiểm thử.
12. Bảo mật và tối ưu.
13. Chuẩn bị Production.
14. Deploy Backend.
15. Deploy Frontend.
16. Kiểm tra và bảo trì.

Trong thực tế, một số hoạt động được lặp lại. Ví dụ, khi làm module Product, ta thiết kế dữ liệu, code API, code giao diện, tích hợp và kiểm thử ngay; không cần đợi hoàn thành tất cả module mới kiểm thử.

---

# 2. Giai đoạn 1 – Phân tích yêu cầu

## Mục tiêu

Xác định website giải quyết vấn đề gì, ai sử dụng, có chức năng nào và phạm vi phiên bản đầu tiên đến đâu.

## 2.1. Xác định phạm vi dự án

Viết mô tả ngắn:

- Tên dự án: `BookStore`.
- Loại hệ thống: Website thương mại điện tử bán sách.
- Khách hàng mục tiêu: Người mua sách trực tuyến.
- Người vận hành: Admin/nhân viên quản lý.
- Kênh sử dụng: Trình duyệt desktop, tablet và mobile.
- Hình thức giao hàng: Giao đến địa chỉ khách hàng.
- Thanh toán ban đầu: COD; cổng trực tuyến có thể triển khai ở phiên bản sau.

Trả lời các câu hỏi:

1. Bán loại sản phẩm nào?
2. Khách có thể xem hàng mà không đăng nhập không?
3. Có bắt buộc đăng nhập khi đặt hàng không?
4. Có cho phép khách đặt hàng không cần tài khoản không?
5. Các phương thức thanh toán nào được hỗ trợ?
6. Ai quản lý sản phẩm, tồn kho và đơn hàng?
7. Có cần quản lý nhiều vai trò nhân viên không?
8. Có cần voucher, đánh giá, wishlist và tích hợp vận chuyển không?
9. Website cần hỗ trợ ngôn ngữ và tiền tệ nào?
10. Mục tiêu MVP là gì?

## 2.2. Xác định Actor

### Guest – Khách chưa đăng nhập

- Xem trang chủ.
- Xem danh sách và chi tiết sản phẩm.
- Tìm kiếm, lọc, sắp xếp.
- Đăng ký/đăng nhập.
- Có thể giữ giỏ hàng tạm thời nếu thiết kế hỗ trợ.

### Customer – Khách đã đăng nhập

- Quản lý hồ sơ.
- Quản lý địa chỉ.
- Quản lý giỏ hàng.
- Đặt hàng.
- Theo dõi đơn hàng.
- Hủy đơn theo điều kiện.
- Đánh giá sản phẩm đã mua nếu chính sách cho phép.
- Quản lý wishlist.

### Admin – Quản trị viên

- Quản lý sản phẩm, danh mục, tác giả, nhà xuất bản.
- Quản lý khách hàng.
- Quản lý đơn hàng và trạng thái.
- Quản lý voucher.
- Quản lý đánh giá.
- Theo dõi tồn kho.
- Xem báo cáo.

Có thể bổ sung Staff/Manager sau này. Không nên thiết kế hệ thống phân quyền quá phức tạp nếu MVP chỉ có một loại Admin.

## 2.3. Liệt kê chức năng theo module

| Module | Chức năng |
|---|---|
| Authentication | Register, Login, Logout, lấy người dùng hiện tại |
| User | Hồ sơ, địa chỉ, đổi mật khẩu |
| Catalog | Danh mục, sản phẩm, tác giả, nhà xuất bản |
| Search | Từ khóa, lọc, sắp xếp, phân trang |
| Cart | Thêm, sửa số lượng, xóa, xem giỏ hàng |
| Checkout | Địa chỉ, phí giao hàng, voucher, xác nhận đơn |
| Order | Lịch sử, chi tiết, hủy, cập nhật trạng thái |
| Payment | COD hoặc cổng thanh toán |
| Promotion | Voucher, điều kiện và giới hạn sử dụng |
| Review | Đánh giá, phản hồi, kiểm duyệt |
| Wishlist | Thêm/xóa sản phẩm yêu thích |
| Inventory | Tồn kho, nhập/xuất/điều chỉnh |
| Admin | Dashboard và màn hình quản trị |
| Notification | Email/thông báo trạng thái |

## 2.4. Phân chia MVP và phiên bản mở rộng

### MVP nên có

- Đăng ký, đăng nhập, đăng xuất.
- Danh sách sản phẩm và chi tiết sản phẩm.
- Danh mục.
- Tìm kiếm, lọc, sắp xếp, phân trang cơ bản.
- Giỏ hàng.
- Checkout COD.
- Lịch sử đơn hàng.
- Admin CRUD sản phẩm/danh mục.
- Admin quản lý đơn hàng.
- Kiểm tra tồn kho cơ bản.

### Giai đoạn mở rộng

- Cổng thanh toán trực tuyến.
- Voucher nâng cao.
- Review và rating.
- Wishlist.
- Email/notification.
- Tích hợp vận chuyển.
- Báo cáo doanh thu nâng cao.
- Redis, search engine hoặc kiến trúc mở rộng khi thực sự cần.

## 2.5. Viết User Story và Acceptance Criteria

Mẫu User Story:

```text
Là [vai trò], tôi muốn [hành động] để [giá trị nhận được].
```

Ví dụ:

```text
Là khách hàng, tôi muốn thêm sách vào giỏ hàng
để có thể mua nhiều quyển trong cùng một lần đặt hàng.
```

Acceptance Criteria:

- Người dùng thêm được sách đang kinh doanh.
- Không thêm được sách đã ngừng bán.
- Không thêm vượt giới hạn tồn kho được phép.
- Có thể tăng/giảm số lượng.
- Có thể xóa dòng sản phẩm.
- Tổng tiền được tính lại.
- Server phải kiểm tra lại giá và tồn kho ở Checkout.

## 2.6. Cách tìm kiếm ở giai đoạn 1

### Cần tìm gì?

- Mẫu đặc tả yêu cầu phần mềm (SRS).
- User Story và Acceptance Criteria.
- Chức năng phổ biến của e-commerce.
- Quy trình mua hàng và quản lý đơn.
- Khái niệm MVP và ưu tiên backlog.

### Từ khóa tìm kiếm mẫu

```text
software requirements specification SRS example ecommerce

E-commerce website functional requirements customer admin

ecommerce user stories acceptance criteria examples

online bookstore website requirements use cases

Agile MVP prioritization MoSCoW method example

checkout process ecommerce business requirements
```

### Cách thực hiện tìm kiếm

1. Tìm 2–3 mẫu SRS hoặc tài liệu yêu cầu của website bán hàng.
2. Không sao chép nguyên danh sách chức năng; đánh dấu chức năng phù hợp với phạm vi của mình.
3. So sánh chức năng Customer và Admin.
4. Tạo bảng: Mã chức năng, tên, Actor, mô tả, mức ưu tiên, điều kiện nghiệm thu.
5. Hỏi người dùng thử (bạn bè/giảng viên) xem luồng mua hàng có thiếu bước không.
6. Chốt phạm vi MVP trước khi thiết kế database.

### Đầu ra cần có

- `requirements.md`.
- Danh sách Actor.
- Danh sách chức năng.
- User Stories.
- Acceptance Criteria.
- Danh sách chức năng MVP và chức năng để sau.

### Điều kiện hoàn thành

- Mỗi chức năng có người sử dụng và mục đích rõ ràng.
- Không có chức năng chỉ được mô tả bằng tên mà không có hành vi.
- Phạm vi MVP không quá lớn.

---

# 3. Giai đoạn 2 – Phân tích nghiệp vụ và thiết kế luồng

## Mục tiêu

Biến danh sách chức năng thành quy trình có điểm bắt đầu, điều kiện, nhánh xử lý và kết quả.

## 3.1. Vẽ Use Case Diagram

Thực hiện:

1. Liệt kê Actor: Guest, Customer, Admin.
2. Liệt kê Use Case theo từng Actor.
3. Đặt tên Use Case bằng động từ + đối tượng, ví dụ `Đặt hàng`, `Quản lý sách`.
4. Xác định Use Case nào yêu cầu đăng nhập.
5. Dùng `include` khi một hành vi bắt buộc được tái sử dụng.
6. Dùng `extend` khi hành vi mở rộng có điều kiện.
7. Kiểm tra mỗi chức năng đã có Actor phù hợp chưa.

Lưu ý: Use Case Diagram mô tả phạm vi và tương tác, không mô tả chi tiết từng bước xử lý trong code.

## 3.2. Vẽ Activity Diagram

Nên vẽ cho các nghiệp vụ có nhiều nhánh:

- Đăng ký/đăng nhập.
- Thêm giỏ hàng.
- Checkout.
- Hủy đơn.
- Thanh toán.
- Admin xác nhận và giao hàng.

Ví dụ luồng Checkout:

```text
Bắt đầu
  -> Người dùng mở Checkout
  -> Backend lấy giỏ hàng
  -> Kiểm tra giỏ hàng còn sản phẩm?
       Không -> Trả lỗi CART_EMPTY -> Kết thúc
       Có
         -> Kiểm tra sản phẩm và tồn kho
         -> Có sản phẩm không hợp lệ?
              Có -> Trả lỗi và yêu cầu cập nhật giỏ hàng
              Không
                -> Validate địa chỉ và thông tin nhận hàng
                -> Tính tiền ở Backend
                -> Kiểm tra voucher nếu có
                -> Tạo đơn trong DB Transaction
                -> Cập nhật/giữ tồn kho theo chính sách
                -> Trả mã đơn hàng
                -> Kết thúc
```

## 3.3. Vẽ Sequence Diagram

Vẽ các đối tượng theo chiều ngang và thời gian từ trên xuống.

Ví dụ đặt hàng:

```text
Customer -> React CheckoutPage: Nhấn Đặt hàng
React -> Laravel API: POST /api/v1/orders
Laravel -> Middleware: Kiểm tra session/auth
Laravel -> FormRequest: Validate input
Controller -> OrderService: createOrder()
OrderService -> MySQL: Kiểm tra cart, price, stock
OrderService -> MySQL: Transaction tạo order/items
MySQL -> OrderService: Kết quả
OrderService -> Controller: Order DTO/data
Controller -> API Resource: Format response
Laravel -> React: JSON + HTTP status
React -> Customer: Hiển thị mã đơn / lỗi
```

Sequence Diagram cần thể hiện rõ:

- Ai gửi request?
- Đối tượng nào xử lý?
- Khi nào truy vấn Database?
- Nhánh lỗi xảy ra ở đâu?
- Response trả về thế nào?

## 3.4. Định nghĩa trạng thái đơn hàng

Ví dụ:

```text
pending -> confirmed -> processing -> shipping -> completed
     \-> cancelled
```

Không cho phép chuyển trạng thái tùy tiện. Hãy lập bảng chuyển trạng thái hợp lệ.

| Trạng thái hiện tại | Trạng thái tiếp theo hợp lệ (ví dụ) |
|---|---|
| pending | confirmed, cancelled |
| confirmed | processing, cancelled (theo chính sách) |
| processing | shipping, cancelled (nếu cho phép) |
| shipping | completed, returned |
| completed | Không tự chuyển về pending |
| cancelled | Trạng thái kết thúc |

Quy tắc thực tế phải được chốt trước khi code, đặc biệt là hoàn kho, hoàn tiền và hủy đơn.

## 3.5. Cách tìm kiếm ở giai đoạn 2

### Từ khóa tìm kiếm

```text
UML use case diagram ecommerce example

UML activity diagram checkout process example

UML sequence diagram REST API login example

UML include extend relationship use case official guide

ecommerce order status workflow state diagram

order cancellation inventory rollback business rules
```

### Cách làm

1. Tìm ví dụ sơ đồ để hiểu ký hiệu, không lấy sơ đồ của dự án khác làm bản cuối.
2. Đối chiếu từng sơ đồ với User Story đã viết.
3. Vẽ bằng draw.io/diagrams.net, StarUML hoặc công cụ tương đương.
4. Với mỗi sơ đồ, viết phần mô tả bằng văn bản.
5. Nhờ một người khác đọc và thử kể lại quy trình; nếu họ hiểu khác ý định thì cần sửa.
6. Đặc biệt rà soát các nhánh lỗi, không chỉ luồng thành công.

### Đầu ra cần có

- Use Case Diagram.
- Activity Diagram cho nghiệp vụ quan trọng.
- Sequence Diagram cho luồng gọi API quan trọng.
- Bảng trạng thái đơn hàng.
- Quy tắc hủy đơn, tồn kho và thanh toán.

---

# 4. Giai đoạn 3 – Thiết kế kiến trúc hệ thống và API

## Mục tiêu

Xác định các thành phần, trách nhiệm từng tầng và giao ước giao tiếp giữa React và Laravel.

## 4.1. Chọn kiến trúc phù hợp

Với dự án này, sử dụng:

- React SPA làm frontend độc lập.
- Laravel cung cấp REST API.
- MySQL làm database.
- Sanctum để xác thực; ưu tiên cân nhắc SPA cookie/session nếu frontend và API cùng top-level domain.

Không cần Microservices cho dự án học tập hoặc MVP. Một Laravel application được chia module hợp lý thường dễ triển khai và bảo trì hơn.

## 4.2. Quy định cấu trúc API

Dùng prefix có version:

```text
/api/v1/...
```

Ví dụ:

| Method | Endpoint | Ý nghĩa |
|---|---|---|
| GET | `/api/v1/books` | Danh sách sách |
| GET | `/api/v1/books/{id}` | Chi tiết sách |
| POST | `/api/v1/admin/books` | Tạo sách |
| PUT/PATCH | `/api/v1/admin/books/{id}` | Cập nhật sách |
| DELETE | `/api/v1/admin/books/{id}` | Xóa/ẩn sách |
| GET | `/api/v1/categories` | Danh mục |
| GET | `/api/v1/cart` | Giỏ hàng |
| POST | `/api/v1/cart/items` | Thêm item vào giỏ |
| POST | `/api/v1/orders` | Tạo đơn hàng |
| GET | `/api/v1/orders` | Đơn của người dùng hiện tại |

Quy tắc:

- Dùng danh từ số nhiều cho tài nguyên.
- GET để đọc, POST để tạo/hành động phù hợp, PUT/PATCH để cập nhật, DELETE để xóa.
- Không đưa logic nghiệp vụ vào URL.
- API Admin phải được bảo vệ ở Backend.
- Không dùng ID do client truyền để quyết định quyền sở hữu; Backend phải kiểm tra user hiện tại.

## 4.3. Chuẩn hóa JSON Response

Ví dụ response danh sách:

```json
{
  "data": [
    {
      "id": 1,
      "name": "Clean Code",
      "price": "180000.00",
      "stock": 12
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 12,
    "total": 56
  }
}
```

Ví dụ validation error:

```json
{
  "message": "The given data was invalid.",
  "errors": {
    "email": ["The email field is required."]
  }
}
```

Thống nhất:

- Response success.
- Response lỗi.
- Pagination metadata.
- Định dạng ngày giờ và tiền.
- Quy tắc ID.
- Quy tắc tên trường: snake_case hoặc camelCase; chọn một quy ước nhất quán.

## 4.4. Chọn cơ chế Authentication

### Phương án A – Sanctum SPA Cookie/Session

Phù hợp khi React SPA và Laravel API thuộc cùng top-level domain, ví dụ:

```text
shop.example.com
api.example.com
```

Đặc điểm:

- Dùng Laravel session cookie.
- Có CSRF protection.
- Cần cấu hình stateful domains, CORS, cookie domain, HTTPS và credentials.
- Frontend cần khởi tạo CSRF cookie theo quy trình Sanctum.

### Phương án B – Bearer Token

Phù hợp với client/API token use case, mobile app hoặc tích hợp bên thứ ba. Phải có chính sách cấp, lưu, thu hồi, hết hạn và bảo vệ token rõ ràng.

Không chọn cơ chế chỉ vì thấy một video hướng dẫn. Hãy xác định mô hình client, domain và yêu cầu bảo mật trước.

## 4.5. Cách tìm kiếm ở giai đoạn 3

```text
site:laravel.com/docs sanctum SPA authentication

site:laravel.com/docs API resources routing middleware

REST API resource naming conventions pagination error response

React Laravel separate frontend backend architecture REST API

Laravel CORS credentials cookie subdomain Sanctum

OWASP REST Security Cheat Sheet authentication authorization
```

### Cách làm

1. Đọc phần tổng quan của Laravel API routing.
2. Đọc Sanctum đúng phiên bản Laravel đang cài.
3. Vẽ sơ đồ Client → API → Application → Database.
4. Lập danh sách endpoint theo module.
5. Viết ví dụ Request/Response cho từng endpoint quan trọng.
6. Thống nhất HTTP status code và format lỗi.
7. Kiểm tra quyền truy cập cho từng endpoint.
8. Ghi lại quyết định chọn cookie/session hay bearer token trong `architecture.md`.

### Đầu ra cần có

- Architecture Diagram.
- API endpoint list.
- API response convention.
- Authentication decision.
- Authorization matrix.

---

# 5. Giai đoạn 4 – Thiết kế UI/UX

## Mục tiêu

Xác định các màn hình, bố cục, hành vi và khả năng sử dụng trên nhiều kích thước màn hình trước khi code.

## 5.1. Liệt kê trang Customer

- Home Page.
- Products Page.
- Product Detail Page.
- Search Results Page (có thể dùng chung Products Page).
- Cart Page.
- Checkout Page.
- Login Page.
- Register Page.
- Profile Page.
- Address Management Page.
- Order History Page.
- Order Detail Page.
- Wishlist Page (nếu có).

## 5.2. Liệt kê trang Admin

- Admin Login (hoặc dùng chung login và điều hướng theo role).
- Dashboard.
- Product List/Create/Edit.
- Category Management.
- Author/Publisher Management.
- Order Management.
- Customer Management.
- Voucher Management.
- Review Management.
- Inventory Management.

## 5.3. Vẽ Wireframe

Với mỗi trang:

1. Xác định mục tiêu chính.
2. Đặt các vùng Header, Navigation, Content, Sidebar, Footer.
3. Đặt thành phần chính (form, card, table, filter, button).
4. Xác định trạng thái Loading, Empty, Error, Disabled.
5. Xác định hành vi khi nhấn nút.
6. Phác thảo mobile, tablet và desktop.

Ví dụ Products Page:

```text
--------------------------------------------------
Header: Logo | Search | Account | Cart
--------------------------------------------------
Breadcrumb
--------------------------------------------------
Sidebar filters | Product listing
               | [Card] [Card] [Card]
               | [Card] [Card] [Card]
               | Pagination
--------------------------------------------------
Footer
```

## 5.4. Tạo Design System

Chốt:

- Font family.
- Màu brand, màu nền, màu chữ, màu trạng thái.
- Typography scale.
- Spacing scale.
- Border radius.
- Shadow.
- Container width.
- Breakpoints.
- Button variants.
- Input, select, checkbox, badge.
- Card, modal, table, toast.

Tạo component dùng chung dựa trên nhu cầu thực, không cần xây design system quá phức tạp từ đầu.

## 5.5. Responsive và accessibility

- Thiết kế mobile-first nếu phù hợp.
- Không để nội dung bị tràn ngang.
- Button có vùng nhấn đủ lớn.
- Form có label.
- Màu chữ đủ tương phản.
- Ảnh có alt text phù hợp.
- Có focus state khi dùng bàn phím.
- Không chỉ dùng màu sắc để thể hiện lỗi/trạng thái.

## 5.6. Cách tìm kiếm ở giai đoạn 4

```text
bookstore ecommerce website UI design inspiration

Figma ecommerce product listing checkout wireframe

mobile ecommerce checkout UX best practices

admin dashboard table filter pagination UI design

Tailwind CSS responsive design official documentation

Tailwind CSS grid columns responsive official docs

WCAG accessible form labels color contrast buttons
```

### Cách làm

1. Tìm 3–5 website cùng lĩnh vực để khảo sát cách bố trí.
2. Ghi nhận pattern tốt: tìm kiếm, filter, card, checkout, trạng thái đơn.
3. Không sao chép nguyên thiết kế hoặc hình ảnh có bản quyền.
4. Vẽ Wireframe trước, sau đó mới chọn màu và trang trí.
5. Thiết kế luồng Checkout ít bước và hiển thị rõ tổng tiền.
6. Kiểm tra bản mobile ở kích thước nhỏ.
7. Tạo danh sách component cần code.

### Đầu ra cần có

- Sitemap.
- Wireframe hoặc Figma.
- Design tokens cơ bản.
- Danh sách component dùng chung.
- Danh sách trạng thái UI.

---

# 6. Giai đoạn 5 – Thiết kế Database và ERD

## Mục tiêu

Mô hình hóa dữ liệu sao cho lưu được nghiệp vụ, đảm bảo tính toàn vẹn và có thể mở rộng.

## 6.1. Liệt kê bảng đề xuất

Danh sách dưới đây là điểm bắt đầu cho website bán sách. Không bắt buộc phải tạo tất cả ngay trong MVP. Chỉ thêm bảng khi có nghiệp vụ thực sự cần.

### Nhóm tài khoản

- `users`
- `addresses`
- `roles` và `role_user` (nếu cần nhiều role linh hoạt; dự án nhỏ có thể bắt đầu bằng cột role với kiểm soát chặt chẽ)

### Nhóm catalog

- `categories`
- `books`
- `book_categories` (nếu một sách có nhiều danh mục; nếu mỗi sách chỉ thuộc một danh mục thì có thể dùng `category_id` trực tiếp trong `books`)
- `authors`
- `author_book`
- `publishers`
- `book_images`

### Nhóm giỏ hàng

- `carts`
- `cart_items`

### Nhóm đơn hàng

- `orders`
- `order_items`
- `order_status_histories`

### Nhóm thanh toán và giao hàng

- `payments`
- `shipments`

### Nhóm voucher

- `coupons`
- `coupon_usages` hoặc cấu trúc redemption phù hợp

### Nhóm tương tác

- `reviews`
- `wishlists`
- `wishlist_items`

### Nhóm kho

- `inventory_movements`

## 6.2. Thiết kế những trường quan trọng

### `users`

- `id`
- `name`
- `email` (unique)
- `password`
- `phone` (nullable, tùy chính sách)
- `role` hoặc bảng role riêng
- `email_verified_at`
- `remember_token`
- `created_at`, `updated_at`

### `categories`

- `id`
- `parent_id` (nullable nếu hỗ trợ danh mục cha/con)
- `name`
- `slug` (unique hoặc unique trong phạm vi phù hợp)
- `description`
- `status`
- timestamps

### `books`

- `id`
- `publisher_id`
- `sku` (unique)
- `isbn` (nullable, unique nếu nghiệp vụ đảm bảo)
- `name`
- `slug`
- `description`
- `price` (DECIMAL)
- `discount_price` (nullable; cần quy tắc kiểm tra nhỏ hơn giá gốc)
- `stock` (nếu dùng mô hình tồn kho đơn giản)
- `status`
- timestamps

### `orders`

- `id`
- `user_id`
- `order_code` (unique)
- `subtotal`
- `discount_amount`
- `shipping_fee`
- `total_amount`
- `payment_method`
- `payment_status`
- `order_status`
- thông tin người nhận và địa chỉ snapshot
- timestamps

### `order_items`

- `id`
- `order_id`
- `book_id` (có thể nullable nếu sản phẩm bị xóa vật lý; cần quyết định chính sách)
- `product_name_snapshot`
- `sku_snapshot`
- `unit_price`
- `quantity`
- `line_total`

**Vì sao phải snapshot?** Giá, tên hoặc mã sản phẩm có thể thay đổi sau khi khách đặt hàng. Đơn hàng cũ phải giữ được thông tin tại thời điểm mua.

## 6.3. Xác định quan hệ

- User 1-N Orders.
- User 1-N Addresses.
- Order 1-N OrderItems.
- Book 1-N OrderItems.
- Category 1-N Books hoặc N-N tùy yêu cầu.
- Book N-N Authors.
- Publisher 1-N Books.
- User 1-N Reviews.
- Book 1-N Reviews.
- Cart 1-N CartItems.
- Book 1-N CartItems.
- Coupon N-N Users thông qua lịch sử sử dụng nếu cần kiểm soát theo người dùng.

## 6.4. Kiểm tra các quy tắc dữ liệu

- `email`, `sku`, `order_code` cần unique phù hợp.
- Giá dùng `DECIMAL`, không dùng FLOAT cho tiền.
- Số lượng phải không âm.
- Foreign Key phải có chính sách `ON DELETE` phù hợp.
- Đơn hàng không được phụ thuộc hoàn toàn vào dữ liệu sản phẩm hiện tại.
- Không xóa vật lý dữ liệu lịch sử quan trọng nếu cần đối soát.
- Index các trường thường lọc/tìm kiếm như `slug`, `category_id`, `status`, `created_at`, nhưng tránh tạo index tràn lan.
- Chọn InnoDB để sử dụng transaction và foreign key.

## 6.5. Vẽ ERD

1. Vẽ bảng và cột.
2. Đánh dấu PK.
3. Đánh dấu FK.
4. Nối quan hệ 1-1, 1-N, N-N.
5. Tách bảng trung gian cho quan hệ N-N.
6. Ghi chú trường nullable/unique.
7. Kiểm tra vòng đời dữ liệu: xóa sách, xóa user, hủy đơn.
8. Đối chiếu ERD với User Story và Activity Diagram.

## 6.6. Cách tìm kiếm ở giai đoạn 5

```text
online bookstore database ERD schema

ecommerce database design orders order_items cart_items

MySQL 8 foreign key InnoDB transaction official documentation

MySQL DECIMAL data type monetary values documentation

Laravel migrations foreign key constraints official docs

Laravel Eloquent relationships many to many official docs

database normalization 1NF 2NF 3NF ecommerce example

SQL index composite index query performance MySQL documentation
```

### Cách làm

1. Tìm 1–2 ERD mẫu của e-commerce để tham khảo các thực thể.
2. Đối chiếu từng bảng với chức năng thực tế.
3. Xác định rõ quan hệ và cardinality.
4. Kiểm tra bảng trung gian.
5. Kiểm tra dữ liệu lịch sử đơn hàng.
6. Kiểm tra giá, tiền, số lượng và thời gian.
7. Vẽ ERD bằng diagrams.net, dbdiagram.io hoặc công cụ tương đương.
8. Nhờ người khác kiểm tra các tình huống xóa, cập nhật và mua hàng đồng thời.
9. Sau khi thống nhất, triển khai bằng Laravel Migration.

### Đầu ra cần có

- ERD.
- Data Dictionary (mô tả bảng/cột).
- Quy tắc khóa và quan hệ.
- Migration plan.
- Dữ liệu mẫu dự kiến.

---

# 7. Giai đoạn 6 – Khởi tạo dự án, môi trường và Git

## Mục tiêu

Tạo môi trường phát triển nhất quán, cấu trúc mã nguồn dễ hiểu và lịch sử thay đổi có thể kiểm soát.

## 7.1. Kiểm tra phiên bản công cụ

Trước khi tạo project, kiểm tra:

```bash
node -v
npm -v
php -v
composer -V
mysql --version
git --version
```

Đối chiếu phiên bản với yêu cầu chính thức của:

- Laravel version dự định dùng.
- PHP và PHP extensions.
- Node.js và Vite.
- Tailwind CSS.
- MySQL.

Không cài package theo một video cũ mà không kiểm tra phiên bản.

## 7.2. Cấu trúc thư mục cấp dự án

```text
BookStore/
├── frontend/
├── backend/
├── docs/
│   ├── requirements/
│   ├── diagrams/
│   ├── database/
│   ├── api/
│   ├── testing/
│   └── deployment/
├── .gitignore
└── README.md
```

## 7.3. Khởi tạo React bằng Vite

Ví dụ khởi tạo React JavaScript:

```bash
npm create vite@latest frontend -- --template react
cd frontend
npm install
npm run dev
```

Nếu chọn TypeScript thì dùng template React TypeScript và duy trì kiểu dữ liệu xuyên suốt. Chọn JavaScript hay TypeScript ngay từ đầu để tránh đổi giữa chừng nếu chưa có lý do.

## 7.4. Cài Tailwind CSS

Tailwind CSS có khác biệt giữa các major version. Với Tailwind CSS v4, làm theo hướng dẫn cài đặt Vite chính thức của v4; không áp dụng máy móc cấu hình `tailwind.config.js` và các directive của v3.

Quy trình chung:

1. Kiểm tra phiên bản Tailwind.
2. Cài đúng package/plugin theo tài liệu phiên bản đó.
3. Cấu hình Vite nếu hướng dẫn yêu cầu.
4. Import CSS entry.
5. Chạy ứng dụng.
6. Thử một số class như `grid`, `flex`, `p-4`, `text-xl`.
7. Kiểm tra responsive variants như `md:grid-cols-3`.

## 7.5. Khởi tạo Laravel

Ví dụ tạo project bằng Composer:

```bash
composer create-project laravel/laravel backend
cd backend
php artisan --version
php artisan serve
```

Nếu dùng Laravel Installer, làm theo hướng dẫn cài đặt chính thức của phiên bản tương ứng.

## 7.6. Cấu hình MySQL local

1. Khởi động MySQL.
2. Tạo database `bookstore`.
3. Tạo user riêng cho ứng dụng nếu có thể.
4. Cấu hình `.env` của Laravel.
5. Chạy kiểm tra kết nối bằng migration hoặc lệnh thử phù hợp.
6. Không dùng tài khoản root cho Production.

Ví dụ `.env` local:

```env
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bookstore
DB_USERNAME=root
DB_PASSWORD=
```

Giá trị thực tế phụ thuộc cấu hình máy. Không commit `.env`.

## 7.7. Cấu hình CORS và Authentication ban đầu

Chưa cần hoàn thiện toàn bộ Sanctum ngay trong ngày đầu. Tuy nhiên, cần xác định domain local frontend/backend, ví dụ:

```text
Frontend: http://localhost:5173
Backend:  http://localhost:8000
```

Ghi lại các origin và port sẽ dùng để cấu hình CORS/Sanctum sau đó. Không dùng `Access-Control-Allow-Origin: *` cùng credentials.

## 7.8. Thiết lập Git

```bash
git init
git add .
git commit -m "chore: initialize project"
```

Branch gợi ý:

```text
main
 develop
  feature/auth
  feature/catalog
  feature/cart
  feature/checkout
  feature/admin
```

Quy tắc:

- `main`: phiên bản ổn định.
- `develop`: nhánh tích hợp (nếu quy trình nhóm cần).
- `feature/...`: một chức năng.
- Commit nhỏ, mô tả đúng thay đổi.
- Không commit `node_modules`, `vendor`, `.env`, file log, file cache hoặc secrets.

## 7.9. Cách tìm kiếm ở giai đoạn 6

```text
Vite create React app official getting started

Tailwind CSS v4 install Vite official documentation

Laravel installation requirements PHP version official docs

Laravel create project Composer official documentation

Git branching workflow feature branch best practices

Node.js Vite compatibility requirements
```

### Cách làm

1. Kiểm tra phiên bản hiện tại của máy.
2. Đọc requirement trước khi cài.
3. Tạo frontend và xác nhận chạy được.
4. Tạo backend và xác nhận chạy được.
5. Kết nối MySQL.
6. Thêm `.gitignore` ngay từ đầu.
7. Commit baseline.
8. Ghi các lệnh khởi chạy trong README.

### Đầu ra cần có

- React project chạy local.
- Laravel project chạy local.
- MySQL kết nối thành công.
- Git repository.
- `.gitignore`.
- README hướng dẫn khởi chạy.

---

# 8. Giai đoạn 7 – Xây dựng Backend Laravel

## Mục tiêu

Xây API, xác thực, phân quyền, xử lý nghiệp vụ và truy cập MySQL.

## 8.1. Thống nhất cách chia tầng

Luồng tham khảo:

```text
HTTP Request
  -> Route
  -> Middleware
  -> Controller
  -> Form Request (validation)
  -> Service / Action (business logic)
  -> Eloquent Model / Query
  -> MySQL
  -> API Resource
  -> JSON Response
```

Không bắt buộc phải tạo Service cho mọi CRUD đơn giản. Tách Service/Action khi nghiệp vụ phức tạp, cần dùng lại hoặc cần test độc lập.

## 8.2. Tạo Migration

Thực hiện theo thứ tự phụ thuộc:

1. users và các bảng nền tảng.
2. categories, publishers, authors.
3. books.
4. bảng trung gian book-author/book-category nếu dùng.
5. book_images.
6. addresses.
7. carts và cart_items.
8. coupons.
9. orders và order_items.
10. payments, shipments.
11. reviews, wishlists.
12. inventory_movements và lịch sử trạng thái.

Với mỗi Migration:

- Đặt kiểu dữ liệu đúng.
- Thiết lập nullable/unique/default.
- Thêm FK.
- Chọn hành vi khi xóa/cập nhật.
- Có `down()` phù hợp.
- Kiểm tra khả năng chạy migration mới và rollback trong môi trường phát triển.

## 8.3. Tạo Model và Eloquent Relationships

Ví dụ quan hệ User – Order:

```php
// app/Models/User.php
public function orders()
{
    return $this->hasMany(Order::class);
}
```

```php
// app/Models/Order.php
public function user()
{
    return $this->belongsTo(User::class);
}

public function items()
{
    return $this->hasMany(OrderItem::class);
}
```

Thực hiện:

1. Khai báo mass assignment an toàn (`$fillable` hoặc `$guarded`).
2. Khai báo quan hệ.
3. Khai báo casts cho số, boolean, ngày giờ, enum/value phù hợp.
4. Không expose password/token trong JSON.
5. Dùng Eager Loading khi cần để tránh N+1.

## 8.4. Factory và Seeder

Tạo dữ liệu mẫu có tính nhất quán:

- Danh mục.
- Tác giả.
- Nhà xuất bản.
- Sách.
- Admin test.
- Customer test.
- Một số đơn hàng test.

Không đưa mật khẩu thật hoặc dữ liệu cá nhân thật vào Seeder công khai.

## 8.5. Authentication bằng Sanctum

Danh sách công việc:

1. Cài và cấu hình Sanctum đúng phiên bản.
2. Chốt cookie/session hay bearer token.
3. Xây Register.
4. Xây Login.
5. Xây Logout.
6. Xây endpoint lấy người dùng hiện tại (`/me`).
7. Bảo vệ route bằng middleware phù hợp.
8. Kiểm tra session/cookie hoặc token.
9. Kiểm tra hết hạn và đăng xuất.
10. Kiểm tra CSRF nếu dùng SPA cookie/session.

Với SPA cookie/session:

- Cấu hình stateful domains.
- Cấu hình CORS chính xác.
- Gửi credentials từ HTTP client.
- Gọi endpoint cấp CSRF cookie theo hướng dẫn Sanctum.
- Cấu hình cookie domain/secure/same-site phù hợp môi trường.
- Đảm bảo HTTPS ở Production.

## 8.6. Xây Module Category

- `Category` Model.
- Migration.
- CategoryController.
- Form Request.
- API Resource.
- CRUD.
- Kiểm tra slug unique.
- Kiểm tra không xóa danh mục đang có sản phẩm hoặc xác định cách chuyển sản phẩm.
- Admin Policy/authorization.
- Feature tests.

## 8.7. Xây Module Book/Product

Endpoint ví dụ:

```text
GET    /api/v1/books
GET    /api/v1/books/{book}
POST   /api/v1/admin/books
PUT    /api/v1/admin/books/{book}
DELETE /api/v1/admin/books/{book}
```

Các phần việc:

1. Tạo Model và quan hệ.
2. Tạo Request validation.
3. Tạo Resource.
4. CRUD.
5. Upload ảnh.
6. Kiểm tra SKU/ISBN/slug.
7. Kiểm tra giá và giá khuyến mãi.
8. Kiểm tra trạng thái sản phẩm.
9. Lấy danh sách có Pagination.
10. Search theo từ khóa.
11. Filter theo category, publisher, author, trạng thái.
12. Sort theo giá, tên hoặc thời gian.
13. Eager load quan hệ cần thiết.
14. Kiểm tra quyền Admin.

Ví dụ query:

```text
GET /api/v1/books?search=clean%20code&category_id=2&sort=price_asc&page=1
```

Backend phải whitelist cột sắp xếp hợp lệ; không ghép trực tiếp chuỗi user input vào SQL.

## 8.8. Upload ảnh

1. Tạo endpoint upload hoặc xử lý ảnh trong endpoint tạo/cập nhật sách.
2. Validate MIME type, extension và size.
3. Đặt giới hạn file.
4. Tạo tên file an toàn, không tin tên file người dùng gửi.
5. Lưu vào Laravel Storage hoặc Object Storage.
6. Lưu đường dẫn/metadata vào database.
7. Trả URL phù hợp.
8. Xóa file cũ khi thay thế nếu không còn được sử dụng.
9. Kiểm tra quyền upload.
10. Cân nhắc tối ưu kích thước và định dạng ảnh.

## 8.9. Xây Module Cart

Endpoint ví dụ:

```text
GET    /api/v1/cart
POST   /api/v1/cart/items
PATCH  /api/v1/cart/items/{item}
DELETE /api/v1/cart/items/{item}
DELETE /api/v1/cart
```

Nghiệp vụ:

- Xác định giỏ hàng thuộc user hiện tại.
- Kiểm tra sản phẩm tồn tại và được bán.
- Kiểm tra số lượng hợp lệ.
- Không tin dữ liệu giá từ client.
- Cộng số lượng nếu item đã tồn tại.
- Trả tổng số lượng và tổng tiền dự kiến.
- Kiểm tra lại dữ liệu ở Checkout vì giá/tồn kho có thể thay đổi.

## 8.10. Xây Checkout và Order

Đây là nghiệp vụ cần đặc biệt cẩn trọng.

1. Nhận thông tin địa chỉ và phương thức thanh toán.
2. Lấy user từ session/token đã xác thực.
3. Lấy Cart từ Database theo user hiện tại.
4. Kiểm tra Cart không rỗng.
5. Đọc lại sản phẩm, giá và trạng thái từ Database.
6. Kiểm tra số lượng tồn kho.
7. Tính subtotal ở Backend.
8. Kiểm tra và tính voucher ở Backend.
9. Tính phí giao hàng ở Backend theo quy tắc đã định.
10. Tính total ở Backend.
11. Mở Database Transaction.
12. Khóa/kiểm soát dòng tồn kho phù hợp để giảm race condition.
13. Tạo Order và Order Items snapshot.
14. Cập nhật/giữ tồn kho theo chính sách.
15. Tạo Payment record nếu cần.
16. Xóa hoặc đánh dấu Cart đã checkout.
17. Commit transaction.
18. Trả Order code và trạng thái.

Quy tắc:

- Không nhận `total_amount` từ frontend làm giá trị có thẩm quyền.
- Dùng transaction để tránh tạo đơn nửa chừng.
- Xử lý hai người cùng mua sản phẩm cuối cùng.
- Có cơ chế tránh tạo đơn trùng khi client gửi lại request (idempotency hoặc chiến lược phù hợp với nghiệp vụ).
- Không xóa giỏ hàng trước khi transaction thành công.

## 8.11. Xây Order Management

Customer:

- Danh sách đơn của chính mình.
- Chi tiết đơn của chính mình.
- Hủy đơn theo trạng thái và chính sách.

Admin:

- Danh sách đơn toàn hệ thống.
- Filter theo trạng thái/ngày/mã đơn.
- Xem chi tiết.
- Chuyển trạng thái theo state transition hợp lệ.
- Ghi lịch sử thay đổi.

Không chỉ kiểm tra `order_id`; phải kiểm tra order có thuộc user hiện tại hay không.

## 8.12. Các module bổ sung

### Voucher

- Mã code unique.
- Thời gian bắt đầu/kết thúc.
- Kiểu giảm: phần trăm hoặc số tiền cố định.
- Giá trị tối thiểu đơn hàng.
- Giảm tối đa.
- Tổng lượt dùng.
- Lượt dùng mỗi user.
- Phạm vi áp dụng.
- Kiểm tra và ghi nhận sử dụng trong quy trình an toàn.

### Review

- Chỉ user đủ điều kiện mới được đánh giá nếu yêu cầu.
- Giới hạn số review theo order/item nếu cần.
- Rating trong khoảng hợp lệ.
- Kiểm duyệt và ẩn review.

### Payment

- Tạo payment intent/request ở Backend.
- Xác minh chữ ký/callback/webhook.
- Chống xử lý webhook trùng.
- Không tin kết quả từ frontend redirect.
- Ghi log giao dịch và trạng thái.

### Queue/Notification

- Gửi email xác nhận đơn.
- Thông báo trạng thái.
- Retry job lỗi.
- Có failed jobs và giám sát worker.

## 8.13. Cách tìm kiếm ở giai đoạn 7

```text
site:laravel.com/docs migrations foreign key indexes

site:laravel.com/docs eloquent relationships eager loading

site:laravel.com/docs form request validation

site:laravel.com/docs API resources controllers routing

site:laravel.com/docs authorization policies gates

site:laravel.com/docs filesystem file uploads storage link

site:laravel.com/docs database transactions pessimistic locking

site:laravel.com/docs queues jobs retries failed jobs

site:laravel.com/docs testing HTTP tests database factories

Laravel ecommerce checkout transaction inventory race condition

Laravel prevent mass assignment official documentation
```

### Cách làm khi tìm một chức năng Laravel

1. Tra khái niệm trong Laravel docs đúng major version.
2. Xác định chức năng thuộc Routing, Middleware, Request, Controller, Eloquent, Resource hay Queue.
3. Đọc ví dụ tối thiểu trong docs.
4. Tạo một route thử nghiệm nhỏ.
5. Viết test hoặc thử bằng Postman.
6. Sau khi hiểu mới áp dụng vào module thật.
7. Kiểm tra validation, authorization và lỗi.
8. Đọc query SQL/log nếu kết quả sai.

### Đầu ra cần có

- Migration và Model.
- Quan hệ Eloquent.
- API theo module.
- Validation và Authorization.
- API Resources.
- Seeder/Factory.
- Feature tests.
- Tài liệu API.

---

# 9. Giai đoạn 8 – Xây dựng Frontend React và Tailwind

## Mục tiêu

Tạo giao diện, điều hướng, quản lý state và xử lý tương tác người dùng.

## 9.1. Cấu trúc thư mục đề xuất

```text
frontend/src/
├── assets/
├── components/
│   ├── common/
│   ├── layout/
│   ├── product/
│   ├── cart/
│   └── admin/
├── layouts/
│   ├── MainLayout.jsx
│   └── AdminLayout.jsx
├── pages/
│   ├── HomePage.jsx
│   ├── ProductsPage.jsx
│   ├── ProductDetailPage.jsx
│   ├── CartPage.jsx
│   ├── CheckoutPage.jsx
│   ├── LoginPage.jsx
│   ├── RegisterPage.jsx
│   ├── ProfilePage.jsx
│   ├── OrdersPage.jsx
│   └── admin/
├── services/
├── hooks/
├── contexts/
├── routes/
├── utils/
├── App.jsx
└── main.jsx
```

Có thể thay đổi theo quy mô. Không tạo quá nhiều thư mục rỗng khi chưa có nhu cầu.

## 9.2. Thiết lập Routing

- Tạo route cho Customer.
- Tạo route cho Admin.
- Tạo Not Found page.
- Tạo Layout route.
- Có thể dùng Protected Route để điều hướng UI, nhưng Backend vẫn phải kiểm tra quyền.
- Kiểm tra refresh trực tiếp URL khi deploy vì SPA cần fallback về `index.html`.

## 9.3. Xây Layout

`MainLayout`:

```text
MainLayout
├── Header
├── Navigation
├── Main Content (Outlet)
└── Footer
```

`AdminLayout`:

```text
AdminLayout
├── Sidebar
├── Admin Header
└── Main Content (Outlet)
```

## 9.4. Xây reusable components

- Button.
- TextInput.
- PasswordInput.
- Select.
- Checkbox.
- Modal.
- ConfirmDialog.
- LoadingSpinner/Skeleton.
- Alert/Toast.
- Pagination.
- Breadcrumb.
- ProductCard.
- ProductGrid.
- PriceDisplay.
- StatusBadge.
- DataTable.

Component nên nhận dữ liệu qua props, phát sự kiện qua callback và giữ trách nhiệm rõ ràng.

## 9.5. Xây trang theo thứ tự

### HomePage

- Hero/banner.
- Category section.
- Featured/new books.
- Best sellers nếu có dữ liệu.
- Footer.

### ProductsPage

- Danh sách sách.
- Search input.
- Filter category/price/publisher.
- Sort.
- Pagination.
- Loading, Error, Empty.

### ProductDetailPage

- Ảnh.
- Tên, tác giả, nhà xuất bản.
- Giá, giá giảm.
- Tình trạng tồn kho.
- Mô tả.
- Số lượng.
- Add to Cart.
- Review nếu có.

### CartPage

- Danh sách item.
- Số lượng.
- Giá.
- Thành tiền.
- Xóa item.
- Tổng tiền dự kiến.
- Nút Checkout.

### CheckoutPage

- Địa chỉ nhận.
- Người nhận và số điện thoại.
- Danh sách item.
- Voucher.
- Phí giao hàng.
- Tổng tiền.
- Phương thức thanh toán.
- Nút xác nhận.

### Admin pages

- Table có tìm kiếm/lọc/phân trang.
- Form thêm/sửa.
- Preview ảnh.
- Modal xác nhận thao tác quan trọng.
- Thông báo thành công/thất bại.

## 9.6. Quản lý state đúng loại

| Loại | Ví dụ | Công cụ có thể dùng |
|---|---|---|
| Local UI State | Modal, tab, input tạm | `useState` |
| Shared Client State | Auth user, theme | Context hoặc state library |
| Server State | Books, orders, cart từ API | TanStack Query hoặc cách quản lý phù hợp |
| Form State | Input, validation, submit | React Hook Form hoặc state cơ bản |

Không lưu toàn bộ dữ liệu server thành nhiều bản sao khác nhau trong nhiều component nếu có thể lấy từ một nguồn có kiểm soát.

## 9.7. Xử lý bốn trạng thái giao diện

Mỗi màn hình lấy dữ liệu từ API nên xử lý:

1. Loading.
2. Success.
3. Empty.
4. Error.

Form cần:

- Giá trị mặc định.
- Validation phía UI để cải thiện trải nghiệm.
- Hiển thị lỗi server.
- Trạng thái submitting.
- Chống nhấn submit liên tục ở UI (Backend vẫn phải xử lý an toàn).

## 9.8. Responsive với Tailwind

- Xây layout mobile trước hoặc đảm bảo mobile không bị bỏ quên.
- Dùng breakpoint variants theo tài liệu Tailwind version đang cài.
- Sử dụng Grid/Flex phù hợp.
- Kiểm tra danh sách sách 1 cột mobile, 2 cột tablet, 3–4 cột desktop tùy chiều rộng.
- Bảng Admin có thể cần scroll ngang hoặc layout mobile riêng.

## 9.9. Cách tìm kiếm ở giai đoạn 8

```text
site:react.dev/learn components props state rendering lists forms

site:react.dev/learn managing state sharing state components

site:react.dev/reference/react useEffect useMemo useContext

React Router official documentation nested routes protected routes

Tailwind CSS v4 Vite installation official docs

Tailwind CSS responsive design official documentation

Tailwind CSS grid-template-columns official docs

TanStack Query React official docs queries mutations cache

React Hook Form official docs validation

accessible React forms labels errors keyboard navigation
```

### Cách làm

1. Tìm tài liệu React cho đúng khái niệm đang cần, ví dụ state hay effect.
2. Không dùng `useEffect` cho mọi thao tác; xác định đó là event, derived state hay synchronization với hệ thống ngoài.
3. Dựng trang với dữ liệu giả trước để ổn định layout.
4. Tạo component có props rõ ràng.
5. Tạo route và Layout.
6. Thêm Loading/Empty/Error.
7. Responsive từng trang.
8. Kiểm tra bằng DevTools và React Developer Tools nếu cần.
9. Sau đó mới tích hợp API thật.

### Đầu ra cần có

- Pages và Layout.
- Reusable Components.
- Route configuration.
- State strategy.
- Responsive UI.
- UI states.

---

# 10. Giai đoạn 9 – Tích hợp Frontend với Backend

## Mục tiêu

Đảm bảo React gửi đúng request, Laravel trả đúng response và giao diện phản ánh chính xác kết quả.

## 10.1. Tạo Axios instance

Tạo `src/services/api.js` để cấu hình tập trung:

- `baseURL`.
- Timeout.
- `Accept: application/json`.
- `Content-Type` phù hợp payload.
- `withCredentials` nếu dùng cookie/session.
- CSRF/XSRF theo cấu hình Sanctum.
- Interceptor xử lý lỗi chung nếu cần.

Không đưa secret vào biến `VITE_...` vì biến này được đưa vào frontend bundle.

## 10.2. Tạo API service theo module

```text
services/
├── api.js
├── authService.js
├── bookService.js
├── categoryService.js
├── cartService.js
├── orderService.js
└── adminService.js
```

Ví dụ:

```javascript
// bookService.js
import api from "./api";

export const getBooks = (params = {}) =>
  api.get("/books", { params });

export const getBookById = (id) =>
  api.get(`/books/${id}`);
```

Service chỉ tập trung giao tiếp API; component chịu trách nhiệm hiển thị và xử lý tương tác.

## 10.3. Tích hợp từng API

Thứ tự gợi ý:

1. Auth `/me` và login.
2. Category list.
3. Book list.
4. Book detail.
5. Search/filter/sort/pagination.
6. Admin CRUD book/category.
7. Cart.
8. Checkout.
9. Orders.
10. Voucher/Payment/Review.

Mỗi API cần kiểm tra:

- URL và HTTP method.
- Query params.
- Request body.
- Headers/cookie.
- Response body.
- HTTP status.
- Validation errors.
- Authorization.

## 10.4. Kiểm tra luồng dữ liệu

```text
React Page
  -> Hook / event handler
  -> API service
  -> Axios
  -> Laravel route
  -> Middleware
  -> Controller / Service
  -> Eloquent
  -> MySQL
  -> JSON Response
  -> React state/cache
  -> Re-render UI
```

## 10.5. Xử lý HTTP Status

| Status | Ý nghĩa thường gặp | Frontend nên làm |
|---|---|---|
| 200 | Thành công | Hiển thị dữ liệu |
| 201 | Tạo thành công | Thông báo, điều hướng |
| 204 | Thành công, không có body | Cập nhật UI phù hợp |
| 400 | Request không hợp lệ | Thông báo lỗi request |
| 401 | Chưa xác thực | Đưa về login/khởi tạo lại auth |
| 403 | Không có quyền | Hiển thị không được phép |
| 404 | Không tìm thấy | Hiển thị not found |
| 409 | Xung đột nghiệp vụ | Hiển thị nguyên nhân và hướng xử lý |
| 422 | Validation error | Gắn lỗi vào field tương ứng |
| 429 | Quá nhiều request | Thông báo thử lại sau |
| 500 | Lỗi server | Thông báo chung, ghi log phía server |

## 10.6. Cách tìm kiếm ở giai đoạn 9

```text
Axios official docs instance interceptors credentials

Laravel Sanctum SPA Axios withCredentials withXSRFToken

Laravel CORS configuration credentials React localhost

React fetch API loading error state best practices

HTTP status codes MDN 401 403 409 422 429

Chrome DevTools Network inspect request response cookies

React TanStack Query mutations invalidation official docs
```

### Cách làm

1. Kiểm tra API bằng Postman trước.
2. Xác nhận response đúng với tài liệu API.
3. Viết service cho API.
4. Gọi service từ trang/hook.
5. Hiển thị dữ liệu và trạng thái UI.
6. Kiểm tra Network tab.
7. Kiểm tra lỗi CORS, cookie, CSRF và session.
8. Thử Request sai để xem React hiển thị lỗi đúng không.

### Đầu ra cần có

- Axios client.
- API services.
- Các trang đã dùng dữ liệu thật.
- Error handling.
- Luồng Authentication hoạt động trên frontend.

---

# 11. Giai đoạn 10 – Hoàn thiện nghiệp vụ thương mại điện tử

## Mục tiêu

Đảm bảo các module kết hợp thành quy trình mua hàng và quản trị hoàn chỉnh.

## 11.1. Luồng mua hàng Customer

1. Khách truy cập trang chủ.
2. Tìm kiếm sách.
3. Lọc theo danh mục/giá.
4. Mở chi tiết sách.
5. Chọn số lượng.
6. Thêm vào giỏ.
7. Mở giỏ hàng.
8. Điều chỉnh số lượng.
9. Tiến hành Checkout.
10. Nhập/chọn địa chỉ.
11. Chọn phương thức thanh toán.
12. Áp dụng voucher nếu có.
13. Xác nhận đặt hàng.
14. Backend kiểm tra lại giá, tồn kho và voucher.
15. Backend tạo đơn trong transaction.
16. React hiển thị kết quả.
17. Khách xem lịch sử và chi tiết đơn.

## 11.2. Luồng Admin

1. Admin đăng nhập.
2. Mở Dashboard.
3. Thêm hoặc cập nhật sách.
4. Quản lý danh mục.
5. Theo dõi tồn kho.
6. Nhận đơn hàng.
7. Xem chi tiết.
8. Xác nhận đơn.
9. Chuyển sang xử lý/giao hàng.
10. Cập nhật hoàn thành hoặc hủy theo quy tắc.
11. Theo dõi lịch sử.

## 11.3. Voucher

Kiểm tra:

- Mã có tồn tại?
- Đang trong thời hạn?
- Có được áp dụng cho sản phẩm/danh mục này?
- Có đạt giá trị đơn tối thiểu?
- Còn lượt sử dụng?
- Người dùng còn lượt sử dụng?
- Mức giảm có vượt giới hạn?

Tính giảm giá ở Backend. Không tin con số giảm giá từ React.

## 11.4. Payment

Khi tích hợp cổng thanh toán:

1. Backend tạo yêu cầu thanh toán.
2. Backend trả thông tin chuyển hướng hoặc phương thức thanh toán.
3. User thực hiện thanh toán tại nhà cung cấp.
4. Nhà cung cấp gửi callback/webhook.
5. Backend xác minh chữ ký và nội dung.
6. Backend kiểm tra mã giao dịch, số tiền, đơn hàng.
7. Backend xử lý webhook theo cách idempotent để không cập nhật hai lần.
8. Backend cập nhật trạng thái thanh toán.
9. Frontend hiển thị trạng thái đã được Backend xác nhận.

Không đánh dấu thanh toán thành công chỉ vì người dùng được chuyển hướng về trang success.

## 11.5. Queue và Notification

Dùng Queue cho tác vụ có thể xử lý sau request:

- Gửi email xác nhận.
- Gửi thông báo.
- Tạo báo cáo.
- Đồng bộ dữ liệu bên ngoài.

Cần thiết lập retry, failed jobs, worker và giám sát. Không đẩy mọi tác vụ nhỏ vào Queue nếu không cần thiết.

## 11.6. Cách tìm kiếm ở giai đoạn 10

```text
Laravel ecommerce order checkout workflow

Laravel database transaction lockForUpdate inventory stock

Laravel queue email notification official docs

Laravel notifications mail official docs

payment gateway webhook signature verification documentation

payment webhook idempotency duplicate event best practices

coupon promotion usage limit database design

order state transition workflow ecommerce
```

### Cách làm

1. Chạy thử luồng COD đầu tiên.
2. Dùng dữ liệu test có tồn kho thấp để kiểm tra tình huống hết hàng.
3. Thử nhấn Đặt hàng hai lần hoặc gửi lại request.
4. Thử voucher hết hạn và hết lượt.
5. Thử Admin chuyển trạng thái sai quy tắc.
6. Sau khi COD ổn định mới tích hợp thanh toán trực tuyến.
7. Với cổng thanh toán, đọc tài liệu tích hợp chính thức của nhà cung cấp, không dựa vào bài viết không rõ phiên bản.

### Đầu ra cần có

- Luồng mua hàng hoàn chỉnh.
- Luồng Admin hoàn chỉnh.
- Quy tắc voucher.
- Quy tắc thanh toán.
- Thông báo và Queue nếu cần.

---

# 12. Giai đoạn 11 – Kiểm thử toàn hệ thống

## Mục tiêu

Phát hiện lỗi trước khi đưa website đến người dùng thật.

## 12.1. Phân biệt các loại kiểm thử

- **Unit Test:** Kiểm tra một hàm/lớp nhỏ.
- **Feature/Integration Test:** Kiểm tra một endpoint hoặc một nhóm thành phần.
- **Component Test:** Kiểm tra hành vi React component.
- **E2E Test:** Kiểm thử luồng xuyên suốt qua trình duyệt.
- **Manual Test:** Người kiểm thử tự thao tác.
- **Regression Test:** Kiểm tra tính năng cũ sau khi thay đổi code.

## 12.2. Backend Test

Dùng PHPUnit hoặc Pest tùy lựa chọn dự án.

Test các trường hợp:

### Authentication

- Đăng ký thành công.
- Email đã tồn tại.
- Password không đạt yêu cầu.
- Đăng nhập sai.
- Logout.
- Endpoint bảo vệ khi chưa đăng nhập.

### Product

- Lấy danh sách.
- Lấy chi tiết tồn tại.
- ID không tồn tại.
- Search/filter/sort.
- Admin tạo/sửa/xóa.
- Customer không có quyền quản trị.

### Cart/Checkout

- Thêm sản phẩm hợp lệ.
- Thêm sản phẩm không tồn tại.
- Số lượng bằng 0 hoặc âm.
- Vượt tồn kho.
- Cart rỗng.
- Giá thay đổi.
- Tạo đơn thành công.
- Lỗi giữa transaction phải rollback.
- Hai request cạnh tranh tồn kho.

### Order

- User chỉ xem đơn của mình.
- User không thể xem đơn của người khác.
- Admin có quyền xem đơn theo role.
- Chuyển trạng thái hợp lệ.
- Chuyển trạng thái không hợp lệ bị từ chối.

## 12.3. Frontend Test

Dùng Vitest và React Testing Library nếu phù hợp.

Kiểm tra:

- ProductCard render đúng props.
- Nút Add to Cart gọi đúng callback.
- Form hiển thị lỗi.
- Loading/Empty/Error state.
- Pagination đổi trang.
- Route phù hợp.
- Cart hiển thị số lượng và tổng tiền từ nguồn dữ liệu phù hợp.

## 12.4. End-to-End Test

Có thể dùng Playwright.

Luồng E2E quan trọng:

```text
Mở website
 -> Đăng nhập
 -> Tìm sách
 -> Mở chi tiết
 -> Thêm vào giỏ
 -> Checkout
 -> Đặt hàng COD
 -> Xem Order History
 -> Admin đăng nhập
 -> Xem đơn
 -> Cập nhật trạng thái
```

## 12.5. Kiểm thử thủ công

Dùng Chrome DevTools:

- Console: lỗi JavaScript.
- Network: Request, Response, thời gian, status.
- Application: cookie, local/session storage.
- Device toolbar: responsive.

Dùng Postman để kiểm tra Backend độc lập.

## 12.6. Viết Test Case

Mẫu:

| Trường | Nội dung |
|---|---|
| Test Case ID | TC-CART-001 |
| Chức năng | Thêm sách vào giỏ |
| Điều kiện | User đã đăng nhập, sách còn hàng |
| Dữ liệu | book_id=1, quantity=1 |
| Bước | Gửi POST cart/items |
| Kết quả mong đợi | Item được thêm, tổng giỏ cập nhật |
| Kết quả thực tế | Ghi khi chạy test |
| Status | Pass/Fail |

## 12.7. Cách tìm kiếm ở giai đoạn 11

```text
site:laravel.com/docs testing HTTP tests database

site:vitest.dev guide React testing

site:testing-library.com/docs/react-testing-library/intro

site:playwright.dev/docs/intro end to end testing

Postman API testing collections environments official docs

software test cases ecommerce checkout examples

OWASP Web Security Testing Guide authentication access control
```

### Cách làm

1. Viết test case trước khi kiểm thử tính năng phức tạp.
2. Test Backend trước khi test toàn luồng.
3. Test Frontend ở trạng thái success và error.
4. Tạo E2E cho luồng mua hàng quan trọng.
5. Lưu kết quả pass/fail.
6. Tạo bug với bước tái hiện rõ ràng.
7. Sửa lỗi rồi chạy regression test.

### Đầu ra cần có

- Test Plan.
- Test Cases.
- Backend tests.
- Frontend tests.
- E2E tests.
- Bug report và kết quả kiểm thử.

---

# 13. Giai đoạn 12 – Bảo mật và tối ưu hiệu năng

## Mục tiêu

Giảm rủi ro bảo mật và tránh các vấn đề hiệu năng phổ biến.

## 13.1. Authentication và Authorization

- Không lưu mật khẩu dạng plain text.
- Dùng cơ chế xác thực đã chọn đúng hướng dẫn.
- Bảo vệ endpoint cần đăng nhập.
- Kiểm tra quyền tại Backend.
- Kiểm tra quyền sở hữu đơn hàng và dữ liệu riêng tư.
- Có chính sách session/token rõ ràng.
- Không để lộ token trong log hoặc URL.

## 13.2. Input và Output

- Validate mọi input tại Backend.
- Không tin dữ liệu giá/tổng tiền từ frontend.
- Chống Mass Assignment.
- Dùng query parameter binding/Eloquent.
- Không trả dữ liệu nhạy cảm.
- Encode/render nội dung người dùng phù hợp để giảm XSS.
- Giới hạn kích thước request và upload.

## 13.3. Bảo vệ API

- CORS chỉ cho phép origin cần thiết.
- Không dùng wildcard origin với credentials.
- Rate limit các endpoint nhạy cảm.
- Kiểm tra CSRF khi dùng cookie/session.
- HTTPS trên Production.
- Ghi log có chọn lọc, không log secrets.

## 13.4. Database

- Index theo truy vấn thật.
- Eager loading để tránh N+1.
- Pagination.
- Transaction cho nghiệp vụ nhiều thao tác ghi.
- Backup định kỳ.
- User DB có quyền tối thiểu cần thiết.

## 13.5. Frontend

- Lazy load route/ảnh khi phù hợp.
- Tối ưu ảnh.
- Code splitting.
- Tránh render lặp không cần thiết.
- Không tải dữ liệu quá nhiều trong một request.
- Không chứa secrets trong bundle.
- Cache dữ liệu có chính sách invalidation rõ ràng.

## 13.6. Backend

- Cache dữ liệu phù hợp.
- Queue tác vụ nền.
- Tối ưu query.
- Log và theo dõi lỗi.
- Rate limit.
- Kiểm tra package/dependency dễ bị lỗi thời.

## 13.7. Cách tìm kiếm ở giai đoạn 12

```text
OWASP Top 10 web application security official

OWASP API Security Top 10 official

Laravel security authentication authorization CSRF official docs

Laravel Eloquent eager loading N+1 query official docs

MySQL EXPLAIN query optimization official documentation

Vite production build code splitting official docs

React performance rendering official documentation

web image optimization WebP AVIF lazy loading best practices
```

### Cách làm

1. Đọc OWASP Top 10 và API Security Top 10 để biết nhóm rủi ro.
2. Rà soát từng API theo xác thực, phân quyền và validation.
3. Dùng test để chứng minh user không xem được dữ liệu người khác.
4. Kiểm tra SQL query và N+1.
5. Kiểm tra bundle size và ảnh.
6. Chạy dependency audit theo package manager.
7. Không áp dụng cache hoặc Redis chỉ để “có công nghệ”; đo vấn đề trước.

### Đầu ra cần có

- Checklist bảo mật.
- Kết quả rà soát quyền.
- Báo cáo query/performance cơ bản.
- Kế hoạch backup và log.

---

# 14. Giai đoạn 13 – Chuẩn bị Production

## Mục tiêu

Chuẩn bị domain, server, database, cấu hình và quy trình deploy.

## 14.1. Chọn phương án hosting

Phương án phổ biến:

### Frontend

- Static hosting (ví dụ Vercel, Netlify, Cloudflare Pages).
- Hoặc build React rồi phục vụ bằng Nginx trên VPS.

### Backend

- VPS Linux tự quản lý.
- Managed Laravel/PaaS phù hợp.

### Database

- MySQL trên cùng VPS (dễ bắt đầu nhưng cần tự quản lý backup và tài nguyên).
- Managed MySQL (tách biệt, có thể giảm công vận hành).

Không có một phương án đúng cho tất cả. Chọn theo ngân sách, khả năng quản trị Linux, nhu cầu uptime và khối lượng truy cập.

## 14.2. Chuẩn bị domain/subdomain

Ví dụ:

```text
shop.example.com  -> React frontend
api.example.com   -> Laravel backend
```

Cả hai cùng top-level domain giúp cấu hình Sanctum SPA cookie/session thuận lợi hơn. Vẫn phải cấu hình cookie, CORS, CSRF và HTTPS chính xác.

## 14.3. Chuẩn bị server

Nếu dùng VPS Linux, cần tìm hiểu và cài đặt:

- Linux distribution được nhà cung cấp hỗ trợ.
- Nginx.
- PHP phiên bản tương thích và PHP-FPM.
- PHP extensions mà Laravel yêu cầu.
- Composer.
- MySQL hoặc kết nối Managed DB.
- Node.js nếu build frontend trên server; nếu build CI bên ngoài thì không nhất thiết cần Node trên server.
- Supervisor cho Queue Worker nếu sử dụng.
- Cron cho Scheduler nếu sử dụng.
- Firewall.
- SSL/TLS.

## 14.4. Chuẩn bị secrets và biến môi trường

Backend `.env` Production:

- `APP_ENV=production`.
- `APP_DEBUG=false`.
- `APP_KEY` bảo mật.
- Database credentials.
- Mail credentials.
- Session/cache/queue settings.
- Sanctum/CORS settings.

Frontend:

- API base URL.
- Chỉ những biến public cần thiết.
- Không chứa API Secret.

## 14.5. Chuẩn bị vận hành

- Backup Database.
- Backup file upload.
- Log rotation.
- Health check.
- Theo dõi dung lượng đĩa.
- Theo dõi CPU/RAM.
- Quy trình rollback bản deploy lỗi.
- Cách khôi phục backup.

## 14.6. Cách tìm kiếm ở giai đoạn 13

```text
Laravel 13 server requirements PHP extensions official docs

Laravel deployment Nginx PHP-FPM official documentation

Vite static site deployment guide official docs

Nginx try_files SPA React Router deployment configuration

Ubuntu UFW firewall official documentation

Let's Encrypt Certbot Nginx official instructions

managed MySQL backup restore provider documentation

Laravel production environment configuration APP_DEBUG false
```

### Cách làm

1. Chọn nhà cung cấp và khu vực máy chủ.
2. Tạo VPS/hosting và lưu thông tin truy cập an toàn.
3. Tạo DNS record.
4. Cài stack tương thích với Laravel.
5. Tạo Database và user riêng.
6. Thiết lập firewall chỉ mở port cần thiết.
7. Chuẩn bị SSL.
8. Chuẩn bị `.env` an toàn.
9. Viết deployment checklist.
10. Thử triển khai trên staging nếu có thể trước Production.

### Đầu ra cần có

- Domain/DNS.
- Server sẵn sàng.
- Database Production.
- SSL.
- Production env.
- Backup/rollback plan.

---

# 15. Giai đoạn 14 – Deploy Backend Laravel

## Mục tiêu

Đưa API Laravel lên server, kết nối database và cấu hình Nginx/PHP-FPM.

## 15.1. Đưa source lên server

Có thể dùng Git:

```bash
git clone <repository-url>
cd backend
```

Trong Production thực tế, nên dùng deploy key hoặc CI/CD với quyền tối thiểu; không đặt token GitHub trong script công khai.

## 15.2. Cài dependency

```bash
composer install --no-dev --optimize-autoloader
```

Kiểm tra Composer lock file đã được commit để cài dependency nhất quán.

## 15.3. Cấu hình `.env`

Tạo `.env` từ mẫu và điền secrets bằng cách an toàn. Không commit `.env`.

Ví dụ các giá trị chính:

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.example.com

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bookstore
DB_USERNAME=bookstore_user
DB_PASSWORD=<secure-secret>
```

Cấu hình thêm mail, cache, queue, session, filesystem, Sanctum và CORS tùy kiến trúc.

## 15.4. APP_KEY

- Tạo key cho ứng dụng mới bằng Artisan.
- Giữ key ổn định giữa các lần deploy.
- Không tùy tiện chạy lại `key:generate` trên hệ thống đã có dữ liệu mã hóa.
- Backup/khôi phục key an toàn theo quy trình quản trị secrets.

## 15.5. Database Migration

1. Tạo database.
2. Tạo DB user có quyền tối thiểu.
3. Kiểm tra kết nối.
4. Backup trước migration có khả năng thay đổi dữ liệu quan trọng.
5. Chạy migration bằng chế độ Production phù hợp, ví dụ `php artisan migrate --force`.
6. Chạy seeder chỉ khi đã kiểm tra nội dung; tránh seed dữ liệu test vào Production.

## 15.6. Storage và permissions

- Cấu hình filesystem.
- Tạo symbolic link nếu dùng public local storage.
- Cấp quyền ghi tối thiểu cho `storage` và `bootstrap/cache`.
- Không chmod toàn bộ project thành quyền ghi công khai.
- Kiểm tra URL ảnh qua domain thật.

## 15.7. Cấu hình Nginx

Điểm quan trọng:

- Document root phải trỏ đến thư mục `public` của Laravel.
- PHP request chuyển qua PHP-FPM đúng socket/port.
- Cấu hình rewrite/fallback theo hướng dẫn Laravel/Nginx.
- Giới hạn upload body size phù hợp.
- Bật HTTPS.
- Không expose `.env`, `vendor`, source code hoặc thư mục private.

Không sao chép nguyên một file cấu hình Nginx từ tutorial khác mà không điều chỉnh đường dẫn, phiên bản PHP-FPM và domain.

## 15.8. Tối ưu Laravel

Theo hướng dẫn phiên bản đang chạy, cân nhắc:

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

Chỉ chạy các lệnh phù hợp với ứng dụng và cách deploy. Lưu ý khi config cache, việc gọi `env()` ngoài file config không hoạt động như lúc local; hãy đọc giá trị cấu hình thông qua `config()` trong code ứng dụng.

## 15.9. Queue và Scheduler

Nếu dùng Queue:

- Cấu hình connection.
- Chạy worker dưới process manager như Supervisor hoặc dịch vụ tương ứng.
- Đảm bảo worker tự khởi động lại sau reboot.
- Có chiến lược retry và failed jobs.
- Reload worker khi deploy code mới theo quy trình Laravel.

Nếu dùng Scheduler:

- Cấu hình Cron gọi `schedule:run` theo hướng dẫn Laravel.
- Kiểm tra lịch chạy và timezone.

## 15.10. Kiểm tra Backend sau deploy

- API health endpoint.
- Kết nối DB.
- Login/logout.
- Cookie/CSRF nếu dùng Sanctum SPA.
- Upload ảnh.
- Queue worker.
- Log không có exception nghiêm trọng.
- Nginx/PHP-FPM không trả 502/500.

## 15.11. Cách tìm kiếm ở giai đoạn 14

```text
site:laravel.com/docs deployment production Nginx

Laravel 13 Nginx PHP-FPM configuration official documentation

Ubuntu install PHP extensions MySQL Nginx official documentation

Composer install no-dev optimize-autoloader production

Laravel storage link permissions deployment official docs

Laravel queue worker Supervisor production documentation

Laravel scheduler cron production official docs

Nginx error log 502 Bad Gateway PHP-FPM troubleshooting
```

### Cách làm

1. Đọc Laravel Deployment docs đúng version.
2. Xác nhận PHP-FPM version và socket.
3. Deploy code.
4. Cài dependency.
5. Cấu hình `.env`.
6. Migrate.
7. Cấu hình storage và permissions.
8. Cấu hình Nginx và SSL.
9. Cache config/route phù hợp.
10. Cấu hình worker/scheduler.
11. Test API qua domain HTTPS.
12. Kiểm tra log khi có lỗi.

### Đầu ra cần có

- Laravel API chạy trên HTTPS.
- MySQL production kết nối thành công.
- Upload/Storage hoạt động.
- Queue/Scheduler hoạt động nếu dùng.
- Không lộ debug/secrets.

---

# 16. Giai đoạn 15 – Deploy Frontend React

## Mục tiêu

Build React thành tài nguyên tĩnh và đưa lên hosting/VPS.

## 16.1. Kiểm tra cấu hình API

Ví dụ:

```env
VITE_API_BASE_URL=https://api.example.com
```

Nhớ rằng biến Vite được nhúng vào bundle ở thời điểm build. Khi thay đổi API URL, thường cần build/deploy lại.

## 16.2. Build

```bash
npm ci
npm run build
```

`npm ci` phù hợp khi có lockfile và muốn cài dependencies đúng lockfile. Kiểm tra build không có lỗi. Thư mục output mặc định của Vite thường là `dist`, nhưng cần kiểm tra `vite.config` nếu đã tùy chỉnh.

## 16.3. Deploy lên Static Hosting

Quy trình tổng quát:

1. Kết nối Git repository.
2. Cấu hình build command.
3. Cấu hình output directory.
4. Khai báo environment variables.
5. Thiết lập domain.
6. Cấu hình SPA fallback/rewrites theo nền tảng.
7. Kiểm tra HTTPS.
8. Deploy.

## 16.4. Deploy lên VPS/Nginx

1. Build ở máy local hoặc CI.
2. Upload nội dung `dist` lên thư mục hosting.
3. Cấu hình Nginx phục vụ file tĩnh.
4. Cấu hình fallback về `index.html` cho React Router.
5. Gắn domain và SSL.
6. Kiểm tra cache headers của file static.
7. Kiểm tra đường dẫn asset sau deploy.

## 16.5. Kiểm tra giao tiếp với Backend

Với Sanctum SPA cookie/session:

- Frontend và API cần đáp ứng yêu cầu cùng top-level domain.
- Cấu hình `stateful` domain.
- CORS cho đúng origin và bật credentials.
- Cookie domain/secure/same-site đúng môi trường.
- Axios gửi credentials và XSRF token theo tài liệu.
- Gọi CSRF cookie endpoint trước khi login theo quy trình Sanctum.
- Dùng HTTPS.

Nếu frontend và backend khác top-level domain, cần đánh giá lại lựa chọn Authentication và chính sách cookie trước khi deploy; đừng mặc định cookie sẽ chia sẻ được.

## 16.6. Cách tìm kiếm ở giai đoạn 15

```text
Vite deploy static site official guide

Vercel Vite React deployment documentation

Netlify Vite deploy configuration documentation

Nginx React SPA try_files index.html official documentation

React Router SPA deployment rewrite rules

Laravel Sanctum SPA production subdomain cookie configuration

Vite env variables production build official docs
```

### Cách làm

1. Đọc hướng dẫn deploy của nền tảng định chọn.
2. Kiểm tra `npm run build` local.
3. Đặt API URL production trước khi build.
4. Deploy.
5. Mở trực tiếp từng route và refresh.
6. Kiểm tra Network để xem API gọi đúng domain.
7. Kiểm tra cookie/CSRF/CORS.
8. Kiểm tra responsive và ảnh.

### Đầu ra cần có

- Frontend truy cập bằng domain HTTPS.
- Route hoạt động khi refresh.
- API gọi đúng Backend Production.
- Không có secret trong bundle.

---

# 17. Giai đoạn 16 – Kiểm tra sau Deploy và bảo trì

## Mục tiêu

Xác nhận website hoạt động trên môi trường thực và có kế hoạch vận hành.

## 17.1. Smoke Test

Chạy các kiểm tra nhanh sau deploy:

- Trang chủ mở được.
- Trang sản phẩm mở được.
- Chi tiết sản phẩm hoạt động.
- Hình ảnh tải được.
- Login/logout.
- Cart.
- Checkout COD.
- Order History.
- Admin login.
- CRUD sản phẩm.
- Admin cập nhật đơn.

## 17.2. Kiểm tra kỹ thuật

- Không có lỗi Console nghiêm trọng.
- Không có request localhost trong Production.
- Không có CORS error.
- Không có mixed content HTTP/HTTPS.
- HTTPS hợp lệ.
- Không expose `.env`.
- `APP_DEBUG=false`.
- Nginx/PHP-FPM ổn định.
- Queue worker còn chạy.
- Database không đầy disk.

## 17.3. Backup và Restore

- Backup Database định kỳ.
- Backup file ảnh/upload.
- Lưu backup tách khỏi VPS.
- Mã hóa backup nếu chứa dữ liệu nhạy cảm.
- Đặt thời hạn lưu giữ.
- Thử restore định kỳ.
- Ghi quy trình khôi phục và người chịu trách nhiệm.

Backup chưa được kiểm chứng restore thì chưa thể coi là phương án khôi phục đáng tin cậy.

## 17.4. Monitoring và Logs

Theo dõi:

- Laravel log.
- Nginx access/error log.
- PHP-FPM log.
- Queue failed jobs.
- Database availability.
- CPU/RAM/disk.
- Tỷ lệ lỗi API.
- Thời gian phản hồi.
- Thời hạn SSL.

Không ghi password, full token hoặc dữ liệu thanh toán vào log.

## 17.5. Quy trình bảo trì

1. Tiếp nhận bug hoặc yêu cầu mới.
2. Tái hiện lỗi.
3. Tìm nguyên nhân.
4. Tạo branch sửa lỗi.
5. Viết test tái hiện lỗi nếu phù hợp.
6. Sửa code.
7. Chạy test.
8. Review.
9. Deploy staging/production.
10. Theo dõi sau deploy.
11. Rollback nếu phát sinh lỗi nghiêm trọng.

## 17.6. Cách tìm kiếm ở giai đoạn 16

```text
Laravel application monitoring logs production

Nginx access error logs official documentation

MySQL backup restore mysqldump official documentation

VPS monitoring CPU RAM disk alerting guide

Laravel health route deployment documentation

production deployment rollback strategy database migration

SSL certificate expiry monitoring best practices
```

### Đầu ra cần có

- Smoke test report.
- Backup schedule.
- Restore procedure.
- Monitoring/logging.
- Bug/maintenance backlog.

---

# 18. Lộ trình code theo module và Sprint

Các giai đoạn 1–16 mô tả vòng đời dự án. Khi code thực tế, nên triển khai theo module dọc (vertical slice): Database → Backend API → Frontend → Integration → Test. Cách này giúp sớm có một luồng chạy hoàn chỉnh.

## Sprint 1 – Phân tích và nền tảng

### Task

- Chốt yêu cầu MVP.
- Viết User Stories.
- Vẽ Use Case.
- Vẽ Activity/Sequence quan trọng.
- Thiết kế architecture.
- Thiết kế ERD.
- Khởi tạo Git.
- Khởi tạo React/Vite/Tailwind.
- Khởi tạo Laravel.
- Kết nối MySQL.

### Definition of Done

- Tài liệu yêu cầu được chốt.
- ERD được kiểm tra.
- Hai project chạy local.
- Database kết nối được.
- README có lệnh khởi chạy.

## Sprint 2 – Authentication và Catalog

### Task

- Migration users/categories/books/authors/publishers.
- Model và relationships.
- Seeder/Factory.
- Sanctum configuration.
- Register/Login/Logout/Me API.
- Category API.
- Book list/detail API.
- Search/filter/sort/pagination.
- React Login/Register.
- React Home/Products/Detail.
- Admin CRUD catalog cơ bản.

### Definition of Done

- Auth đúng cơ chế.
- React lấy dữ liệu sách từ Laravel.
- CRUD catalog có authorization.
- API test pass.

## Sprint 3 – Cart

### Task

- Migration carts/cart_items.
- Cart relationships.
- Cart API.
- Kiểm tra số lượng và tồn kho.
- React Cart Page.
- Cập nhật/xóa item.
- Tổng tiền hiển thị.

### Definition of Done

- Giỏ hàng gắn với đúng user.
- Không tin giá client.
- Cart API và UI hoạt động.

## Sprint 4 – Checkout và Order

### Task

- Migration orders/order_items/status history.
- Thiết kế trạng thái đơn hàng.
- Checkout validation.
- Transaction.
- Snapshot sản phẩm/giá.
- Order API.
- React Checkout.
- React Order History/Detail.
- Admin Order Management.

### Definition of Done

- Đặt hàng COD end-to-end.
- Tổng tiền do Backend tính.
- Tồn kho được kiểm tra và cập nhật an toàn.
- Customer chỉ xem được đơn của mình.

## Sprint 5 – Nghiệp vụ mở rộng và kiểm thử

### Task

- Voucher.
- Review.
- Wishlist.
- Payment gateway nếu có phạm vi.
- Email/Queue.
- Dashboard.
- Backend tests.
- Frontend tests.
- E2E tests.
- Security review.

### Definition of Done

- Các nghiệp vụ mở rộng hoạt động.
- Có test cho luồng quan trọng.
- Các lỗi nghiêm trọng đã được xử lý.

## Sprint 6 – Production và Deploy

### Task

- Chọn hosting.
- Chuẩn bị domain/DNS.
- Chuẩn bị VPS/hosting.
- Deploy Laravel.
- Deploy React.
- Cấu hình SSL.
- Cấu hình CORS/Sanctum.
- Backup.
- Monitoring.
- Smoke test.

### Definition of Done

- Website chạy bằng domain HTTPS.
- Customer mua được hàng.
- Admin quản lý được đơn/sản phẩm.
- Có backup và cách restore.
- Không để lộ secrets/debug.

---

# 19. Quy trình tìm kiếm và xử lý lỗi kỹ thuật

Khi gặp lỗi, không nên thay nhiều thứ cùng lúc. Dùng quy trình sau.

## 19.1. Quy trình 8 bước

1. **Tái hiện lỗi:** Ghi các bước khiến lỗi xuất hiện.
2. **Đọc thông báo đầy đủ:** Không chỉ nhìn dòng cuối; xem stack trace và error code.
3. **Xác định tầng:** Frontend, Network, Laravel, Database, Web Server hay môi trường.
4. **Thu thập bằng chứng:** Console, Network, Laravel log, SQL, version.
5. **Tìm kiếm chính xác:** Search nguyên văn error trong dấu ngoặc kép + tên framework/version.
6. **Đối chiếu tài liệu:** Ưu tiên đúng version và issue được xác nhận.
7. **Thử một thay đổi:** Ghi lại kết quả trước/sau.
8. **Viết test hoặc ghi chú:** Đảm bảo lỗi không quay lại.

## 19.2. Xác định lỗi theo tầng

| Hiện tượng | Nơi kiểm tra trước |
|---|---|
| Trang React trắng | Browser Console, Vite build, import/component |
| API không gọi được | Network tab, URL, CORS, server status |
| 401 | Authentication/session/cookie/token |
| 403 | Middleware, Policy, role, ownership |
| 419 | CSRF/session/cookie nếu dùng Laravel web/session |
| 422 | Form Request validation và payload |
| 404 API | Route, prefix, HTTP method, route cache |
| 500 | Laravel log, exception, DB query |
| SQLSTATE | Connection, schema, FK, dữ liệu |
| 502/504 | Nginx, PHP-FPM, timeout, service process |
| Ảnh không hiện | Storage path, symlink, permissions, URL |
| Refresh route bị 404 | SPA fallback của hosting/Nginx |

## 19.3. Cụm từ tìm kiếm lỗi

```text
"exact error message" Laravel 13

"SQLSTATE[23000]" MySQL foreign key Laravel

"419 Page Expired" Laravel Sanctum SPA CSRF

"CORS policy" Laravel React credentials

"502 Bad Gateway" Nginx PHP-FPM Ubuntu

"Vite build failed" Tailwind CSS version

"The requested module does not provide an export" React Vite
```

Thay version theo dự án. Xóa thông tin riêng tư khỏi log trước khi đăng lên diễn đàn.

## 19.4. Nhật ký lỗi

Tạo bảng hoặc file issue gồm:

| Trường | Nội dung |
|---|---|
| ID | BUG-001 |
| Summary | Mô tả ngắn |
| Environment | Local/Staging/Production |
| Version | Laravel/React/PHP/Node |
| Steps | Các bước tái hiện |
| Expected | Kết quả mong đợi |
| Actual | Kết quả thực tế |
| Evidence | Log/screenshot đã ẩn dữ liệu nhạy cảm |
| Root cause | Nguyên nhân |
| Fix | Cách sửa |
| Regression test | Kiểm tra lại |

---

# 20. Bộ tài liệu cần lưu trong dự án

```text
docs/
├── 01-requirements/
│   ├── requirements.md
│   ├── user-stories.md
│   └── acceptance-criteria.md
│
├── 02-analysis/
│   ├── actors-and-use-cases.md
│   ├── activity-diagrams.md
│   ├── sequence-diagrams.md
│   └── business-rules.md
│
├── 03-design/
│   ├── architecture.md
│   ├── erd.md
│   ├── data-dictionary.md
│   └── ui-ux.md
│
├── 04-api/
│   ├── conventions.md
│   ├── authentication.md
│   ├── catalog.md
│   ├── cart.md
│   ├── checkout-orders.md
│   └── admin.md
│
├── 05-testing/
│   ├── test-plan.md
│   ├── test-cases.md
│   ├── test-results.md
│   └── bug-reports.md
│
├── 06-deployment/
│   ├── architecture-production.md
│   ├── environment-variables.md
│   ├── deployment-guide.md
│   ├── backup-restore.md
│   └── rollback.md
│
└── decisions/
    └── ADR-001-authentication-strategy.md
```

Nên có tài liệu quyết định kiến trúc (ADR) cho các lựa chọn quan trọng như:

- Chọn Sanctum SPA cookie/session hay bearer token.
- Một sách có một hay nhiều danh mục.
- Tồn kho trừ ở thời điểm tạo đơn hay xác nhận đơn.
- Hủy đơn có hoàn kho theo trạng thái nào.
- Dùng local storage hay object storage cho ảnh.
- Cách lưu và xác minh thanh toán.

---

# 21. Checklist tổng trước khi công bố website

## Phân tích và thiết kế

- [ ] Phạm vi MVP đã chốt.
- [ ] Actor và chức năng đã rõ.
- [ ] User Story có Acceptance Criteria.
- [ ] Use Case/Activity/Sequence cho luồng quan trọng.
- [ ] Architecture diagram.
- [ ] API contract.
- [ ] ERD và Data Dictionary.
- [ ] Wireframe/UI design.

## Môi trường và mã nguồn

- [ ] React/Vite/Tailwind chạy local.
- [ ] Laravel chạy local.
- [ ] MySQL kết nối.
- [ ] Phiên bản dependency đã được kiểm tra.
- [ ] `.env` không được commit.
- [ ] README có hướng dẫn chạy dự án.
- [ ] Git branch/commit rõ ràng.

## Backend

- [ ] Migration chạy được.
- [ ] Model và relationships đúng.
- [ ] Validation đầy đủ.
- [ ] Authorization/ownership đầy đủ.
- [ ] API Resource nhất quán.
- [ ] Transaction cho nghiệp vụ cần thiết.
- [ ] Upload được kiểm soát.
- [ ] Logs không chứa secrets.

## Frontend

- [ ] Route hoạt động.
- [ ] Component có trách nhiệm rõ.
- [ ] Loading/Empty/Error/Success.
- [ ] Form hiển thị validation.
- [ ] Responsive.
- [ ] Không chứa secret.
- [ ] Không gọi localhost ở Production.

## Nghiệp vụ

- [ ] Đăng ký/đăng nhập/đăng xuất.
- [ ] Xem/tìm/lọc sản phẩm.
- [ ] Giỏ hàng.
- [ ] Checkout COD.
- [ ] Tổng tiền tính ở Backend.
- [ ] Tồn kho được kiểm soát.
- [ ] Đơn hàng và lịch sử.
- [ ] Admin quản lý sản phẩm/đơn.
- [ ] Trạng thái đơn đúng quy tắc.

## Kiểm thử và bảo mật

- [ ] Backend tests.
- [ ] Frontend tests.
- [ ] E2E luồng mua hàng.
- [ ] Kiểm tra user không xem được đơn người khác.
- [ ] Kiểm tra API Admin.
- [ ] Kiểm tra request sai và dữ liệu bất thường.
- [ ] Kiểm tra CORS/CSRF/session.
- [ ] `APP_DEBUG=false`.
- [ ] HTTPS.

## Deploy và vận hành

- [ ] Domain/DNS.
- [ ] Backend deploy.
- [ ] Frontend deploy.
- [ ] Database Production.
- [ ] Upload ảnh hoạt động.
- [ ] Queue/Scheduler nếu dùng.
- [ ] SPA fallback.
- [ ] Backup Database.
- [ ] Backup file upload.
- [ ] Đã thử restore.
- [ ] Logs/monitoring.
- [ ] Có quy trình rollback.

---

# 22. Nguồn tài liệu chính thức

> **Cách dùng:** Chọn đúng phiên bản đang cài trong project. Tài liệu ở nhánh `master` hoặc `next` có thể mô tả phiên bản đang phát triển; ưu tiên trang tài liệu version ổn định tương ứng với project.

## React

- [React – Quick Start](https://react.dev/learn)
- [React – Installation](https://react.dev/learn/installation)
- [React – Managing State](https://react.dev/learn/managing-state)
- [React – API Reference](https://react.dev/reference/react)

## Vite

- [Vite – Getting Started](https://vite.dev/guide/)
- [Vite – Environment Variables and Modes](https://vite.dev/guide/env-and-mode)
- [Vite – Building for Production](https://vite.dev/guide/build)
- [Vite – Deploying a Static Site](https://vite.dev/guide/static-deploy)

## Tailwind CSS

- [Tailwind CSS – Installation with Vite](https://tailwindcss.com/docs/installation/using-vite)
- [Tailwind CSS – Responsive Design](https://tailwindcss.com/docs/responsive-design)
- [Tailwind CSS – Grid Template Columns](https://tailwindcss.com/docs/grid-template-columns)

## Laravel

- [Laravel – Documentation](https://laravel.com/docs)
- [Laravel – Installation](https://laravel.com/docs/installation)
- [Laravel – Migrations](https://laravel.com/docs/migrations)
- [Laravel – Eloquent Relationships](https://laravel.com/docs/eloquent-relationships)
- [Laravel – Validation](https://laravel.com/docs/validation)
- [Laravel – API Resources](https://laravel.com/docs/eloquent-resources)
- [Laravel – Authorization](https://laravel.com/docs/authorization)
- [Laravel – Filesystem](https://laravel.com/docs/filesystem)
- [Laravel – Sanctum](https://laravel.com/docs/sanctum)
- [Laravel – Queues](https://laravel.com/docs/queues)
- [Laravel – Notifications](https://laravel.com/docs/notifications)
- [Laravel – Testing](https://laravel.com/docs/testing)
- [Laravel – Deployment](https://laravel.com/docs/deployment)

## MySQL

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MySQL Reference Manual](https://dev.mysql.com/doc/refman/)

## Testing và API

- [Playwright – Getting Started](https://playwright.dev/docs/intro)
- [Vitest – Guide](https://vitest.dev/guide/)
- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [Postman Learning Center](https://learning.postman.com/)
- [MDN – HTTP Response Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

## Bảo mật

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP API Security Project](https://owasp.org/www-project-api-security/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)

## Git và triển khai

- [Pro Git Book](https://git-scm.com/book/en/v2)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)

---

# Kết luận – Cách bắt đầu thực tế

Không cần triển khai cả 16 giai đoạn trong một lần. Bắt đầu bằng các công việc sau:

1. Hoàn thiện yêu cầu MVP và User Stories.
2. Vẽ ERD cho các bảng cần dùng trong MVP.
3. Chốt kiến trúc React SPA + Laravel API + MySQL và Authentication.
4. Khởi tạo project, Git và môi trường local.
5. Tạo Migration, Model và Seeder.
6. Làm module Authentication.
7. Làm module Category và Book từ Database → API → React → Test.
8. Tiếp tục Cart → Checkout → Order → Admin.
9. Kiểm thử, bảo mật và tối ưu.
10. Deploy Backend, Frontend và kiểm tra Production.

**Nguyên tắc quan trọng nhất:** Mỗi chức năng phải có yêu cầu rõ ràng, dữ liệu rõ ràng, API rõ ràng, giao diện rõ ràng và tiêu chí kiểm thử. Làm theo từng module hoàn chỉnh sẽ giúp bạn hiểu được luồng dữ liệu từ React → Laravel → MySQL → Laravel → React, thay vì chỉ tạo ra nhiều file code nhưng không nắm được cách toàn hệ thống vận hành.
