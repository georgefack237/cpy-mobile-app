import 'package:cpy_app/features/notifications/providers/notifications_provider.dart';
import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/notification_item.dart';
import 'package:timeago/timeago.dart' as timeago;


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {


  @override
  void initState() {
    final provider = Provider.of<NotificationsProvider>(context, listen: false);
    provider.getNotifications(context: context);
    super.initState();
  }

 bool loading = false;
 String message = '';

  String convertToTimeAgo(String timestampString) {
    // Enregistrer les messages français (à faire une seule fois, idéalement dans main() ou initState)
    timeago.setLocaleMessages('fr', timeago.FrMessages());

    // Parser la chaîne de timestamp en DateTime
    DateTime dateTime = DateTime.parse(timestampString);

    // Convertir en time ago avec locale français
    return timeago.format(dateTime, locale: 'fr');
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
              "Notifications",
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


      body: !loading ? buildContent() : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),

            SizedBox(height: 30),

            if(message.isNotEmpty)
            Text(message, style: const TextStyle(color: Colors.black, fontSize: 12))
          ],
        )
      ),

    );
  }


  Widget buildContent() {
    return Consumer<NotificationsProvider>(
        builder: (context, provider, child) {

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {

          }

          return provider.notifications != null ? Column(
            children: [

              Expanded(
                child: ListView.builder(
                    padding:  EdgeInsets.symmetric(horizontal: appPadding.padH16(context.screenSize)),
                    itemCount: provider.notifications!.length,
                    itemBuilder: (context, index) {
                      var notification = provider.notifications![index];
                      return NotificationItem(
                        notificationModel: notification,
                        onTap: () {


                         /*
                          if(notification.type == 'poems'){

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>  PoemDetailPage(id: notification.itemId!, title: notification.title!)));

                          }else if(notification.type == 'songs'){

                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>  HymnSongDetailsPage(songId: notification.itemId!, hymnSong: null,)));

                          }else if(notification.type == 'medias'){

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>  const MediaPage()));

                          } else{

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>  const StrongPage()));

                          } */



                        }, timeAgo: convertToTimeAgo(notification.createdAt!));
                    }),
              )
            ],
          ):

          provider.isLoading ? const Expanded(child: Center(child: CircularProgressIndicator())) : provider.error != null ? Center(child: Text(provider.error!)): const SizedBox();
        });

  }
}







