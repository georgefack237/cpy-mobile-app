import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/features/home/pages/home_page.dart';
import 'package:cpy_app/features/hymns/pages/hymn_book_details_page.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_book_item.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/admin_hymn_book_provider.dart';

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
        offline:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Text('Pas de connexion Internet'),

                const SizedBox(height: 15),

                FilledButton.tonal(onPressed: (){
                  final provider = Provider.of<AdminHymnBookProvider>(context, listen: false);
                  provider.getHymnBooks();
                }, child: Text(
                    'Mode hors ligne'
                    ,style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fontSizes.font13(context.screenSize)
                )))
              ],
            )),
    );
  }

  Widget buildTabContent() {
    return Consumer<AdminHymnBookProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }


      if (provider.error != null) {

      }

      return provider.hymnBooks != null
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      itemCount: provider.hymnBooks!.length,
                      itemBuilder: (context, index) {
                        var hymnSong = provider.hymnBooks![index];
                        return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HymnBookDetailsPage(hymnBook: hymnSong)));
                            },
                            child: HymnBookItem(hymnBook: hymnSong));
                      }),
                )
              ],
            )
          : provider.isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : provider.error != null
                  ? Center(child: Text(provider.error!))
                  : const SizedBox();
    });
  }
}

class InternetScaffold extends StatefulWidget {
  const InternetScaffold({super.key, required this.body, required this.title, required this.offline, this.actions, this.appBar});

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
          return  Scaffold(
              backgroundColor: Colors.white,
              appBar: widget.appBar ?? PreferredSize(
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
                    title:  Text(
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
              body: connected ? widget.body : widget.offline
          );
        });
  }
}
