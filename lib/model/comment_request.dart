class CommentRequest {
  String comment;

  Map<String, dynamic> toMap() => {
    "comment": comment,
  };
}