class JungleAppModel {
  const JungleAppModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.iconUrl,
    required this.bannerUrl,
    required this.iconGlyph,
    required this.bannerGradient,
    required this.screenshots,
    required this.category,
    required this.version,
    required this.sizeMb,
    required this.downloadUrl,
    required this.rating,
    required this.reviewCount,
    required this.releaseDate,
    required this.isFeatured,
    required this.tags,
    this.model3dUrl,
    this.changelog,
  });

  final String id;
  final String name;
  final String tagline;
  final String description;
  final String iconUrl;
  final String bannerUrl;
  final String iconGlyph;
  final List<String> bannerGradient;
  final List<String> screenshots;
  final String category;
  final String version;
  final double sizeMb;
  final String downloadUrl;
  final double rating;
  final int reviewCount;
  final DateTime releaseDate;
  final bool isFeatured;
  final List<String> tags;
  final String? model3dUrl;
  final String? changelog;

  factory JungleAppModel.fromJson(Map<String, dynamic> json) {
    return JungleAppModel(
      id: json['id'] as String,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      iconUrl: (json['iconUrl'] ?? '') as String,
      bannerUrl: (json['bannerUrl'] ?? '') as String,
      iconGlyph: json['iconGlyph'] as String,
      bannerGradient: List<String>.from(json['bannerGradient'] as List),
      screenshots: List<String>.from(json['screenshots'] as List),
      category: json['category'] as String,
      version: json['version'] as String,
      sizeMb: (json['sizeMb'] as num).toDouble(),
      downloadUrl: json['downloadUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      isFeatured: json['isFeatured'] as bool,
      tags: List<String>.from(json['tags'] as List),
      model3dUrl: json['model3dUrl'] as String?,
      changelog: json['changelog'] as String?,
    );
  }

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return true;
    }
    return name.toLowerCase().contains(normalized) ||
        tagline.toLowerCase().contains(normalized) ||
        category.toLowerCase().contains(normalized) ||
        tags.any((tag) => tag.toLowerCase().contains(normalized));
  }
}
