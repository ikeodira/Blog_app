import 'dart:convert';

import 'package:blog_app/consts/api_const.dart';
import 'package:blog_app/models/bookmarks_model.dart';
import 'package:blog_app/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookmarksProvider extends ChangeNotifier {
  List<BookmarksModel> bookmarkList = [];

  List<BookmarksModel> get getBookmarkList {
    return bookmarkList;
  }

  Future<void> addToBookmark({required NewsModel newsModel}) async {
    try {
      var url = Uri.parse(
          "https://blog-app-d70a4-default-rtdb.firebaseio.com/bookmarks.json");
      // var uri = Uri.https(BASEURL_FIREBASE, "/bookmarks.json");
      var response = await http.post(
        url,
        body: jsonEncode(
          newsModel.toJson(),
        ),
      );
      print('Response status ${response.statusCode}');
      print('Response status ${response.body}');
    } catch (error) {
      print(error);
    }
  }
}
