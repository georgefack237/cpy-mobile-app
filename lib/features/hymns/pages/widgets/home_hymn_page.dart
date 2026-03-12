import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/data/models/hymn_category.dart';
import 'package:cpy_app/features/hymns/pages/search_songs_page.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_item.dart';
import 'package:cpy_app/features/hymns/providers/local_hymn_book_provider.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/hymn_song.dart';
import '../../../../utils/icons/my_icons.dart';


class HomeHymnPage extends StatefulWidget {
  const HomeHymnPage({super.key, required this.hymnBook});

  final HymnBookCollection hymnBook;

  @override
  State<HomeHymnPage> createState() => _HomeHymnPageState();
}


class _HomeHymnPageState extends State<HomeHymnPage> {


  List<HymnSong> songs = [];
  List<HymnSong> selectedHymns = [];




  @override
  void initState() {
    selected = categories[0];
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
            title: Text(
              widget.hymnBook.nameFr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),

            actions: [


              InkWell(
                  onTap: () {

                    setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchSongsPage(hymnBook: widget.hymnBook)));
                    });

                  },
                  child:  MyIcon(
                    color: greyIcon,
                    size: 20,
                    icon: MyIcons.searchIcon,
                  )),
            ],
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

                const SizedBox(height: 15),

                SizedBox(
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
                              color: selected == categories[index] ? primaryDarkest:
                              const Color(0xFFF1F1F1).withOpacity(0.3),
                              border: Border.all( color: selected == categories[index] ? primaryDarkest:
                              const Color(0xFFF1F1F1).withOpacity(0.7))
                          ),
                          child: Center(
                            child: Text(
                              categories[index].nameFr,
                              style:  TextStyle(
                                color: selected == categories[index] ? Colors.white:  Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),


                const SizedBox(height: 5),

                selected!.id == 0 ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      itemCount: provider.songs!.length,
                      itemBuilder: (context, index) {
                        var hymnSong = provider.songs![index];
                        return HymnItem2(hymnSong: hymnSong);
                      }),
                ): selected!.id != 0 && selectedHymns.isNotEmpty? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      itemCount: selectedHymns.length,
                      itemBuilder: (context, index) {
                        var hymnSong = selectedHymns[index];
                        return HymnItem2(hymnSong: hymnSong);
                      }),
                ): selected!.id != 0 && selectedHymns.isEmpty ? Container(
                    child: const Center(child: Text(""))
                ): Container(child: const Center(child: Text(""))),
              ],
            ):
            provider.isLoading ? const Expanded(child: Center(child: CircularProgressIndicator()))

                : provider.error != null ? Text(provider.error!): const SizedBox();
          });
  }
}

