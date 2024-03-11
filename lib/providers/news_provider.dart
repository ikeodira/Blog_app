import 'package:blog_app/models/news_model.dart';
import 'package:blog_app/services/news_api.dart';
import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newsList = [];

  List<NewsModel> get getNewsList {
    return newsList;
  }

  Future<List<NewsModel>> fetchAllNews(
      {required int pageIndex, required String sortBy}) async {
    newsList =
        await NewsApiServices.getAllNews(page: pageIndex, sortBy: sortBy);
    return newsList;
  }

  NewsModel findByDate({required String publishedAt}) {
    return newsList
        .firstWhere((newsModel) => newsModel.publishedAt == publishedAt);
  }

  Future<List<NewsModel>> fetchTopHeadlines() async {
    newsList = await NewsApiServices.getTopHeadlines();
    return newsList;
  }

  Future<List<NewsModel>> searchNewsProvider({required String query}) async {
    newsList = await NewsApiServices.searchNews(query: query.toLowerCase());
    return newsList;
  }
}
