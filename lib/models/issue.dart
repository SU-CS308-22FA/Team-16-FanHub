class IssuePiece {
  String title;
  String description;
  String uid;
  String? did;

  IssuePiece({
    required this.title,
    required this.description,
    required this.uid,
    this.did,
  });

  @override
  String toString() => 'Issue $title';
}
