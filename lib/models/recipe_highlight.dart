class RecipeHighlight {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int views;
  final int likes;

  RecipeHighlight({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.views,
    required this.likes,
  });

  factory RecipeHighlight.fromJson(Map<String, dynamic> json) {
    return RecipeHighlight(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      views: json['views'] as int,
      likes: json['likes'] as int,
    );
  }
}


