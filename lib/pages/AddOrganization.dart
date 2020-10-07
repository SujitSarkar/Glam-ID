import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/shared/BouncyPageRoute.dart';
import 'package:telegramchatapp/shared/FormDecoration.dart';

import 'LoginPage.dart';

class NewOrganization extends StatefulWidget {
  @override
  _NewOrganizationState createState() => _NewOrganizationState();
}

class _NewOrganizationState extends State<NewOrganization> {

  bool loading = false;
  String orgName = "";
  String clsOrDept = "";
  final _formKey = GlobalKey<FormState>();

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
              padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white,),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    icon: Icon(Icons.power_settings_new,color: Colors.white,),
                    onPressed: () => logOut(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10.0,),

              Text(
                "Add Organization",
                style: TextStyle(
                  color: Colors.deepPurple[800],fontSize: 23.0, fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40.0,),

              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: textInputDecoration.copyWith(hintText: 'Organization Name'),
                validator: (value) => value.isEmpty ? "Enter Organization Name" : null,
                onChanged: (value){
                  setState(() => orgName = value);
                },
              ),

              SizedBox(height: 40.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  RaisedButton(
                    onPressed: () {
                      if(_formKey.currentState.validate()){
                        setState(() => loading = true);
                        insertOrganizationToFirestore();
                      }
                    },
                    color: Colors.green[800],
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white,fontSize: 20.0),
                    ),
                  ),

                  SizedBox(width: 30.0,),

                  RaisedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.red[800],
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white,fontSize: 20.0),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0,),

              Container(
                child: loading ? fadingCircle() : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future logOut() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    Navigator.push(context, BouncyPageRoute(widget: LoginScreen()));
  }

  void insertOrganizationToFirestore(){
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    Firestore.instance.collection("organizations").document(orgName)
        .setData({
      "organization_name": orgName,
      "created_time": dateTime,
    }).then((value) async{
      setState(() => loading = false);
      Fluttertoast.showToast(msg: "Added Successfully");
      Navigator.of(context).pop();

    },onError: (errorMgs){
      setState(() => loading = false);
      Fluttertoast.showToast(msg: errorMgs.toString());
    });
  }
}
