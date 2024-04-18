class ExpiredToken {
  String? expiredDate;
  String? message;
  bool? showWarning;
  int? days;

  ExpiredToken({
    this.expiredDate,
    this.days,
    this.message,
    this.showWarning,
  });

  ExpiredToken.fromJson(Map<String, dynamic> json) {
    expiredDate = json['expired_date'];
    days = json['days'];
    message = json['message'];
    showWarning = json['show_warning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expired_date'] = expiredDate;
    data['days'] = days;
    data['message'] = message;
    data['show_warning'] = showWarning;
    return data;
  }
}
