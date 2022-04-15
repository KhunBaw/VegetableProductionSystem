import 'package:flutter/material.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vegetable_plots/models/area.dart';
import 'package:vegetable_plots/providers/grow_provider.dart';

class Area_Item extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final Area area_items;

  Area_Item(this.area_items);

  @override
  _Area_ItemState createState() => _Area_ItemState();
}

class _Area_ItemState extends State<Area_Item> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      color:
          widget.area_items.status == false ? Colors.white : Colors.redAccent,
      child: InkWell(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
        onTap: () {
          Alert(
            context: context,
            type: AlertType.none,
            title: "${widget.area_items.areaName}",
            content: Niku(
              NikuColumn(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ยาว').asNiku().color(Colors.blue).fontSize(16),
                      Text('${widget.area_items.areaLong}')
                          .asNiku()
                          .color(Colors.blue)
                          .fontSize(14)
                          .niku()
                          .mr(30),
                    ],
                  ).niku().mt(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('กว้าง').asNiku().color(Colors.blue).fontSize(16),
                      Text('${widget.area_items.areaWide}')
                          .asNiku()
                          .color(Colors.blue)
                          .fontSize(14)
                          .niku()
                          .mr(30),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.area_items.status == false
                              ? 'ผักปลูกล่าสุด '
                              : 'ผักที่กำลังปลูก ')
                          .asNiku()
                          .color(Colors.blue)
                          .fontSize(16),
                      Text(widget.area_items.areaVName == ''
                              ? '-'
                              : '${widget.area_items.areaVName}')
                          .asNiku()
                          .color(Colors.blue)
                          .fontSize(14)
                          .niku()
                          .mr(30),
                    ],
                  ),
                  Text('จำนวนผักที่ปลูกได้')
                      .asNiku()
                      .color(Colors.blue)
                      .fontSize(18)
                      .niku()
                      .mt(10),
                  Consumer(builder:
                      (BuildContext context, Grows valueV, Widget child) {
                    show(double vLong, double vWide) {
                      return ((widget.area_items.areaLong *
                                  widget.area_items.areaWide) ~/
                              (vLong * vWide))
                          .toInt();
                    }

                    return ListView.builder(
                            shrinkWrap: true,
                            itemCount: valueV.items_v?.length,
                            itemBuilder: (context, i) {
                              return NikuRow([
                                Text(valueV.items_v[i].vName)
                                    .asNiku()
                                    .color(Colors.blue)
                                    .fontSize(18),
                                Text('${show(valueV.items_v[i].vLong, valueV.items_v[i].vWide)} ต้น ${((show(valueV.items_v[i].vLong, valueV.items_v[i].vWide) * valueV.items_v[i].vNfv) / 1000).toStringAsFixed(1)} kg')
                                    .asNiku()
                                    .color(Colors.blue)
                                    .fontSize(18)
                              ]).mainAxisAlignment(
                                  MainAxisAlignment.spaceBetween);
                            })
                        .niku()
                        .height(MediaQuery.of(context).size.height - 600)
                        .width(MediaQuery.of(context).size.width);
                  })
                ],
              ),
            ).mt(5),
            buttons: [
              DialogButton(
                child: Text(
                  "ปิด",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(116, 116, 191, 1.0),
                  Color.fromRGBO(52, 138, 199, 1.0)
                ]),
              )
            ],
          ).show();
        },
        child: NikuRow(
          [
            Text('${widget.area_items.areaName}')
                .asNiku()
                .color(
                  widget.area_items.status == false
                      ? Colors.black
                      : Colors.white,
                )
                .fontWeight(FontWeight.bold)
          ],
        )
            .mainAxisAlignment(MainAxisAlignment.center)
            .niku()
            .center()
            .height(40),
      ).niku().width(MediaQuery.of(context).size.width),
    );
  }
}
