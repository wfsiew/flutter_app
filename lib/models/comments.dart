class Comments {

  num? id;
  num? postId;
  String? name;
  String? email;
  String? body;

  Comments({
    this.id,
    this.postId,
    this.name,
    this.email,
    this.body,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      postId: json['postId'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'id': id,
    'postId': postId,
    'name': name,
    'email': email,
    'body': body,
  };
}