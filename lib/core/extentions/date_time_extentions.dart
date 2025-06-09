extension DateTimeExtentions on DateTime {
  String toTimeOnly() {
    final hours = this.hour.toString().padLeft(2, '0');
    final minutes = this.minute.toString().padLeft(2, '0');

    return '$hours:$minutes';
  }
}
