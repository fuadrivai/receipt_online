// ignore_for_file: unnecessary_this

class LazadaCount {
  int? packed;
  int? pending;
  int? rts;
  int? total;

  LazadaCount({this.packed, this.pending, this.rts, this.total});

  LazadaCount.fromJson(Map<String, dynamic> json) {
    packed = json['packed'];
    pending = json['pending'];
    rts = json['rts'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packed'] = this.packed;
    data['pending'] = this.pending;
    data['rts'] = this.rts;
    data['total'] = this.total;
    return data;
  }
}
