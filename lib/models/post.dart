class Post {
  String title;
  String description;
  // String date;
  String? photo;
  // int likeCt;

  Post({
    required this.title,
    required this.description,
    // required this.likeCt,
    // required this.date,
    this.photo,
  });

  @override
  String toString() => 'Post $title';
}
