import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_plots/components/grow_item.dart';
import 'package:vegetable_plots/components/sidemenu.dart';
import '../../providers/grow_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GrowList extends StatefulWidget {
  @override
  _GrowListState createState() => _GrowListState();
}

class _GrowListState extends State<GrowList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.show(status: 'กำลังโหลด...');
    Provider.of<Grows>(context, listen: false).loadGrow();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, Grows grows, Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "บันทึกการปลูกผัก",
              style: GoogleFonts.mali(
                textStyle: TextStyle(
                  fontSize: 18.sp,
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
              Provider.of<Grows>(context, listen: false).loadGrow();
            },
            child: NikuStack(
              [
                SvgPicture.asset(
                  'assets/svg_image1.svg',
                ).niku().width(411.w).height(820.h)
                  ..positioned(top: 242.h),
                NikuColumn(
                  [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: grows.items?.length + 1 ?? 1,
                      itemBuilder: (context, i) {
                        return grows.items?.length != i
                            ? Grow_Item(
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
                              )
                            : Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30.0),
                                    topLeft: Radius.circular(30.0),
                                  ),
                                ),
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(30.0),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/HOME/ADD');
                                  },
                                  child: Niku(
                                    Icon(
                                      Icons.control_point,
                                      size: 50.0.sp,
                                      color: Colors.blue,
                                    ),
                                  ).niku().p(10.w),
                                ),
                              ).niku().ml(3.w).mr(3.w).mt(3.h);
                      },
                    ).niku()
                      ..expanded(),
                  ],
                ),
              ],
            ).center().niku().width(411.w).boxDecoration(
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
