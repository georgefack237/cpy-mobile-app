import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/data/models/hymn_category.dart';
import 'package:cpy_app/data/models/poem_model.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_item.dart';
import 'package:cpy_app/features/hymns/pages/widgets/poem_item.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../data/models/hymn_song.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/globals.dart';
import '../../../utils/icons/myIcon.dart';
import '../../../utils/icons/my_icons.dart';
import '../providers/admin_hymn_book_provider.dart';

class HymnBookDetailsPage extends StatefulWidget {
  const HymnBookDetailsPage({super.key, required this.hymnBook});

  final HymnBookCollection hymnBook;

  @override
  State<HymnBookDetailsPage> createState() => _HymnBookDetailsPageState();
}


class _HymnBookDetailsPageState extends State<HymnBookDetailsPage> {
  
  HymnCategory? selected;
  PoemCategory? selectedCategory;

  int bookSongs = 0;
  bool loading = false;
  List<HymnSong> songs = [];
  List<HymnSong> selectedHymns = [];
  List<PoemModel> selectedPoems = [];

  late final AdminHymnBookProvider _provider;



  @override
  void initState() {
    selected = categories[0];
    selectedCategory = userPoemCategories[0];
    _provider = Provider.of<AdminHymnBookProvider>(context, listen: false);
    _provider.getHymnBookSongs(hymnBookId: widget.hymnBook.id.toString());
    _provider.getHymnBookPoems(hymnBookId: widget.hymnBook.id);
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  List<HymnSong> searchList = [];
  List<PoemModel> searchPoemList = [];

  int currentPage = 1;
  bool searching = false;
  bool dateFilter = false;
  String searchQuery = "";


  TextEditingController txtSearch = TextEditingController();
  final FocusNode _focus = FocusNode();
  
  List<HymnCategory>  categories = [
    HymnCategory(id: 0, nameEn:  'All', nameFr: 'Tout', type: 'all'),
    HymnCategory(id: 1, nameEn: "Celebration", nameFr: 'Célébration', type: "celebration"),
    HymnCategory(id: 2, nameEn: "Thanksgiving", nameFr: 'Reconnaissance', type: "thanksgiving"),
    HymnCategory(id: 3, nameEn: "Warnings", nameFr: 'Interpellations', type: "warnings"),
    HymnCategory(id: 4, nameEn: "Supplications", nameFr: 'Supplications', type: "supplications"),
    HymnCategory(id: 5, nameEn: "Assurance", nameFr: 'Assurance', type: "assurance"),
    HymnCategory(id: 6, nameEn: "Hope", nameFr: 'Espérance', type: "hope")
  ];



  List<PoemCategory>  userPoemCategories = [
    PoemCategory(id: 0, nameEn:  'All', nameFr: 'Tout', type: 'all'),
    PoemCategory(id: 1, nameEn: "Celebration", nameFr: 'Célébration', type: "celebration"),
    PoemCategory(id: 2, nameEn: "Repentance", nameFr: 'Repentance', type: "repentance"),
    PoemCategory(id: 3, nameEn: "Warnings", nameFr: 'Interpellations', type: "warnings"),
    PoemCategory(id: 4, nameEn: "Soupirs", nameFr: 'Soupirs', type: "soupirs"),
    PoemCategory(id: 5, nameEn: "Assurance", nameFr: 'Assurance', type: "assurance"),
    PoemCategory(id: 6, nameEn: "Hope", nameFr: 'Espérance', type: "hope")
  ];



  List<String> hymns = [
    "Yehoshoua ma vie",
    "Adonai tu est vivant",
    "Je te lou papa",
    "Combien El est grande",
    "Yehoshoua",
    "Ezeckiel 47",
    "Donne moi ton eau"
  ];

  String removeDiacritics(String str) {
    const withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    String result = str;
    for (int i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], withoutDia[i]);
    }
    return result;
  }

  filterHymns({required String query, required List<HymnSong> words}) {
    final data = words.where((hymn) {
      final titleLower = removeDiacritics(hymn.title!.toLowerCase());
     // final contentLower = removeDiacritics(hymn.partitionText!.toLowerCase());
      final searchLower = removeDiacritics(query.toLowerCase());

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      searchQuery = query;
      searchList = data;
    });
  }


  filterPoems({required String query, required List<PoemModel> poems}) {
    final data = poems.where((poem) {
      final titleLower = removeDiacritics(poem.title.toLowerCase());
      final contentLower = removeDiacritics(poem.paroles.toLowerCase());
      final searchLower = removeDiacritics(query.toLowerCase());

      return titleLower.contains(searchLower) || contentLower.contains(searchLower);
    }).toList();

    setState(() {
      searchQuery = query;
      searchPoemList = data;
    });
  }

  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 2,
    child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 135),
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 20),
            child: AppBar(
              leading: !searching ? IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined, color: Colors.black87, size: 25),
              ): null,
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
              bottom: TabBar(
                onTap: (index) {
                  // This gives you the current tab index when tapped
                  print('Current tab index: $index');
                  setState(() {
                    _currentTabIndex = index;
                    logger.i(_currentTabIndex);
                  });
                },
                indicatorSize: TabBarIndicatorSize.tab,
               indicatorColor: const Color(0xFF3B5898),
                labelColor: const Color(0xFF3B5898),
                labelStyle: const TextStyle(fontSize: 16, fontFamily: "Poppins"),
                tabs: [
                  Tab(text: "Cantiques ${widget.hymnBook.hymnSongsCount}"),
                  Tab(text: "Poèmes ${widget.hymnBook.hymnPoemsCount}"),
                ],
              ),

              title: searching ? Container(
                width: MediaQuery.of(context).size.width - 35,
                height: 40,
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

                     _currentTabIndex == 0 ? filterHymns(query: value, words:  _provider.songs!):
                     filterPoems(query: value, poems: _provider.poems!);
                    });
                  },
                  controller: txtSearch,
                  decoration: InputDecoration(

                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    prefixIcon: const Icon(CupertinoIcons.search,
                        color: primary),
                    suffixIcon: searching
                        ? IconButton(
                      icon: const Icon(Icons.cancel,
                          color: tColorLight),
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
                        fontSize: fontSizes.font13(context.screenSize),
                        fontFamily: 'Poppins'),
                    contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 20),

                  ),
                ),
              ): Text(
                widget.hymnBook.nameFr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              
              actions: [

              !searching ?  InkWell(
                    onTap: () {
                      setState(() {
                        _focus.requestFocus();
                        searching = !searching;
                        searchList = _provider.songs!;
                      });
                    },
                    child: const MyIcon(
                      color: greyIcon,
                      size: 20,
                      icon: MyIcons.searchIcon,
                    )): SizedBox(),
              ],
            ),

          ),
        ),

        body: TabBarView(children: [
          buildHymnSongsContent(),
          buildHymnPoemsContent()
        ]),
      ),
    );
  }


  Widget buildHymnSongsContent() {
    return Consumer<AdminHymnBookProvider>(

          builder: (context, provider, child) {

            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {

            }
            
            return provider.songs != null ? Column(
              children: [

                if(!searching)
                const SizedBox(height: 30),

               !searching ? SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    padding: const EdgeInsets.only(right: 25,left: 10),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            selected = categories[index];
                            selectedHymns = provider.songs!.where((hymn){return hymn.categoryId == selected!.id;}).toList();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              color: selected == categories[index] ?
                              primaryDarkest:
                              const Color(0xFFF1F1F1).withOpacity(0.3),
                              border: Border.all( color: selected == categories[index] ?
                              primaryDarkest:
                              const Color(0xFFF1F1F1).withOpacity(0.7))
                          ),
                          child: Center(
                            child: Text(
                              categories[index].nameFr,
                              style:  TextStyle(
                                color: selected == categories[index] ? Colors.white:  Colors.black,
                                fontFamily: "Roboto",
                                fontSize: fontSizes.font13(context.screenSize),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ): SizedBox(),


                const SizedBox(height: 5),


                searching ?  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          var hymnSong = searchList[index];
                          return HymnItem2(hymnSong: hymnSong);
                        }),
                  ): selected!.id == 0 ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                      itemCount: provider.songs!.length,
                      itemBuilder: (context, index) {
                        var hymnSong = provider.songs![index];
                        return HymnItem2(hymnSong: hymnSong);
                      }),
                ): selected!.id != 0 && selectedHymns.isNotEmpty? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                      itemCount: selectedHymns.length,
                      itemBuilder: (context, index) {
                        var hymnSong = selectedHymns[index];
                        return HymnItem2(hymnSong: hymnSong);
                      }),
                ): selected!.id != 0 && selectedHymns.isEmpty ?
                Expanded(
                  child: Center(
                      child: Text('Aucune donnée trouvée!',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: fontSizes.font15(context.screenSize)
                          )
                      )
                  ),
                ): Expanded(
                  child: Center(
                      child: Text('Aucune donnée trouvée!',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: fontSizes.font15(context.screenSize)
                          )
                      )
                  ),
                ),
              ],
            ):

            provider.isLoading ? const Expanded(child: Center(child: CircularProgressIndicator()))

                : provider.error != null ? Text(provider.error!): const SizedBox();
          });
  }





  Widget buildHymnPoemsContent() {
    return Consumer<AdminHymnBookProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {

            }

            return provider.poems != null ? Column(
              children: [
                if(!searching)
                  const SizedBox(height: 30),

                !searching ? SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    padding: const EdgeInsets.only(right: 25,left: 10),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            selectedCategory = userPoemCategories[index];
                            selectedPoems = provider.poems!.where((hymn){return hymn.poemCategoryId == selectedCategory!.id;}).toList();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              color: selectedCategory == userPoemCategories[index] ?
                              primaryDarkest:
                              const Color(0xFFF1F1F1).withOpacity(0.3),
                              border: Border.all( color: selectedCategory == userPoemCategories[index] ?
                              primaryDarkest:
                              const Color(0xFFF1F1F1).withOpacity(0.7))
                          ),
                          child: Center(
                            child: Text(
                              userPoemCategories[index].nameFr,
                              style:  TextStyle(
                                color: selectedCategory == userPoemCategories[index] ? Colors.white:  Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ): const SizedBox(),


                const SizedBox(height: 5),

                searching && searchQuery.isNotEmpty ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                      itemCount: searchPoemList.length,
                      itemBuilder: (context, index) {
                        var poem = searchPoemList[index];
                        return PoemItem(poem: poem);
                      }),
                ): selectedCategory!.id == 0 ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                      itemCount: provider.poems!.length,
                      itemBuilder: (context, index) {
                        var poem = provider.poems![index];
                        return PoemItem(poem: poem);
                      })): selectedCategory!.id != 0 && selectedPoems.isNotEmpty ?
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                      itemCount: selectedPoems.length,
                      itemBuilder: (context, index) {
                        var poem = selectedPoems[index];
                        return PoemItem(poem: poem);
                      }),
                ): selectedCategory!.id != 0 && selectedPoems.isEmpty ? Expanded(
                  child: Center(
                      child: Text('Aucune donnée trouvée!',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: fontSizes.font15(context.screenSize)
                          )
                      )
                  ),
                ): Expanded(
                  child: Center(
                      child: Text('Aucune donnée trouvée!',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: fontSizes.font15(context.screenSize)
                          )
                      )
                  ),
                ),
              ],
            ):

            provider.isLoading ? const Expanded(child: Center(child: CircularProgressIndicator()))

                : provider.error != null ? Text(provider.error!): const SizedBox();
          });
  }
}

