class Expedition {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  Expedition(
      {this.id, this.name, this.description, this.createdAt, this.updatedAt});

  Expedition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
