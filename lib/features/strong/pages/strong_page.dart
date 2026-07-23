import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/features/hymns/pages/hymn_books_page.dart';
import 'package:cpy_app/features/strong/data/model/word_reference.dart';
import 'package:cpy_app/features/strong/word_item.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors/light_colors.dart';
import '../../../utils/icons/myIcon.dart';
import '../../../utils/icons/my_icons.dart';
import '../../hymns/pages/widgets/hymn_book_shimmer.dart';
import '../providers/word_reference_provider.dart';
import 'error_state.dart';

class StrongPage extends StatefulWidget {
  const StrongPage({super.key});

  @override
  State<StrongPage> createState() => _StrongPageState();
}

class _StrongPageState extends State<StrongPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool showOffline = false;
  List<WordReference> words = [];

  List<WordReference> searchList = [];
  int currentPage = 1;
  bool searching = false;
  bool dateFilter = false;
  String searchQuery = "";

  TextEditingController txtSearch = TextEditingController();
  final FocusNode _focus = FocusNode();
  late final WordReferenceProvider _provider;

  @override
  void initState() {
    _provider = Provider.of<WordReferenceProvider>(context, listen: false);
    _provider.getWords(context: context);
    super.initState();
  }

  void filterWords({required String query, required List<WordReference> words}) {
    final data = words.where((profile) {
      final titleLower = profile.word.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      logger.i(data);
      searchQuery = query;
      searchList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InternetScaffold(
      body: RefreshIndicator(
          strokeWidth: 1,
          color: primaryDark,
          backgroundColor: Colors.white,
          onRefresh: () async {
            _provider.getWords(context: context);
          },
          child: buildContent()),
      appBar: PreferredSize(
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
            title: searching
                ? Container(
              width: MediaQuery.of(context).size.width - 35,
              height: 40,
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              decoration: BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.circular(15)),
              child: TextField(
                focusNode: _focus,
                onChanged: (value) {
                  setState(() {
                    searching = _focus.hasFocus;
                    searching = txtSearch.text == '' ? false : true;
                    searchQuery = value;
                    filterWords(query: value, words: showOffline ? _provider.localWords! : _provider.words!);
                  });
                },
                controller: txtSearch,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5.5),
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
                      : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  hintText: 'Recherche ...',
                  hintStyle:
                  TextStyle(color: tColorLight, fontSize: fontSizes.font13(context.screenSize), fontFamily: 'Poppins'),
                  contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                ),
              ),
            )
                : const Text(
              'Lexique',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            actions: [
              !searching
                  ? InkWell(
                  onTap: () {
                    setState(() {
                      _focus.requestFocus();
                      searching = !searching;
                      searchList = showOffline ? _provider.localWords! : _provider.words!;
                    });
                  },
                  child: const MyIcon(
                    color: greyIcon,
                    size: 20,
                    icon: MyIcons.searchIcon,
                  ))
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
      title: '',
      // Polished offline state: soft icon circle + primary "Réessayer"
      // + outlined "Mode hors ligne", matching the language used on
      // other screens' offline prompts instead of a bare text + basic
      // tonal buttons.
      offline: !showOffline
          ? ErrorStateView(
        icon: Icons.wifi_off_rounded,
        title: 'Pas de connexion Internet',
        primaryLabel: 'Réessayer',
        onPrimaryAction: () => _provider.getWords(context: context),
        secondaryLabel: 'Mode hors ligne',
        onSecondaryAction: () {
          _provider.getLocalWords(context: context);
          setState(() {
            showOffline = true;
          });
        },
      )
          : buildOfflineContent(_provider),
    );
  }

  Widget buildOfflineContent(WordReferenceProvider homeProvider) {
    return Consumer<WordReferenceProvider>(builder: (context, provider, child) {
      if (provider.error != null) {
        return ErrorStateView(
          icon: Icons.cloud_off_rounded,
          title: 'Une erreur est survenue',
          message: provider.error,
          primaryLabel: 'Réessayer',
          onPrimaryAction: () => provider.getLocalWords(context: context),
        );
      }

      return provider.localWords != null
          ? Column(
        children: [
          searching
              ? Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  var word = searchList[index];
                  return WordItem(
                    wordReference: word,
                  );
                }),
          )
              : Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                itemCount: provider.localWords!.length,
                itemBuilder: (context, index) {
                  var word = provider.localWords![index];
                  return WordItem(
                    wordReference: word,
                  );
                }),
          )
        ],
      )
          : provider.isLoading
          ? const HymnBookShimmerList()
          : const SizedBox();
    });
  }

  Widget buildContent() {
    return Consumer<WordReferenceProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const HymnBookShimmerList();
      }

      if (provider.error != null) {
        return ErrorStateView(
          icon: Icons.cloud_off_rounded,
          title: 'Une erreur est survenue',
          message: provider.error,
          primaryLabel: 'Réessayer',
          onPrimaryAction: () => _provider.getWords(context: context),
        );
      }

      return provider.words != null
          ? Column(
        children: [
          searching
              ? Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  var word = searchList[index];
                  return WordItem(
                    wordReference: word,
                  );
                }),
          )
              : Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                itemCount: provider.words!.length,
                itemBuilder: (context, index) {
                  var word = provider.words![index];
                  return WordItem(
                    wordReference: word,
                  );
                }),
          )
        ],
      )
          : const SizedBox();
    });
  }
}