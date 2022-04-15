import 'dart:convert';

import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:niku/niku.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LOGIN extends StatefulWidget {
  const LOGIN({Key key}) : super(key: key);

  @override
  _LOGINState createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {
  bool checkedValue = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Future login(String username, String password, bool checkedValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    EasyLoading.show(status: 'กำลังโหลด...');

    var url = Uri.parse(dotenv.env['api_url'] + 'signin');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
    };
    await http
        .post(
      url, //Edit url
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
        'key': checkedValue,
      }),
    )
        .then((response) async {
      // print(response.statusCode);
      if (response.statusCode == 201) {
        //Code for status 201
        EasyLoading.showSuccess(jsonDecode(response.body)['message']);
        prefs.setString('username', username);
        prefs.setString('token', jsonDecode(response.body)['accessToken']);
        prefs.setString('name',
            '${jsonDecode(response.body)['user']['fm_name']} ${jsonDecode(response.body)['user']['fm_lname']}');
        prefs.setString(
            'photo', '${jsonDecode(response.body)['user']['photo']}');
        Navigator.pushReplacementNamed(context, '/HOME');
      } else if (response.statusCode == 401) {
        EasyLoading.showError(response.body);
      } else {
        EasyLoading.showError('Error');
        throw Exception('Failed to load orders');
      }
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getid();
    setState(() {
      username.text = '';
    });
  }

  Future getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await prefs.getString('token');

    if (token != null) {
      EasyLoading.show(status: 'กำลังโหลด...');
      var url = Uri.parse(dotenv.env['api_url'] + 'farmers');
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-type": "application/json",
        "Authorization": "bearer $token",
      };

      await http
          .get(
        url, //Edit url
        headers: headers,
      )
          .then((response) async {
        // print(response.statusCode);
        if (response.statusCode == 200) {
          //Code for status 201
          Navigator.pushReplacementNamed(context, '/HOME');
        } else if (response.statusCode == 401) {
          EasyLoading.showSuccess('ล็อคอินสำเร็จ');
        } else {
          EasyLoading.showError('กรุณาล็อคอินใหม่');
          //throw Exception('Failed to load orders');
        }
      }).catchError((error) {
        if (error) {
          EasyLoading.showError('error');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NikuStack(
        [
          Stack(
            children: <Widget>[
              Pinned.fromPins(
                Pin(start: 0.0, end: 0.0),
                Pin(start: 0.0, end: 14.0),
                child: SvgPicture.string(
                  '<svg viewBox="0.0 473.0 360.5 157.6" ><path transform="translate(0.0, -14.0)" d="M 0 487 C 241.2734375 598.06005859375 360.5128173828125 553.3452758789063 360.5128173828125 553.3452758789063 L 360.5128173828125 644.637939453125 L 0 644.637939453125 L 0 487 Z" fill="#bdf22e" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                  allowDrawingOutsideViewBox: true,
                  fit: BoxFit.fill,
                ),
              ),
              Pinned.fromPins(
                Pin(start: 0.0, end: 0.0),
                Pin(start: 45.9, end: 0.0),
                child: SvgPicture.string(
                  '<svg viewBox="0.0 518.9 360.5 125.8" ><path  d="M 0 518.8776245117188 C 219.8476104736328 593.4022216796875 360.5128173828125 518.8776245117188 360.5128173828125 518.8776245117188 L 360.5128173828125 644.637939453125 L 0 644.637939453125 L 0 518.8776245117188 Z" fill="#32d7c0" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                  allowDrawingOutsideViewBox: true,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ).niku().width(411.w).height(180.4.h)
            ..positioned(top: 639.6.h),
          CircleAvatar(
            backgroundImage: NetworkImage(
                    'http://www.sarakadee.com/blog/oneton/wp-content/uploads/2017/12/cat-cute-e1533862828469.jpg') ??
                '',
            radius: 70.h,
          ).niku()
            ..positioned(top: 73.8.h),
          Text('เข้าสู่ระบบ')
              .asNiku()
              .fontSize(30.sp)
              .fontWeight(FontWeight.bold)
              .niku()
              .positioned(top: 237.8.h),
          TextField(
            controller: username,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen, width: 1.w),
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0.r),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0.r),
                ),
              ),
              hintText: 'ชื่อผู้ใช้',
              hintStyle: TextStyle(fontSize: 18.sp),
              counterStyle: TextStyle(fontSize: 18.sp),
            ),
          ).niku().width(349.35.w).height(60.h)
            ..positioned(top: 311.6.h),
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen, width: 1.w),
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0.r),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0.r),
                ),
              ),
              hintText: 'รหัสผ่าน',
              hintStyle: TextStyle(fontSize: 18.sp),
              counterStyle: TextStyle(fontSize: 18.sp),
            ),
          ).niku().width(349.35.w).height(60.h)
            ..positioned(top: 377.2.h),
          NikuRow(
            [
              Checkbox(
                value: checkedValue,
                onChanged: (value) => setState(() => checkedValue = value),
              ),
              NikuButton(
                Text('บันทึกเข้าสู่ระบบ')
                    .asNiku()
                    .fontSize(14.sp)
                    .color(Colors.black)
                    .mb(10.h),
              ).onPressed(() {
                setState(() {
                  checkedValue = !checkedValue;
                });
              }).pt(10.h),
            ],
          ).niku()
            ..positioned(top: 435.h, left: 41.1.w),
          Niku()
              .boxDecoration(BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(100)))
              .height(10.h)
              .width(82.2.w)
            ..positioned(top: 483.8.h),
          Positioned(
            top: 533.h,
            child: NikuButton(Text('เข้าสู่ระบบ'))
              ..padding(EdgeInsets.fromLTRB(30.w, 3.h, 30.w, 10.h))
              ..rounded(100)
              ..fontSize(25.sp)
              ..fg(Colors.white)
              ..bg(Colors.blue)
              ..overlay(Colors.blue[600])
              ..onPressed(() {
                login(username.text, password.text, checkedValue);
                //Navigator.pushReplacementNamed(context, '/HOME');
              }),
          ),
        ],
      ).topCenter().niku().width(411.w).height(820.h),
    );
  }
}
