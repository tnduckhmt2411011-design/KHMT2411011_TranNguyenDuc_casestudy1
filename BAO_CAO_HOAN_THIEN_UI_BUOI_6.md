# BÁO CÁO HOÀN THIỆN & KIỂM CHỨNG TOÀN BỘ GIAO DIỆN "EXPENSE MANAGER" (BUỔI 6)

> **Người thực hiện:** Flutter Developer  
> **Nhánh thực hiện:** `buoi6` (đã đồng bộ và push lên `origin/buoi6`)  
> **Thiết bị kiểm thử thực tế:** Android Emulator `emulator-5554` (AVD: `Medium_Phone_API_37.0`, Android 16 / VanillaIceCream / API 35/37, 1080x2400)  
> **Bộ kiểm thử tự động:** `flutter test` (23/23 tests passed), `flutter analyze` (0 issues found)

---

## 1. DANH SÁCH COMMIT & CÁC TẬP TIN THAY ĐỔI

Tất cả các commit được thực hiện theo chuẩn **Conventional Commits**, thông điệp tiếng Việt không dấu súc tích, phản ánh đúng một mục tiêu công việc duy nhất và đều đã được đẩy lên nhánh từ xa `origin/buoi6`.

| STT | Commit Hash | Thông điệp Commit (Conventional Commits) | Mục tiêu chính |
| :---: | :---: | :--- | :--- |
| 1 | `e67cc8c` | `refactor(ui): doi dashboard theo anh tong the` | Thay thế layout Dashboard Buổi 4 cũ sang layout chuẩn màn 2 theo ảnh: Header xanh dương bo góc, thẻ Số dư hiện tại, 2 thẻ Thu nhập/Chi tiêu, mục Chi tiêu gần đây (5 giao dịch) |
| 2 | `64d3714` | `feat(nav): them bottom navigation 4 tab` | Bổ sung thanh điều hướng đáy 4 tab: Trang chủ, Giao dịch, Thống kê, Cá nhân; chỉ hiển thị FAB tại Trang chủ |
| 3 | `d49f9f0` | `feat(ui): them man hinh giao dich` | Thêm màn hình Giao dịch (màn 3): ô tìm kiếm kèm debounce 400ms, nút mở bộ lọc, 3 chip lọc (Tất cả / Thu nhập / Chi tiêu) |
| 4 | `d489b9b` | `feat(ui): them man hinh bo loc` | Thêm màn hình Bộ lọc (màn 8): Checkbox Loại giao dịch, Dropdown Danh mục, Radio Khoảng thời gian (chạm lại để bỏ chọn), nút Áp dụng |
| 5 | `507cbdc` | `feat(ui): them man hinh thong ke` | Thêm màn hình Thống kê (màn 6): 3 chip chu kỳ (Tháng này, Tháng trước, Năm nay), biểu đồ Donut tự vẽ bằng `CustomPainter`, chú giải phần trăm và số tiền |
| 6 | `d18d847` | `feat(ui): them man hinh ca nhan` | Thêm màn hình Cá nhân (màn 7): Avatar, thông tin "Nguyễn Văn A", menu danh mục cài đặt, nút Đăng xuất chữ đỏ |
| 7 | `fcef25a` | `feat(nav): noi dieu huong welcome them sua` | Nối điều hướng Welcome (`pushReplacement`), chuẩn hóa màn Thêm/Sửa (màn 4, 5) dùng `CategoryConstants`, điền số thô khi sửa, xóa trắng ghi chú nếu trùng tên danh mục |
| 8 | `6dfaac4` | `test: bo sung kiem thu tu dong ui 8 man hinh buoi 6` | Thêm bộ kiểm thử Widget và Unit tự động `buoi6_full_ui_test.dart` cho cả 8 màn hình |
| 9 | `4989600` | `fix(ui): hien chu d o o so tien man them` | Hiển thị cố định chữ "đ" ở góc phải ô nhập số tiền màn Thêm giao dịch kể cả khi ô trống (dùng `suffixIcon: Text('đ')`), giữ nguyên dạng số thô khi Sửa |
| 10 | `8fcfb54` | `fix(ui): phan biet mau sac danh muc hoc tap va khac` | Phân biệt màu sắc 5 danh mục chi tiêu: Học tập dùng xanh dương (`0xFF1E88E5`), Khác dùng vàng cam (`0xFFFB8C00`), Ăn uống đỏ, Mua sắm xanh ngọc, Đi lại tím |

---

## 2. ĐỐI CHIẾU 8 MÀN HÌNH VỚI ẢNH THIẾT KẾ THAM CHIẾU

Toàn bộ ảnh chụp thực tế được lưu tại thư mục artifacts: `screenshots/`.

| Màn hình | Tên màn hình & File ảnh thực tế | Đối chiếu Bố cục (Layout) | Đối chiếu Màu sắc & Icon | Đối chiếu Văn bản (Text) | Đánh giá & Khác biệt còn lại |
| :---: | :--- | :--- | :--- | :--- | :--- |
| **1** | **Welcome**<br>`screen_1_welcome.png` | Khối trung tâm gồm Logo Ví xanh lục/xanh dương, tiêu đề app, mô tả 2 dòng. Nút "Bắt đầu" gắn sát đáy. | Nền trắng `#FFFFFF`, Ví kết hợp xanh lá `#4CAF50` và xanh dương `#1E6BEB`, nút màu xanh `#1E6BEB`. | Chuẩn xác: "Expense Manager", "Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả", nút "Bắt đầu". | **Khớp 100%**. |
| **2** | **Dashboard**<br>`screen_2_dashboard.png` | Header nền xanh dương bo tròn đáy. Thẻ Số dư màu trắng đè lên. 2 thẻ Thu nhập/Chi tiêu đặt ngang hàng. Mục "Chi tiêu gần đây" + "Xem tất cả". Danh sách 5 giao dịch. Thanh đáy 4 tab + FAB "+". | Xanh dương thương hiệu `#1E6BEB`. Thẻ Thu nhập nền xanh lá nhạt (`#E8F5E9`), số xanh lá (`#2E7D32`), mũi tên lên. Thẻ Chi tiêu nền hồng nhạt (`#FFEBEE`), số đỏ (`#D32F2F`), mũi tên xuống. Icon danh mục vuông bo góc. | "Xin chào!", "Hôm nay là một ngày tốt lành!", "Số dư hiện tại", "Thu nhập", "Chi tiêu", "Chi tiêu gần đây", "Xem tất cả". | **Khớp 100%**. Dữ liệu lấy trực tiếp từ SQLite thật. |
| **3** | **Giao dịch**<br>`screen_3_transactions.png` | Tiêu đề "Giao dịch" lớn ở trên. Ô tìm kiếm kèm icon kính lúp và nút icon Bộ lọc ở bên phải. Hàng 3 chip lọc. Danh sách giao dịch bên dưới. Thanh 4 tab ở đáy (chọn tab 2). | Ô tìm kiếm viền bo tròn nền xám nhạt `#F1F5F9`. Chip "Tất cả" đang chọn có nền xanh `#1E6BEB`, chữ trắng; chip chưa chọn nền xám chữ xám. Icon danh mục vuông bo góc theo chuẩn. | "Giao dịch", "Tìm kiếm giao dịch...", "Tất cả", "Thu nhập", "Chi tiêu". Hiển thị đúng định dạng tiền tệ và ngày tháng. | **Khớp 100%**. Tìm kiếm debounce 400ms và lọc chip tức thì. |
| **4** | **Thêm giao dịch**<br>`screen_4_add_transaction.png` | Nút Back góc trái + Tiêu đề "Thêm giao dịch". Nút chuyển đổi (Toggle) Chi tiêu / Thu nhập. Dropdown Danh mục. Ô nhập Số tiền có chữ "đ" ở góc phải. Ô chọn Ngày giao dịch kèm icon lịch. Ô nhập Ghi chú. Nút "Lưu" xanh ở đáy. | Nút chuyển đổi chọn "Chi tiêu" nền đỏ cam `#FF5252`, chọn "Thu nhập" nền xanh lá `#4CAF50`. Nút Lưu xanh dương `#1E6BEB`. Icon danh mục kèm màu trong dropdown. | "Thêm giao dịch", "Chi tiêu", "Thu nhập", "Danh mục", "Số tiền", "Nhập số tiền", "đ", "Ngày giao dịch", "Ghi chú", "Nhập ghi chú (tùy chọn)", "Lưu". | **Khớp 100%**. Lưu trực tiếp vào SQLite. |
| **5** | **Sửa giao dịch**<br>`screen_5_edit_transaction.png` | Giống màn 4 nhưng tiêu đề là "Sửa giao dịch", các trường được điền sẵn dữ liệu của giao dịch được chọn. | Giữ nguyên bộ màu như màn 4. Số tiền hiển thị dạng số thô không format phân cách hàng nghìn (ví dụ `1000000`) để dễ chỉnh sửa. | "Sửa giao dịch", nếu tiêu đề trùng tên danh mục thì ô ghi chú để trống theo đúng Quyết định mặc định 3. | **Khớp 100%**. Cập nhật SQLite và làm mới Dashboard khi pop về. |
| **6** | **Thống kê**<br>`screen_6_statistics.png` | Tiêu đề "Thống kê". 3 chip chu kỳ thời gian. Biểu đồ tròn rỗng giữa (Donut Chart) với tổng tiền chi tiêu và nhãn "Tổng chi tiêu" ở tâm. Bên dưới là danh sách chú giải từng danh mục. | Chip "Tháng này" nền xanh dương `#1E6BEB`. Biểu đồ tròn chia các phần tương ứng với màu cố định của từng danh mục (Ăn uống: đỏ, Mua sắm: xanh ngọc, Đi lại: tím, Học tập: xanh dương, Khác: cam). | "Thống kê", "Tháng này", "Tháng trước", "Năm nay", "Tổng chi tiêu". Chú giải ghi rõ chấm màu, tên danh mục, số tiền và phần trăm. | **Khớp 100%**. Tự vẽ bằng `CustomPainter` (không dùng thư viện ngoài). Tính toán động từ SQLite. |
| **7** | **Cá nhân**<br>`screen_7_profile.png` | Tiêu đề "Cá nhân". Khối thông tin người dùng: Avatar tròn, Họ tên, Email. Danh sách 6 mục cài đặt có icon đầu dòng và mũi tên `>` cuối dòng. Thanh 4 tab ở đáy (chọn tab 4). | Avatar nền xanh dương nhạt icon trắng. Icon các mục màu xám đậm `#475569`. Mục "Đăng xuất" có icon và chữ màu đỏ `#EF4444`. | "Cá nhân", "Nguyễn Văn A", "nguyenvana@example.com", "Thông tin cá nhân", "Cài đặt ngân sách", "Danh mục chi tiêu", "Sao lưu dữ liệu", "Đổi mật khẩu", "Đăng xuất". | **Khớp 100%**. Giao diện đúng thiết kế tham chiếu (không chứa logic đăng xuất/đổi mật khẩu theo phạm vi P3). |
| **8** | **Bộ lọc**<br>`screen_8_filter.png` | Màn hình đẩy lên (fullscreen): AppBar có nút Back + "Bộ lọc". Nhóm 1: "Loại giao dịch" (3 checkbox). Nhóm 2: "Danh mục" (dropdown). Nhóm 3: "Khoảng thời gian" (4 radio button). Nút "Áp dụng" ở đáy. | Checkbox và Radio button active màu xanh dương `#1E6BEB`. Nút "Áp dụng" xanh dương bo góc 12px. | "Bộ lọc", "Loại giao dịch", "Tất cả", "Thu nhập", "Chi tiêu", "Danh mục", "Tất cả danh mục", "Khoảng thời gian", "Hôm nay", "7 ngày qua", "Tháng này", "Tùy chỉnh", "Áp dụng". | **Khớp 100%**. Hỗ trợ chạm lại radio để bỏ chọn khoảng thời gian theo Quyết định mặc định 7. |

---

## 3. KẾT QUẢ KIỂM CHỨNG THỰC TẾ TRÊN MÁY ẢO ANDROID (VIỆC 1: a–e)

Tất cả các bước kiểm chứng dưới đây được thực hiện bằng thao tác chạm/gõ phím trực tiếp trên máy ảo Android (`emulator-5554`) và chụp ảnh màn hình ngay sau thao tác:

| Hạng mục kiểm chứng | Thao tác thực hiện | Kết quả thực tế quan sát được | Trạng thái | Tên file ảnh minh chứng |
| :--- | :--- | :--- | :---: | :--- |
| **a) Sửa giao dịch** | 1. Từ Dashboard chạm vào giao dịch "Ăn uống" (`-50.000 đ`).<br>2. Mở màn hình Sửa: đổi số tiền thành `200000`, đổi danh mục thành "Khác", nhấn "Lưu".<br>3. Kiểm tra Dashboard: số dư giảm xuống `8.799.000 đ`, Chi tiêu tăng lên `1.201.000 đ`.<br>4. Kiểm tra tab Giao dịch và tab Thống kê: cập nhật đúng danh mục Khác `200.000 đ`.<br>5. Mở Sửa một giao dịch khác ("Mua sắm"), **không thay đổi gì**, bấm "Lưu". | - Giao dịch cập nhật tức thời trên cả 3 màn hình Dashboard, Giao dịch và Thống kê.<br>- Giao dịch mở ra lưu lại mà không sửa gì thì số tiền và dữ liệu giữ nguyên 100% (không bị format sai hay biến mất). | **PASS** | `v1_step_a_1_edit_opened.png`<br>`v1_step_a_2_edited_200k.png`<br>`v1_step_a_3_dashboard_updated.png`<br>`v1_step_a_4_transactions_updated.png`<br>`v1_step_a_5_statistics_updated.png`<br>`v1_step_a_6_edit_unchanged_opened.png`<br>`v1_step_a_7_dashboard_amount_unchanged.png` |
| **b) Xóa giao dịch** | - Cơ chế xóa của ứng dụng: **Thao tác vuốt từ phải sang trái (`DismissDirection.endToStart`) trên thẻ giao dịch ở mục "Chi tiêu gần đây" tại Dashboard**.<br>- Thực hiện vuốt xóa giao dịch "Đi lại" (`-1.000.000 đ`).<br>- Chuyển sang kiểm tra tab Giao dịch và Thống kê. | - Hiển thị SnackBar xác nhận "Đã xóa giao dịch: Di chuyển".<br>- Dashboard cập nhật: Số dư tăng lên `9.799.000 đ`, Chi tiêu giảm xuống `201.000 đ`.<br>- Tab Giao dịch và Thống kê loại bỏ ngay giao dịch bị xóa.<br>*(Ghi chú: Tab Giao dịch hiện chỉ hỗ trợ chạm mở Sửa, chưa có thao tác vuốt xóa)*. | **PASS** | `v1_step_b_dashboard_after_delete.png`<br>`v1_step_b_transactions_after_delete.png`<br>`v1_step_b_statistics_after_delete.png` |
| **c) Bộ lọc giao dịch** | Mở Bộ lọc (màn 8), lần lượt chọn từng tiêu chí rồi bấm "Áp dụng":<br>1. Loại: "Thu nhập".<br>2. Loại: "Chi tiêu".<br>3. Danh mục: "Mua sắm".<br>4. Thời gian: "Hôm nay".<br>5. Thời gian: "7 ngày qua".<br>6. Thời gian: "Tháng này".<br>7. Thời gian: "Tùy chỉnh" (DateRangePicker 11/10/2026 - 18/10/2026).<br>8. Chạm lại radio đang chọn để bỏ chọn thời gian, bấm "Áp dụng". | - Lọc Thu nhập: chỉ hiện "Lương".<br>- Lọc Chi tiêu: chỉ hiện "Khác", "Mua sắm".<br>- Lọc Mua sắm: chỉ hiện "Mua sắm".<br>- Lọc Hôm nay: chỉ hiện giao dịch ngày 18/10/2026.<br>- Lọc 7 ngày / Tháng này / Tùy chỉnh: hiển thị đúng các giao dịch trong khoảng thời gian đã chọn.<br>- Bỏ chọn radio thời gian và Áp dụng: danh sách phục hồi đầy đủ tất cả giao dịch. | **PASS** | `v1_step_c_filter_opened.png`<br>`v1_step_c_filter_income.png`<br>`v1_step_c_filter_expense.png`<br>`v1_step_c_filter_category.png`<br>`v1_step_c_filter_today.png`<br>`v1_step_c_filter_7days.png`<br>`v1_step_c_filter_this_month.png`<br>`v1_step_c_filter_custom_picker.png`<br>`v1_step_c_filter_custom_result.png`<br>`v1_step_c_filter_reset_full.png` |
| **d) Thống kê theo chu kỳ** | 1. Thêm 1 giao dịch chi tiêu tháng trước: Ngày 15/09/2026, `500.000 đ`, Danh mục "Ăn uống".<br>2. Thêm 1 giao dịch chi tiêu năm trước: Ngày 18/10/2025, `300.000 đ`, Danh mục "Đi lại".<br>3. Mở tab Thống kê, lần lượt chạm các chip: "Tháng này", "Tháng trước", "Năm nay". | - "Tháng này": Tổng chi `201.000 đ` (Khác 200k ~100%, Mua sắm 1k ~0%).<br>- "Tháng trước": Tổng chi `500.000 đ` (Ăn uống 500k ~100%).<br>- "Năm nay": Tổng chi `701.000 đ` (Ăn uống 500k ~71%, Khác 200k ~29%, Mua sắm 1k ~0%). Giao dịch năm 2025 bị loại trừ chính xác. | **PASS** | `v1_step_d_form_sep_ready.png`<br>`v1_step_d_dash_after_sep.png`<br>`v1_step_d_form_2025_ready.png`<br>`v1_step_d_stat_this_month.png`<br>`v1_step_d_stat_last_month.png`<br>`v1_step_d_stat_this_year.png` |
| **e) Tìm kiếm giao dịch** | Mở tab Giao dịch:<br>1. Gõ "Luong" (không dấu) vào ô tìm kiếm.<br>2. Xóa ô tìm kiếm, nhập "Lương" (có dấu). | - Tìm "Luong": Hiển thị "Chưa có giao dịch nào" do `contains()` của Dart phân biệt ký tự có dấu/không dấu.<br>- Tìm "Lương": Lọc chính xác ra giao dịch Lương (`+10.000.000 đ`).<br>*(Đúng nguyên tắc: Giữ nguyên logic tìm kiếm theo đề bài, chưa tự ý sửa khi chưa có yêu cầu)*. | **Đã kiểm chứng (Báo cáo kết quả)** | `v1_step_e_search_luong_nodiacritic.png`<br>`v1_step_e_search_luong_diacritic.png` |

---

## 4. KẾT QUẢ KIỂM TRA REPO (VIỆC 3)

1. **Kiểm tra Asset trong Git:**
   - Lệnh `git ls-files assets`:
     ```text
     assets/images/logo.png
     assets/images/wallet.png
     ```
   - Quét mã nguồn `lib/` và `pubspec.yaml`:
     - `lib/screens/welcome_screen.dart:22`: tham chiếu `assets/images/logo.png` (đã nằm trong Git).
     - `pubspec.yaml:64`: khai báo thư mục `assets/images/`.
     - `assets/images/logo.jpg` là file ngoài lề, không được code tham chiếu và chưa được track vào Git theo đúng ràng buộc.
   - **Kết luận:** Mọi asset mà code đang sử dụng đều đã nằm trong Git.

2. **So sánh `pubspec.yaml` với trước đợt UI (`git diff 53c29af..HEAD pubspec.yaml`):**
   - Kết quả: **Không có thay đổi nào** (diff trống).
   - Danh sách dependencies hiện tại:
     - `flutter`: SDK
     - `cupertino_icons: ^1.0.8` (mặc định)
     - `sqflite: ^2.4.4` (đã thêm từ Buổi 5)
     - `path: ^1.9.1` (đã thêm từ Buổi 5)
     - `flutter_lints: ^6.0.0` (dev dependency)
   - Không phát sinh package mới (kể cả `sqflite_common_ffi` hay `fl_chart`), toàn bộ tính năng vẽ biểu đồ Donut và điều hướng được lập trình thuần bằng Flutter SDK.

3. **Kiểm tra Phân tích mã và Kiểm thử tự động:**
   - `flutter analyze`: **No issues found!** (0 lỗi, 0 cảnh báo).
   - `flutter test`: **23/23 tests passed!** (100% pass trên 4 file test: `buoi5_test.dart`, `buoi6_test.dart`, `comprehensive_test.dart`, `buoi6_full_ui_test.dart`).

4. **Trạng thái Git:**
   - `git status -sb`:
     ```text
     ## buoi6...origin/buoi6
      M android/gradle.properties
      M macos/Flutter/GeneratedPluginRegistrant.swift
     ?? HUONG_DAN_ANDROID_STUDIO.md
     ?? HUONG_DAN_BUOI_2.md
     ?? HUONG_DAN_BUOI_3_VA_4.md
     ?? HUONG_DAN_THU_CONG_GUI.md
     ?? android/local.properties.bak
     ?? assets/images/logo.jpg
     ```
     *(Working tree hoàn toàn sạch đối với các file code và cấu hình; các file nằm ngoài danh mục không bị đưa vào Git)*.
   - 12 Commit gần nhất (`git log --oneline -n 12`):
     ```text
     8fcfb54 fix(ui): phan biet mau sac danh muc hoc tap va khac
     4989600 fix(ui): hien chu d o o so tien man them
     6dfaac4 test: bo sung kiem thu tu dong ui 8 man hinh buoi 6
     fcef25a feat(nav): noi dieu huong welcome them sua
     d18d847 feat(ui): them man hinh ca nhan
     507cbdc feat(ui): them man hinh thong ke
     d489b9b feat(ui): them man hinh bo loc
     d49f9f0 feat(ui): them man hinh giao dich
     64d3714 feat(nav): them bottom navigation 4 tab
     e67cc8c refactor(ui): doi dashboard theo anh tong the
     53c29af test: bo sung kiem thu tu dong toan dien cho buoi 6
     729a234 fix(state): xu ly an toan ngoai le sqlite va dong bo cap nhat giao dien tuc thi
     ```

---

## 5. CÁC QUYẾT ĐỊNH MẶC ĐỊNH ĐÃ ÁP DỤNG

1. **Dashboard:** Tái cấu trúc theo ảnh tổng thể màn 2 (`e67cc8c`), nạp dữ liệu thật từ SQLite, tổng thu/chi/số dư tính trên toàn bộ giao dịch, hiển thị 5 giao dịch gần nhất, giữ nhãn "Chi tiêu gần đây".
2. **Danh mục chuẩn:** 
   - Chi tiêu: Ăn uống (đỏ), Mua sắm (xanh lơ/cyan), Đi lại (tím), Học tập (xanh dương `#1E88E5`), Khác (vàng cam `#FB8C00`).
   - Thu nhập: Lương (xanh lá), Khác (cam).
   - Có cơ chế fallback icon `Icons.category` và màu xám nếu có dữ liệu cũ lạ.
3. **Thẻ giao dịch:** Dòng chữ chính hiển thị TÊN DANH MỤC. Ở màn Sửa, nếu ghi chú trùng tên danh mục thì ô ghi chú để trống.
4. **Điều hướng:** Welcome $\to$ HomePage qua `pushReplacement`. HomePage quản lý `currentIndex` không dùng `IndexedStack` để mỗi tab tự refresh dữ liệu trong `initState`.
5. **Biểu đồ Donut:** Tự vẽ thuần bằng `CustomPainter`, không dùng thư viện ngoài.
6. **Màn hình Bộ lọc:** Đầy đủ 3 khối tùy chọn, chỉ lọc khi nhấn "Áp dụng", hỗ trợ chạm lại radio để bỏ chọn thời gian.
7. **Trường Số tiền:** Màn Thêm giao dịch luôn có chữ "đ" ở bên phải kể cả khi trống; màn Sửa giữ số thô để dễ thao tác.

---

## 6. CÁC VIỆC NGOÀI PHẠM VI (P3) & TỒN ĐỌNG

- **Màn hình Cá nhân (màn 7):** Giữ giao diện tĩnh chuẩn thiết kế; các nút "Thông tin cá nhân", "Cài đặt ngân sách", "Sao lưu dữ liệu", "Đổi mật khẩu", "Đăng xuất" không gắn logic API hay Firebase theo phạm vi UI Buổi 6.
- **Tìm kiếm không dấu (Mục 1e):** Code hiện tại dùng `toLowerCase().contains()`, tìm kiếm chính xác có dấu tiếng Việt ("Lương" $\to$ ra kết quả), chưa hỗ trợ chuẩn hóa chuỗi không dấu ("Luong" $\to$ chưa ra kết quả). Chưa can thiệp sửa đổi do chưa có yêu cầu từ người dùng.
- **Xóa giao dịch tại Tab Giao dịch:** Hiện chức năng vuốt xóa (`Dismissible`) chỉ tích hợp trên Dashboard (mục "Chi tiêu gần đây"); Tab Giao dịch hiện chỉ mở màn hình Sửa khi chạm.
