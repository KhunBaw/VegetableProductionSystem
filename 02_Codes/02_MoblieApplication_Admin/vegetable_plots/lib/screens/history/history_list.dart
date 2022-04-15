import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_plots/components/history_item.dart';
import 'package:vegetable_plots/components/sidemenu.dart';
import 'package:vegetable_plots/providers/history_provider.dart';

class History_List extends StatefulWidget {
  @override
  _History_ListState createState() => _History_ListState();
}

class _History_ListState extends State<History_List> {
  @override
  void initState() {
    super.initState();
    Provider.of<Historys>(context, listen: false).loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, Historys grows, Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "ประวัติการปลูกผัก",
              style: GoogleFonts.mali(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
              Provider.of<Historys>(context, listen: false).loadHistory();
            },
            child: NikuStack(
              [
                SvgPicture.asset(
                  'assets/svg_image1.svg',
                  fit: BoxFit.fitWidth,
                ).niku().positioned(bottom: 0),
                NikuColumn(
                  [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: grows.items?.length ?? 1,
                      itemBuilder: (context, i) {
                        return History_Item(
                          grows.items[i]?.pdId,
                          grows.items[i]?.pdD,
                          grows.items[i]?.pdD1,
                          grows.items[i]?.cD3,
                          grows.items[i]?.vName,
                          grows.items[i]?.number,
                          grows.items[i]?.weight,
                          grows.items[i]?.area,
                          grows.items[i]?.orderId,
                          grows.items[i]?.areaId,
                        );
                      },
                    ).niku()
                      ..expanded(),
                  ],
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
      },
    );
  }
}
