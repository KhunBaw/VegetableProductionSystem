import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_plots/components/area_item.dart';
import 'package:vegetable_plots/components/sidemenu.dart';
import 'package:vegetable_plots/providers/area_provider.dart';

class AreaList extends StatefulWidget {
  @override
  _AreaListState createState() => _AreaListState();
}

class _AreaListState extends State<AreaList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.show(status: 'กำลังโหลด...');
    Provider.of<Areas>(context, listen: false).loadArea();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, Areas areas, Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "พื้นที่",
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
              Provider.of<Areas>(context, listen: false).loadArea();
            },
            child: NikuStack(
              [
                SvgPicture.asset(
                  'assets/svg_image1.svg',
                  fit: BoxFit.fitWidth,
                ).niku().positioned(bottom: 0),
                NikuColumn([
                  NikuRow(
                    [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      Text('พื้นที่ว่าง')
                          .asNiku()
                          .color(Colors.white)
                          .fontWeight(FontWeight.bold)
                          .niku()
                          .ml(10),
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ).niku().ml(10),
                      Text('พื้นที่ไม่ว่าง')
                          .asNiku()
                          .color(Colors.white)
                          .fontWeight(FontWeight.bold)
                          .niku()
                          .ml(10),
                    ],
                  )
                      .mainAxisAlignment(MainAxisAlignment.center)
                      .niku()
                      .margin(EdgeInsets.fromLTRB(0, 15, 0, 20)),
                  ListView.builder(
                    itemCount: areas.items?.length ?? 0,
                    itemBuilder: (context, i) {
                      return Area_Item(areas.items[i]);
                    },
                  ).niku()
                    ..expanded(),
                ]),
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
