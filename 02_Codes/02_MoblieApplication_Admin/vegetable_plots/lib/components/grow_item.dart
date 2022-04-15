// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:niku/niku.dart';
import 'package:vegetable_plots/models/grow.dart';
import 'package:vegetable_plots/screens/grow/grow_detail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Grow_Item extends StatefulWidget {
  final String pd_id;
  final int pd_d;
  final String pd_d1;
  final String c_d3;
  final String v_name;
  final int number;
  final double weight;
  final List<AreaIN> area;
  final List<String> order_id;
  final List<String> area_id;

  Grow_Item(this.pd_id, this.pd_d, this.pd_d1, this.c_d3, this.v_name,
      this.number, this.weight, this.area, this.order_id, this.area_id);

  @override
  _Grow_ItemState createState() => _Grow_ItemState();
}

class _Grow_ItemState extends State<Grow_Item> {
  String area_show = '';
  String order_id_show = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var i = 0; i < widget.area.length; i++) {
      if (widget.area.length > 0 && widget.area.length - 1 > i) {
        area_show = area_show + widget.area[i].areaName + ',';
      } else {
        area_show = area_show + widget.area[i].areaName;
      }
    }

    for (var i = 0; i < widget.order_id.length; i++) {
      if (widget.order_id.length > 0 && widget.order_id.length - 1 > i) {
        order_id_show = order_id_show + widget.order_id[i] + ',';
      } else {
        order_id_show = order_id_show + widget.order_id[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0.r),
          topLeft: Radius.circular(30.0.r),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0.r),
          topLeft: Radius.circular(30.0.r),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CareDetail(
                    widget.pd_id,
                    widget.pd_d,
                    widget.pd_d1,
                    widget.c_d3,
                    widget.v_name,
                    widget.number,
                    widget.weight,
                    widget.area,
                    widget.order_id,
                    widget.area_id,
                    order_id_show,
                    area_show)),
          );
        },
        child: Niku(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    TimelineTile(
                      axis: TimelineAxis.horizontal,
                      alignment: TimelineAlign.start,
                      lineXY: 0.3,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        height: 20.h,
                        color:
                            widget.pd_d >= 1 ? Colors.lightGreen : Colors.blue,
                      ),
                      beforeLineStyle: LineStyle(
                        color: Colors.lightGreen,
                        thickness: widget.pd_d > 1 ? 6 : 0,
                      ),
                      endChild: Container(
                        margin: EdgeInsets.only(top: 3.h),
                        child: Text('เพาะ')
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(14.sp)
                            .ml(49.w),
                        constraints: BoxConstraints(
                          minWidth: 120.w,
                        ),
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.horizontal,
                      alignment: TimelineAlign.start,
                      lineXY: 0.3,
                      beforeLineStyle: LineStyle(
                        color: Colors.lightGreen,
                        thickness: widget.pd_d > 1 ? 6 : 0,
                      ),
                      afterLineStyle: LineStyle(
                        color: Colors.lightGreen,
                        thickness: widget.pd_d > 2 ? 6 : 0,
                      ),
                      indicatorStyle: IndicatorStyle(
                        height: 20.h,
                        color:
                            widget.pd_d >= 2 ? Colors.lightGreen : Colors.blue,
                      ),
                      endChild: Container(
                        margin: EdgeInsets.only(top: 3.h),
                        child: Text('ย้าย')
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(14.sp)
                            .ml(49.w),
                        constraints: BoxConstraints(
                          minWidth: 120.w,
                        ),
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.horizontal,
                      alignment: TimelineAlign.start,
                      lineXY: 0.3,
                      isLast: true,
                      beforeLineStyle: LineStyle(
                        color: Colors.lightGreen,
                        thickness: widget.pd_d > 2 ? 6 : 0,
                      ),
                      indicatorStyle: IndicatorStyle(
                        height: 20.h,
                        color:
                            widget.pd_d >= 3 ? Colors.lightGreen : Colors.blue,
                      ),
                      endChild: Container(
                        margin: EdgeInsets.only(top: 3.h),
                        child: Container(
                          margin: EdgeInsets.only(top: 3.h),
                          child: Text('เก็บ')
                              .asNiku()
                              .color(Colors.blue)
                              .fontSize(14.sp)
                              .ml(49.w),
                          constraints: BoxConstraints(
                            minWidth: 120.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ).niku()
                  ..constraints(
                      BoxConstraints(maxHeight: 50.h, maxWidth: 411.w)),
              ),
              NikuRow([
                Text('หมายเลขปลูก : ')
                    .asNiku()
                    .fontWeight(FontWeight.bold)
                    .color(Colors.blue)
                    .fontSize(14.sp),
                Text('${widget.pd_id}')
                    .asNiku()
                    .color(Colors.blue)
                    .fontSize(14.sp),
              ]),
              NikuRow([
                Text('คำสั่งซื้อ : ')
                    .asNiku()
                    .fontWeight(FontWeight.bold)
                    .color(Colors.blue)
                    .fontSize(14.sp),
                Text('$order_id_show')
                    .asNiku()
                    .color(Colors.blue)
                    .fontSize(14.sp),
              ]).niku().mt(5.h),
              NikuRow(
                [
                  Icon(
                    Icons.date_range,
                    color: Colors.blue,
                    size: 24.sp,
                  ),
                  Text(widget.pd_d1 + ' ')
                      .asNiku()
                      .color(Colors.blue)
                      .fontSize(14.sp)
                      .niku()
                      .pb(3.h)
                      .ml(3.w),
                  Icon(
                    Icons.event_available,
                    color: Colors.blue,
                    size: 24.sp,
                  ),
                  Text(
                    widget.c_d3,
                  )
                      .asNiku()
                      .fontSize(14.sp)
                      .color(Colors.blue)
                      .niku()
                      .pb(3.h)
                      .ml(3.w),
                ],
              ).niku().pt(3.h),
              NikuRow(
                [
                  Icon(
                    Icons.location_on,
                    color: Colors.redAccent[400],
                    size: 24.sp,
                  ),
                  Text(area_show)
                      .asNiku()
                      .color(Colors.blue)
                      .fontSize(14.sp)
                      .niku()
                      .pb(4.h)
                      .ml(3.w),
                ],
              ),
              NikuRow(
                [
                  Icon(
                    Icons.grass,
                    color: Colors.green,
                    size: 24.sp,
                  ),
                  Text('${widget.v_name} : ${widget.number} ต้น : ${widget.weight.toStringAsFixed(1)} Kg')
                      .asNiku()
                      .color(Colors.blue)
                      .fontSize(14.sp)
                      .niku()
                      .pb(1.h)
                      .ml(3.w)
                ],
              ),
            ],
          ),
        ).niku().p(10.w),
      ),
    ).niku().ml(3.w).mr(3.w).mt(3.h);
  }
}
