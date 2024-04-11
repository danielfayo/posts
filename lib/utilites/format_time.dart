String formatFromNow(int milliseconds) {
    DateTime then = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    DateTime now = DateTime.now();
    Duration difference = now.difference(then);

    int seconds = difference.inSeconds;
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();
    int days = (hours / 24).floor();
    int weeks = (days / 7).floor();

    String fromNowText;
    if (weeks > 0) {
      fromNowText = weeks == 1 ? '$weeks week ago' : '$weeks weeks ago';
    } else if (days > 0) {
      fromNowText = days == 1 ? '$days day ago' : '$days days ago';
    } else if (hours > 0) {
      fromNowText = hours == 1 ? '$hours hour ago' : '$hours hours ago';
    } else if (minutes > 0) {
      fromNowText =
          minutes == 1 ? '$minutes minute ago' : '$minutes minutes ago';
    } else if (seconds > 0) {
      fromNowText =
          seconds == 1 ? '$seconds second ago' : '$seconds seconds ago';
    } else {
      fromNowText = "Just now";
    }
    return fromNowText;
  }