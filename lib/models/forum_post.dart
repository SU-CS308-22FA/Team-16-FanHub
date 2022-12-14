class ForumPost {
  String title;
  String description;
  String sender_id;
  String? comments;

  ForumPost({
    required this.title,
    required this.description,
    required this.sender_id,
    this.comments,
  });

  @override
  String toString() =>
      'Title: $title Desc: $description sender_id: $sender_id comments: $comments';
}
