class Blog{
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String imageUrl;
  final String date;
  final String readTime;
  final String author;
  final List<String> tags;

  Blog({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.readTime,
    required this.author,
    this.tags = const[],
});
}