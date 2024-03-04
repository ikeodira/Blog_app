import 'package:blog_app/inner_screens/bookmarks_screen.dart';
import 'package:blog_app/providers/theme_provider.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/widgets/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      // elevation: 0.0,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      "assets/images/newspaper.png",
                      height: 60,
                      width: 60,
                    ),
                  ),
                  const VerticalSpacing(20),
                  Flexible(
                    child: Text(
                      "News App",
                      style: GoogleFonts.lobster(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const VerticalSpacing(20),
            listTiles(
              label: "Home",
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const HomeScreen(),
                    inheritTheme: true,
                    ctx: context,
                    type: PageTransitionType.bottomToTop,
                  ),
                );
              },
              icon: IconlyBold.home,
            ),
            listTiles(
              label: "Bookmark",
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const BookmarkScreen(),
                    inheritTheme: true,
                    ctx: context,
                    type: PageTransitionType.bottomToTop,
                  ),
                );
              },
              icon: IconlyBold.bookmark,
            ),
            const Divider(thickness: 5),
            SwitchListTile(
              title: Text(
                themeProvider.getDarkTheme ? 'Dark' : 'Light',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              secondary: Icon(
                themeProvider.getDarkTheme ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.secondary,
              ),
              value: themeProvider.getDarkTheme,
              onChanged: (bool value) {
                setState(() {
                  themeProvider.setDarkTheme = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class listTiles extends StatelessWidget {
  const listTiles({
    super.key,
    required this.label,
    required this.onTap,
    required this.icon,
  });

  final String label;
  final void Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
