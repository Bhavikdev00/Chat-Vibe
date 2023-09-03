import 'package:cloud_firestore/cloud_firestore.dart';

class DateFormatUtil {
  static String formatTimeAgo(Timestamp ts) {
    DateTime time = ts.toDate();
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'last active $years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return 'last active $months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays >= 1) {
      return 'last active ${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours >= 1) {
      return 'last active ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes >= 1) {
      return 'last active ${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'last active just now';
    }
  }
}
