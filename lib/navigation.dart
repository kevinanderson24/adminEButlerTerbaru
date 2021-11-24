import 'package:ebutlersemester7/orders.dart';
import 'package:ebutlersemester7/addingproduct.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ebutlersemester7/signup.dart';



class BottomNav extends StatefulWidget {
  const BottomNav ({ Key? key }) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<BottomNav> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    CustomerOrder(),
    AddingProductPage(),
    SignUp(),
  ];

  void onItemTap(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.clipboardList),
            title: Text("Orders"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text("Add Product"),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountPlus),
            title: Text("Sign Up"),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTap,
      ),
    );
  }
}