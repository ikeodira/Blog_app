import 'package:blog_app/consts/vars.dart';
import 'package:blog_app/inner_screens/search_screen.dart';
import 'package:blog_app/providers/news_provider.dart';
import 'package:blog_app/providers/news_provider.dart';
import 'package:blog_app/providers/news_provider.dart';
import 'package:blog_app/services/news_api.dart';
import 'package:blog_app/services/utils.dart';
import 'package:blog_app/widgets/articles_widget.dart';
import 'package:blog_app/widgets/drawer_widget.dart';
import 'package:blog_app/widgets/empty_screen.dart';
import 'package:blog_app/widgets/loading_widget.dart';
import 'package:blog_app/widgets/tabs.dart';
import 'package:blog_app/widgets/top_trending.dart';
import 'package:blog_app/widgets/vertical_spacing.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../models/news_model.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsType newsType = NewsType.allNews;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.publishedAt.name;

  // @override
  // void didChangeDependencies() {
  //   getNewsList();
  //   super.didChangeDependencies();
  // }

  // Future<List<NewsModel>> getNewsList() async {
  //   List<NewsModel> newsList = await ;
  //   return newsList;
  // }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    Size size = Utils(context).getScreenSize;
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: color),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "News App",
          style: GoogleFonts.lobster(
            textStyle: TextStyle(
              color: color,
              fontSize: 20,
              letterSpacing: 0.6,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const SearchScreen(),
                  type: PageTransitionType.bottomToTop,
                  inheritTheme: true,
                  ctx: context,
                ),
              );
            },
            icon: const Icon(IconlyLight.search),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                TabsWidget(
                  text: "All news",
                  color: newsType == NewsType.allNews
                      ? Theme.of(context).cardColor
                      : Colors.transparent,
                  ontap: () {
                    if (newsType == NewsType.allNews) {
                      return;
                    }
                    setState(() {
                      newsType = NewsType.allNews;
                    });
                  },
                  fontSize: newsType == NewsType.allNews ? 22 : 14,
                ),
                const SizedBox(width: 25),
                TabsWidget(
                  text: "Top trending",
                  color: newsType == NewsType.topTrending
                      ? Theme.of(context).cardColor
                      : Colors.transparent,
                  ontap: () {
                    if (newsType == NewsType.topTrending) {
                      return;
                    }
                    setState(() {
                      newsType = NewsType.topTrending;
                    });
                    // Container(
                    //   child: Text("This is the trending section"),
                    // );
                  },
                  fontSize: newsType == NewsType.topTrending ? 22 : 14,
                )
              ],
            ),
            const VerticalSpacing(10),
            newsType == NewsType.topTrending
                ? Container()
                : SizedBox(
                    height: kBottomNavigationBarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        paginationButtons(
                          ontap: () {
                            if (currentPageIndex == 0) {
                              return;
                            }
                            setState(() {
                              currentPageIndex -= 1;
                            });
                          },
                          text: "Prev",
                        ),
                        Flexible(
                          flex: 2,
                          child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  color: currentPageIndex == index
                                      ? Colors.blue
                                      : Theme.of(context).cardColor,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentPageIndex = index;
                                      });
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text('${index + 1}'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        paginationButtons(
                          ontap: () {
                            if (currentPageIndex == 4) {
                              return;
                            }
                            setState(() {
                              currentPageIndex += 1;
                            });
                          },
                          text: "Next",
                        ),
                      ],
                    ),
                  ),
            const VerticalSpacing(10),
            newsType == NewsType.topTrending
                ? Container()
                : Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton(
                          value: sortBy,
                          items: dropDownItems,
                          onChanged: (String? value) {
                            setState(() {
                              sortBy = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
            // const LoadingWidget(),
            FutureBuilder<List<NewsModel>>(
              future: newsType == NewsType.topTrending
                  ? newsProvider.fetchTopHeadlines()
                  : newsProvider.fetchAllNews(
                      pageIndex: currentPageIndex + 1, sortBy: sortBy),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return newsType == NewsType.allNews
                      ? LoadingWidget(newsType: newsType)
                      : Expanded(
                          child: LoadingWidget(newsType: newsType),
                        );
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: EmptyNewsWidget(
                      text: "An error occured ${snapshot.error}",
                      // text: "An error occured, please try again",
                      imagePath: "assets/images/no_news.png",
                    ),
                  );
                } else if (snapshot.data == null) {
                  print(snapshot.data.toString());
                  return Expanded(
                    child: EmptyNewsWidget(
                      text: "No news found ${snapshot.error}",
                      // text: "No news found",
                      imagePath: "assets/images/no_news.png",
                    ),
                  );
                }

                return newsType == NewsType.allNews
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: snapshot.data![index],
                              child: const ArticlesWidget(
                                  // imageUrl: snapshot.data![index].urlToImage,
                                  // dateToShow: snapshot.data![index].dateToShow,
                                  // readingTime:
                                  //     snapshot.data![index].readingTimeText,
                                  // title: snapshot.data![index].title,
                                  // url: snapshot.data![index].url,
                                  ),
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        height: size.height * 0.6,
                        child: Swiper(
                          autoplayDelay: 8000,
                          autoplay: true,
                          itemWidth: size.width * 0.9,
                          layout: SwiperLayout.STACK,
                          itemCount: 5,
                          viewportFraction: 0.9,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: snapshot.data![index],
                              child: const TopTrendingWidget(),
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItem = [
      DropdownMenuItem(
        value: SortByEnum.relevancy.name,
        child: Text(SortByEnum.relevancy.name.toLowerCase()),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
    ];
    return menuItem;
  }

  Widget paginationButtons({required Function() ontap, required String text}) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.all(6),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}






    //  if (newsType == NewsType.allNews)
    //           Expanded(
    //             child: ListView.builder(
    //               itemCount: newsList.length,
    //               itemBuilder: (context, index) {
    //                 return ArticlesWidget(
    //                   imageUrl: newsList[index].urlToImage,
    //                 );
    //               },
    //             ),
    //           ),
    //         if (newsType == NewsType.topTrending)
    //           SizedBox(
    //             height: size.height * 0.6,
    //             child: Swiper(
    //               autoplayDelay: 8000,
    //               autoplay: true,
    //               itemWidth: size.width * 0.9,
    //               layout: SwiperLayout.STACK,
    //               itemCount: 5,
    //               viewportFraction: 0.9,
    //               itemBuilder: (context, index) {
    //                 return TopTrendingWidget();
    //               },
    //             ),
    //           ),

