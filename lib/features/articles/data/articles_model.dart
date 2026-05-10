class ArticlesModel {
  String id, title, date, image, name, description, category;

  ArticlesModel({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
    required this.name,
    required this.description,
    required this.category,
  });

  factory ArticlesModel.fromJson(Map<String, dynamic> json) {
    return ArticlesModel(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      category: json['category']
    );
  }
}