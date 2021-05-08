/// title : "test1"
/// description : "test"
/// date : "17/06/2020"
/// file_path : "upload/moment/150x150.png"
/// file_type : null

class MomentListModel {
  String _title;
  String _description;
  String _date;
  String _filePath;
  dynamic _fileType;

  String get title => _title;
  String get description => _description;
  String get date => _date;
  String get filePath => _filePath;
  dynamic get fileType => _fileType;

  MomentListModel({
      String title, 
      String description, 
      String date, 
      String filePath, 
      dynamic fileType}){
    _title = title;
    _description = description;
    _date = date;
    _filePath = filePath;
    _fileType = fileType;
}

  MomentListModel.fromJson(dynamic json) {
    _title = json["title"];
    _description = json["description"];
    _date = json["date"];
    _filePath = json["file_path"];
    _fileType = json["file_type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["description"] = _description;
    map["date"] = _date;
    map["file_path"] = _filePath;
    map["file_type"] = _fileType;
    return map;
  }

}