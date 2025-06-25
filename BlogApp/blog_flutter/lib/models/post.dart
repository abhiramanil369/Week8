class Post {
  final int id;
  final String title;
  final String summary;
  final String content;
  final String author;
  final String createdAt;

  Post({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? 'Anonymous',
      createdAt: json['created_at'] ?? '',
    );
  }
}
