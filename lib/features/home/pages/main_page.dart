import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';
import '../../../core/notifications/push_notifications/firebase_push_notifications.dart';
import '../../hymns/pages/hymn_books_page.dart';
import '../../media/pages/media_page.dart';
import '../../more/pages/more_screen.dart';
import '../../strong/pages/strong_page.dart';
import 'home_page.dart';


class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key, this.index});

  final int? index;

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _bottomNavIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? daysRemaining;
  bool isLoading= false;
  bool loading = false;

  late final PageController _controller;

  final List<Widget> _listWidget = [
    const HomePage(),
    const HymnBooksPage(),
    const MediaPage(),
    const StrongPage(),
    const HelpPage(),
  ];

  @override
  void initState() {
    NotificationService.onMessage(context);

    _controller = PageController(initialPage: widget.index == null ? 0: widget.index!);
    super.initState();
  }

  void onTap(int index) {
    if (_bottomNavIndex != index) {
      _controller.jumpToPage(index);
      setState(() {
        _bottomNavIndex = index;
      });
    }
  }


  void navigateToScreen({required Widget screen}){
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [

          isLoading ? const Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(child: CircularProgressIndicator()),
              ))) : Container(),

          (!isLoading) ? Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  onPageChanged: (value){
                    onTap(value);
                  },
                  children: _listWidget
              )
          ): Container()

        ],
      ),

      bottomNavigationBar: SizedBox(
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),

          child: BottomNavigationBar(
            elevation: 4,
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            selectedLabelStyle:  const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.blue
            ),

            unselectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.black
            ),

            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            currentIndex: _bottomNavIndex,
            selectedItemColor: const Color(0xFF3B5898),

            items: <BottomNavigationBarItem>[

              BottomNavigationBarItem(
                  icon: MyIcon(
                      size: 20,
                      icon: MyIcons.homeIcon,
                      color: _bottomNavIndex == 0 ? const Color(0xFF3B5898): Colors.grey
                  ),
                  label: "Accueil"),

              BottomNavigationBarItem(
                  icon: MyIcon(
                      size: 20,
                      icon: MyIcons.bookNew,
                      color: _bottomNavIndex == 1 ? const Color(0xFF3B5898): Colors.grey
                  ),
                  label: 'Recueils'),


              BottomNavigationBarItem(
                  icon: MyIcon(
                      size: 20,
                      icon: MyIcons.fileIcon,
                      color: _bottomNavIndex == 2 ? const Color(0xFF3B5898): Colors.grey
                  ),
                  label: 'Médiathèque'),

              BottomNavigationBarItem(
                  icon: MyIcon(
                      size: 20,
                      icon: MyIcons.strongIcon,
                      color: _bottomNavIndex == 3 ? const Color(0xFF3B5898): Colors.grey
                  ),
                  label: 'Lexique'),

              BottomNavigationBarItem(
                  icon: MyIcon(
                      size: 20,
                      icon: MyIcons.moreMenu,
                      color: _bottomNavIndex == 4 ? const Color(0xFF3B5898): Colors.grey
                  ),
                  label: 'Plus'),

            ],
            onTap: (value){
              onTap(value);
            },
          ),
        ),
      ),

    );

  }

}