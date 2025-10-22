import 'package:flutter/material.dart';
import 'dart:async'; // Cần cho Timer

/// Enum để định nghĩa các loại Notification Banner
enum NotificationType { success, error, info }

/// Custom Widget hiển thị Notification trượt từ trên xuống
class TopSnackbarNotification extends StatefulWidget {
  final String message;
  final NotificationType type;
  final Duration duration;

  const TopSnackbarNotification({
    super.key,
    required this.message,
    this.type = NotificationType.info,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<TopSnackbarNotification> createState() => _TopSnackbarNotificationState();
}

class _TopSnackbarNotificationState extends State<TopSnackbarNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Timer? _timer;
  late VoidCallback _removeOverlay;

  @override
  void initState() {
    super.initState();
    _removeOverlay = () {};

    // Khởi tạo AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Thời gian trượt
    );

    // Animation trượt từ Top (Offset(0.0, -1.0) là ngoài màn hình phía trên)
    _animation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(_controller);

    // Bắt đầu animation trượt vào
    _controller.forward();

    // Bắt đầu timer để tự động ẩn sau duration
    _timer = Timer(widget.duration, () {
      _controller.reverse().then((_) {
        // Sau khi trượt ra, xóa OverlayEntry
        _removeOverlay();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }


  // Setter để lấy hàm xóa OverlayEntry
  set onRemove(VoidCallback removeCallback) {
    _removeOverlay = removeCallback;
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final IconData iconData;

    switch (widget.type) {
      case NotificationType.success:
        backgroundColor = Colors.green.shade700;
        iconData = Icons.check_circle_outline;
        break;
      case NotificationType.error:
        backgroundColor = Colors.red.shade700;
        iconData = Icons.error_outline;
        break;
      case NotificationType.info:
      backgroundColor = Colors.blue.shade700;
        iconData = Icons.info_outline;
        break;
    }

    // Sử dụng SlideTransition để áp dụng animation trượt
    return SlideTransition(
      position: _animation,
      child: SafeArea( // Đảm bảo không bị che bởi status bar
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(8),
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(iconData, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Hàm tiện ích để hiển thị Notification ---

/// OverlayEntry hiện tại để đảm bảo chỉ có một Notification hiển thị
OverlayEntry? _currentOverlayEntry;

/// Hàm tiện ích để hiển thị Custom Notification Banner ở trên cùng
void showTopSnackbarNotification(
    BuildContext context,
    String message, {
      NotificationType type = NotificationType.info,
      Duration duration = const Duration(seconds: 3),
    }) {
  // Hàm để xóa OverlayEntry
  void removeOverlay() {
    _currentOverlayEntry?.remove();
    _currentOverlayEntry = null;
  }

  // Nếu đã có, xóa cái cũ trước
  if (_currentOverlayEntry != null) {
    _currentOverlayEntry!.remove();
    _currentOverlayEntry = null;
  }

  // Tạo OverlayEntry mới
  _currentOverlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: TopSnackbarNotification(
          message: message,
          type: type,
          duration: duration,
        ),
      );
    },
  );

  // Thêm OverlayEntry vào Overlay
  Overlay.of(context).insert(_currentOverlayEntry!);

  // **LƯU Ý QUAN TRỌNG:** // Để tự động xóa sau animation, bạn cần gọi removeOverlay() bên trong
  // `_TopSnackbarNotificationState.dispose()`
  // nhưng cách đơn giản nhất là dùng Timer như đã implement ở trên.
}