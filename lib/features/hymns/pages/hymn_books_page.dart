import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_book_item.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_book_shimmer.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_no_internet.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/admin_hymn_book_provider.dart';
import 'hymn_book_details_page.dart';

class HymnBooksPage extends StatefulWidget {
  const HymnBooksPage({super.key});

  @override
  State<HymnBooksPage> createState() => _HymnBooksPageState();
}

class _HymnBooksPageState extends State<HymnBooksPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? selected;

  @override
  void initState() {
    final provider = Provider.of<AdminHymnBookProvider>(context, listen: false);
    provider.getHymnBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InternetScaffold(
      title: 'Recueils',
      body: buildTabContent(),
      offline: NoInternetView(
        onRetry: () {
          Provider.of<AdminHymnBookProvider>(
            context,
            listen: false,
          ).getHymnBooks();
        },
      ),
    );
  }

  Widget buildTabContent() {
    return Consumer<AdminHymnBookProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const HymnBookShimmerList();
      }

      return provider.hymnBooks != null ? RefreshIndicator(
        strokeWidth: 1,
        color: primary,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await provider.getHymnBooks();
        },
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: provider.hymnBooks!.length,
            itemBuilder: (context, index) {

              List<String> assets = [
                'assets/illustrations/book_one.svg',
                'assets/illustrations/book_two.svg',
                'assets/illustrations/book_three.svg',

                'assets/illustrations/book_four.svg',
                'assets/illustrations/book_five.svg',
                'assets/illustrations/book_six.svg',

                'assets/illustrations/book_seven.svg',
                'assets/illustrations/book_eight.svg',
                'assets/illustrations/book_nine.svg',

                'assets/illustrations/book_ten.svg',
                'assets/illustrations/book_eleven.svg'
              ];

              var hymnSong = provider.hymnBooks![index];
              return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HymnBookDetailsPage(hymnBook: hymnSong)));
                  },
                  child: HymnBookItem(hymnBook: hymnSong, asset: assets[index]));
            }),
      )
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : const SizedBox();
    });
  }


}

class InternetScaffold extends StatefulWidget {
  const InternetScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.offline,
    this.actions,
    this.appBar,
  });

  final Widget body;
  final Widget offline;
  final String title;
  final List<Widget>? actions;
  final PreferredSize? appBar;

  @override
  State<InternetScaffold> createState() => _InternetScaffoldState();
}

class _InternetScaffoldState extends State<InternetScaffold> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isNetworkEnabled,
      builder: (context, connected, home) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar:
              widget.appBar ??
              PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 80),
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 6),
                  child: AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark,
                      systemNavigationBarIconBrightness: Brightness.dark,
                    ),
                    surfaceTintColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    centerTitle: false,
                    title: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                    ),
                    actions: widget.actions,
                  ),
                ),
              ),
          body: connected ? widget.body : widget.offline,
        );
      },
    );
  }
}
