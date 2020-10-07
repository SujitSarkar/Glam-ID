import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/shared/FormDecoration.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ext_storage/ext_storage.dart';

class EditStudent extends StatefulWidget {
  final String name;
  final String roll;
  final String address;
  final String mobile;
  final String blood;
  final String email;
  final String photoUrl;
  final String orgName;
  final String photoName;

  EditStudent(
      {this.name,
      this.roll,
      this.address,
      this.mobile,
      this.blood,
      this.email,
      this.photoUrl,
      this.orgName,this.photoName});

  @override
  _EditStudentState createState() => _EditStudentState(
      this.name,
      this.roll,
      this.address,
      this.mobile,
      this.blood,
      this.email,
      this.photoUrl,
      this.orgName,
      this.photoName);
}

class _EditStudentState extends State<EditStudent> {
  String name;
  String roll;
  String address;
  String mobile;
  String blood;
  String email;
  String photoUrl;
  String orgName;
  String photoName;

  _EditStudentState(this.name, this.roll, this.address, this.mobile, this.blood,
      this.email, this.photoUrl, this.orgName, this.photoName);

  TextEditingController nameController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool loading = false;
  File imageFile;

  final pdf = pw.Document();
  static const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
  static const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
  static const PdfColor purple = PdfColor.fromInt(0x673AB7);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrivePreviousData();
  }

  void retrivePreviousData() {
    nameController = TextEditingController(text: name);
    rollController = TextEditingController(text: roll);
    addressController = TextEditingController(text: address);
    mobileController = TextEditingController(text: mobile);
    bloodController = TextEditingController(text: blood);
    emailController = TextEditingController(text: email);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 1.0, top: 5.0, right: 5.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        "Student Details",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.file_download,
                      color: Colors.white,
                    ),
                    onPressed: ()async{
                      writeOnPdf();
                      savePdf();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: loading
          ? Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    doubleBounce(),
                    Text(
                      "Updating Information, please wait",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              color: Colors.transparent,
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Column(
                        children: [
                          (imageFile == null)
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: cubeGrid(),
                                      width: 300.0,
                                      height: 300.0,
                                    ),
                                    width: 300.0,
                                    height: 300.0,
                                    imageUrl: photoUrl,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                )
                              : Material(
                                  child: Image.file(
                                    imageFile,
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                          RaisedButton(
                            onPressed: () {
                              takePhotoFromCamera();
                            },
                            color: Colors.deepPurple,
                            child: Text(
                              "Take Photo",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Name : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.grey[600])),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            controller: nameController,
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Name'),
                            onChanged: (value) {
                              setState(() => name = value);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Address : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.grey[600])),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            controller: addressController,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Address'),
                            onChanged: (value) {
                              setState(() => address = value);
                            },
                          ),

                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Blood Group : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.grey[600])),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.characters,
                            controller: bloodController,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Blood Group'),
                            onChanged: (value) {
                              setState(() => blood = value);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Mobile Number : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.grey[600])),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: mobileController,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Mobile Number'),
                            onChanged: (value) {
                              setState(() => mobile = value);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Email : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.grey[600])),
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Email'),
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  if(imageFile != null){
                                    setState(() => loading = true);
                                    uploadImageToForestoreAndStorage();
                                  }
                                  else{
                                    setState(() => loading = true);
                                    updateStudentData();
                                  }
                                },
                                color: Colors.green[800],
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              RaisedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                color: Colors.red[800],
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      )),
                ),
              ],
            ),
    );
  }

  Future takePhotoFromCamera() async {
    File newImageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (newImageFile != null) {
      setState(() {
        this.imageFile = newImageFile;
      });
    }
  }

  Future updateStudentData() async {
    Firestore.instance.collection(orgName).document(roll).updateData({
      "name": name,
      "address": address,
      "photoUrl": photoUrl,
      "blood group": blood,
      "email": email,
      "mobile": mobile,
      "org name": orgName,
      "photo name": photoName,
    }).then((data) async{
      setState(() => loading=false);
      Fluttertoast.showToast(msg: "Information Updated");
      Navigator.of(context).pop();

    },onError: (errorMgs){
      setState(() => loading=false);
      Fluttertoast.showToast(msg: errorMgs.toString());
      Navigator.of(context).pop();
    });
  }

  Future uploadImageToForestoreAndStorage() async {

    StorageReference storageReference =
    FirebaseStorage.instance.ref().child(orgName).child(photoName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    storageUploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;

        storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          photoUrl = newImageDownloadUrl;
          Firestore.instance.collection(orgName).document(roll).updateData({
            "name": name,
            "address": address,
            "photoUrl": photoUrl,
            "blood group": blood,
            "email": email,
            "mobile": mobile,
            "org name": orgName,
            "photo name": photoName,
          }).then((data) async {
            setState(() => loading = false);
            Fluttertoast.showToast(msg: "Information Updated");
            Navigator.of(context).pop();
          });
        }, onError: (errorMsg) {
          setState(() => loading = false);
          Fluttertoast.showToast(msg: errorMsg.toString());
          Navigator.of(context).pop();
        });
      }
    });
  }

  Future writeOnPdf() async{

    final image = PdfImage.file(
      pdf.document,
      bytes: File(photoUrl).readAsBytesSync(),
    );

    var data = await rootBundle.load("assets/OpenSans-Regular.ttf");
    var myFont = pw.Font.ttf(data);
    var myStyle = pw.TextStyle(font: myFont);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),

        build: (pw.Context context){
          return <pw.Widget>[

            pw.Header(
              level: 0,
              child: pw.Text(orgName),
            ),

            //pw.Image(image,alignment: pw.Alignment.center,width: 300,height: 300),

            pw.Paragraph(
                text: "Roll: $roll",style: myStyle
            ),
            pw.Paragraph(
              text: "Name: $name",style: myStyle
            ),
            pw.Paragraph(
                text: "Address: $address",style:myStyle
            ),
            pw.Paragraph(
                text: "Blood Group: $blood",style:myStyle
            ),
            pw.Paragraph(
                text: "Mobile Number: $mobile",style: myStyle
            ),
            pw.Paragraph(
                text: "Email: $email",style: myStyle
            ),

            pw.Footer(
                title: pw.Text(
                "Glamworld IT Ltd.",
                style: pw.TextStyle(
                  font: myFont,
                  color: purple,
                )
            ))
          ];
        },
        maxPages: 1,
      )
    );
  }

  Future savePdf() async{

    String stuRoll = roll;

    String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

    //String documentPath = documentDirectory.path;
    final file = File("$path/$stuRoll.pdf");
    await file.writeAsBytes(pdf.save());

    Fluttertoast.showToast(msg: "PDF Saved to: $path");
  }

}