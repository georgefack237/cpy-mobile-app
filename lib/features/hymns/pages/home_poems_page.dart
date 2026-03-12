import 'package:cpy_app/features/hymns/pages/widgets/home_hymn_page.dart';
import 'package:cpy_app/features/hymns/pages/widgets/hymn_item_collection_item.dart';
import 'package:cpy_app/features/hymns/providers/local_hymn_book_provider.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/pages/local_poems_page.dart';

class HomePoemsPage extends StatefulWidget {
  const HomePoemsPage({super.key});

  @override
  State<HomePoemsPage> createState() => _HomePoemsPageState();
}

class _HomePoemsPageState extends State<HomePoemsPage> {

  @override
  void initState() {
    final provider = Provider.of<LocalHymnBookProvider>(context, listen: false);
    provider.getHymnBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:  PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 80),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child:AppBar(
              centerTitle: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Poems",
                style:  TextStyle(
                    color:Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: fontSizes.font20(context.screenSize),
                    fontWeight: FontWeight.w600),
                maxLines: 1,
              ),

              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined, color:black, size: 25),
              ),



            ),
          ),
        ),


        body: Consumer<LocalHymnBookProvider>(
            builder: (context, provider, child) {

              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {

              }
              return provider.hymnBooks != null ? ListView(
                padding: EdgeInsets.symmetric(horizontal: appPadding.padH16(context.screenSize)),
                children: provider.hymnBooks!.map((localHymnBook){
                  return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> LocalPoemsPage(hymnBook: localHymnBook)));
                      },
                      child: HymnItemCollectionItem(hymnBook: localHymnBook, isPoem: true)
                  );
                }).toList(),
              ): provider.isLoading ?
              const Expanded(child: Center(child: CircularProgressIndicator())) :
              provider.error != null ? Text(provider.error!): const SizedBox();
            })






    );
  }
}
