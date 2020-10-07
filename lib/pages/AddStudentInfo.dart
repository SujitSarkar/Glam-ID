import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/shared/BouncyPageRoute.dart';
import 'package:telegramchatapp/shared/FormDecoration.dart';

import 'LoginPage.dart';

class AddStudents extends StatefulWidget {
  final String orgaName;

  AddStudents({this.orgaName});

  @override
  _AddStudentsState createState() => _AddStudentsState(this.orgaName);
}

class _AddStudentsState extends State<AddStudents> {
  String orgaName;
  _AddStudentsState(this.orgaName);

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  File imageFile;
  String name = '';
  String roll = '';
  String address = '';
  String mobile = '';
  String blood = '';
  String email = '';
  String photoUrl = '';
  String photoName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              padding:
                  EdgeInsets.only(left: 1.0, top: 5.0, right: 5.0, bottom: 5.0),
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
                        "Add Student Details",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                    ),
                    onPressed: () => logOut(),
                  )
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
                      "Saving Information, please wait",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              color: Colors.transparent,
            )
          : Form(
              key: _formKey,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: Column(
                          children: [
                            (imageFile == null)
                                ? Material(
                                    child: Icon(
                                      Icons.account_box,
                                      size: 300.0,
                                      color: Colors.grey,
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
                            TextFormField(
                              //textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.number,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Roll/ID'),
                              validator: (value) =>
                                  value.isEmpty ? "Enter Roll/ID" : null,
                              onChanged: (value) {
                                setState(() => roll = value);
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Name'),
                              validator: (value) =>
                                  value.isEmpty ? "Enter Name" : null,
                              onChanged: (value) {
                                setState(() => name = value);
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Address'),
                              validator: (value) =>
                                  value.isEmpty ? "Enter Address" : null,
                              onChanged: (value) {
                                setState(() => address = value);
                              },
                            ),

                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Blood Group'),
                              onChanged: (value) {
                                setState(() => blood = value);
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Mobile Number'),
                              onChanged: (value) {
                                setState(() => mobile = value);
                              },
                            ),

                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
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
                                    if (_formKey.currentState.validate()) {
                                      if (imageFile != null) {
                                        setState(() => loading = true);
                                        uploadImageToForestoreAndStorage();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Take a photo first");
                                      }
                                    }
                                  },
                                  color: Colors.green[800],
                                  child: Text(
                                    "Save",
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
            ),
    );
  }

  Future logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    //Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    Navigator.push(context, BouncyPageRoute(widget: LoginScreen()));
  }

  Future takePhotoFromCamera() async {
    File newImageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (newImageFile != null) {
      setState(() {
        this.imageFile = newImageFile;
      });
    }
  }

  Future uploadImageToForestoreAndStorage() async {

    photoName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(orgaName).child(photoName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    storageUploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;

        storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          photoUrl = newImageDownloadUrl;
          Firestore.instance.collection(orgaName).document(roll).setData({
            "roll/id": roll,
            "name": name,
            "address": address,
            "photoUrl": photoUrl,
            "blood group": blood,
            "email": email,
            "mobile": mobile,
            "org name": orgaName,
            "photo name": photoName,
          }).then((data) async {
            setState(() => loading = false);
            Fluttertoast.showToast(msg: "Information Saved");
            Navigator.of(context).pop();
          });
        }, onError: (errorMsg) {
          setState(() => loading = false);
          Fluttertoast.showToast(msg: errorMsg.toString());
        });
      }
    });
  }
}
