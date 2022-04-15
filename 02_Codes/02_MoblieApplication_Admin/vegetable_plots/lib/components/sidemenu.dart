import 'package:flutter/material.dart';
import 'package:niku/niku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String _name;
  String _photo;
  void initState() {
    super.initState();
    getName();
  }

  Future<void> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name');
    final String photo = prefs.getString('photo');

    setState(() {
      _name = name;
      _photo = photo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Colors.blue[300],
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: NikuStack([
              CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(_photo != null
                    ? _photo
                    : "https://image.sistacafe.com/images/uploads/summary/image/81105/pexels-tranmautritam-2286016.jpg"),
                backgroundColor: Colors.white,
              ),
              // Positioned(
              //   bottom: 5,
              //   child: Text('ชื่อ : แมว น่ารัก')
              //       .asNiku()
              //       .fontWeight(FontWeight.bold)
              //       .color(Colors.white),
              // ),
              Positioned(
                bottom: 25,
                child: Text('$_name')
                    .asNiku()
                    .fontWeight(FontWeight.bold)
                    .color(Colors.white),
              )
            ]).topCenter(),
          ),
          ListTile(
            leading: Icon(Icons.work_outline, color: Colors.redAccent[400]),
            title: Text('บันทึกการปลูกผัก'),
            onTap: () {
              Navigator.pushNamed(context, '/HOME');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart_outlined,
                color: Colors.redAccent[400]),
            title: Text('คำสั่งซื้อ'),
            onTap: () {
              Navigator.pushNamed(context, '/Order');
            },
          ),
          ListTile(
            leading:
                Icon(Icons.location_on_outlined, color: Colors.redAccent[400]),
            title: Text('พื้นที่'),
            onTap: () {
              Navigator.pushNamed(context, '/Area');
            },
          ),
          ListTile(
            leading:
                Icon(Icons.watch_later_outlined, color: Colors.redAccent[400]),
            title: Text('ผักที่ปลูกปัจจุบัน'),
            onTap: () {
              Navigator.pushNamed(context, '/Current_v');
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Colors.redAccent[400]),
            title: Text('แจ้งเตือน'),
            onTap: () {
              Navigator.pushNamed(context, '/Notification');
            },
          ),
          ListTile(
            leading: Icon(Icons.update, color: Colors.redAccent[400]),
            title: Text('ประวัติการปลูก'),
            onTap: () {
              Navigator.pushNamed(context, '/History');
            },
          ),
          Divider(),
          Align(
            alignment: Alignment.bottomLeft,
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent[400]),
              title: Text('ออกจากระบบ'),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushNamed(context, '/LOGIN');
              },
            ),
          ),
        ],
      ),
    );
  }
}
