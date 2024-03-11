import 'package:blog_app/models/bookmarks_model.dart';
import 'package:flutter/material.dart';

class BookmarksProvider extends ChangeNotifier {
  List<BookmarksModel> bookmarkList = [];

  List<BookmarksModel> get getBookmarkList {
    return bookmarkList;
  }
}
