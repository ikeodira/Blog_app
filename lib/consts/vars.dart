import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum NewsType {
  topTrending,
  allNews,
}

enum SortByEnum {
  relevancy, // articles more closely related to q comes first
  popularity, // articles from popular sources and publishers come first
  publishedAt, // newest articles comes first
}

TextStyle titleTextStyle =
    GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold);

TextStyle smallTextStyle = GoogleFonts.montserrat(fontSize: 15);

List<String> searchKeywords = [
  "Football",
  "Flutter",
  "Python",
  "Weather",
  "Crypto",
  "Bitcoin",
  "Youtube",
  "Netflix",
  "Meta",
];
