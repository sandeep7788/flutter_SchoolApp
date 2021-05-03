

class SubjectModel {
  final String subjectid, subject;

  SubjectModel(this.subjectid, this.subject);

  SubjectModel.fromJson(Map<String, dynamic> json)
      :subjectid= json['subjectid'],
        subject= json['subject'];

  Map<String, dynamic> toJson() =>
      {
        'subjectid' : subjectid,
        'subject': subject,
      };
}