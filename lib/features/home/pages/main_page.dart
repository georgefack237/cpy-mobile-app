import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../core/notifications/push_notifications/firebase_push_notifications.dart';
import '../../hymns/pages/hymn_books_page.dart';
import '../../hymns/pages/poem_detail_page.dart';
import '../../hymns/pages/widgets/hymn_song_details_page.dart';
import '../../media/pages/media_page.dart';
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
  ];

  @override
  void initState() {
    NotificationService.onMessage(context);

  //  _saveNotificationToken();

   /* FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {

      var id = message.data['id'];
      var page = message.data['page'];

      if (id == 'update') {

      } else if (page != null) {

        if(page == 'poems'){

          Navigator.push(context, MaterialPageRoute(builder: (context)=>  PoemDetailPage(id: message.data['id'] , title: '')));

        } else if(page == 'songs'){

          Navigator.push(context, MaterialPageRoute(builder: (context)=>  const HymnBooksPage()));

          //Navigator.push(context, MaterialPageRoute(builder: (context)=>  HymnSongDetailsPage(songId:  message.data['id'] , hymnSong: null,)));

        } else if(page == 'medias'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>  const MediaPage()));

        } else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>  const StrongPage()));

        }

      } else if (message.data['page'] == 'tasks') {
       // var taskId = message.data['id'].toString();
       // Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailsPage(fromNotification: true, taskId: taskId)));
      } else if (message.data['page'] == 'contacts') {
       // Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsHome(fromMenu: true)));
      } else if(message.data['page'] == 'update_location'){


      }
    }); */


    _controller = PageController(initialPage: widget.index == null ? 0: widget.index!);
    super.initState();
  }

  void onTap(int index) {

    if(index == 5){
      if(!isLoading && !loading) {
      }
    }else{

      if (_bottomNavIndex != index) {
        _controller.jumpToPage(index);
        setState(() {
          _bottomNavIndex = index;
        });
      }
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
