import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:vegetable_plots/models/area.dart';
import 'package:vegetable_plots/models/loss.dart';
import 'package:vegetable_plots/models/order.dart';
import 'package:vegetable_plots/models/vegetable_data.dart';
import 'package:vegetable_plots/providers/area_provider.dart';
import 'package:vegetable_plots/providers/grow_provider.dart';
import 'package:vegetable_plots/providers/order_provider.dart';
import 'package:niku/niku.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainAdd extends StatefulWidget {
  @override
  _MainAddState createState() => _MainAddState();
}

class _MainAddState extends State<MainAdd> {
  String vegetable = '';
  List<String> l_vegetable = [];
  List<String> area = [];
  List<String> order = [];
  List<String> area_n = [];
  double v_nfv = 0;
  double number = 0;
  double v_sq_m = 0;
  int r_number = 0;
  int area_tn = 0;
  TextEditingController numberController = TextEditingController()..text = '0';
  int loss = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<Grows>(context, listen: false).loadGrow();
    Provider.of<Areas>(context, listen: false).loadArea();
    Provider.of<Orders>(context, listen: false).loadOrder();

    http.get(
      Uri.parse(dotenv.env['api_url'] + 'vegetable_loss'), //Edit url
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-type": "application/json",
        // // Authorize Header
        // "Authorization": "bearer $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        //Code for status 200
        loss = lossFromJson(response.body).loss;
      } else {
        EasyLoading.showError('Error');
        throw Exception('Failed to load vegetable_loss');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "เพิ่มการปลูก",
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
      body: NikuStack(
        [
          SvgPicture.asset(
            'assets/svg_image1.svg',
            fit: BoxFit.fitWidth,
          ).niku().positioned(bottom: 0),
          ListView(
            children: [
              Form(
                child: NikuColumn(
                  [
                    Consumer(
                      builder:
                          (BuildContext context, Grows valueV, Widget child) {
                        return NikuColumn(
                          [
                            Consumer(
                              builder: (BuildContext context, Orders valueOrder,
                                  Widget child) {
                                // ignore: unused_element
                                vegetBy(List<String> value) {
                                  List<Order> vOrder = [];
                                  value.forEach((element) {
                                    valueOrder.items.forEach((element2) {
                                      if (element == element2.orderId) {
                                        vOrder.add(element2);
                                      }
                                    });
                                  });

                                  List<String> chveget = [];
                                  int chveget2 = 0;
                                  if (vOrder.length > 1) {
                                    for (var i = 0;
                                        i < vOrder.length - 1;
                                        i++) {
                                      for (var x = 0;
                                          x < vOrder[i + 1].vegetable.length;
                                          x++) {
                                        if (vOrder[i].vegetable.any((element) =>
                                            element.vId ==
                                            vOrder[i + 1].vegetable[x].vId)) {
                                          chveget2++;
                                          if (!chveget.contains(
                                              vOrder[i + 1].vegetable[x].vId)) {
                                            chveget.add(
                                                vOrder[i + 1].vegetable[x].vId);
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    if (!vOrder.isEmpty) {
                                      vOrder.first.vegetable.forEach((element) {
                                        chveget.add(element.vId);
                                      });
                                    }
                                  }

                                  Map<dynamic, dynamic> map2 = {};
                                  if (chveget2 == vOrder.length - 1) {
                                    map2 = {'status': true, 'chveget': chveget};
                                  } else {
                                    map2 = {'status': false, 'chveget': []};
                                  }

                                  return map2;
                                }

                                return Consumer(
                                  builder: (BuildContext context, Areas value_a,
                                      Widget child) {
                                    all_number_show() {
                                      int number_f = 0;

                                      order.forEach((element) {
                                        valueV.items.forEach((element2) {
                                          element2.orderId.forEach((element3) {
                                            if (element3 == element) {
                                              //true;
                                              number_f += element2.number;
                                            }
                                          });
                                        });
                                      });

                                      return {
                                        'number_f': number_f,
                                        'number_fKg':
                                            ((v_nfv * number_f) / 1000)
                                                .toStringAsFixed(1),
                                        'r_number': r_number,
                                        'r_numberKg':
                                            ((v_nfv * r_number) / 1000)
                                                .toStringAsFixed(1),
                                        'los_number':
                                            (r_number * (100 / (100 - loss)))
                                                .toInt(),
                                        'los_numberKg': ((v_nfv *
                                                    (r_number *
                                                            (100 /
                                                                (100 - loss)))
                                                        .toInt()) /
                                                1000)
                                            .toStringAsFixed(1),
                                        'rf_number': r_number - number_f,
                                        'rf_numberKg':
                                            ((v_nfv * (r_number - number_f)) /
                                                    1000)
                                                .toStringAsFixed(1),
                                        'rfl_number':
                                            (r_number * (100 / (100 - loss)))
                                                    .toInt() -
                                                number_f,
                                        'rfl_numberKg': ((v_nfv *
                                                    ((r_number *
                                                                (100 /
                                                                    (100 -
                                                                        loss)))
                                                            .toInt() -
                                                        number_f)) /
                                                1000)
                                            .toStringAsFixed(1),
                                        'lr_number':
                                            ((r_number * (100 / (100 - loss)))
                                                        .toInt() -
                                                    number_f) -
                                                number.toInt(),
                                        'lr_numberKg': ((v_nfv *
                                                    (((r_number *
                                                                    (100 /
                                                                        (100 -
                                                                            loss)))
                                                                .toInt() -
                                                            number_f) -
                                                        number.toInt())) /
                                                1000)
                                            .toStringAsFixed(1),
                                        'hr_number': number.toInt() -
                                            ((r_number * (100 / (100 - loss)))
                                                    .toInt() -
                                                number_f),
                                        'hr_numberKg': ((v_nfv *
                                                    (number.toInt() -
                                                        ((r_number *
                                                                    (100 /
                                                                        (100 -
                                                                            loss)))
                                                                .toInt() -
                                                            number_f))) /
                                                1000)
                                            .toStringAsFixed(1),
                                      };
                                    }

                                    vegetable_recommend() {
                                      double number_a = 0;

                                      order.forEach((element) {
                                        valueOrder.items.forEach((element2) {
                                          if (element == element2.orderId) {
                                            element2.vegetable
                                                .forEach((element3) {
                                              if (element3.vId == vegetable) {
                                                if (element3.unitEng == 'kg') {
                                                  number_a += element3.weight
                                                      .toDouble();
                                                }
                                                if (element3.unitEng == 'g') {
                                                  number_a += element3.weight
                                                          .toDouble() /
                                                      1000;
                                                }
                                              }
                                            });
                                          }
                                        });
                                      });

                                      // print(number_a);

                                      for (var i = 0;
                                          i < valueV.items_v.length;
                                          i++) {
                                        if (valueV.items_v[i].vId ==
                                            vegetable) {
                                          v_nfv = valueV.items_v[i].vNfv;
                                          v_sq_m = (valueV.items_v[i].vWide /
                                                  100) *
                                              (valueV.items_v[i].vLong / 100);
                                        }
                                      }

                                      if (number_a > 0 && v_nfv > 0)
                                        r_number =
                                            (number_a / (v_nfv / 1000) + 1)
                                                .toInt();
                                      int rfl_number =
                                          all_number_show()['rfl_number'];
                                      number = rfl_number.toDouble();
                                      numberController.text =
                                          rfl_number.toString();

                                      area_tn = 0;
                                      area_n = [];
                                      area.forEach((element) {
                                        value_a.items.forEach((element2) {
                                          if (element == element2.areaId) {
                                            area_n.add(element2.areaName);
                                            area_tn += (((element2.areaWide ~/
                                                            100) *
                                                        (element2.areaLong ~/
                                                            100)) ~/
                                                    v_sq_m)
                                                .toInt();
                                          }
                                        });
                                      });
                                    }

                                    return NikuColumn(
                                      [
                                        SmartSelect<String>.multiple(
                                          title: 'คำสั่งซื้อ',
                                          placeholder: order.isNotEmpty
                                              ? 'ไม่มีคำสั่งซื้อ'
                                              : 'กรุณาเลือก',
                                          value: order,
                                          modalConfirm: true,
                                          modalValidation: (chosen) {
                                            return chosen.isEmpty
                                                ? 'กรุณาเลือกอย่างน้อย 1 รายการ'
                                                : vegetBy(chosen)['status'] ==
                                                        false
                                                    ? 'กรุณาเลือกชนิดผักให้ตรงกัน'
                                                    : null;
                                          },
                                          choiceTitleBuilder:
                                              (context, state, choice) {
                                            return S2Text(
                                              text: state.title,
                                              style: TextStyle(
                                                color: state.selected
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : null,
                                              ),
                                              highlightColor: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.7),
                                            );
                                          },
                                          tileBuilder: (context, state) {
                                            return S2Tile.fromState(
                                              state,
                                              isTwoLine: true,
                                              leading: Container(
                                                width: 40,
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.shopping_cart,
                                                  color: Colors.orangeAccent,
                                                ),
                                              ),
                                              isLoading: valueOrder.status,
                                              loadingText: 'กำลังโหลด',
                                            );
                                          },
                                          modalFooterBuilder: (context, state) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 7.0,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  TextButton(
                                                    child:
                                                        Text('ไม่มีคำสั่งซื้อ'),
                                                    onPressed: () {
                                                      setState(() {
                                                        order = [
                                                          'ไม่มีคำสั่งซื้อ'
                                                        ];
                                                        r_number = 0;
                                                      });
                                                      state.closeModal(
                                                          confirmed: false);
                                                    },
                                                  ),
                                                  Spacer(),
                                                  TextButton(
                                                    child: Text('ยกเลิก'),
                                                    onPressed: () =>
                                                        state.closeModal(
                                                            confirmed: false),
                                                  ),
                                                  SizedBox(width: 5),
                                                  TextButton.icon(
                                                    icon: Icon(Icons.check),
                                                    label: Text('ยืนยัน')
                                                        .asNiku()
                                                        .color(Colors.white),
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      onSurface: Colors.white,
                                                    ),
                                                    onPressed: () =>
                                                        state.closeModal(
                                                            confirmed: true),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          modalConfig: S2ModalConfig(
                                            style: S2ModalStyle(
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(15.0),
                                                  topRight:
                                                      Radius.circular(15.0),
                                                ),
                                              ),
                                            ),
                                            headerStyle: S2ModalHeaderStyle(
                                              centerTitle: true,
                                            ),
                                          ),
                                          choiceItems:
                                              S2Choice.listFrom<String, Order>(
                                            source: valueOrder?.items,
                                            value: (index, item) =>
                                                item.orderId,
                                            title: (index, item) {
                                              return '${item.orderId} (${item.od.name})';
                                            },
                                            subtitle: (index, item) {
                                              double weight_t = 0;

                                              valueV.items.forEach((element) {
                                                if (item.orderId.contains(
                                                    element.orderId.first)) {
                                                  item.vegetable
                                                      .forEach((element2) {
                                                    if (element.vName ==
                                                        element2.vName) {
                                                      double number_a;
                                                      if (element2.unitEng ==
                                                          'kg') {
                                                        number_a = element2
                                                            .weight
                                                            .toDouble();
                                                      }
                                                      if (element2.unitEng ==
                                                          'g') {
                                                        number_a = element2
                                                                .weight
                                                                .toDouble() /
                                                            1000;
                                                      }

                                                      double vNfv = valueV
                                                          .items_v
                                                          .where((x) =>
                                                              x.vName ==
                                                              element.vName)
                                                          .first
                                                          .vNfv;

                                                      weight_t =
                                                          (element.number *
                                                                  vNfv) /
                                                              1000;
                                                    }
                                                  });
                                                }
                                              });

                                              String string =
                                                  'วันรับผัก : ${item.dateFinal}';

                                              item.vegetable.forEach((element) {
                                                if (string == '')
                                                  string =
                                                      '${element.vName} ${(element.weight - weight_t).toStringAsFixed(1)} ${element.unitEng}/${element.weight.toDouble().toStringAsFixed(1)} ${element.unitEng}';
                                                else
                                                  string = string +
                                                      '\n${element.vName} ${(element.weight - weight_t).toStringAsFixed(1)} ${element.unitEng}/${element.weight.toDouble().toStringAsFixed(1)} ${element.unitEng}';
                                              });
                                              return string;
                                            },
                                            hidden: (index, item) {
                                              bool status = true;
                                              if (item.status == 'start') {
                                                status = false;
                                              } else {
                                                valueV.items.forEach((element) {
                                                  if (item.orderId.contains(
                                                      element.orderId.first)) {
                                                    item.vegetable
                                                        .forEach((element2) {
                                                      if (element.vName ==
                                                          element2.vName) {
                                                        double number_a;
                                                        if (element2.unitEng ==
                                                            'kg') {
                                                          number_a = element2
                                                              .weight
                                                              .toDouble();
                                                        }
                                                        if (element2.unitEng ==
                                                            'g') {
                                                          number_a = element2
                                                                  .weight
                                                                  .toDouble() /
                                                              1000;
                                                        }

                                                        double vNfv = valueV
                                                            .items_v
                                                            .where((x) =>
                                                                x.vName ==
                                                                element.vName)
                                                            .first
                                                            .vNfv;

                                                        if (number_a >
                                                            (element.number *
                                                                    vNfv) /
                                                                1000) {
                                                          status = false;
                                                        }
                                                      }
                                                    });
                                                  }
                                                });
                                              }

                                              return status;
                                            },
                                          ),
                                          onChange: (state) {
                                            Map<dynamic, dynamic> veget =
                                                vegetBy(state.value);
                                            List<dynamic> chveget =
                                                veget['chveget'];

                                            setState(() {
                                              if (veget['status']) {
                                                order = state.value;
                                                order.first == 'ไม่มีคำสั่งซื้อ'
                                                    ? order.removeAt(0)
                                                    : null;
                                                l_vegetable = veget['chveget'];
                                                if (chveget.length == 1) {
                                                  vegetable =
                                                      veget['chveget'].first;
                                                }
                                                if (state.value.length == 0) {
                                                  area = [];
                                                }
                                                vegetable_recommend();
                                              } else {
                                                r_number = 0;
                                                state.value.length > 0
                                                    ? EasyLoading.showError(
                                                        'กรุณาเลือกชนิดผักให้ตรงกัน')
                                                    : null;
                                                vegetable = '';
                                                order = area = [];
                                              }
                                            });
                                          },
                                          modalFilter: true,
                                          modalFilterAuto: true,
                                          modalFilterHint: 'ค้นหา',
                                          modalType: S2ModalType.bottomSheet,
                                        ),
                                        if (order.isNotEmpty &&
                                            order.first != 'ไม่มีคำสั่งซื้อ')
                                          Niku(NikuColumn(
                                            [
                                              Text('ต้องการทั้งหมดโดยประมาณ ${all_number_show()['r_number']} ต้น (${all_number_show()['r_numberKg']} กิโลกรัม)')
                                                  .asNiku()
                                                  .center()
                                                  .fontSize(13)
                                                  .color(Colors.grey[800]),
                                              Text('จำนวนแนะนำการปลูกทั้งหมดเพื่อชดเชยการสูญเสีย ${all_number_show()['los_number']} ต้น (${all_number_show()['los_numberKg']} กิโลกรัม)')
                                                  .asNiku()
                                                  .center()
                                                  .fontSize(13)
                                                  .color(Colors.grey[800]),
                                              Text('ปลูกแล้ว ${all_number_show()['number_f']} ต้น (ประมาณ ${all_number_show()['number_fKg']} กิโลกรัม)')
                                                  .asNiku()
                                                  .center()
                                                  .fontSize(13)
                                                  .color(Colors.grey[800]),
                                            ],
                                          ).m(10))
                                              .boxDecoration(BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black12)),
                                        SmartSelect<String>.single(
                                          title: 'ผักที่ปลูก',
                                          placeholder: 'กรุณาเลือก',
                                          value: vegetable,
                                          modalConfirm: true,
                                          modalValidation: (chosen) {
                                            return chosen.isEmpty
                                                ? 'กรุณาเลือก 1 รายการ'
                                                : null;
                                          },
                                          choiceTitleBuilder:
                                              (context, state, choice) {
                                            return S2Text(
                                              text: state.title,
                                              style: TextStyle(
                                                color: state.selected
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : null,
                                              ),
                                              highlightColor: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.7),
                                            );
                                          },
                                          modalFooterBuilder: (context, state) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 7.0,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Spacer(),
                                                  TextButton(
                                                    child: Text('ยกเลิก'),
                                                    onPressed: () =>
                                                        state.closeModal(
                                                            confirmed: false),
                                                  ),
                                                  SizedBox(width: 5),
                                                  TextButton.icon(
                                                    icon: Icon(Icons.check),
                                                    label: Text('ยืนยัน')
                                                        .asNiku()
                                                        .color(Colors.white),
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      onSurface: Colors.white,
                                                    ),
                                                    onPressed: () =>
                                                        state.closeModal(
                                                            confirmed: true),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          tileBuilder: (context, state) {
                                            return S2Tile.fromState(
                                              state,
                                              isTwoLine: true,
                                              leading: Container(
                                                width: 40,
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.grass,
                                                  color: Colors.green[700],
                                                ),
                                              ),
                                              title: state.titleWidget,
                                              value: state.valueDisplay,
                                              onTap: state.showModal,
                                              isLoading: order.length < 1,
                                              loadingText: 'รอเลือกคำสั่งซื้อ',
                                            );
                                          },
                                          modalConfig: S2ModalConfig(
                                            style: S2ModalStyle(
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(15.0),
                                                  topRight:
                                                      Radius.circular(15.0),
                                                ),
                                              ),
                                            ),
                                            headerStyle: S2ModalHeaderStyle(
                                              centerTitle: true,
                                            ),
                                          ),
                                          choiceConfig: S2ChoiceConfig(
                                            useDivider: true,
                                            overscrollColor: Colors.green,
                                            style: S2ChoiceStyle(
                                              titleStyle: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          // choiceItems: value_v.items_v,
                                          choiceItems: S2Choice.listFrom<String,
                                              VegetableData>(
                                            source: valueV.items_v,
                                            value: (index, item) => item.vId,
                                            title: (index, item) => item.vName,
                                            meta: (index, item) => item,
                                            hidden: (index, item) {
                                              bool status = true;
                                              if (order.isNotEmpty) {
                                                if (order.first !=
                                                    'ไม่มีคำสั่งซื้อ') {
                                                  l_vegetable
                                                      .forEach((element) {
                                                    if (item.vId == element) {
                                                      status = false;
                                                    }
                                                  });
                                                } else {
                                                  status = false;
                                                }
                                              }

                                              return status;
                                            },
                                          ),
                                          choiceLayout: S2ChoiceLayout.list,
                                          choiceBuilder:
                                              (context, choice, searchText) {
                                            return Card(
                                              margin: EdgeInsets.all(5),
                                              color: choice.selected
                                                  ? Colors.lightGreen
                                                  : Colors.white,
                                              child: InkWell(
                                                onTap: () {
                                                  choice.select(true);
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      radius: 40.0,
                                                      backgroundImage:
                                                          NetworkImage(choice
                                                              .meta.vPhoto),
                                                      child: choice.selected
                                                          ? Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : null,
                                                    ),
                                                    Text(
                                                      choice.title,
                                                    )
                                                        .asNiku()
                                                        .color(
                                                          choice.selected
                                                              ? Colors.white
                                                              : null,
                                                        )
                                                        .fontSize(18)
                                                        .niku()
                                                        .pl(30),
                                                  ],
                                                )
                                                    .niku()
                                                    .center()
                                                    .width(100)
                                                    .height(100),
                                              ),
                                            );
                                          },
                                          onChange: (state) {
                                            setState(() {
                                              area = [];
                                              vegetable = state.value;
                                              area_tn = 0;
                                              vegetable_recommend();
                                            });
                                          },
                                          modalFilter: true,
                                          modalFilterAuto: true,
                                          modalFilterHint: 'ค้นหา',
                                          modalType: S2ModalType.bottomSheet,
                                        ),
                                        SmartSelect<String>.multiple(
                                          title: 'พื้นที่',
                                          placeholder: 'กรุณาเลือก',
                                          value: area,
                                          modalConfirm: true,
                                          modalValidation: (chosen) {
                                            return chosen.isEmpty
                                                ? 'กรุณาเลือกอย่างน้อย 1 รายการ'
                                                : null;
                                          },
                                          choiceTitleBuilder:
                                              (context, state, choice) {
                                            return S2Text(
                                              text: state.title,
                                              style: TextStyle(
                                                color: state.selected
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : null,
                                              ),
                                              highlightColor: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.7),
                                            );
                                          },
                                          modalFooterBuilder: (context, state) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 7.0,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Spacer(),
                                                  TextButton(
                                                    child: Text('ยกเลิก'),
                                                    onPressed: () =>
                                                        state.closeModal(
                                                            confirmed: false),
                                                  ),
                                                  SizedBox(width: 5),
                                                  TextButton.icon(
                                                    icon: Icon(
                                                      Icons.check,
                                                    ),
                                                    label: Text('ยืนยัน')
                                                        .asNiku()
                                                        .color(Colors.white),
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      onSurface: Colors.white,
                                                    ),
                                                    onPressed: () =>
                                                        state.closeModal(
                                                            confirmed: true),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          tileBuilder: (context, state) {
                                            return S2Tile.fromState(
                                              state,
                                              isTwoLine: true,
                                              leading: Container(
                                                width: 40,
                                                alignment: Alignment.center,
                                                child: Icon(Icons.view_module,
                                                    color: Colors.brown[700]),
                                              ),
                                              title: state.titleWidget,
                                              value: state.valueDisplay,
                                              onTap: state.showModal,
                                              isLoading: vegetable == '',
                                              loadingText: 'รอเลือกผัก',
                                            );
                                          },
                                          modalConfig: S2ModalConfig(
                                            style: S2ModalStyle(
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(15.0),
                                                  topRight:
                                                      Radius.circular(15.0),
                                                ),
                                              ),
                                            ),
                                            headerStyle: S2ModalHeaderStyle(
                                              centerTitle: true,
                                            ),
                                          ),
                                          choiceLayout: S2ChoiceLayout.list,
                                          choiceBuilder:
                                              (context, choice, searchText) {
                                            return Card(
                                              margin: EdgeInsets.fromLTRB(
                                                  5, 5, 5, 5),
                                              color: choice.selected
                                                  ? Colors.lightGreen
                                                  : choice.disabled
                                                      ? Colors.grey[300]
                                                      : Colors.white,
                                              child: InkWell(
                                                onTap: () => choice.disabled
                                                    ? null
                                                    : choice.selected != true
                                                        ? choice.select(true)
                                                        : choice.select(false),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      radius: 40.0,
                                                      backgroundImage:
                                                          NetworkImage(choice
                                                              .meta.areaPhoto),
                                                      child: choice.selected
                                                          ? Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : null,
                                                    ),
                                                    NikuColumn(
                                                      [
                                                        Text(
                                                          choice.title,
                                                        )
                                                            .asNiku()
                                                            .color(
                                                              choice.selected
                                                                  ? Colors.white
                                                                  : null,
                                                            )
                                                            .fontSize(18),
                                                        Text(
                                                          choice.subtitle,
                                                        )
                                                            .asNiku()
                                                            .color(
                                                              choice.selected
                                                                  ? Colors.white
                                                                  : null,
                                                            )
                                                            .fontSize(14)
                                                      ],
                                                    ).niku().pl(30).pt(25),
                                                  ],
                                                )
                                                    .niku()
                                                    .center()
                                                    .width(100)
                                                    .height(100),
                                              ),
                                            );
                                          },
                                          choiceItems:
                                              S2Choice.listFrom<String, Area>(
                                            source: value_a.items,
                                            value: (index, item) => item.areaId,
                                            title: (index, item) =>
                                                item.areaName,
                                            meta: (index, item) => item,
                                            hidden: (index, item) {
                                              if (item.areaLv == vegetable ||
                                                  (((item.areaWide / 100) *
                                                              (item.areaLong /
                                                                  100)) /
                                                          v_sq_m) <
                                                      1 ||
                                                  item.status == true) {
                                                return true;
                                              }
                                              return false;
                                            },
                                            disabled: (index, item) {
                                              if (vegetable == '') {
                                                return true;
                                              }
                                              return false;
                                            },
                                            subtitle: (index, item) {
                                              if (v_sq_m != 0) {
                                                if (item.areaDetail == '')
                                                  return 'ปลูกได้ ' +
                                                      (((item.areaWide ~/ 100) *
                                                                  (item.areaLong ~/
                                                                      100)) ~/
                                                              v_sq_m)
                                                          .toInt()
                                                          .toString() +
                                                      ' ต้น';
                                                else
                                                  return item.areaDetail +
                                                      '\nปลูกได้ ' +
                                                      (((item.areaWide ~/ 100) *
                                                                  (item.areaLong ~/
                                                                      100)) ~/
                                                              v_sq_m)
                                                          .toInt()
                                                          .toString() +
                                                      ' ต้น';
                                              } else
                                                return '';
                                            },
                                          ),
                                          onChange: (state) {
                                            setState(() {
                                              area = state.value;
                                              vegetable_recommend();
                                            });
                                          },
                                          modalFilter: true,
                                          modalFilterAuto: true,
                                          modalFilterHint: 'ค้นหา',
                                          modalType: S2ModalType.bottomSheet,
                                        ),
                                        NikuRow(
                                          [
                                            Text('จำนวนผัก')
                                                .asNiku()
                                                .fontSize(15)
                                                .mr(10),
                                            TextField(
                                              controller: numberController,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    if (value == '') {
                                                      number = 0;
                                                    } else {
                                                      number = double.parse(
                                                          value ?? '0');
                                                    }
                                                  },
                                                );
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              textAlign: TextAlign.center,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
                                                prefixIcon: Container(
                                                  transform:
                                                      Matrix4.translationValues(
                                                          -4, -2, 0.0),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.blue,
                                                    ),
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          if (number > 0) {
                                                            number = number - 1;
                                                            numberController
                                                                    .text =
                                                                number
                                                                    .toInt()
                                                                    .toString();
                                                          }
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                                suffixIcon: IconButton(
                                                        icon: Icon(
                                                          Icons.add_circle,
                                                          color: Colors.blue,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            number = number + 1;
                                                            numberController
                                                                    .text =
                                                                number
                                                                    .toInt()
                                                                    .toString();
                                                          });
                                                        })
                                                    .niku()
                                                    .transform(Matrix4
                                                        .translationValues(
                                                            4, -2, 0.0)),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                              ),
                                            ).niku().height(35).width(160),
                                            Text('ต้น')
                                                .asNiku()
                                                .fontSize(15)
                                                .ml(5)
                                                .mr(5),
                                            Text(':').asNiku().fontSize(15),
                                            Text('${((v_nfv * number) / 1000).toStringAsFixed(1)} Kg')
                                                .asNiku()
                                                .fontSize(15)
                                                .ml(10)
                                          ],
                                        ),
                                        NikuColumn(
                                          [
                                            // if (vegetable != '' &&
                                            //     !valueV.items.any((x) =>
                                            //         x.orderId.first ==
                                            //         order.first))
                                            //   NikuColumn([
                                            //     Text('จำนวนที่ต้องการ ${r_number} ต้น : ${((v_nfv * r_number) / 1000).toStringAsFixed(1)} Kg\nต้องการปลูก ${number.toInt()} ต้น อัตตราสูญเสีย ${loss}%\nรวม ${number.toInt()} - ((${number.toInt()} * ${loss}) / 100) = ${(number.toInt() - (number.toInt() * loss) / 100).toInt()} ต้น : ${((v_nfv * (number.toInt() - (number.toInt() * loss) / 100).toInt()) / 1000).toStringAsFixed(1)} Kg')
                                            //         .asNiku()
                                            //         .center()
                                            //         .fontSize(14)
                                            //         .color(Colors.grey[700])
                                            //         .mt(6),
                                            //     // Text('ประมาณการผักได้จริง ${(number - (number / 100) * loss).toInt()} ต้น อัตตราสูนเสีย ${loss}%')
                                            //     //     .asNiku()
                                            //     //     .fontSize(14)
                                            //     //     .color(Colors.grey[700])
                                            //     //     .mt(6),
                                            //     Text('จำนวนที่ต้องการ ${r_number} ต้น : ${((v_nfv * r_number) / 1000).toStringAsFixed(1)} Kg')
                                            //         .asNiku()
                                            //         .fontSize(14)
                                            //         .color(r_number >
                                            //                 number.toInt()
                                            //             ? Colors.redAccent
                                            //             : Colors.grey[700])
                                            //         .mt(7),
                                            //     if (area.isNotEmpty)
                                            //       Text('และพื้นที่เต็มที่ ${area_tn} ต้น')
                                            //           .asNiku()
                                            //           .fontSize(14)
                                            //           .color(area_tn <
                                            //                   number.toInt()
                                            //               ? Colors.redAccent
                                            //               : Colors.grey[700])
                                            //           .mt(4),
                                            //   ]),
                                            if (vegetable != '' &&
                                                valueV.items.any((x) =>
                                                    x.orderId.first ==
                                                    order.first))
                                              NikuColumn([
                                                Text('จำนวนต้องการเพิ่มคำสั่งซื้อโดยประมาณ\n${all_number_show()['rf_number']} ต้น (ประมาณ ${all_number_show()['rf_numberKg']} กิโลกรัม)')
                                                    .asNiku()
                                                    .center()
                                                    .fontSize(14)
                                                    .color(Colors.grey[800])
                                                    .mt(6),
                                                Text('จำนวนแนะนำการปลูกเพิ่มเพื่อชดเชยการสูญเสีย\n${all_number_show()['rfl_number']} ต้น (ประมาณ ${all_number_show()['rfl_numberKg']} กิโลกรัม)')
                                                    .asNiku()
                                                    .center()
                                                    .fontSize(14)
                                                    .color(Colors.grey[800])
                                                    .mt(7),
                                                Text('อัตราการสูญเสีย ${loss}%')
                                                    .asNiku()
                                                    .center()
                                                    .fontSize(14)
                                                    .color(Colors.grey[800])
                                                    .mt(7),
                                                if (number.toInt() ==
                                                    all_number_show()[
                                                        'rfl_number'])
                                                  Text('คุณได้เลือกจำนวนปลูกครบตามจำนวนที่แนะนำแล้ว')
                                                      .asNiku()
                                                      .style(TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold))
                                                      .center()
                                                      .fontSize(14)
                                                      .color(Colors.green)
                                                      .mt(7),
                                                if (number.toInt() <
                                                    all_number_show()[
                                                        'rfl_number'])
                                                  Text('คุณเลือกจำนวนปลูกน้อยกว่าจำนวนแนะนำอยู่ ${all_number_show()['lr_number']} ต้น (ประมาณ ${all_number_show()['lr_numberKg']} กิโลกรัม)')
                                                      .asNiku()
                                                      .style(TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold))
                                                      .center()
                                                      .fontSize(14)
                                                      .color(Colors.red)
                                                      .mt(7),
                                                if (number.toInt() >
                                                    all_number_show()[
                                                        'rfl_number'])
                                                  Text('คุณได้เลือกจำนวนปลูกเกินจำนวนแนะนำ ${all_number_show()['hr_number']} ต้น (ประมาณ ${all_number_show()['hr_numberKg']} กิโลกรัม)')
                                                      .asNiku()
                                                      .style(TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold))
                                                      .center()
                                                      .fontSize(14)
                                                      .color(Colors.orange)
                                                      .mt(7),
                                                // if (area.isNotEmpty)
                                                //   Text(area_tn < number.toInt()
                                                //           ? 'พื้นที่เต็มที่ ${area_tn} ต้น เกิน ${((area_tn / 100) * (number - area_tn)).toStringAsFixed(1)}%'
                                                //           : 'พื้นที่เต็มที่ ${area_tn} ต้น')
                                                //       .asNiku()
                                                //       .fontSize(14)
                                                //       .color(area_tn <
                                                //               number.toInt()
                                                //           ? Colors.redAccent
                                                //           : Colors.grey[800])
                                                //       .mt(4),
                                              ])
                                                  .mt(8)
                                                  .mb(10)
                                                  .ml(10)
                                                  .mr(10)
                                                  .niku()
                                                  .boxDecoration(BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        Colors.lightBlue[100],
                                                  ))
                                                  .mt(10),
                                            if (area.isNotEmpty)
                                              NikuColumn([
                                                Text(area_tn < number.toInt()
                                                        ? 'จำนวนที่สามารถปลูกได้จากพื้นที่ว่างคงเหลือ (${area_n.reduce((x, y) => '$x,$y')}) ${area_tn} ต้น โดยประมาณ จำกัดการปลูกสูงสุด 10% จากปริมาณที่พื้นที่รองรับ ขณะนี้เกินไปแล้ว ${((area_tn / 100) * (number - area_tn)).toStringAsFixed(1)}%'
                                                        : 'จำนวนที่สามารถปลูกได้จากพื้นที่ว่างคงเหลือ (${area_n.reduce((x, y) => '$x,$y')}) ${area_tn} ต้น โดยประมาณ จำกัดการปลูกสูงสุด 10% จากปริมาณที่พื้นที่รองรับ')
                                                    .asNiku()
                                                    .style(TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 1.5))
                                                    .center()
                                                    .fontSize(14)
                                                    .color(area_tn <
                                                            number.toInt()
                                                        ? ((area_tn / 100) *
                                                                    (number -
                                                                        area_tn)) >=
                                                                10
                                                            ? Colors.redAccent
                                                            : ((area_tn / 100) *
                                                                        (number -
                                                                            area_tn)) >=
                                                                    5
                                                                ? Colors.orange
                                                                : Colors
                                                                    .lightGreen[700]
                                                        : Colors.grey[800])
                                                    .mt(7),
                                              ])
                                                  .mt(8)
                                                  .mb(10)
                                                  .ml(10)
                                                  .mr(10)
                                                  .niku()
                                                  .boxDecoration(BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        Colors.lightGreen[100],
                                                  ))
                                                  .mt(10),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ).niku().padding(EdgeInsets.only(left: 15, right: 20));
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        if (vegetable != '' &&
                            area.length != 0 &&
                            order.length != 0 &&
                            number.toInt() > 1) {
                          if (((area_tn / 100) * (number - area_tn)) > 10) {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('แจ้งเตือน!'),
                                  content: Text(
                                          '${number.toInt()} ต้น เกินจำนวนที่สามารถปลูกได้จากพื้นที่ว่าง')
                                      .asNiku()
                                      .center(),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('ตกลง'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Provider.of<Grows>(context, listen: false).addGrow(
                                vegetable, area, order, number.toInt());
                            Navigator.pop(context);
                          }
                        } else {
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('แจ้งเตือน!'),
                                content: Text('กรุณาป้อนข้อมูลให้ครบ'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('ตกลง'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Center(
                        child: Text('ยืนยัน')
                            .asNiku()
                            .fontSize(18)
                            .color(Colors.white)
                            .niku()
                            .center()
                            .boxDecoration(
                              BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.blue,
                              ),
                            )
                            .width(100)
                            .height(40),
                      ),
                    ).niku().mt(15)
                  ],
                )
                    .niku()
                    .width(double.infinity)
                    .boxDecoration(BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ))
                    .margin(EdgeInsets.fromLTRB(5, 10, 5, 0)),
              ),
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
    );
  }
}
