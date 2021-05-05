/// id : "43344"
/// Student : "Mohit Pareek"

class StudentAttandanceModel {
  String _id;
  String _student;
  bool _isSelected=false;

  set id(String value) {
    _id = value;
  }

  String get id => _id;
  String get student => _student;
  bool get isSelected => _isSelected;


  StudentAttandanceModel({
      String id, 
      String student}){
    _id = id;
    _student = student;
}

  StudentAttandanceModel.fromJson(dynamic json) {
    _id = json["id"];
    _student = json["Student"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["Student"] = _student;
    return map;
  }

  set student(String value) {
    _student = value;
  }

  set isSelected(bool value) {
    _isSelected = value;
  }

}
