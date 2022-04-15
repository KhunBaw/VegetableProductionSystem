import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_plots/components/sidemenu.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:vegetable_plots/providers/notification_provider.dart';
import '../../models/notification.dart';

class Notification_List extends StatefulWidget {
  @override
  _Notification_ListState createState() => _Notification_ListState();
}

class _Notification_ListState extends State<Notification_List> {
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.show(status: 'กำลังโหลด...');
    Provider.of<Notifications>(context, listen: false).loadNotification();
  }

  getdate(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
    var inputDate = inputFormat.parse('${DateTime.now()}');
    var outputFormat = DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(inputDate);
    var inputFormat2 = DateFormat('yyyy-MM-dd');
    var inputDate2 = inputFormat2.parse(date);
    var outputDate2 = outputFormat.format(inputDate2);
    return outputDate == outputDate2 ? true : false;
  }

  getdate2(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    DateTime inputDate = inputFormat.parse('${date}');

    var fiftyDaysFromNow =
        DateTime(inputDate.year + 543, inputDate.month, inputDate.day);

    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(fiftyDaysFromNow);

    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, Notifications notification, Widget child) {
      return Scaffold(
        backgroundColor: Colors.blue[400],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "การแจ้งเตือน",
            style: GoogleFonts.mali(
                textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
          ),
          flexibleSpace: Niku().boxDecoration(
            BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Colors.blue[300],
              ], begin: Alignment.topRight, end: Alignment.bottomLeft),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            Provider.of<Notifications>(context, listen: false)
                .loadNotification();
          },
          child: NikuStack(
            [
              SvgPicture.asset(
                'assets/svg_image1.svg',
                fit: BoxFit.fitWidth,
              ).niku().positioned(bottom: 0),
              GroupedListView<Notificationss, String>(
                elements: notification.items,
                groupBy: (element) => element.date,
                groupSeparatorBuilder: (String groupByValue) => Text(
                        getdate(groupByValue)
                            ? 'วันนี้'
                            : getdate2(groupByValue))
                    .asNiku()
                    .center()
                    .fontSize(16)
                    .fontWeight(FontWeight.bold)
                    .color(Colors.white)
                    .niku()
                    .p(8)
                    .pl(10)
                    .pr(10)
                    .boxDecoration(BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(20)))
                    .mt(10)
                    .mb(5)
                    .ml(30)
                    .mr(30),

                itemBuilder: (context, Notificationss element) {
                  return Card(
                    elevation: 8.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Niku(
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        // leading: Icon(
                        //   Icons.account_circle,
                        //   size: 40,
                        // ),
                        title: Text(element.title),
                        subtitle: Text(element.subtitle),
                        trailing: Text(element.time),
                      ),
                    ),
                  );
                },
                itemComparator: (item1, item2) =>
                    item1.time.compareTo(item2.time), // optional
                useStickyGroupSeparators: true, // optional
                floatingHeader: true, // optional
                order: GroupedListOrder.ASC, // optional
              ),
            ],
          ).center().niku().boxDecoration(
                BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.blue[300],
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
        ),
        drawer: SideMenu(),
      );
    });
  }
}
