import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/pages/Home.dart';
import 'package:telegramchatapp/shared/BouncyPageRoute.dart';
import 'package:telegramchatapp/shared/FormDecoration.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;
  String userId = '';
  String password = '';
  String error = "";
  final _formKey = GlobalKey<FormState>();

  SharedPreferences preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Check the user Online or Offline...
    checkUserOnlineOrOffline();
  }

  Future checkUserOnlineOrOffline() async{
    SharedPreferences isOnline = await SharedPreferences.getInstance();
    if(isOnline.getString("onlineUserId") != null){
      loading = false;
      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      Navigator.push(context, BouncyPageRoute(widget: HomePage()));
    }

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
              padding:EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Organization List",
                    style: TextStyle(color: Colors.white,fontSize: 23.0,),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              SizedBox(height: 20.0,),

              TextFormField(
                decoration: textInputDecoration,
                validator: (value) => value.isEmpty ? "Enter User Id" : null,
                onChanged: (value){
                  setState(() => userId = value);
                },
              ),

              SizedBox(height: 20.0),

              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (value) => value.isEmpty ? "Enter Password" : null,
                onChanged: (value){
                  setState(() => password = value);
                },
                obscureText: true,
              ),

              SizedBox(height: 20.0,),

              RaisedButton(
                onPressed: () {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    error = "";
                    userVerification();
                  }
                },
                color: Colors.deepPurple[800],
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white,fontSize: 20.0),
                ),
              ),

              SizedBox(height: 20.0,),

              Container(
                child: loading ? fadingCircle() : Container(),
              ),

              Text(
                error,
                style: TextStyle(color: Colors.red,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future userVerification() async{

      List list =[];

      final CollectionReference authList = Firestore.instance.collection("authentication");

      await authList.getDocuments().then((querySnapshot){
        querySnapshot.documents.forEach((element) {
          list.add(element.data);
        });
      });

      if(list[0]["user_id"] == userId && list[0]["password"] == password){
        loading = false;
        error = "";

        //Remember User by Shared Preferences...
        SharedPreferences rememberUser = await SharedPreferences.getInstance();
        rememberUser.setString("onlineUserId", list[0]["user_id"]);
        rememberUser.commit();
        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        Navigator.push(context, BouncyPageRoute(widget: HomePage()));
      }
      else{
        setState(() {
          loading = false;
          error = "Wrong User Id or Password";
        });
      }
  }
}
