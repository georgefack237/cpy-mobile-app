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

  List<HymnCategory> categories = [
    HymnCategory(id: 0, nameEn: 'All', nameFr: 'Tout', type: 'all'),
    HymnCategory(id: 1, nameEn: "Celebration", nameFr: 'Célébration', type: "celebration"),
    HymnCategory(id: 2, nameEn: "Thanksgiving", nameFr: 'Reconnaissance', type: "thanksgiving"),
    HymnCategory(id: 3, nameEn: "Warnings", nameFr: 'Interpellations', type: "warnings"),
    HymnCategory(id: 4, nameEn: "Supplications", nameFr: 'Supplications', type: "supplications"),
    HymnCategory(id: 5, nameEn: "Assurance", nameFr: 'Assurance', type: "assurance"),
    HymnCategory(id: 6, nameEn: "Hope", nameFr: 'Espérance', type: "hope")
  ];

  List<PoemCategory> userPoemCategories = [
    PoemCategory(id: 0, nameEn: 'All', nameFr: 'Tout', type: 'all'),
    PoemCategory(id: 1, nameEn: "Celebration", nameFr: 'Célébration', type: "celebration"),
    PoemCategory(id: 2, nameEn: "Repentance", nameFr: 'Repentance', type: "repentance"),
    PoemCategory(id: 3, nameEn: "Warnings", nameFr: 'Interpellations', type: "warnings"),
    PoemCategory(id: 4, nameEn: "Soupirs", nameFr: 'Soupirs', type: "soupirs"),
    PoemCategory(id: 5, nameEn: "Assurance", nameFr: 'Assurance', type: "assurance"),
    PoemCategory(id: 6, nameEn: "Hope", nameFr: 'Espérance', type: "hope")
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
          preferredSize: const Size.fromHeight(150),
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 20),
            child: AppBar(




              leading: !searching
                  ? IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined, color:black, size: 25),
              ) : null,




              leadingWidth: 52,
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          _currentTabIndex = index;
                          logger.i(_currentTabIndex);
                        });
                      },
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: dark,
                      labelStyle: TextStyle(
                          fontSize: fontSizes.font13(context.screenSize), fontFamily: "Poppins", fontWeight: FontWeight.w600),
                      unselectedLabelStyle: TextStyle(
                          fontSize: fontSizes.font13(context.screenSize), fontFamily: "Poppins", fontWeight: FontWeight.w500),
                      tabs: [
                        Tab(text: "Cantiques  ${widget.hymnBook.hymnSongsCount}"),
                        Tab(text: "Poèmes  ${widget.hymnBook.hymnPoemsCount}"),
                      ],
                    ),
                  ),
                ),
              ),
              title: searching ? Container(
                width: MediaQuery.of(context).size.width - 35,
                height: 44,
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.circular(16)),
                child: TextField(
                  focusNode: _focus,
                  onChanged: (value) {
                    setState(() {
                      searching = _focus.hasFocus;
                      searching = txtSearch.text == '' ? false : true;
                      searchQuery = value;

                      _currentTabIndex == 0
                          ? filterHymns(query: value, words: _provider.songs!)
                          : filterPoems(query: value, poems: _provider.poems!);
                    });
                  },
                  controller: txtSearch,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(CupertinoIcons.search, color: primary),
                    suffixIcon: searching
                        ? IconButton(
                      icon: const Icon(Icons.cancel, color: tColorLight),
                      onPressed: () {
                        setState(() {
                          txtSearch.clear();
                          searching = false;
                        });
                      },
                    )
                        : const SizedBox(height: 0, width: 0),
                    hintText: 'Recherche ...',
                    hintStyle: TextStyle(color: tColorLight, fontSize: fontSizes.font13(context.screenSize), fontFamily: 'Poppins'),
                    contentPadding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  widget.hymnBook.nameFr,
                  style:  TextStyle(
                      color:Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: fontSizes.font20(context.screenSize),
                      fontWeight: FontWeight.w600),
                ),
              ),
              actions: [
                !searching
                    ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _softIconButton(
                    icon: MyIcons.searchIcon,
                    isCustomIcon: true,
                    onTap: () {
                      setState(() {
                        _focus.requestFocus();
                        searching = !searching;
                        searchList = _provider.songs!;
                      });
                    },
                  ),
                )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        body: TabBarView(children: [buildHymnSongsContent(), buildHymnPoemsContent()]),
      ),
    );
  }

  /// A small circular, softly-tinted icon button — used for the back arrow
  /// and the search trigger so both match the rounded, soft language used
  /// across the rest of the app (cards, chips, etc).
  Widget _softIconButton({
    required dynamic icon,
    required VoidCallback onTap,
    bool isCustomIcon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: primarySoft.withOpacity(.2),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primarySoft.withOpacity(.14),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: isCustomIcon
              ? MyIcon(color: primary, size: 18, icon: icon as String)
              : Icon(icon as IconData, color: primary, size: 20),
        ),
      ),
    );
  }

  /// Pill-style category filter chip. Selected state keeps using your
  /// existing `primaryDarkest` token; the unselected state now uses a
  /// neutral soft fill instead of the old translucent grey border.
  Widget _categoryChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(29),
          splashColor: primaryDarkest.withOpacity(.12),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: isSelected ? primaryDarkest : backgroundLight,
              border: Border.all(
                color: isSelected ? primaryDarkest : const Color(0xFFECECEC),
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: primaryDarkest.withOpacity(.25), blurRadius: 10, offset: const Offset(0, 4))]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : dark,
                fontFamily: "Poppins",
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: fontSizes.font13(context.screenSize),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Friendly empty state — replaces the bare centered text with an icon
  /// in a soft tinted circle above the message.
  Widget _emptyState(BuildContext context, {String message = 'Aucune donnée trouvée !'}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: primarySoft.withOpacity(.16), shape: BoxShape.circle),
            child: Icon(CupertinoIcons.search, color: primary, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fontSizes.font15(context.screenSize),
              fontWeight: FontWeight.w500,
              color: dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingState() {
    return Center(child: CircularProgressIndicator(color: primary));
  }

  Widget buildHymnSongsContent() {
    return Consumer<AdminHymnBookProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return _loadingState();
      }

      if (provider.error != null) {}

      return provider.songs != null
          ? Column(
        children: [
          if (!searching) const SizedBox(height: 20),
          !searching
              ? SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.only(right: 25, left: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _categoryChip(
                  context: context,
                  label: categories[index].nameFr,
                  isSelected: selected == categories[index],
                  onTap: () {
                    setState(() {
                      selected = categories[index];
                      selectedHymns = provider.songs!.where((hymn) {
                        return hymn.categoryId == selected!.id;
                      }).toList();
                    });
                  },
                );
              },
            ),
          )
              : const SizedBox(),
          const SizedBox(height: 5),
          searching
              ? Expanded(
            child: searchList.isEmpty
                ? _emptyState(context)
                : ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  var hymnSong = searchList[index];
                  return HymnItem(hymnSong: hymnSong);
                }),
          )
              : selected!.id == 0
              ? Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                itemCount: provider.songs!.length,
                itemBuilder: (context, index) {
                  var hymnSong = provider.songs![index];
                  return HymnItem(hymnSong: hymnSong);
                }),
          )
              : selected!.id != 0 && selectedHymns.isNotEmpty
              ? Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                itemCount: selectedHymns.length,
                itemBuilder: (context, index) {
                  var hymnSong = selectedHymns[index];
                  return HymnItem(hymnSong: hymnSong);
                }),
          )
              : Expanded(child: _emptyState(context)),
        ],
      )
          : provider.isLoading
          ? Expanded(child: _loadingState())
          : provider.error != null
          ? Text(provider.error!)
          : const SizedBox();
    });
  }

  Widget buildHymnPoemsContent() {
    return Consumer<AdminHymnBookProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return _loadingState();
      }

      if (provider.error != null) {}

      return provider.poems != null
          ? Column(
        children: [
          if (!searching) const SizedBox(height: 20),
          !searching
              ? SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.only(right: 25, left: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _categoryChip(
                  context: context,
                  label: userPoemCategories[index].nameFr,
                  isSelected: selectedCategory == userPoemCategories[index],
                  onTap: () {
                    setState(() {
                      selectedCategory = userPoemCategories[index];
                      selectedPoems = provider.poems!.where((hymn) {
                        return hymn.poemCategoryId == selectedCategory!.id;
                      }).toList();
                    });
                  },
                );
              },
            ),
          )
              : const SizedBox(),
          const SizedBox(height: 5),
          searching && searchQuery.isNotEmpty
              ? Expanded(
            child: searchPoemList.isEmpty
                ? _emptyState(context)
                : ListView.builder(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                itemCount: searchPoemList.length,
                itemBuilder: (context, index) {
                  var poem = searchPoemList[index];
                  return PoemItem(poem: poem);
                }),
          )
              : selectedCategory!.id == 0
              ? Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                  itemCount: provider.poems!.length,
                  itemBuilder: (context, index) {
                    var poem = provider.poems![index];
                    return PoemItem(poem: poem);
                  }))
              : selectedCategory!.id != 0 && selectedPoems.isNotEmpty
              ? Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                itemCount: selectedPoems.length,
                itemBuilder: (context, index) {
                  var poem = selectedPoems[index];
                  return PoemItem(poem: poem);
                }),
          )
              : Expanded(child: _emptyState(context)),
        ],
      )
          : provider.isLoading
          ? Expanded(child: _loadingState())
          : provider.error != null
          ? Text(provider.error!)
          : const SizedBox();
    });
  }
}