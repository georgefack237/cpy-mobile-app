
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/globals.dart';


class MediaLinkPage extends StatefulWidget {
  const MediaLinkPage({super.key, required this.webLink, required this.name});

  final String webLink;
  final String name;

  @override
  State<MediaLinkPage> createState() => _MediaLinkPageState();
}

class _MediaLinkPageState extends State<MediaLinkPage> {
  late final WebViewController _controller;

  bool validURL = false;
  bool isLoading = true;
  double progress = 0.0;

  bool isValidUrl(String url) {
    Uri? uri = Uri.tryParse(url);
    bool valid = uri != null && uri.hasScheme && uri.hasAuthority;

    if (valid) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (p) {
              setState(() {
                progress = p / 100.0;
                isLoading = p < 100; // only loading if not 100%
              });
            },
            onPageStarted: (url) {
              setState(() {
                isLoading = true;
                progress = 0.0;
              });
            },
            onPageFinished: (url) {
              setState(() {
                isLoading = false;
                progress = 1.0;
              });
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    }

    setState(() {
      validURL = valid;
    });

    return valid;
  }

  @override
  void initState() {
    super.initState();
    isValidUrl(widget.webLink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: black, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.name,
          style: const TextStyle(color: dark),
        ),
      ),
      body: validURL
          ? Stack(
        children: [
          WebViewWidget(controller: _controller),

          // Show loading indicator when page is loading
          if (isLoading)
            LinearProgressIndicator(
              value: progress < 1.0 ? progress : null,
              color: primary,
              backgroundColor: muted.withOpacity(0.2),
            ),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Invalid url!',
              style: TextStyle(
                color: dark,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: fontSizes.font15(context.screenSize),
              ),
            ),
            SizedBox(height: context.screenSize.height * .009),
            RichText(
              softWrap: true,
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "The url ",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: muted,
                  fontSize: fontSizes.font13(context.screenSize),
                  fontFamily: 'Poppins',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.webLink,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizes.font13(context.screenSize),
                      color: primary,
                    ),
                  ),
                  TextSpan(
                    text: " is not valid!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: fontSizes.font13(context.screenSize),
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
