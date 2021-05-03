/// id : "131"
/// user_id : "22926"
/// school_id : "28"
/// title : "राम नवमी"
/// description : "अवकाश"
/// total_days : "0"
/// start_date : "21/04/2021"
/// end_date : "21/04/2021"
/// slug : "रम-नवम-130"
/// isactive : "1"
/// created_at : "2021-04-13 02:41:53"
/// updated_at : "0000-00-00 00:00:00"

class HolidayListModel {
  String _id;
  String _userId;
  String _schoolId;
  String _title;
  String _description;
  String _totalDays;
  String _startDate;
  String _endDate;
  String _slug;
  String _isactive;
  String _createdAt;
  String _updatedAt;

  String get id => _id;
  String get userId => _userId;
  String get schoolId => _schoolId;
  String get title => _title;
  String get description => _description;
  String get totalDays => _totalDays;
  String get startDate => _startDate;
  String get endDate => _endDate;
  String get slug => _slug;
  String get isactive => _isactive;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  HolidayListModel({
      String id, 
      String userId, 
      String schoolId, 
      String title, 
      String description, 
      String totalDays, 
      String startDate, 
      String endDate, 
      String slug, 
      String isactive, 
      String createdAt, 
      String updatedAt}){
    _id = id;
    _userId = userId;
    _schoolId = schoolId;
    _title = title;
    _description = description;
    _totalDays = totalDays;
    _startDate = startDate;
    _endDate = endDate;
    _slug = slug;
    _isactive = isactive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  HolidayListModel.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["user_id"];
    _schoolId = json["school_id"];
    _title = json["title"];
    _description = json["description"];
    _totalDays = json["total_days"];
    _startDate = json["start_date"];
    _endDate = json["end_date"];
    _slug = json["slug"];
    _isactive = json["isactive"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["user_id"] = _userId;
    map["school_id"] = _schoolId;
    map["title"] = _title;
    map["description"] = _description;
    map["total_days"] = _totalDays;
    map["start_date"] = _startDate;
    map["end_date"] = _endDate;
    map["slug"] = _slug;
    map["isactive"] = _isactive;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}