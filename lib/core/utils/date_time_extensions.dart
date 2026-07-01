String formatTimeAgo(DateTime date) {
  final Duration diff = DateTime.now().difference(date);

  if (diff.inDays >= 365) {
    final int years = (diff.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  } else if (diff.inDays >= 30) {
    final int months = (diff.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  } else if (diff.inDays >= 1) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours}h ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes}m ago';
  } else {
    return 'Just now';
  }
}
