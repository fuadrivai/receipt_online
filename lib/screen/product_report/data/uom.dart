class UOM {
  int? id;
  String? name;
  String? description;
  int? isActive;

  UOM({this.id, this.name, this.description, this.isActive});

  UOM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['is_active'] = isActive;
    return data;
  }
}
