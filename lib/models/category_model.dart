class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Helper to clean up category name (e.g. remove "Entertainment: ")
  String get cleanName {
    if (name.contains(': ')) {
      return name.split(': ').last;
    }
    return name;
  }

  String get groupName {
    if (name.contains(': ')) {
      return name.split(': ').first;
    }
    return 'General';
  }
}
