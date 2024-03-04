import 'package:blog_app/widgets/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class NewsDetailsWebView extends StatefulWidget {
  const NewsDetailsWebView({super.key, required this.url});
  final String url;

  @override
  State<NewsDetailsWebView> createState() => _NewsDetailsWebViewState();
}

class _NewsDetailsWebViewState extends State<NewsDetailsWebView> {
  late WebViewController _webViewController;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          //Stay inside the browser
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(IconlyLight.arrowLeft2),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: color),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.url,
            style: TextStyle(color: color),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _showModalSheetfct();
              },
              icon: const Icon(Icons.more_horiz),
            )
          ],
        ),
        body: Column(
          //Correct Command
          // docker run -it -u 0 -p 8080:8080 -e DATA_UPLOAD_MAX_NUMBER_FILES=10000000  -v $(pwd)/:/label-studio/data heartexlabs/label-studio:latest
          // docker run -it -p 8080:8080 -e DATA_UPLOAD_MAX_NUMBER_FILES=10000000 -v $(pwd)/:/label-studio/data heartexlabs/label-studio:latest
          children: [
            LinearProgressIndicator(
              value: _progress,
              color: _progress == 1.0 ? Colors.transparent : Colors.blue,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            Expanded(
              child: WebView(
                initialUrl: widget.url,
                zoomEnabled: true,
                onProgress: (progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showModalSheetfct() async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalSpacing(20),
              Center(
                child: Container(
                  height: 5,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const VerticalSpacing(20),
              const Text(
                "More option",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const VerticalSpacing(20),
              const Divider(thickness: 2),
              const VerticalSpacing(20),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text("Share"),
                onTap: () async {
                  try {
                    await Share.share(
                      widget.url,
                      subject: "Look what I made",
                    );
                  } catch (error) {
                    GlobalMethods.errorDialog(
                      errorMessage: "An error occured $error",
                      context: context,
                    );
                  }
                },
              ),
              const VerticalSpacing(20),
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text("Open in Browser"),
                onTap: () async {
                  if (!await launchUrl(Uri.parse(widget.url))) {
                    throw Exception('Could not launch $widget.url');
                  }
                },
              ),
              const VerticalSpacing(20),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text("Refresh"),
                onTap: () async {
                  try {
                    await _webViewController.reload();
                  } catch (err) {
                    GlobalMethods.errorDialog(
                      errorMessage: "An error occured $err",
                      context: context,
                    );
                  } finally {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
