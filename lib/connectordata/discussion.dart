class Discussion {
  String? id;
  String? datetime;
  String? body;
  String? sender;
  String? title;
  String? name;
  String? image;

  Discussion(
      {this.datetime,
      this.body,
      this.sender,
      this.title,
      this.name,
      this.image});

  Discussion.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    body = json['body'];
    sender = json['sender'];
    title = json['title'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['body'] = this.body;
    data['sender'] = this.sender;
    data['title'] = this.title;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
