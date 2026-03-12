import 'package:cpy_app/utils/colors/light_colors.dart';
import 'package:cpy_app/utils/dimensions/fontsizes.dart';
import 'package:cpy_app/utils/icons/myIcon.dart';
import 'package:cpy_app/utils/icons/my_icons.dart';
import 'package:flutter/material.dart';

import '../../../utils/globals.dart';
import '../data/notification_model.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.notificationModel, required this.onTap, required this.timeAgo});

  final NotificationModel notificationModel;
  final Function() onTap;
  final String timeAgo;

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: EdgeInsets.symmetric(vertical: context.screenSize.width * .020),
            child: Row(
              mainAxisSize:MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: primary.withOpacity(.3),
                        child: const MyIcon(size: 22, icon: MyIcons.notificationIcon, color: Colors.white)
                    ),


                    SizedBox(width: context.screenSize.width *.040),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(
                          width: context.screenSize.width * .45,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              notificationModel.title ?? 'No info',
                              style: TextStyle(
                                  color: dark,
                                  fontFamily: 'Poppins',
                                  fontSize: fontSizes.font13(context.screenSize)
                              )
                          ),
                        ),

                        SizedBox(height: context.screenSize.width *.025),

                        SizedBox(
                          width: context.screenSize.width * .40,
                          child: Text(
                              notificationModel.description ?? "Nothing",
                              maxLines: 1,

                              style: TextStyle(
                                  color: tColorLight,
                                  fontFamily: 'Poppins',
                                  fontSize: fontSizes.font12(context.screenSize),
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        ),

                        SizedBox(height: context.screenSize.width * .030),

                      ],
                    ),
                  ],
                ),

                Text(
                    timeAgo,
                    style: TextStyle(
                        color: dark,
                        fontFamily: 'Poppins',
                        fontSize: fontSizes.font11(context.screenSize),
                        fontWeight: FontWeight.w300
                    )
                ),
              ],

            ),
          ),


          Divider(color: Colors.black54.withOpacity(0.04)),

        ],
      ),
    );
  }
}
