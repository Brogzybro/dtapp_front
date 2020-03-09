String formatDateTimeFull(DateTime date) {
  return "${formatDateFull(date)} ${formatTimeFull(date)}";
}

String formatDateFull(DateTime date) {
  return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String formatTimeFull(DateTime date) {
  return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
}
