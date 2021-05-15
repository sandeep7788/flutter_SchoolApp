/// id : "2213"
/// user_id : "42919"
/// school_id : "32"
/// created_by : "480"
/// title : "Test for all"
/// description : "this is push notification for all"
/// notification_type : "all"
/// notification_to : null
/// slug : "test-for-all-2212"
/// isactive : "1"
/// created_at : "2021-04-05 04:46:35"
/// updated_at : "0000-00-00 00:00:00"

class NotifactionListModel {
  String _id;
  String _userId;
  String _schoolId;
  String _createdBy;
  String _title;
  String _description;
  String _notificationType;
  dynamic _notificationTo;
  String _slug;
  String _isactive;
  String _createdAt;
  String _updatedAt;

  String get id => _id;
  String get userId => _userId;
  String get schoolId => _schoolId;
  String get createdBy => _createdBy;
  String get title => _title;
  String get description => _description;
  String get notificationType => _notificationType;
  dynamic get notificationTo => _notificationTo;
  String get slug => _slug;
  String get isactive => _isactive;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  NotifactionListModel({
      String id, 
      String userId, 
      String schoolId, 
      String createdBy, 
      String title, 
      String description, 
      String notificationType, 
      dynamic notificationTo, 
      String slug, 
      String isactive, 
      String createdAt, 
      String updatedAt}){
    _id = id;
    _userId = userId;
    _schoolId = schoolId;
    _createdBy = createdBy;
    _title = title;
    _description = description;
    _notificationType = notificationType;
    _notificationTo = notificationTo;
    _slug = slug;
    _isactive = isactive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  NotifactionListModel.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["user_id"];
    _schoolId = json["school_id"];
    _createdBy = json["created_by"];
    _title = json["title"];
    _description = json["description"];
    _notificationType = json["notification_type"];
    _notificationTo = json["notification_to"];
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
    map["created_by"] = _createdBy;
    map["title"] = _title;
    map["description"] = _description;
    map["notification_type"] = _notificationType;
    map["notification_to"] = _notificationTo;
    map["slug"] = _slug;
    map["isactive"] = _isactive;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}