import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_plots/components/order_item.dart';
import 'package:vegetable_plots/components/sidemenu.dart';
import 'package:vegetable_plots/providers/area_provider.dart';
import 'package:vegetable_plots/providers/grow_provider.dart';
import 'package:vegetable_plots/providers/order_provider.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.show(status: 'กำลังโหลด...');
    Provider.of<Orders>(context, listen: false).loadOrder();
    Provider.of<Grows>(context, listen: false).loadGrow();
    Provider.of<Areas>(context, listen: false).loadArea();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, Orders orders, Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "คำสั่งซื้อ",
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
                Provider.of<Orders>(context, listen: false).loadOrder();
              },
              child: NikuStack(
                [
                  SvgPicture.asset(
                    'assets/svg_image1.svg',
                    fit: BoxFit.fitWidth,
                  ).niku()
                    ..positioned(bottom: 0),
                  NikuColumn([
                    Niku(
                      NikuStack(
                        [
                          Text('รหัส')
                              .asNiku()
                              .fontWeight(FontWeight.bold)
                              .color(Colors.blue)
                              .niku()
                                ..positioned(left: 65, top: 5),
                          Text('ชื้อผัก')
                              .asNiku()
                              .fontWeight(FontWeight.bold)
                              .color(Colors.blue)
                              .ml(40)
                              .niku()
                                ..positioned(left: 140, top: 5),
                          Text('น้ำหนัก')
                              .asNiku()
                              .color(Colors.blue)
                              .fontWeight(FontWeight.bold)
                              .niku()
                                ..positioned(left: 315, top: 5),
                        ],
                      ).niku().pt(10).boxDecoration(BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                            ),
                          )),
                    ).niku().height(50).mb(5),
                    ListView.builder(
                      itemCount: orders.items?.length ?? 0,
                      itemBuilder: (context, i) {
                        return Order_Item(orders.items[i]);
                      },
                    ).niku().expanded(),
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
                  )),
          drawer: SideMenu(),
        );
      },
    );
  }
}
