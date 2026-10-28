# Web Push cho ứng dụng kho

Web Push gửi thông báo FCM đến những trình duyệt đã bật **Thông báo thay đổi dữ liệu** trong Cài đặt. Các Cloud Functions theo dõi thay đổi Firestore và gửi đến topic `warehouse_activity`. Mỗi thao tác xóa dữ liệu hàng loạt trong ứng dụng gửi một thông báo tóm tắt.

## Cấu hình Firebase

1. **Public VAPID key** đã được cấu hình sẵn trong ứng dụng. Có thể thay bằng `--dart-define=WEB_PUSH_VAPID_KEY=PUBLIC_VAPID_KEY` khi build. Không dùng private key trong ứng dụng.
2. Bật Cloud Functions cho dự án. Cloud Functions triển khai thực tế yêu cầu gói **Blaze**.
3. Cài package cho `functions/` bằng `npm install --prefix functions`.
4. Triển khai Functions trước khi bật Web Push: `firebase deploy --only functions`.
5. Build và triển khai Web:

   ```sh
   flutter build web
   firebase deploy --only hosting
   ```

Nếu Functions chạy ở URL khác, thêm `--dart-define=WEB_PUSH_ENDPOINT=https://REGION-PROJECT.cloudfunctions.net/webPush` khi build.

Web Push cần HTTPS (Firebase Hosting cung cấp sẵn) hoặc localhost. Người dùng đăng nhập, mở Cài đặt và bật Web Push để cấp quyền. Lựa chọn bật/tắt được lưu trên trình duyệt; khi đã bật, token được đăng ký lại sau khi tải lại trang. Khi đăng xuất, ứng dụng hủy token và tắt lựa chọn Web Push trên trình duyệt đó. Người dùng cần bật lại sau lần đăng nhập tiếp theo.

## Các sự kiện được gửi

- Tạo hoặc chỉnh sửa phiếu nhập/xuất trong `transactions`.
- Ghi nhận kiểm kho trong `reconciliations`.
- Thêm, chỉnh sửa hoặc vô hiệu hóa sản phẩm, khách hàng, kho hàng, công thức.
- Xóa dữ liệu chọn lọc trong màn hình Cài đặt: một thông báo tổng hợp sau khi xóa thành công.

Thay đổi tồn kho và công nợ phát sinh từ phiếu không tạo thêm thông báo riêng. Các lần xóa hàng loạt dùng một thông báo để tránh gửi hàng loạt thông báo đến người dùng.

Trong Cài đặt có **Gửi thử Web Push** để kiểm tra trình duyệt đang bật. Khi tab đang mở, thông báo hiện trong ứng dụng; khi tab ở nền hoặc đóng, service worker hiển thị thông báo hệ thống. Khả năng nhận thông báo khi đóng trình duyệt phụ thuộc vào trình duyệt và hệ điều hành.

Tài liệu: [FlutterFire nhận FCM trên Web](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages), [VAPID key](https://firebase.google.com/docs/cloud-messaging/flutter/get-started), [Cloud Functions](https://firebase.google.com/docs/functions/get-started).
