import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vegetable_plots/models/grow.dart';
import 'package:vegetable_plots/models/problem_take.dart';
import 'package:vegetable_plots/providers/area_provider.dart';
import 'package:vegetable_plots/providers/problems_provider.dart';
import 'package:vegetable_plots/providers/problemtake_provider.dart';

class HistoryDetail extends StatefulWidget {
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
  final String order_id_show;
  final String area_show;

  HistoryDetail(
    this.pd_id,
    this.pd_d,
    this.pd_d1,
    this.c_d3,
    this.v_name,
    this.number,
    this.weight,
    this.area,
    this.order_id,
    this.area_id,
    this.order_id_show,
    this.area_show,
  );
  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  String _setDate;

  @override
  void initState() {
    super.initState();

    EasyLoading.show(status: 'กำลังโหลด...');
    Provider.of<Areas>(context, listen: false).loadArea();
    Provider.of<Problems>(context, listen: false).loadProblem();
    Provider.of<ProblemTakes>(context, listen: false)
        .loadProblemTakes(widget.pd_id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder:
          (BuildContext context, ProblemTakes _dataProblemTake, Widget child) {
        return Scaffold(
            backgroundColor: Colors.blue[400],
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                widget.pd_id,
                style: GoogleFonts.mali(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
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
                Provider.of<ProblemTakes>(context, listen: false)
                    .loadProblemTakes(widget.pd_id);
              },
              child: NikuStack(
                [
                  Positioned(
                    bottom: 0.0,
                    child: SvgPicture.asset(
                      'assets/svg_image1.svg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  NikuColumn(
                    [
                      Niku(
                        NikuColumn(
                          [
                            NikuRow(
                              [
                                Text(
                                  'หมายเลข : ',
                                )
                                    .asNiku()
                                    .fontWeight(FontWeight.bold)
                                    .color(Colors.blue)
                                    .niku()
                                    .pr(15),
                                Text(
                                  '${widget.pd_id}',
                                ).asNiku().color(Colors.blue),
                              ],
                            ),
                            Niku(
                              NikuRow(
                                [
                                  Text(
                                    'ผักที่ปลูก : ',
                                  )
                                      .asNiku()
                                      .fontWeight(FontWeight.bold)
                                      .color(Colors.blue)
                                      .niku()
                                      .pr(15),
                                  Text(
                                    '${widget.v_name}',
                                  ).asNiku().color(Colors.blue),
                                ],
                              ),
                            ).mt(7),
                            Niku(
                              NikuRow(
                                [
                                  Text(
                                    'คำสั่งซื้อ : ',
                                  )
                                      .asNiku()
                                      .fontWeight(FontWeight.bold)
                                      .color(Colors.blue)
                                      .niku()
                                      .pr(20),
                                  Text('${widget.order_id_show}')
                                      .asNiku()
                                      .color(Colors.blue),
                                ],
                              ),
                            ).mt(7),
                            Niku(
                              NikuRow(
                                [
                                  Text('วันเริ่มปลูก : ')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontWeight(FontWeight.bold)
                                      .niku()
                                      .pb(3),
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.blue,
                                  ),
                                  Text(' ' + '${widget.pd_d1}')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .mb(3),
                                ],
                              ),
                            ).mt(5),
                            Niku(
                              NikuRow(
                                [
                                  Text('วันเก็บ : ')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontWeight(FontWeight.bold)
                                      .mb(3)
                                      .mr(28),
                                  Icon(
                                    Icons.event_available,
                                    color: Colors.blue,
                                  ),
                                  Text(' ' + '${widget.c_d3}')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .mb(3),
                                ],
                              ),
                            ).mt(3),
                            Niku(
                              NikuRow(
                                [
                                  Text('จำนวน : ')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontWeight(FontWeight.bold)
                                      .mr(29),
                                  Text('${widget.number} ต้น : ${widget.weight.toStringAsFixed(1)} Kg')
                                      .asNiku()
                                      .color(Colors.blue),
                                ],
                              ),
                            ).mt(5),
                            Niku(
                              NikuRow(
                                [
                                  Text(
                                    'พื้นที่ปลูก : ',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontWeight(FontWeight.bold)
                                      .mr(12),
                                  Text(widget.area_show)
                                      .asNiku()
                                      .color(Colors.blue),
                                ],
                              ),
                            ).mt(10),
                          ],
                        ),
                      )
                        ..p(10)
                        ..bg(Colors.white)
                        ..rounded(10)
                        ..m(10),
                      ListView.builder(
                        shrinkWrap: true,
                        // ignore: null_aware_before_operator
                        itemCount: _dataProblemTake == null
                            ? 1
                            : _dataProblemTake.items.length,
                        itemBuilder: (context, i) {
                          return _dataProblemTake.items[i]?.type == 'pd1' ||
                                  _dataProblemTake.items[i]?.type == 'pd2' ||
                                  _dataProblemTake.items[i]?.type == 'pd3'
                              ? Niku(
                                  NikuButton(
                                    NikuStack([
                                      Text(_dataProblemTake.items[i]?.date ??
                                              'null')
                                          .asNiku()
                                          .color(Colors.blue)
                                          .fontSize(16)
                                          .niku()
                                            ..positioned(left: 15),
                                      Text('${_dataProblemTake.items[i]?.data ?? 'null'}')
                                          .asNiku()
                                          .color(Colors.blue)
                                          .fontSize(16)
                                          .softWrap(false)
                                          .overflow(TextOverflow.fade)
                                          .niku()
                                            ..positioned(left: 100, top: 11),
                                    ]).center(),
                                  )..onPressed(() {}),
                                )
                                  .height(50)
                                  .boxDecoration(BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.white,
                                  ))
                                  .ml(10)
                                  .mr(10)
                                  .mb(10)
                              : _dataProblemTake.items[i]?.type == 'problem'
                                  ? ProblemWidget(_dataProblemTake.items[i],
                                      widget.pd_id, widget.area_id)
                                  : _dataProblemTake.items[i]?.type == 'take'
                                      ? TakeWidget(_dataProblemTake.items[i])
                                      : null;
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
            ));
      },
    );
  }
}

class ProblemWidget extends StatefulWidget {
  final ProblemTake items;
  final String pd_id;
  final List area_id;
  ProblemWidget(this.items, this.pd_id, this.area_id);

  @override
  _ProblemWidgetState createState() => _ProblemWidgetState();
}

class _ProblemWidgetState extends State<ProblemWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    TextEditingController _dateController = TextEditingController();

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          locale: Locale("th", "TH"),
          initialDate: selectedDate,
          initialDatePickerMode: DatePickerMode.day,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100));
      if (picked != null)
        setState(() {
          selectedDate = picked;
          _dateController.text = DateFormat.yMd('th').format(selectedDate);
        });
    }

    return Niku(
      NikuButton(
        NikuStack(
          [
            Text(widget.items.date)
                .asNiku()
                .color(Colors.blue)
                .fontSize(16)
                .niku()
                  ..positioned(left: 15),
            Icon(
              Icons.warning,
              color: Colors.yellow[700],
              size: 20,
            ).niku()
              ..positioned(left: 100, top: 11),
            Text('${widget.items?.problemsData ?? 'null'}')
                .asNiku()
                .color(Colors.blue)
                .fontSize(16)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(230)
                  ..positioned(left: 120, top: 11),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.blue,
              size: 20,
            ).niku()
              ..positioned(left: 350),
          ],
        ).center(),
      )..onPressed(() {
          Alert(
              context: context,
              style: AlertStyle(titleStyle: TextStyle(color: Colors.blue)),
              type: AlertType.warning,
              title: "ปัญหา",
              content: NikuColumn(
                [
                  NikuStack([
                    Niku().width(MediaQuery.of(context).size.width).height(30),
                    Positioned(
                      left: 0,
                      child: Text('วันที่')
                          .asNiku()
                          .color(Colors.blue)
                          .fontWeight(FontWeight.bold)
                          .fontSize(18),
                    ),
                    Positioned(
                      left: 60,
                      child: Text(':')
                          .asNiku()
                          .color(Colors.blue)
                          .fontWeight(FontWeight.bold)
                          .fontSize(18),
                    ),
                    Positioned(
                      left: 80,
                      child: Text(widget.items.date).asNiku().fontSize(18),
                    ),
                  ]).niku().mt(10),
                  NikuStack([
                    Niku().width(MediaQuery.of(context).size.width).height(30),
                    Positioned(
                      left: 0,
                      child: Text('ปัญหา')
                          .asNiku()
                          .color(Colors.blue)
                          .fontWeight(FontWeight.bold)
                          .fontSize(18),
                    ),
                    Positioned(
                      left: 60,
                      child: Text(':')
                          .asNiku()
                          .color(Colors.blue)
                          .fontWeight(FontWeight.bold)
                          .fontSize(18),
                    ),
                    Positioned(
                      left: 80,
                      child: Text(
                        widget.items.problemsData,
                      ).asNiku().color(Colors.black).fontSize(16),
                    ),
                  ]).niku().mt(10),
                  NikuStack([
                    Niku().width(MediaQuery.of(context).size.width).height(30),
                    Positioned(
                      left: 0,
                      child: Text('วิธีแก้')
                          .asNiku()
                          .color(Colors.blue)
                          .fontWeight(FontWeight.bold)
                          .fontSize(18),
                    ),
                    Positioned(
                      left: 60,
                      child: Text(':')
                          .asNiku()
                          .color(Colors.blue)
                          .fontWeight(FontWeight.bold)
                          .fontSize(18),
                    ),
                    Positioned(
                      left: 80,
                      child: Text(
                        widget.items.solvingData,
                      ).asNiku().color(Colors.black).fontSize(16),
                    ),
                  ]).niku().mt(10),
                  NikuStack([
                    Niku().width(MediaQuery.of(context).size.width).height(30),
                    Positioned(
                      left: 0,
                      child: Text('จำนวนผักเสียหาย')
                          .asNiku()
                          .color(Colors.blue)
                          .fontWeight(FontWeight.bold)
                          .fontSize(18),
                    ),
                    Positioned(
                      left: 160,
                      child: Text(':')
                          .asNiku()
                          .color(Colors.blue)
                          .fontWeight(FontWeight.bold)
                          .fontSize(18),
                    ),
                    Positioned(
                      left: 180,
                      child: Text('${widget.items.number} ต้น')
                          .asNiku()
                          .fontSize(18),
                    ),
                  ]).niku().mt(5),
                ],
              ).niku().width(MediaQuery.of(context).size.width),
              buttons: [
                DialogButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.yellow[700],
                  radius: BorderRadius.circular(100),
                  width: 150,
                  child: Text(
                    "ปิด",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ]).show();
        }),
    )
        .height(50)
        .boxDecoration(BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
        ))
        .ml(10)
        .mr(10)
        .mb(10);
  }
}

class TakeWidget extends StatelessWidget {
  final ProblemTake items;
  TakeWidget(this.items);

  @override
  Widget build(BuildContext context) {
    return Niku(
      NikuButton(
        NikuStack(
          [
            Text(items.date).asNiku().color(Colors.blue).fontSize(16).niku()
              ..positioned(left: 15),
            Text('${items.fertilizer.fertilizerType}')
                .asNiku()
                .color(Colors.blue)
                .fontSize(16)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(180)
                  ..positioned(left: 100, top: 11),
            Text('${items.fertilizer.takeVolume} ${items.fertilizer.unitEng}')
                .asNiku()
                .color(Colors.blue)
                .fontSize(16)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(90)
                  ..positioned(left: 320, top: 15),
          ],
        ).center(),
      )..onPressed(() {}),
    )
        .height(50)
        .boxDecoration(BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
        ))
        .ml(10)
        .mr(10)
        .mb(10);
  }
}
