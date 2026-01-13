// Notifications Notifier
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsNotifier extends Notifier<bool> {
  @override
  bool build() => true; // Default: notifications enabled

  void toggle(bool value) {
    state = value;
  }
}

// Provider for notifications preference (local to profile page)
final notificationsProvider = NotifierProvider<NotificationsNotifier, bool>(() {
  return NotificationsNotifier();
});