class Platform {
  int? id;
  bool? isActive;
  String? logo;
  String? icon;
  String? name;

  Platform({this.id, this.isActive, this.logo, this.name, this.icon});

  Platform.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    logo = json['logo'];
    icon = json['icon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_active'] = isActive;
    data['logo'] = logo;
    data['icon'] = icon;
    data['name'] = name;
    return data;
  }
}
