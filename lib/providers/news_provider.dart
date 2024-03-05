import 'package:blog_app/models/news_model.dart';
import 'package:blog_app/services/news_api.dart';
import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newList = [];

  List<NewsModel> get getNewsList {
    return newList;
  }

  Future<List<NewsModel>> fetchAllNews() async {
    newList = await NewsApiServices.getAllNews();
    return newList;
  }
}
