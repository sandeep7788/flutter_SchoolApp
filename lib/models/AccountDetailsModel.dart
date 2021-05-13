/// email : "7014741657"
/// address : "Jaipur Rajasthan"
/// phonenumber : "7014741657"
/// profileimage : "upload/profile/icon.png"

class AccountDetailsModel {
  String _email;
  String _address;
  String _phonenumber;
  String _profileimage;

  String get email => _email;
  String get address => _address;
  String get phonenumber => _phonenumber;
  String get profileimage => _profileimage;

  AccountDetailsModel({
      String email, 
      String address, 
      String phonenumber, 
      String profileimage}){
    _email = email;
    _address = address;
    _phonenumber = phonenumber;
    _profileimage = profileimage;
}

  AccountDetailsModel.fromJson(dynamic json) {
    _email = json["email"];
    _address = json["address"];
    _phonenumber = json["phonenumber"];
    _profileimage = json["profileimage"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email"] = _email;
    map["address"] = _address;
    map["phonenumber"] = _phonenumber;
    map["profileimage"] = _profileimage;
    return map;
  }

}