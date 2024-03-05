import 'package:blog_app/inner_screens/blog_details.dart';
import 'package:blog_app/inner_screens/news_details_webview.dart';
import 'package:blog_app/models/news_model.dart';
import 'package:blog_app/services/utils.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class TopTrendingWidget extends StatelessWidget {
  const TopTrendingWidget({
    super.key,
  });

  // final String url;

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsModelProvider = Provider.of<NewsModel>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: () {
            print("top trending clicked");
            Navigator.pushNamed(
              context,
              NewsDetailsScreen.routeName,
              arguments: newsModelProvider.publishedAt,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  boxFit: BoxFit.fill,
                  errorWidget: Image.asset("assets/images/empty_image.png"),
                  imageUrl: newsModelProvider.urlToImage,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  newsModelProvider.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            child:
                                NewsDetailsWebView(url: newsModelProvider.url),
                            type: PageTransitionType.bottomToTop,
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    icon: Icon(
                      Icons.link,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  SelectableText(
                    newsModelProvider.dateToShow,
                    style: GoogleFonts.montserrat(fontSize: 15),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
