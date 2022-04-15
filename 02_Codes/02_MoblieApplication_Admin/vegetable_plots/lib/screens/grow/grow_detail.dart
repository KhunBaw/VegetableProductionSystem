import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:niku/niku.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:vegetable_plots/models/area.dart';
import 'package:vegetable_plots/models/grow.dart';
import 'package:vegetable_plots/models/problem.dart';
import 'package:vegetable_plots/models/problem_take.dart';
import 'package:vegetable_plots/models/unit.dart';
import 'package:vegetable_plots/providers/area_provider.dart';
import 'package:vegetable_plots/providers/grow_provider.dart';
import 'package:vegetable_plots/providers/problems_provider.dart';
import 'package:vegetable_plots/providers/problemtake_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CareDetail extends StatefulWidget {
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

  CareDetail(
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
  _CareDetailState createState() => _CareDetailState();
}

class _CareDetailState extends State<CareDetail> {
  String _setDate;
  File uploadimage;

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
                                    .fontSize(14.sp)
                                    .niku()
                                    .pr(15.w),
                                Text(
                                  '${widget.pd_id}',
                                ).asNiku().color(Colors.blue).fontSize(14.sp),
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
                                      .fontSize(14.sp)
                                      .niku()
                                      .pr(15.w),
                                  Text(
                                    '${widget.v_name}',
                                  ).asNiku().color(Colors.blue).fontSize(14.sp),
                                ],
                              ),
                            ).mt(7.h),
                            Niku(
                              NikuRow(
                                [
                                  Text(
                                    'คำสั่งซื้อ : ',
                                  )
                                      .asNiku()
                                      .fontWeight(FontWeight.bold)
                                      .color(Colors.blue)
                                      .fontSize(14.sp)
                                      .niku()
                                      .pr(20.w),
                                  Text('${widget.order_id_show}')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontSize(14.sp),
                                ],
                              ),
                            ).mt(7.h),
                            Niku(
                              NikuRow(
                                [
                                  Text('วันเริ่มปลูก : ')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontWeight(FontWeight.bold)
                                      .fontSize(14.sp)
                                      .niku()
                                      .pb(3.h),
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.blue,
                                    size: 24.sp,
                                  ),
                                  Text(' ' + '${widget.pd_d1}')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontSize(14.sp)
                                      .mb(3.h),
                                ],
                              ),
                            ).mt(5.h),
                            Niku(
                              NikuRow(
                                [
                                  Text('วันเก็บ : ')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontWeight(FontWeight.bold)
                                      .fontSize(14.sp)
                                      .mb(3.h)
                                      .mr(28.w),
                                  Icon(
                                    Icons.event_available,
                                    color: Colors.blue,
                                    size: 24.sp,
                                  ),
                                  Text(' ' + '${widget.c_d3}')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontSize(14.sp)
                                      .mb(3.h),
                                ],
                              ),
                            ).mt(3.h),
                            Niku(
                              NikuRow(
                                [
                                  Text('จำนวน : ')
                                      .asNiku()
                                      .color(Colors.blue)
                                      .fontWeight(FontWeight.bold)
                                      .fontSize(14.sp)
                                      .mr(29.w),
                                  Text('${widget.number} ต้น : ${widget.weight.toStringAsFixed(1)} Kg')
                                      .asNiku()
                                      .fontSize(14.sp)
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
                                      .fontSize(14.sp)
                                      .mr(12.w),
                                  Text(widget.area_show)
                                      .asNiku()
                                      .fontSize(14.sp)
                                      .color(Colors.blue),
                                ],
                              ),
                            ).mt(10.h),
                          ],
                        ),
                      )
                        ..p(10.w)
                        ..bg(Colors.white)
                        ..rounded(10.r)
                        ..m(10.w),
                      ListView.builder(
                        shrinkWrap: true,
                        // ignore: null_aware_before_operator
                        itemCount: _dataProblemTake == null
                            ? 1
                            : _dataProblemTake.items.length + 1,
                        itemBuilder: (context, i) {
                          return (_dataProblemTake == null
                                      ? 0
                                      : _dataProblemTake.items.length) ==
                                  i
                              ? Addproblems(widget.area_id, widget.pd_id)
                              : _dataProblemTake.items[i]?.type == 'pd1' ||
                                      _dataProblemTake.items[i]?.type ==
                                          'pd2' ||
                                      _dataProblemTake.items[i]?.type == 'pd3'
                                  ? Niku(
                                      NikuButton(
                                        NikuStack([
                                          Text(_dataProblemTake
                                                      .items[i]?.date ??
                                                  'null')
                                              .asNiku()
                                              .color(Colors.blue)
                                              .fontSize(14.sp)
                                              .niku()
                                            ..positioned(left: 15.w),
                                          Text('${_dataProblemTake.items[i]?.data ?? 'null'}')
                                              .asNiku()
                                              .color(Colors.blue)
                                              .fontSize(14.sp)
                                              .softWrap(false)
                                              .overflow(TextOverflow.fade)
                                              .niku()
                                            ..positioned(
                                                left: 100.w, top: 12.h),
                                        ]).center(),
                                      )..onPressed(() {
                                          Alert(
                                              context: context,
                                              title:
                                                  "${_dataProblemTake.items[i]?.data ?? 'null'}",
                                              content: StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                Future<void>
                                                    chooseImageC() async {
                                                  XFile choosedimage =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera);
                                                  //set source: ImageSource.camera to get image from camera
                                                  setState(() {
                                                    uploadimage = File(
                                                        choosedimage?.path);
                                                  });
                                                }

                                                Future<void>
                                                    chooseImageG() async {
                                                  XFile choosedimage =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  //set source: ImageSource.camera to get image from camera
                                                  setState(() {
                                                    uploadimage = File(
                                                        choosedimage?.path);
                                                  });
                                                }

                                                return NikuColumn([
                                                  uploadimage == null
                                                      ? _dataProblemTake
                                                                  .items[i]
                                                                  ?.photo !=
                                                              ''
                                                          ? Image.network(
                                                                  _dataProblemTake
                                                                      .items[i]
                                                                      ?.photo)
                                                              .niku()
                                                              .maxHeight(200.h)
                                                              .maxWidth(200.w)
                                                          : NikuColumn([
                                                              Text('ไม่มีรูปภาพ')
                                                                  .asNiku()
                                                                  .fontSize(
                                                                      16.sp)
                                                                  .mb(5.h)
                                                                  .mt(5.h),
                                                              Image.network(
                                                                      'https://s3-ap-southeast-1.amazonaws.com/wpimages.mover.in.th/wp-content/uploads/2019/05/28154928/Screen-Shot-2562-05-28-at-15.48.49.png')
                                                                  .niku()
                                                                  .maxHeight(
                                                                      200.h)
                                                                  .maxWidth(
                                                                      200.w)
                                                            ])
                                                      : Image.file(uploadimage)
                                                          .niku()
                                                          .maxHeight(200.h)
                                                          .maxWidth(200.w),
                                                  NikuRow([
                                                    DialogButton(
                                                      onPressed: () =>
                                                          chooseImageC(),
                                                      child: Icon(
                                                        Icons
                                                            .photo_camera_outlined,
                                                        color: Colors.white,
                                                        size: 24.sp,
                                                      ),
                                                      color: Colors.green[400],
                                                    ),
                                                    DialogButton(
                                                      onPressed: () =>
                                                          chooseImageG(),
                                                      child: Icon(
                                                        Icons
                                                            .collections_outlined,
                                                        color: Colors.white,
                                                        size: 24.sp,
                                                      ),
                                                      color: Colors.red[400],
                                                    ),
                                                  ]).mainAxisAlignment(
                                                      MainAxisAlignment.center)
                                                ]);
                                              }),
                                              buttons: [
                                                DialogButton(
                                                  onPressed: () => {
                                                    if (uploadimage == null)
                                                      {
                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'แจ้งเตือน!'),
                                                              content: Text(
                                                                      'ยังไม่มีการอัพโหลดรูปภาพ')
                                                                  .asNiku()
                                                                  .center(),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                          'ตกลง')
                                                                      .asNiku()
                                                                      .fontSize(
                                                                          14.sp),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        )
                                                      }
                                                    else
                                                      {
                                                        Grows().photoGrow(
                                                            uploadimage,
                                                            widget.pd_id,
                                                            _dataProblemTake
                                                                .items[i]
                                                                ?.type),
                                                        setState(() {
                                                          uploadimage = null;
                                                        }),
                                                        Navigator.pop(context),
                                                      },
                                                  },
                                                  child: Text(
                                                    "ยืนยัน",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  color: Colors.green,
                                                ),
                                                DialogButton(
                                                  onPressed: () => {
                                                    setState(() {
                                                      uploadimage = null;
                                                    }),
                                                    Navigator.pop(context),
                                                  },
                                                  child: Text(
                                                    "ปิด",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  color: Colors.orange[400],
                                                ),
                                              ]).show();
                                        }),
                                    )
                                      .height(50.h)
                                      .boxDecoration(BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0.r)),
                                        color: Colors.white,
                                      ))
                                      .ml(10.w)
                                      .mr(10.w)
                                      .mb(10.h)
                                  : _dataProblemTake.items[i]?.type == 'problem'
                                      ? ProblemWidget(_dataProblemTake.items[i],
                                          widget.pd_id, widget.area_id)
                                      : _dataProblemTake.items[i]?.type ==
                                                  'pd3_f' ||
                                              _dataProblemTake.items[i]?.type ==
                                                  'pd2_f'
                                          ? AddpdWidget(
                                              _dataProblemTake.items[i],
                                              widget.pd_id)
                                          : _dataProblemTake.items[i]?.type ==
                                                  'take'
                                              ? TakeWidget(
                                                  _dataProblemTake.items[i])
                                              : AddTakeWidget(
                                                  _dataProblemTake.items[i],
                                                  widget.pd_id);
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

class TakeWidget extends StatelessWidget {
  final ProblemTake items;
  TakeWidget(this.items);

  @override
  Widget build(BuildContext context) {
    return Niku(
      NikuButton(
        NikuStack(
          [
            Text(items.date).asNiku().color(Colors.blue).fontSize(14.sp).niku()
              ..positioned(left: 15.w),
            Text('${items.fertilizer.fertilizerType}')
                .asNiku()
                .color(Colors.blue)
                .fontSize(14.sp)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(180.w)
              ..positioned(left: 100.w, top: 11.h),
            Text('${items.fertilizer.takeVolume} ${items.fertilizer.unitEng}')
                .asNiku()
                .color(Colors.blue)
                .fontSize(14.sp)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(90.w)
              ..positioned(left: 320.w, top: 15.h),
          ],
        ).center(),
      )..onPressed(() {}),
    )
        .height(50.h)
        .boxDecoration(BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
          color: Colors.white,
        ))
        .ml(10.w)
        .mr(10.w)
        .mb(10.h);
  }
}

class AddTakeWidget extends StatefulWidget {
  final ProblemTake items;
  final String pd_id;
  AddTakeWidget(this.items, this.pd_id);

  @override
  _AddTakeWidgetState createState() => _AddTakeWidgetState();
}

class _AddTakeWidgetState extends State<AddTakeWidget> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  List<Unit> unit;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        locale: Locale("th", "TH"),
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd('th').format(selectedDate);
      });
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'กำลังโหลด...');
    getunit();
  }

  Future<void> getunit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(dotenv.env['api_url'] + 'unit');

    String token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      // // Authorize Header
      "Authorization": "bearer $token",
    };

    await http
        .get(
      url, //Edit url
      headers: headers,
    )
        .then((response) {
      if (response.statusCode == 200) {
        unit = unitFromJson(response.body);
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError('Error');
        throw Exception('Failed to load orders');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Niku(
      NikuButton(
        NikuStack(
          [
            Text(widget.items.date)
                .asNiku()
                .color(Colors.white)
                .fontSize(16.sp)
                .niku()
              ..positioned(left: 15.w),
            Text('${widget.items.fertilizerType} (${widget.items.time})')
                .asNiku()
                .color(Colors.white)
                .fontSize(16.sp)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(180.w)
              ..positioned(left: 100.w, top: 11.h),
            Text('${widget.items.amount} ${widget.items.unitEng}')
                .asNiku()
                .color(Colors.white)
                .fontSize(16.sp)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(90.w)
              ..positioned(left: 320.w, top: 15.h),
          ],
        ).center(),
      )..onPressed(() async {
          selectedDate = DateTime.now();
          _dateController.text = DateFormat.yMd('th').format(selectedDate);
          String unit_id = widget.items.unitId;
          double number = widget.items.amount.toDouble();
          TextEditingController numberController = TextEditingController();
          numberController.text = widget.items.amount.toString();

          Alert(
              context: context,
              title: "${widget.items.fertilizerType} (${widget.items.time})",
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return NikuColumn(
                  [
                    NikuRow([
                      Text('วันที่')
                          .asNiku()
                          .fontSize(15)
                          .niku()
                          .pb(14.h)
                          .mr(60.w)
                          .ml(15.w),
                      NikuButton(
                        Niku(
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(bottom: 15.h)),
                          ),
                        )
                            .niku()
                            .align(Alignment.center)
                            .width(100.w)
                            .height(30.h)
                            .boxDecoration(
                                BoxDecoration(color: Colors.grey[300])),
                      ).onPressed(() {
                        _selectDate(context);
                      }),
                    ]),
                    NikuRow(
                      [
                        Text('จำนวน')
                            .asNiku()
                            .fontSize(15)
                            .niku()
                            .mr(10.w)
                            .pb(11.h),
                        TextField(
                          controller: numberController,
                          onChanged: (value) {
                            setState(
                              () {
                                number = double.parse(value);
                                numberController.text =
                                    number.toInt().toString();
                              },
                            );
                          },
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Container(
                              transform: Matrix4.translationValues(-4, -2, 0.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(
                                    () {},
                                  );
                                },
                              ),
                            ),
                            suffixIcon: Container(
                              transform: Matrix4.translationValues(4, -2, 0.0),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      number = number + 1;
                                      numberController.text =
                                          number.toInt().toString();
                                    });
                                  }),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.r)),
                            ),
                          ),
                        ).niku().height(35.h).width(130.w),
                      ],
                    ).niku().pl(15.w).pr(20.w).mt(10.h),
                    NikuColumn(
                      [
                        SmartSelect<String>.single(
                            title: 'หน่วย',
                            placeholder: 'กรุณาเลือก',
                            value: unit_id,
                            tileBuilder: (context, state) {
                              return S2Tile(
                                title: state.titleWidget,
                                value: state.valueDisplay,
                                onTap: state.showModal,
                                isLoading: unit.length <= 0,
                                loadingText: 'รอข้อมูล',
                              );
                            },
                            choiceItems: S2Choice.listFrom<String, Unit>(
                              source: unit,
                              value: (index, item) => item.unitId,
                              title: (index, item) =>
                                  '${item.unitEng} (${item.unitTh})',
                            ),
                            onChange: (state) {
                              setState(() {
                                unit_id = state.value;
                              });
                            }),
                      ],
                    )
                  ],
                );
              }),
              buttons: [
                DialogButton(
                  onPressed: () => {
                    Provider.of<Grows>(context, listen: false).addTake(
                        '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                        widget.items.fertilizerId,
                        widget.items.fertilizerType,
                        unit_id,
                        number.toInt(),
                        widget.pd_id),
                    Provider.of<ProblemTakes>(context, listen: false)
                        .loadProblemTakes(widget.pd_id),
                    Navigator.pop(context),
                  },
                  child: Text(
                    "ยืนยัน",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.green,
                ),
                DialogButton(
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                  child: Text(
                    "ปิด",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.orange[400],
                ),
              ]).show();
        }),
    )
        .height(50.h)
        .boxDecoration(BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
          color: Colors.deepOrange[300],
        ))
        .ml(10.w)
        .mr(10.w)
        .mb(10.h);
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
                .fontSize(14.sp)
                .niku()
              ..positioned(left: 15.w),
            Icon(
              Icons.warning,
              color: Colors.yellow[700],
              size: 20,
            ).niku()
              ..positioned(left: 100.w, top: 11.h),
            Text('${widget.items?.problemsData ?? 'null'}')
                .asNiku()
                .color(Colors.blue)
                .fontSize(14.sp)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(230.w)
              ..positioned(left: 120.w, top: 11.h),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.blue,
              size: 20.sp,
            ).niku()
              ..positioned(left: 350.w),
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
                  onPressed: () {
                    Navigator.pop(context);

                    selectedDate = DateTime.parse(DateFormat("dd/MM/yyyy")
                        .parse(widget.items.date)
                        .toString()); //widget.items.date

                    selectedDate = DateTime(selectedDate.year - 543,
                        selectedDate.month, selectedDate.day);

                    _dateController.text =
                        DateFormat.yMd('th').format(selectedDate);

                    String solving = widget.items.solvingData;
                    String problem = widget.items.problemsData;

                    String area = widget.items.areaId;
                    double number = widget.items.number.toDouble();
                    TextEditingController numberController =
                        TextEditingController();
                    TextEditingController problemOther =
                        TextEditingController();
                    TextEditingController solvingOther =
                        TextEditingController();
                    problemOther.text = widget.items.problemsData;
                    solvingOther.text = widget.items.solvingData;
                    numberController.text = widget.items.number.toString();

                    Alert(
                      context: context,
                      title: 'แก้ไขปัญหา',
                      content: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return NikuColumn(
                            [
                              NikuRow([
                                Text('วันที่')
                                    .asNiku()
                                    .fontSize(15)
                                    .niku()
                                    .pb(14)
                                    .mr(60)
                                    .ml(15),
                                NikuButton(
                                  Niku(
                                    TextFormField(
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _dateController,
                                      decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          contentPadding:
                                              EdgeInsets.only(bottom: 15)),
                                    ),
                                  )
                                      .niku()
                                      .align(Alignment.center)
                                      .width(100)
                                      .height(30)
                                      .boxDecoration(BoxDecoration(
                                          color: Colors.grey[300])),
                                ).onPressed(() {
                                  _selectDate(context);
                                }),
                              ]),
                              Consumer(
                                builder: (BuildContext context,
                                    Problems problemss, Widget child) {
                                  List<Problem> problemsItem = problemss.items;
                                  List<Solving> problemsSolving = [];
                                  List<Solving> solvingItem = [];
                                  bool chackproblemsItem = false;

                                  problemsItem.forEach((element) {
                                    if (element.problemsName == problem) {
                                      chackproblemsItem = true;
                                    }
                                  });

                                  if (problem != '' && chackproblemsItem) {
                                    solvingItem = (problemsItem.firstWhere(
                                            (data) =>
                                                data.problemsName == problem))
                                        .solving;

                                    if (solvingItem.every(
                                        (data) => data.name != 'อื่นๆ')) {
                                      solvingItem.add(Solving(
                                          unitId: '',
                                          name: 'อื่นๆ',
                                          amount: 0));
                                    }
                                  } else if (problemsItem.isNotEmpty) {
                                    problem = 'อื่นๆ';
                                    //error
                                    solvingItem = (problemsItem.firstWhere(
                                        (data) => data.problemsName == problem,
                                        orElse: () => null))?.solving;

                                    if (solvingItem != null &&
                                        solvingItem.every(
                                            (data) => data.name != 'อื่นๆ')) {
                                      solvingItem.add(Solving(
                                          unitId: '',
                                          name: 'อื่นๆ',
                                          amount: 0));
                                    } else {
                                      solvingItem = [];
                                      solvingItem.add(Solving(
                                          unitId: '',
                                          name: 'อื่นๆ',
                                          amount: 0));
                                    }
                                  }

                                  bool chacksolvingItem = true;
                                  if (solvingItem != null) {
                                    solvingItem.forEach((element) {
                                      if (element.name == solving) {
                                        chacksolvingItem = false;
                                      }
                                    });
                                  }

                                  if (chacksolvingItem) {
                                    solving = 'อื่นๆ';
                                  }

                                  problemsItem.forEach((element) {
                                    element.solving.forEach((element2) {
                                      if (problemsSolving == null) {
                                        problemsSolving.add(element2);
                                      } else if (problemsSolving.every(
                                          (solving) => solving != element2)) {
                                        problemsSolving.add(element2);
                                      }
                                    });
                                  });

                                  if (problemsItem.every(
                                      (data) => data.problemsName != 'อื่นๆ')) {
                                    problemsItem.add(Problem(
                                      problemsName: 'อื่นๆ',
                                      solving: problemsSolving,
                                      problemsId: '',
                                      id: 999,
                                    ));
                                  }

                                  return NikuColumn(
                                    [
                                      SmartSelect<String>.single(
                                          title: 'ปัญหา',
                                          placeholder: 'กรุณาเลือก',
                                          value: problem,
                                          choiceItems: S2Choice.listFrom<String,
                                              Problem>(
                                            source: problemsItem,
                                            value: (index, item) =>
                                                item.problemsName,
                                            title: (index, item) =>
                                                item.problemsName,
                                          ),
                                          onChange: (state) {
                                            setState(() {
                                              if (state.value != '') {
                                                solvingItem = (problemsItem
                                                    .firstWhere((data) =>
                                                        data.problemsName ==
                                                        state.value)).solving;
                                                if (solvingItem.every((data) =>
                                                    data.name != 'อื่นๆ')) {
                                                  solvingItem.add(Solving(
                                                      unitId: '',
                                                      name: 'อื่นๆ',
                                                      amount: 0));
                                                }
                                              }

                                              problem = state.value;
                                            });
                                          }),
                                      Visibility(
                                        visible: problem == 'อื่นๆ',
                                        child: Niku(
                                          TextField(
                                            controller: problemOther,
                                            onChanged: (value) {
                                              setState(
                                                () {},
                                              );
                                            },
                                            keyboardType: TextInputType.text,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                          visible: solvingItem != null,
                                          child: SmartSelect<String>.single(
                                              title: 'วิธีแก้',
                                              placeholder: 'กรุณาเลือก',
                                              value: solving ?? null,
                                              tileBuilder: (context, state) {
                                                return S2Tile(
                                                  title: state.titleWidget,
                                                  value: state.valueDisplay,
                                                  onTap: state.showModal,
                                                  isLoading:
                                                      solvingItem.length < 1,
                                                  loadingText: 'รอเลือกปัญหา',
                                                );
                                              },
                                              choiceItems: S2Choice.listFrom<
                                                  String, Solving>(
                                                source: solvingItem,
                                                value: (index, item) =>
                                                    item.name,
                                                title: (index, item) =>
                                                    item.name,
                                                subtitle: (index, item) {
                                                  return '${item.amount}';
                                                },
                                              ),
                                              onChange: (state) => setState(
                                                  () => {
                                                        solving = state.value
                                                      }))),
                                      Visibility(
                                        visible: solving == 'อื่นๆ',
                                        child: Niku(
                                          TextField(
                                            controller: solvingOther,
                                            onChanged: (value) {
                                              setState(
                                                () {},
                                              );
                                            },
                                            keyboardType: TextInputType.text,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Consumer(
                                builder: (BuildContext context, Areas areas,
                                    Widget child) {
                                  return SmartSelect<String>.single(
                                    title: 'พื้นที่',
                                    placeholder: 'กรุณาเลือก',
                                    value: area,
                                    modalConfig: const S2ModalConfig(
                                      style: S2ModalStyle(
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            topRight: Radius.circular(15.0),
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
                                        margin: const EdgeInsets.fromLTRB(
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
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 40.0,
                                                    backgroundImage:
                                                        NetworkImage(choice
                                                            .meta.areaPhoto),
                                                    child: choice.selected
                                                        ? Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                          )
                                                        : null,
                                                  ),
                                                  Column(
                                                    children: [
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
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    choiceItems:
                                        S2Choice.listFrom<String, Area>(
                                      source: areas.items,
                                      value: (index, item) => item.areaId,
                                      title: (index, item) => item.areaName,
                                      meta: (index, item) => item,
                                      hidden: (index, item) {
                                        bool a = true;
                                        widget.area_id.forEach((element) {
                                          if (item.areaId == element) {
                                            a = false;
                                          }
                                        });

                                        return a;
                                      },
                                      subtitle: (index, item) {
                                        return '';
                                      },
                                    ),
                                    onChange: (state) {
                                      setState(() {
                                        area = state.value;
                                      });
                                    },
                                    modalFilter: true,
                                    modalFilterAuto: true,
                                    modalFilterHint: 'ค้นหา',
                                    modalType: S2ModalType.bottomSheet,
                                  );
                                },
                              ),
                              NikuRow(
                                [
                                  Text('จำนวนผัก')
                                      .asNiku()
                                      .fontSize(15)
                                      .niku()
                                      .mr(10),
                                  TextField(
                                    controller: numberController,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          number = double.parse(value);
                                          numberController.text =
                                              number.toInt().toString();
                                        },
                                      );
                                    },
                                    keyboardType: TextInputType.number,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      prefixIcon: Container(
                                        transform: Matrix4.translationValues(
                                            -4, -2, 0.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.remove_circle,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            setState(
                                              () {
                                                number = number - 1;
                                                numberController.text =
                                                    number.toInt().toString();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      suffixIcon: Container(
                                        transform: Matrix4.translationValues(
                                            4, -2, 0.0),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.add_circle,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                number = number + 1;
                                                numberController.text =
                                                    number.toInt().toString();
                                              });
                                            }),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                    ),
                                  ).niku().height(35).width(120),
                                  Text('ต้น').asNiku().fontSize(15).ml(5).mr(5)
                                ],
                              ).niku().pl(15).pr(20),
                            ],
                          );
                        },
                      ).niku().width(600),
                      buttons: [
                        DialogButton(
                          child: Text("ยืนยัน")
                              .asNiku()
                              .color(Colors.white)
                              .fontSize(20),
                          onPressed: () {
                            Provider.of<ProblemTakes>(context, listen: false)
                                .updateProblem(
                                    widget.pd_id,
                                    selectedDate.toString(),
                                    problem == 'อื่นๆ'
                                        ? problemOther.text
                                        : problem,
                                    solving == 'อื่นๆ'
                                        ? solvingOther.text
                                        : solving,
                                    area,
                                    number.toInt(),
                                    widget.items.index);

                            Provider.of<ProblemTakes>(context, listen: false)
                                .loadProblemTakes(widget.pd_id);
                            Navigator.pop(context);
                          },
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),
                        DialogButton(
                          child: Text("ยกเลิก")
                              .asNiku()
                              .color(Colors.white)
                              .fontSize(20),
                          onPressed: () => Navigator.pop(context),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(116, 116, 191, 1.0),
                            Color.fromRGBO(52, 138, 199, 1.0)
                          ]),
                        )
                      ],
                    ).show();
                  },
                  color: Colors.yellow[700],
                  radius: BorderRadius.circular(100),
                  width: 150,
                  child: Text(
                    "แก้ไข",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ]).show();
        }),
    )
        .height(50.h)
        .boxDecoration(BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
          color: Colors.white,
        ))
        .ml(10.w)
        .mr(10.w)
        .mb(10.h);
  }
}

class Addproblems extends StatefulWidget {
  final List area_id;
  final String pd_id;

  Addproblems(this.area_id, this.pd_id);

  @override
  _AddproblemsState createState() => _AddproblemsState();
}

class _AddproblemsState extends State<Addproblems> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        locale: Locale("th", "TH"),
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd('th').format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Niku(
      NikuButton(
        Center(
          child: Icon(
            Icons.control_point,
            size: 45.0.sp,
            color: Colors.blue,
          ),
        ),
      )..onPressed(() async {
          selectedDate = DateTime.now();
          _dateController.text = DateFormat.yMd('th').format(selectedDate);
          List<Solving> solvingItem = [];
          String solving = '';
          String problem = '';
          String area = '';
          double number = 0;
          TextEditingController numberController = TextEditingController();
          TextEditingController problemOther = TextEditingController();
          TextEditingController solvingOther = TextEditingController();
          problemOther.text = '';
          solvingOther.text = '';
          numberController.text = '0';
          Alert(
            context: context,
            title: 'เพิ่มปัญหา',
            content: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return NikuColumn(
                  [
                    NikuRow([
                      Text('วันที่')
                          .asNiku()
                          .fontSize(15)
                          .niku()
                          .pb(14.h)
                          .mr(60.w)
                          .ml(15.w),
                      NikuButton(
                        Niku(
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(bottom: 15.h)),
                          ),
                        )
                            .niku()
                            .align(Alignment.center)
                            .width(100.w)
                            .height(30.h)
                            .boxDecoration(
                                BoxDecoration(color: Colors.grey[300])),
                      ).onPressed(() {
                        _selectDate(context);
                      }),
                    ]),
                    Consumer(
                      builder: (BuildContext context, Problems problems,
                          Widget child) {
                        List<Problem> problemsItem = problems.items;
                        List<Solving> problemsSolving = [];

                        problemsItem.forEach((element) {
                          element.solving.forEach((element2) {
                            if (problemsSolving == null) {
                              problemsSolving.add(element2);
                            } else if (problemsSolving
                                .every((solving) => solving != element2)) {
                              problemsSolving.add(element2);
                            }
                          });
                        });

                        if (problemsItem
                            .every((data) => data.problemsName != 'อื่นๆ')) {
                          problemsItem.add(Problem(
                            problemsName: 'อื่นๆ',
                            solving: problemsSolving,
                            problemsId: '',
                            id: null,
                          ));
                        }

                        return NikuColumn(
                          [
                            SmartSelect<String>.single(
                                title: 'ปัญหา',
                                placeholder: 'กรุณาเลือก',
                                value: problem,
                                choiceItems: S2Choice.listFrom<String, Problem>(
                                  source: problemsItem,
                                  value: (index, item) => item.problemsName,
                                  title: (index, item) => item.problemsName,
                                ),
                                onChange: (state) {
                                  setState(() {
                                    if (state.value != '') {
                                      solvingItem = (problemsItem.firstWhere(
                                          (data) =>
                                              data.problemsName ==
                                              state.value)).solving;
                                      if (solvingItem.every(
                                          (data) => data.name != 'อื่นๆ')) {
                                        solvingItem.add(Solving(
                                            unitId: '',
                                            name: 'อื่นๆ',
                                            amount: 0));
                                      }
                                    }

                                    problem = state.value;
                                  });
                                }),
                            Visibility(
                              visible: problem == 'อื่นๆ',
                              child: Niku(
                                TextField(
                                  controller: problemOther,
                                  onChanged: (value) {
                                    setState(
                                      () {},
                                    );
                                  },
                                  keyboardType: TextInputType.text,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SmartSelect<String>.single(
                                title: 'วิธีแก้',
                                placeholder: 'กรุณาเลือก',
                                value: solving,
                                tileBuilder: (context, state) {
                                  return S2Tile(
                                    title: state.titleWidget,
                                    value: state.valueDisplay,
                                    onTap: state.showModal,
                                    isLoading: solvingItem.length < 1,
                                    loadingText: 'รอเลือกปัญหา',
                                  );
                                },
                                choiceItems: S2Choice.listFrom<String, Solving>(
                                  source: solvingItem,
                                  value: (index, item) => item.name,
                                  title: (index, item) => item.name,
                                  subtitle: (index, item) {
                                    return '${item.amount}';
                                  },
                                ),
                                onChange: (state) =>
                                    setState(() => solving = state.value)),
                            Visibility(
                              visible: solving == 'อื่นๆ',
                              child: Niku(
                                TextField(
                                  controller: solvingOther,
                                  onChanged: (value) {
                                    setState(
                                      () {},
                                    );
                                  },
                                  keyboardType: TextInputType.text,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Consumer(
                      builder:
                          (BuildContext context, Areas areas, Widget child) {
                        return SmartSelect<String>.single(
                          title: 'พื้นที่',
                          placeholder: 'กรุณาเลือก',
                          value: area,
                          modalConfig: const S2ModalConfig(
                            style: S2ModalStyle(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                              ),
                            ),
                            headerStyle: S2ModalHeaderStyle(
                              centerTitle: true,
                            ),
                          ),
                          choiceLayout: S2ChoiceLayout.list,
                          choiceBuilder: (context, choice, searchText) {
                            return Card(
                              margin: const EdgeInsets.all(5),
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
                                child: SizedBox(
                                  width: 100.w,
                                  height: 100.h,
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 40.0.r,
                                          backgroundImage: NetworkImage(
                                              choice.meta.areaPhoto),
                                          child: choice.selected
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        Column(
                                          children: [
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
                                        ).niku().pl(30.w).pt(25.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          choiceItems: S2Choice.listFrom<String, Area>(
                            source: areas.items,
                            value: (index, item) => item.areaId,
                            title: (index, item) => item.areaName,
                            meta: (index, item) => item,
                            hidden: (index, item) {
                              bool a = true;
                              widget.area_id.forEach((element) {
                                if (item.areaId == element) {
                                  a = false;
                                }
                              });

                              return a;
                            },
                            subtitle: (index, item) {
                              return '';
                            },
                          ),
                          onChange: (state) {
                            setState(() {
                              area = state.value;
                            });
                          },
                          modalFilter: true,
                          modalFilterAuto: true,
                          modalFilterHint: 'ค้นหา',
                          modalType: S2ModalType.bottomSheet,
                        );
                      },
                    ),
                    NikuRow(
                      [
                        Text('จำนวนผัก').asNiku().fontSize(15).niku().mr(10),
                        TextField(
                          controller: numberController,
                          onChanged: (value) {
                            setState(
                              () {
                                number = double.parse(value);
                                numberController.text =
                                    number.toInt().toString();
                              },
                            );
                          },
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Container(
                              transform: Matrix4.translationValues(-4, -2, 0.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      number = number - 1;
                                      numberController.text =
                                          number.toInt().toString();
                                    },
                                  );
                                },
                              ),
                            ),
                            suffixIcon: Container(
                              transform: Matrix4.translationValues(4, -2, 0.0),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      number = number + 1;
                                      numberController.text =
                                          number.toInt().toString();
                                    });
                                  }),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ).niku().height(35).width(120),
                        Text('ต้น').asNiku().fontSize(15).ml(5).mr(5)
                      ],
                    ).niku().pl(15).pr(20),
                  ],
                );
              },
            ).niku().width(600),
            buttons: [
              DialogButton(
                child: Text("บันทึก").asNiku().color(Colors.white).fontSize(20),
                onPressed: () {
                  Provider.of<ProblemTakes>(context, listen: false).addProblem(
                      widget.pd_id,
                      selectedDate.toString(),
                      problem == 'อื่นๆ' ? problemOther.text : problem,
                      solving == 'อื่นๆ' ? solvingOther.text : solving,
                      area,
                      number.toInt());

                  Provider.of<ProblemTakes>(context, listen: false)
                      .loadProblemTakes(widget.pd_id);
                  Navigator.pop(context);
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
              DialogButton(
                child: Text("ยกเลิก").asNiku().color(Colors.white).fontSize(20),
                onPressed: () => Navigator.pop(context),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(116, 116, 191, 1.0),
                  Color.fromRGBO(52, 138, 199, 1.0)
                ]),
              )
            ],
          ).show();
        }).bg(Colors.white),
    )
        .boxDecoration(BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
        ))
        .ml(10)
        .mr(10)
        .mb(10);
  }
}

class AddpdWidget extends StatefulWidget {
  final ProblemTake items;
  final String pd_id;

  AddpdWidget(this.items, this.pd_id);

  @override
  _AddpdWidgetState createState() => _AddpdWidgetState();
}

class _AddpdWidgetState extends State<AddpdWidget> {
  File uploadimage;

  @override
  Widget build(BuildContext context) {
    return Niku(
      NikuButton(
        NikuStack(
          [
            Text(widget.items.date)
                .asNiku()
                .color(Colors.white)
                .fontSize(14.sp)
                .niku()
              ..positioned(left: 15.w),
            Icon(
              Icons.watch_later,
              color: Colors.white,
              size: 24.sp,
            ).niku()
              ..positioned(left: 100.w),
            Text('${widget.items.data}')
                .asNiku()
                .color(Colors.white)
                .fontSize(14.sp)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(180.w)
              ..positioned(left: 125.w, top: 11.h),
            Text('ยืนยัน')
                .asNiku()
                .color(Colors.white)
                .fontSize(14.sp)
                .softWrap(false)
                .overflow(TextOverflow.fade)
                .niku()
                .width(90.w)
              ..positioned(left: 320.w, top: 11.h),
          ],
        ).center(),
      )..onPressed(() {
          Alert(
              context: context,
              title: "${widget.items?.data ?? 'null'}",
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                Future<void> chooseImageC() async {
                  XFile choosedimage =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  //set source: ImageSource.camera to get image from camera
                  setState(() {
                    uploadimage = File(choosedimage?.path);
                  });
                }

                Future<void> chooseImageG() async {
                  XFile choosedimage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  //set source: ImageSource.camera to get image from camera
                  setState(() {
                    uploadimage = File(choosedimage?.path);
                  });
                }

                return NikuColumn([
                  uploadimage == null
                      ? NikuColumn([
                          Text('ไม่มีรูปภาพ').asNiku().fontSize(16).mb(5).mt(5),
                          Image.network(
                                  'https://s3-ap-southeast-1.amazonaws.com/wpimages.mover.in.th/wp-content/uploads/2019/05/28154928/Screen-Shot-2562-05-28-at-15.48.49.png')
                              .niku()
                              .maxHeight(200)
                              .maxWidth(200)
                        ])
                      : Image.file(uploadimage)
                          .niku()
                          .maxHeight(200)
                          .maxWidth(200),
                  NikuRow([
                    DialogButton(
                      onPressed: () => chooseImageC(),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.white,
                      ),
                      color: Colors.green[400],
                    ),
                    DialogButton(
                      onPressed: () => chooseImageG(),
                      child: Icon(
                        Icons.collections_outlined,
                        color: Colors.white,
                      ),
                      color: Colors.red[400],
                    ),
                  ]).mainAxisAlignment(MainAxisAlignment.center)
                ]);
              }),
              buttons: [
                DialogButton(
                  onPressed: () => {
                    Grows().photoGrow(
                        uploadimage, widget.pd_id, widget.items?.type),
                    Provider.of<ProblemTakes>(context, listen: false)
                        .loadProblemTakes(widget.pd_id),
                    setState(() {
                      uploadimage = null;
                    }),
                    Navigator.pop(context),
                  },
                  child: Text(
                    "ยืนยัน",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.green,
                ),
                DialogButton(
                  onPressed: () => {
                    setState(() {
                      uploadimage = null;
                    }),
                    Navigator.pop(context),
                  },
                  child: Text(
                    "ปิด",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.orange[400],
                ),
              ]).show();
        }),
    )
        .height(50.h)
        .boxDecoration(BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
          color: Colors.orange[400],
        ))
        .ml(10.w)
        .mr(10.w)
        .mb(10.h);
  }
}
