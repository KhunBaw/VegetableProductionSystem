import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_plots/components/current_v_item.dart';
import 'package:vegetable_plots/components/sidemenu.dart';
import 'package:vegetable_plots/providers/grow_provider.dart';

class Current_v_List extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ผักที่ปลูกปัจจุบัน",
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
        },
        child: NikuStack(
          [
            SvgPicture.asset(
              'assets/svg_image1.svg',
              fit: BoxFit.fitWidth,
            ).niku().positioned(bottom: 0),
            NikuColumn(
              [
                NikuStack([
                  Text('ชื้อผัก')
                      .asNiku()
                      .fontSize(16)
                      .color(Colors.blue)
                      .fontWeight(FontWeight.bold)
                      .niku()
                      .positioned(top: 10, left: 90),
                  Text('จำนวน')
                      .asNiku()
                      .fontSize(16)
                      .color(Colors.blue)
                      .fontWeight(FontWeight.bold)
                      .niku()
                      .positioned(top: 10, left: 200),
                  Text('น้ำหนัก')
                      .asNiku()
                      .fontSize(16)
                      .color(Colors.blue)
                      .fontWeight(FontWeight.bold)
                      .niku()
                      .positioned(top: 10, left: 290),
                ])
                    .niku()
                    .boxDecoration(BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                    ))
                    .mb(15)
                    .width(double.infinity)
                    .height(60),
                Consumer(
                    builder: (BuildContext context, Grows grows, Widget child) {
                  show() {
                    List<dynamic> vName = [];
                    grows.items.forEach((element) {
                      if (vName.any((x) => x['vName'] == element.vName)) {
                        for (var i = 0; i < vName.length; i++) {
                          if (vName[i]['vName'] == element.vName) {
                            vName[i]['number'] += element.number;
                          }
                        }
                      } else {
                        vName.add({
                          'vName': element.vName,
                          'number': element.number,
                          'url': '',
                          'weight': 0.0,
                        });
                      }
                    });
                    grows.items_v.forEach((element) {
                      if (vName.any((x) => x['vName'] == element.vName)) {
                        for (var i = 0; i < vName.length; i++) {
                          if (vName[i]['vName'] == element.vName) {
                            vName[i]['url'] = element.vPhoto;
                            vName[i]['weight'] =
                                (element.vNfv * vName[i]['number']) / 1000;
                          }
                        }
                      }
                    });
                    return vName;
                  }

                  List<dynamic> items = show();
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        return Current_v_Item(
                            items[i]['vName'],
                            items[i]['url'],
                            items[i]['number'],
                            items[i]['weight']);
                      }).niku().expanded();
                }),
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
  }
}
