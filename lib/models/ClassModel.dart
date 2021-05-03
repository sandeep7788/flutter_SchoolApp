

class ClassModel {
  final String id, srno, user_id, classes, school_id, slug;
  final String isactive, created_at, updated_at;

  ClassModel(this.id, this.srno, this.user_id, this.classes, this.school_id, this.slug, this.isactive, this.created_at, this.updated_at);

  ClassModel.fromJson(Map<String, dynamic> json)
      :id= json['id'],
        srno= json['srno'],
        user_id= json['user_id'],
        classes= json['class'],
        school_id= json['school_id'],
        slug= json['slug'],
        isactive= json['isactive'],
        created_at= json['created_at'],
        updated_at= json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'srno': srno,
        'user_id': user_id,
        'class': classes,
        'school_id': school_id,
        'slug': slug,
        'isactive': isactive,
        'created_at': created_at,
        'updated_at': updated_at,
      };
}