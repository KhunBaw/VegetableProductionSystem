import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:niku/niku.dart';
import 'package:smart_select/smart_select.dart';
import 'package:vegetable_plots/models/area.dart';
import 'package:vegetable_plots/models/order.dart';
import 'package:vegetable_plots/providers/area_provider.dart';
import 'package:vegetable_plots/providers/grow_provider.dart';

class Order_Item extends StatelessWidget {
  final Order order_item;

  Order_Item(this.order_item);

  String stringNewvName(List<Vegetable> items) {
    String string = '';
    items.forEach((element) {
      if (string == '')
        string = '${element.vName}';
      else
        string = string + '\n${element.vName}';
    });
    return string;
  }

  String stringNewWeight(List<Vegetable> items) {
    String string = '';
    items.forEach((element) {
      if (string == '')
        string = '${element.weight} ${element.unitEng}';
      else
        string = string + '\n${element.weight} ${element.unitEng}';
    });
    return string;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, Grows valueV, Widget child) {
      show() {
        List<String> arealist = [];
        List<String> arealist_s = [];
        String cd_3 = '';
        String string = '';

        if (order_item.status == 'start')
          order_item.vegetable.forEach((element) {
            if (string == '')
              string =
                  '${element.vName} : ${element.weight} ${element.unitEng}';
            else
              string = string +
                  '\n${element.vName} : ${element.weight} ${element.unitEng}';
          });

        valueV.items.forEach((element) {
          if (element.orderId.contains(order_item.orderId)) {
            cd_3 = element.cD3;
            if (order_item.status != 'start') {
              arealist.addAll(element.areaId);
            }
            order_item.vegetable.forEach((element2) {
              if (string == '')
                string =
                    '${element2.vName} : ${element2.weight} ${element2.unitEng} (ปลูกไปแล้ว ${element.weight} kg)';
              else
                string = string +
                    '\n${element2.vName} : ${element2.weight} ${element2.unitEng} (ปลูกไปแล้ว ${element.weight} kg)';
            });
          }
        });

        if (arealist.isNotEmpty) {
          List<Area> area = Provider.of<Areas>(context, listen: false).items;
          area.forEach((element) {
            if (arealist.contains(element.areaId)) {
              arealist_s.add(element.areaName);
            }
          });
        }

        String arealist_ss = '';
        if (arealist_s.isNotEmpty) {
          arealist_ss = arealist_s.reduce((x, y) => '$x,$y');
        }
        return {
          'arealist': arealist_ss,
          'cd_3': cd_3,
          'stringNewVW': string,
        };
      }

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        color: order_item.status == 'start'
            ? Colors.white
            : order_item.status == 'progress'
                ? Colors.amber[700]
                : order_item.status == 'final'
                    ? Colors.lightGreen
                    : Colors.redAccent,
        child: InkWell(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
          onTap: () {
            Alert(
              context: context,
              type: AlertType.none,
              style: AlertStyle(
                titleStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
              title: "${order_item.orderId}",
              content: Niku(
                NikuColumn(
                  [
                    NikuRow(
                      [
                        Text('ชื่อ : ')
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(16),
                        Text(order_item.od.name)
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(14),
                      ],
                    ),
                    NikuRow(
                      [
                        Text(
                          'ที่อยู่ : ',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ).asNiku().color(Colors.blue).fontSize(16),
                        Text(order_item.od.address)
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(12)
                            .maxLines(1)
                            .softWrap(false)
                            .overflow(TextOverflow.fade)
                            .niku()
                            .flexible(),
                      ],
                    ),
                    NikuRow(
                      [
                        Text('ช่องทางติดต่อ : ')
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(16),
                        Text(order_item.od.phnum)
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(14),
                      ],
                    ),
                    if (order_item.status != 'final')
                      NikuColumn([
                        SizedBox(
                          height: 10,
                        ),
                        Text('ออเดอร์')
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(16),
                        Text('${show()['stringNewVW']}')
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(14)
                            .niku()
                            .mt(5),
                      ]),
                    SizedBox(
                      height: 10,
                    ),
                    NikuRow(
                      [
                        Text('วันรับผัก : ')
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(16),
                        Text(order_item.dateFinal)
                            .asNiku()
                            .color(Colors.blue)
                            .fontSize(14),
                      ],
                    ),
                    if (order_item.status != 'start' &&
                        order_item.status != 'final')
                      NikuColumn([
                        NikuRow(
                          [
                            Text('ได้รับผักประมาณ : ')
                                .asNiku()
                                .color(Colors.blue)
                                .fontSize(16),
                            Text('${show()['cd_3']}')
                                .asNiku()
                                .color(Colors.blue)
                                .fontSize(14),
                          ],
                        ),
                        NikuRow(
                          [
                            Text('พื้นที่ปลูก : ')
                                .asNiku()
                                .color(Colors.blue)
                                .fontSize(16),
                            Text('${show()['arealist']}')
                                .asNiku()
                                .color(Colors.blue)
                                .fontSize(14),
                          ],
                        ),
                      ]),
                  ],
                ),
              ).mt(10),
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
          child: NikuStack(
            [
              Text(order_item.orderId)
                  .asNiku()
                  .fontWeight(FontWeight.bold)
                  .color(
                    order_item.status != 'start' ? Colors.white : Colors.blue,
                  )
                  .niku()
                  .pt(15)
                    ..positioned(left: 20),
              Text(stringNewvName(order_item.vegetable))
                  .asNiku()
                  .fontWeight(FontWeight.bold)
                  .color(
                      order_item.status != 'start' ? Colors.white : Colors.blue)
                  .niku()
                  .pt(15)
                    ..positioned(left: 170),
              Text(stringNewWeight(order_item.vegetable))
                  .asNiku()
                  .fontWeight(FontWeight.bold)
                  .color(
                      order_item.status != 'start' ? Colors.white : Colors.blue)
                  .niku()
                  .pt(15)
                    ..positioned(left: 300),
            ],
          ).niku(),
        ).niku().height(order_item.vegetable.length > 1
            ? 50 + (order_item.vegetable.length * 10).toDouble()
            : 50),
      ).niku().ml(5).mr(5);
    });
  }
}
