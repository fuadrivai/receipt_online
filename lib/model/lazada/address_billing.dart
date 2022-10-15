class AddressBilling {
  String? address1;
  String? address2;
  String? address3;
  String? address4;
  String? address5;
  String? city;
  String? country;
  String? firstName;
  String? lastName;
  String? phone;
  String? phone2;
  String? postCode;

  AddressBilling(
      {this.address1,
      this.address2,
      this.address3,
      this.address4,
      this.address5,
      this.city,
      this.country,
      this.firstName,
      this.lastName,
      this.phone,
      this.phone2,
      this.postCode});

  AddressBilling.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    address4 = json['address4'];
    address5 = json['address5'];
    city = json['city'];
    country = json['country'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    phone2 = json['phone2'];
    postCode = json['post_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['address1'] = address1;
    data['address2'] = address2;
    data['address3'] = address3;
    data['address4'] = address4;
    data['address5'] = address5;
    data['city'] = city;
    data['country'] = country;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['phone2'] = phone2;
    data['post_code'] = postCode;
    return data;
  }
}
