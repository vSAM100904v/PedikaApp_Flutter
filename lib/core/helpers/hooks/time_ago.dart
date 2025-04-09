class TimeAgo {
  static String format(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} Mounth';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} Day';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} Hours';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} Minute';
    } else {
      return 'Now';
    }
  }
}
