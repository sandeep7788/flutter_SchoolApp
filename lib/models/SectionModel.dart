class SectionModel {
  final String id, section, user_id, school_id, slug;
  final String isactive, created_at, updated_at;


  SectionModel(this.id, this.section, this.user_id, this.school_id,
      this.slug, this.isactive, this.created_at, this.updated_at);

  SectionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user_id = json['user_id'],
        section = json['section'],
        school_id = json['school_id'],
        slug = json['slug'],
        isactive = json['isactive'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() => {
        'id': id,

        'user_id': user_id,
    'section': section,
        'school_id': school_id,
        'slug': slug,
        'isactive': isactive,
        'created_at': created_at,
        'updated_at': updated_at,
      };
}
