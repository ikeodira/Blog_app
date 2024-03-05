import 'dart:convert';
import 'dart:io';
import 'package:blog_app/consts/api_const.dart';
import 'package:blog_app/models/news_model.dart';
import "package:http/http.dart" as http;

class NewsApiServices {
  static Future<List<NewsModel>> getAllNews({required int page}) async {
    // var url = Uri.parse(
    //     "https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=ee4f17289f264c0ebcc60b6d332e2b11");

    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": "bitcoin",
        "pageSize": "5",
        "domains": "bbc.co.uk,techcrunch.com,engadget.com",
        // "page": page.toString(),
        "page": 1.toString(),

        // "apiKey": API_KEY,
      });
      var response = await http.get(uri, headers: {
        "X-Api-key": API_KEY,
      });

      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
      }

      for (var v in data["articles"]) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }
}
