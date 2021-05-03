/// userid : "42921"
/// login : "test123"
/// name : "Ravi Teja"
/// facultyid : "480"
/// image : "upload/profile/icon.png"
/// class_teacher : "720"
/// school_id : "32"
/// school_name : "Harshi Public School"
/// school_session : "2020-2021"

class SignUppModel {
  String _userid;
  String _login;
  String _name;
  String _facultyid;
  String _image;
  String _classTeacher;
  String _schoolId;
  String _schoolName;
  String _schoolSession;

  String get userid => _userid;
  String get login => _login;
  String get name => _name;
  String get facultyid => _facultyid;
  String get image => _image;
  String get classTeacher => _classTeacher;
  String get schoolId => _schoolId;
  String get schoolName => _schoolName;
  String get schoolSession => _schoolSession;

  SignUppModel({
      String userid, 
      String login, 
      String name, 
      String facultyid, 
      String image, 
      String classTeacher, 
      String schoolId, 
      String schoolName, 
      String schoolSession}){
    _userid = userid;
    _login = login;
    _name = name;
    _facultyid = facultyid;
    _image = image;
    _classTeacher = classTeacher;
    _schoolId = schoolId;
    _schoolName = schoolName;
    _schoolSession = schoolSession;
}

  SignUppModel.fromJson(dynamic json) {
    _userid = json["userid"];
    _login = json["login"];
    _name = json["name"];
    _facultyid = json["facultyid"];
    _image = json["image"];
    _classTeacher = json["class_teacher"];
    _schoolId = json["school_id"];
    _schoolName = json["school_name"];
    _schoolSession = json["school_session"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userid"] = _userid;
    map["login"] = _login;
    map["name"] = _name;
    map["facultyid"] = _facultyid;
    map["image"] = _image;
    map["class_teacher"] = _classTeacher;
    map["school_id"] = _schoolId;
    map["school_name"] = _schoolName;
    map["school_session"] = _schoolSession;
    return map;
  }

}