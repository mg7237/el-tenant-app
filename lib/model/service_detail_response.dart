// To parse this JSON data, do
//
//     final serviceDetailResponse = serviceDetailResponseFromJson(jsonString);

import 'dart:convert';

ServiceDetailResponse serviceDetailResponseFromJson(String str) => ServiceDetailResponse.fromJson(json.decode(str));

String serviceDetailResponseToJson(ServiceDetailResponse data) => json.encode(data.toJson());

class ServiceDetailResponse {
  String title;
  String description;
  int requestType;
  int requestStatus;
  String supportName;
  String supportEmail;
  String supportContact;
  List<Attachment> attachments;
  List<Comment> comments;

  ServiceDetailResponse({
    this.title,
    this.description,
    this.requestType,
    this.requestStatus,
    this.supportName,
    this.supportEmail,
    this.supportContact,
    this.attachments,
    this.comments,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) => new ServiceDetailResponse(
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    requestType: json["requestType"] == null ? null : json["requestType"],
    requestStatus: json["requestStatus"] == null ? null : json["requestStatus"],
    supportName: json["supportName"] == null ? null : json["supportName"],
    supportEmail: json["supportEmail"] == null ? null : json["supportEmail"],
    supportContact: json["supportContact"] == null ? null : json["supportContact"],
    attachments: json["attachments"] == null ? null : new List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
    comments: json["comments"] == null ? null : new List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "requestType": requestType == null ? null : requestType,
    "requestStatus": requestStatus == null ? null : requestStatus,
    "supportName": supportName == null ? null : supportName,
    "supportEmail": supportEmail == null ? null : supportEmail,
    "supportContact": supportContact == null ? null : supportContact,
    "attachments": attachments == null ? null : new List<dynamic>.from(attachments.map((x) => x)),
    "comments": comments == null ? null : new List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}


class Attachment {
  int id;
  String attachmentUrl;

  Attachment({
    this.id,
    this.attachmentUrl,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => new Attachment(
    id: json["id"] == null ? null : json["id"],
    attachmentUrl: json["attachmentURL"] == null ? null : json["attachmentURL"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "attachmentURL": attachmentUrl == null ? null : attachmentUrl,
  };
}


class Comment {
  int id;
  String comment;
  String commentBy;
  String createdDate;

  Comment({
    this.id,
    this.comment,
    this.commentBy,
    this.createdDate,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => new Comment(
    id: json["id"] == null ? null : json["id"],
    comment: json["comment"] == null ? null : json["comment"],
    commentBy: json["comment_by"] == null ? null : json["comment_by"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "comment": comment == null ? null : comment,
    "comment_by": commentBy == null ? null : commentBy,
    "createdDate": createdDate == null ? null : createdDate,
  };
}
