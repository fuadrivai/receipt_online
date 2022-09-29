class Expedition {
  int? id;
  String? name;
  String? alias;
  String? description;
  String? createdAt;
  String? updatedAt;

  Expedition(
      {this.id,
      this.name,
      this.alias,
      this.description,
      this.createdAt,
      this.updatedAt});

  Expedition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['alias'] = alias;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
