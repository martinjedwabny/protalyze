class DurationFormatter {
  static String format(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    int hh = duration.inHours.remainder(60);
    int mm = duration.inMinutes.remainder(60);
    int ss = duration.inSeconds.remainder(60);
    if (duration.inHours > 0) return "$hh:${twoDigits(mm)}:${twoDigits(ss)}";
    // if (duration.inMinutes > 0)
    return "$mm:${twoDigits(ss)}";
    // return "$ss";
  }

  static String formatWithLetters(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    int hh = duration.inHours.remainder(60);
    int mm = duration.inMinutes.remainder(60);
    int ss = duration.inSeconds.remainder(60);
    if (duration.inHours > 0)
      return "${hh}h ${twoDigits(mm)}m ${twoDigits(ss)}s";
    if (duration.inMinutes > 0) return "${mm}m ${twoDigits(ss)}s";
    return "${ss}s";
  }
}
