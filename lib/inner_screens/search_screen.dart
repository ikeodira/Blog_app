import 'package:blog_app/consts/vars.dart';
import 'package:blog_app/models/news_model.dart';
import 'package:blog_app/providers/news_provider.dart';
import 'package:blog_app/providers/news_provider.dart';
import 'package:blog_app/widgets/articles_widget.dart';
import 'package:blog_app/widgets/empty_screen.dart';
import 'package:blog_app/widgets/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchTextController;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    focusNode = FocusNode();
  }

  List<NewsModel>? searchList = [];
  bool isSearching = false;

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      _searchTextController.dispose();
      focusNode.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          focusNode.unfocus();
                          Navigator.pop(context);
                        },
                        child: const Icon(IconlyLight.arrowLeft2),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          controller: _searchTextController,
                          style: TextStyle(color: color),
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          onEditingComplete: () async {
                            searchList = await newsProvider.searchNewsProvider(
                                query: _searchTextController.text);
                            isSearching = true;
                            focusNode.unfocus();
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              bottom: 8 / 5,
                            ),
                            hintText: "Search",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffix: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  _searchTextController.clear();
                                  focusNode.unfocus();
                                  isSearching = false;
                                  searchList!.clear();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpacing(20),
                if (!isSearching && searchList!.isEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MasonryGridView.count(
                        itemCount: searchKeywords.length,
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              _searchTextController.text =
                                  searchKeywords[index];
                              searchList =
                                  await newsProvider.searchNewsProvider(
                                      query: _searchTextController.text);
                              isSearching = true;
                              focusNode.unfocus();
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: color),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  searchKeywords[index],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (isSearching && searchList!.isEmpty)
                  const Expanded(
                    child: EmptyNewsWidget(
                      text: "Oops! No results found",
                      imagePath: "assets/images/search.png",
                    ),
                  ),
                if (searchList != null && searchList!.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchList!.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: searchList![index],
                          child: const ArticlesWidget(),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
