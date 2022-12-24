class Post {
  String title;
  String description;
  String? photo;
  String? post_id;
  String uid;
  // List<String>? liked_by;
  // int like_ct;

  Post({
    required this.title,
    required this.description,
    required this.uid,
    // required this.like_ct,
    // required this.likeCt,
    this.post_id,
    // required this.date,
    this.photo,
    // this.liked_by,
  });

  @override
  String toString() => 'Post $title';
}
