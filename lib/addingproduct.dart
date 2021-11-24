import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutlersemester7/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';

class AddingProductPage extends StatefulWidget {
  const AddingProductPage ({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<AddingProductPage> {
  //initialization code
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('product');
  final _formkey = GlobalKey<FormState>(); //formkey
  final TextEditingController nameController = new TextEditingController();  //controller
  final TextEditingController priceController = new TextEditingController();  //controller
  final TextEditingController descriptionController = new TextEditingController(); //controller
  final TextEditingController idController = new TextEditingController();
  File? image;
  final imagePicker = ImagePicker();
  String? fileName;
  String? downloadURL;
  

  //image picker
  Future pickImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      if (pick != null){
        image = File(pick.path);
      }
    });
  }

  //uploading the image, then getting the download url and then
  //adding that download url to our cloud Firestore
  Future uploadImageToFirebaseStorage() async {
    fileName = basename(image!.path);
    Reference ref = FirebaseStorage.instance.ref().child('product/$fileName');
    UploadTask uploadTask = ref.putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    downloadURL = await snapshot.ref.getDownloadURL();
    postDetailsToFirestore();
    // print(downloadURL); //url will be show on terminal
  }

  //send details (productname, productprice, url) to firestore
  void postDetailsToFirestore() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    ProductModel productModel = ProductModel(url: '');

    //writing all the values
    productModel.name = nameController.text;
    productModel.price = int.tryParse(priceController.text);
    productModel.id = idController.text;
    productModel.description = descriptionController.text;
    productModel.url = downloadURL!;

    await collectionReference.doc(idController.text).set(productModel.toMap());

    Fluttertoast.showToast(msg: "Product added successfully!");
    
  }

  @override
  Widget build(BuildContext context) {
    //showing snackbar
    showSnackBar(String snackText, Duration d){
      final snackBar = SnackBar(content: Text(snackText), duration: d);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(-5, 0),
                blurRadius: 15,
                spreadRadius: 3)
            ]
          ),
          width: double.infinity,
          height: 450,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 160,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          autofocus: false,
                          controller: idController,
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.poppins(),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(hintText: "Id"),
                          validator: (value){
                            if(value!.isEmpty){
                              return ("Id of Product cannot be empty");
                            }
                            return null;
                          },
                          onSaved: (value){
                            idController.text = value!;
                          },
                        ),

                        TextFormField(
                          autofocus: false,
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.poppins(),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(hintText: "Name"),
                          validator: (value) {
                            if(value!.isEmpty){
                              return ("Name of Product cannot be empty");
                            }
                            return null;
                          },
                          onSaved: (value){
                            nameController.text = value!;
                          },
                        ),

                        TextFormField(
                          autofocus: false,
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.poppins(),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(hintText: "Price"),
                          validator: (value){
                            if(value!.isEmpty){
                              return ("Price of Product cannot be empty!");
                            }
                          },
                          onSaved: (value){
                            priceController.text = value!;
                          },
                        ), 

                        TextFormField(
                          autofocus: false,
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.poppins(),
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          decoration: InputDecoration(hintText: "Description"),
                          validator: (value){
                            if(value!.isEmpty){
                              return ("Description of Product cannot be empty");
                            }
                          },
                          onSaved: (value){
                            descriptionController.text = value!;
                          },
                        ),
                        
                        SizedBox(
                          height: 15,
                        ),

                        (image != null)
                        ? Image.file(
                          image!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )

                        : Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text("No image Selected", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold)),
                          
                        ),

                      
                        SizedBox(
                          height: 5,
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: ElevatedButton.icon(
                                label: Text("Select", textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                                icon: Icon(MdiIcons.imagePlus),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.greenAccent, // background color
                                  onPrimary: Colors.white, // foreground color
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  pickImage();
                                },
                              ),
                            ),

                          ],
                        ),
                      ], 
                    ),
                ), 
              ),
             
              Container(
                height: 450,
                width: 130,
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.blueAccent,
                  child: Text("Add Product", style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                  onPressed: () {
                    if( idController.text.isNotEmpty && nameController.text.isNotEmpty && priceController.text.isNotEmpty && descriptionController.text.isNotEmpty && image != null){
                      uploadImageToFirebaseStorage().whenComplete(() => showSnackBar("Image has been added into storage successfully. ", Duration(milliseconds: 500)));
                      Fluttertoast.showToast(msg: "Product has been added successfully." );
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AddingProductPage()), (route) => false);
                    }else{
                      Fluttertoast.showToast(msg: "Id, Name, Price, and Description cannot be empty, image must be selected", textColor: Colors.red);
                    }
                  },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}