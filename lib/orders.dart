import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grouped_list/grouped_list.dart';


class CustomerOrder extends StatefulWidget {
  const CustomerOrder({Key? key}) : super(key: key);

  @override
  _CustomerOrderState createState() => _CustomerOrderState();
}

class _CustomerOrderState extends State<CustomerOrder> {
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text("Kevin"),
      ),
      body: StreamBuilder(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            return ListView(
              children: snapshot.data!.docs.map((e) => ListTile(
                title: Text(e['email']),
                subtitle: Text("Product: " + e['secondName'] + "    x  " + e[('firstName')] ),)).toList(),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
      
    );
  }



  Future getPosts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    
    return querySnapshot.docs;
  }
}
