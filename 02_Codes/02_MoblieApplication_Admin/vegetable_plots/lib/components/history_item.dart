import 'package:flutter/material.dart';
import 'package:niku/niku.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vegetable_plots/models/grow.dart';
import 'package:vegetable_plots/screens/history/history_detail.dart';

class History_Item extends StatefulWidget {
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

  const History_Item(this.pd_id, this.pd_d, this.pd_d1, this.c_d3, this.v_name,
      this.number, this.weight, this.area, this.order_id, this.area_id);

  @override
  _History_ItemState createState() => _History_ItemState();
}

class _History_ItemState extends State<History_Item> {
  String area_show = '';
  String order_id_show = '';
  @override
  void initState() {
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
          bottomRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryDetail(
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
                      alignment: TimelineAlign.manual,
                      lineXY: 0.3,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        height: 20,
                        color:
                            widget.pd_d >= 1 ? Colors.lightGreen : Colors.blue,
                      ),
                      beforeLineStyle: LineStyle(
                        color: Colors.lightGreen,
                        thickness: widget.pd_d > 1 ? 6 : 0,
                      ),
                      endChild: Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('เพาะ').asNiku().color(Colors.blue),
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.horizontal,
                      alignment: TimelineAlign.manual,
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
                        height: 20,
                        color:
                            widget.pd_d >= 2 ? Colors.lightGreen : Colors.blue,
                      ),
                      endChild:
                          Text('ย้าย').asNiku().color(Colors.blue).niku().mt(3),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.horizontal,
                      alignment: TimelineAlign.manual,
                      lineXY: 0.3,
                      isLast: true,
                      beforeLineStyle: LineStyle(
                        color: Colors.lightGreen,
                        thickness: widget.pd_d > 2 ? 6 : 0,
                      ),
                      indicatorStyle: IndicatorStyle(
                        height: 20,
                        color:
                            widget.pd_d >= 3 ? Colors.lightGreen : Colors.blue,
                      ),
                      endChild: Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('เก็บ').asNiku().color(Colors.blue),
                      ),
                    ),
                  ],
                ).niku()
                  ..container()
                  ..constraints(BoxConstraints(maxHeight: 50)),
              ),
              NikuRow([
                Text('หมายเลขปลูก : ')
                    .asNiku()
                    .fontWeight(FontWeight.bold)
                    .color(Colors.blue),
                Text('${widget.pd_id}').asNiku().color(Colors.blue),
              ]),
              NikuRow([
                Text('คำสั่งซื้อ : ')
                    .asNiku()
                    .fontWeight(FontWeight.bold)
                    .color(Colors.blue),
                Text('$order_id_show').asNiku().color(Colors.blue).fontSize(14),
              ]).niku().mt(5),
              NikuRow(
                [
                  Icon(
                    Icons.date_range,
                    color: Colors.blue,
                  ),
                  Text(widget.pd_d1 + ' ')
                      .asNiku()
                      .color(Colors.blue)
                      .niku()
                      .pb(3)
                      .ml(3),
                  Icon(
                    Icons.event_available,
                    color: Colors.blue,
                  ),
                  Text(
                    widget.c_d3,
                  ).asNiku().color(Colors.blue).niku().pb(3).ml(3),
                ],
              ).niku().pt(3),
              NikuRow(
                [
                  Icon(Icons.location_on, color: Colors.redAccent[400]),
                  Text(area_show)
                      .asNiku()
                      .color(Colors.blue)
                      .niku()
                      .pb(4)
                      .ml(3),
                ],
              ),
              NikuRow(
                [
                  Icon(Icons.grass, color: Colors.green),
                  Text('${widget.v_name} : ${widget.number} ต้น : ${widget.weight.toStringAsFixed(1)} Kg')
                      .asNiku()
                      .color(Colors.blue)
                      .niku()
                      .pb(1)
                      .ml(3)
                ],
              ),
            ],
          ),
        ).niku().p(10),
      ),
    ).niku().ml(3).mr(3).mt(3);
  }
}
