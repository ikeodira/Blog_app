import 'package:blog_app/widgets/articles_widget.dart';
import 'package:blog_app/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/utils.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    Size size = Utils(context).getScreenSize;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: color),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Bookmarks",
          style: GoogleFonts.lobster(
            textStyle: TextStyle(
              color: color,
              fontSize: 20,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
      body: const EmptyNewsWidget(
        text: "You didn't add anything yet to your bookmark",
        imagePath: "assets/images/bookmark.png",
      ),
      // ListView.builder(
      //   itemCount: 20,
      //   itemBuilder: (context, index) {
      //     return const ArticlesWidget();
      //   },
      // ),
    );
  }
}
