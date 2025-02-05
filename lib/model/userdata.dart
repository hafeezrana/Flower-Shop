class UserData {
  UserData({
    this.id,
    this.createdAt,
    this.fullName,
    this.phoneNo,
    this.latitude,
    this.longitude,
    this.token,
  });

  UserData.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    fullName = json['full_name'];
    phoneNo = json['phone_no'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    token = json['token'];
  }
  num? id;
  String? createdAt;
  String? fullName;
  String? phoneNo;
  String? latitude;
  String? longitude;
  String? token;
  UserData copyWith({
    num? id,
    String? createdAt,
    String? fullName,
    String? phoneNo,
    String? latitude,
    String? longitude,
    String? token,
  }) =>
      UserData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        fullName: fullName ?? this.fullName,
        phoneNo: phoneNo ?? this.phoneNo,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        token: token ?? this.token,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['full_name'] = fullName;
    map['phone_no'] = phoneNo;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['token'] = token;
    return map;
  }
}
