class TimeModel {
  TimeModel({
    this.hours = 0,
    this.minutes = 0,
  })  : assert(hours >= 0 && hours <= 23),
        assert(minutes >= 0 && minutes <= 59);

  factory TimeModel.fromMap(Map<String, int> json) {
    return TimeModel(
      hours: json['hours'],
      minutes: json['minutes'],
    );
  }

  /// [str] format "HH:mm"
  factory TimeModel.fromString(String str) {
    final List<String> tmp = str.trim().split(':');
    return TimeModel(
      hours: int.parse(tmp[0].trim(), radix: 10),
      minutes: int.parse(tmp[1].trim(), radix: 10),
    );
  }

  int hours;

  int minutes;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'hours': this.hours,
        'minutes': this.minutes,
      };

  @override
  toString() {
    String h = this.hours.toString();
    String m = this.minutes.toString();
    h = h.length < 2 ? '0$h' : h;
    m = m.length < 2 ? '0$m' : m;
    return '$h:$m';
  }

  @override
  bool operator ==(Object other) =>
      other is TimeModel &&
      this.hours == other.hours &&
      this.minutes == other.minutes;

  @override
  get hashCode => hours.hashCode * 31 ^ minutes.hashCode * 31;

  bool gt(TimeModel other, {bool includeEqual}) {
    bool greater = false;

    if (includeEqual == true) {
      greater = (this.hours >= other.hours) ||
          ((this.hours == other.hours) && (this.minutes >= other.minutes));
    } else {
      greater = (this.hours > other.hours) ||
          ((this.hours == other.hours) && (this.minutes > other.minutes));
    }

    return greater;
  }
}
