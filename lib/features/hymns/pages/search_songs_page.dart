import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/data/models/hymn_category.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_item.dart';
import 'package:cpy_app/features/hymns/providers/local_hymn_book_provider.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/hymn_song.dart';
import '../../../../utils/icons/my_icons.dart';


class SearchSongsPage extends StatefulWidget {
  const SearchSongsPage({super.key, required this.hymnBook});

  final HymnBookCollection hymnBook;

  @override
  State<SearchSongsPage> createState() => _SearchSongsPageState();
}


class _SearchSongsPageState extends State<SearchSongsPage> {


  List<HymnSong> songs = [];
  List<HymnSong> selectedHymns = [];


  List<HymnSong> searchList = [];
  int currentPage = 1;
  bool searching = false;
  bool dateFilter = false;
  String searchQuery = "";


  TextEditingController txtSearch = TextEditingController();
  final FocusNode _focus = FocusNode();


  filterSearchHymn({required String query, required List<HymnSong> songs}) {
    final contactList= songs.where((profile) {
      final titleLower = profile.title!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      searchQuery = query;
      searchList = contactList;
    });
  }


  @override
  void initState() {
    searching = true;
    _focus.requestFocus();
    final provider = Provider.of<LocalHymnBookProvider>(context, listen: false);
    provider.getLocalHymnBookSongs(hymnBookId: widget.hymnBook.id);
    super.initState();
  }

  void refresh() {
    setState(() {});
  }


  List<HymnCategory>  categories = [
    HymnCategory(id: 0, nameEn:  'All', nameFr: 'Tout', type: 'all'),
    HymnCategory(id: 1, nameEn: "Celebration", nameFr: 'Célébration', type: "celebration"),
    HymnCategory(id: 2, nameEn: "Thanksgiving", nameFr: 'Reconnaissance', type: "thanksgiving"),
    HymnCategory(id: 3, nameEn: "Warnings", nameFr: 'Interpellations', type: "warnings"),
    HymnCategory(id: 4, nameEn: "Supplications", nameFr: 'Supplications', type: "supplications"),
    HymnCategory(id: 5, nameEn: "Assurance", nameFr: 'Assurance', type: "assurance"),
    HymnCategory(id: 6, nameEn: "Hope", nameFr: 'Espérance', type: "hope")
  ];

  HymnCategory? selected;
  int clicked = 0;
  int bookSongs = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 20),
          child: AppBar(
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_outlined, color: Colors.black87, size: 25),
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title:  Text(
              'Recherche',
              style: TextStyle(
                fontSize: fontSizes.font20(context.screenSize),
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),


      body: buildTabContent(),

    );
  }


  Widget buildTabContent() {
    return
      Consumer<LocalHymnBookProvider>(builder: (context, provider, child) {

        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {

        }
        return provider.songs != null ? Column(
          children: [

            //const SizedBox(height: 15),

            Container(
              width: MediaQuery.of(context).size.width - 35,
              height: 50,
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              decoration: BoxDecoration(
                  color: backgroundLight,
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                focusNode: _focus,
                onChanged: (value) {
                  setState(() {
                    searching = _focus.hasFocus;
                    searching = txtSearch.text == '' ? false : true;
                    searchQuery = value;
                    filterSearchHymn(query: value, songs: provider.songs!);
                   // isNetworkEnabled.value == true ?  filterSearchHymn(value): filterSearchContactL(value);
                  });
                },
                controller: txtSearch,
                decoration: InputDecoration(

                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5.5),
                  ),
                  prefixIcon: const Icon(CupertinoIcons.search, color: primary),
                  suffixIcon: searching ? IconButton(icon: const Icon(Icons.cancel, color: tColorLight),
                    onPressed: () {
                      setState(() {
                        txtSearch.clear();
                        searching = false;
                      });
                    },
                  ) : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  hintText: 'Recherche ...',
                  hintStyle:  TextStyle(
                      color: tColorLight,
                      fontSize: fontSizes.font15(context.screenSize),
                      fontFamily: 'Poppins'),
                  contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 20),

                ),
              ),
            ),

            const SizedBox(height: 5),

           !searching ? Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  itemCount: provider.songs!.length,
                  itemBuilder: (context, index) {
                    var hymnSong = provider.songs![index];
                    return HymnItem2(hymnSong: hymnSong);
                  }),
            ): searching ? Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    var hymnSong = searchList[index];
                    return HymnItem2(hymnSong: hymnSong);
                  }),
            ): Container(child: const Center(child: Text(""))),
          ],
        ):
        provider.isLoading ? const Expanded(child: Center(child: CircularProgressIndicator()))

            : provider.error != null ? Text(provider.error!): const SizedBox();
      });
  }
}

