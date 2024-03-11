import 'package:flutter/material.dart';

class BookmarksModel extends ChangeNotifier {
  String newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content,
      dateToShow,
      readingTimeText;

  BookmarksModel({
    required this.newsId,
    required this.sourceName,
    required this.authorName,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.dateToShow,
    required this.readingTimeText,
  });

  factory BookmarksModel.fromJson(dynamic json) {
    return BookmarksModel(
      newsId: json["newsId"] ?? "",
      sourceName: json["sourceName"] ?? "",
      authorName: json["authorName"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      url: json["url"] ?? "",
      urlToImage: json["urlToImage"] ?? "",
      publishedAt: json["publishedAt"] ?? "",
      content: json["content"] ?? "",
      dateToShow: json["dateToShow"] ?? "",
      readingTimeText: json["readingTimeText"] ?? "",
    );
  }

  static List<BookmarksModel> newsFromSnapshot(List newSnapshot) {
    return newSnapshot.map((json) {
      return BookmarksModel.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["NewsId"] = newsId;
    data["sourceName"] = sourceName;
    data["authorName"] = authorName;
    data["title"] = title;
    data["description"] = description;
    data["url"] = url;
    data["urlToImage"] = urlToImage;
    data["publishedAt"] = publishedAt;
    data["content"] = content;
    data["dateToShow"] = dateToShow;
    data["readingTimeText"] = readingTimeText;
    return data;
  }
}
