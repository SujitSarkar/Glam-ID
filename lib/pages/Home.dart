import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/pages/AddOrganization.dart';
import 'package:telegramchatapp/pages/StudentLst.dart';
import 'package:telegramchatapp/shared/BouncyPageRoute.dart';
import 'package:telegramchatapp/shared/FormDecoration.dart';

import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController searchEditingController = TextEditingController();

  bool isSearch = false;
  String searchQuery = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSearch = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        automaticallyImplyLeading: false, //remove default back button
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new, color: Colors.white,),
            onPressed: () => logOut(),
          ),
        ],
        backgroundColor: Colors.deepPurple,
        title: Container(
          margin: new EdgeInsets.only(bottom: 4.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            cursorColor: Colors.white,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
            controller: searchEditingController,
            decoration: InputDecoration(
              hintText: 'Search here...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              filled: true,
              prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 30.0,),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.grey[400],),
                onPressed: (){
                  searchEditingController.clear();
                  setState(() {
                  isSearch = false;
                });},
              ),
            ),
            onChanged: (value){
              searchQuery = value;
              setState(() {
                isSearch = true;
              });
            },
          ),
        ),
      ),
      body: isSearch ? displaySearchResults(context) : displayAllResults(context),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Organization",
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add, color: Colors.white,
        ),
        onPressed: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrganization()));
          Navigator.push(context, BouncyPageRoute(widget: NewOrganization()));
        },
      ),
    );
  }

  Future logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    Navigator.push(context, BouncyPageRoute(widget: LoginScreen()));
  }

  displayAllResults(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("organizations").snapshots(),
      builder: (context, snapshot) {
        return snapshot.data.documents.length == 0
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 70.0,
                    ),
                    Text(
                      "No Organization List",
                      style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot orgs = snapshot.data.documents[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(orgs['organization_name']),
                        subtitle: Text(DateFormat("dd MMMM yyyy - hh:mm:aa")
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                int.parse(orgs['created_time'])))),
                        onTap: () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => AllStudentsList(orgName: orgs['organization_name'])));
                          Navigator.push(context, BouncyPageRoute(widget: StudentList(orgName: orgs['organization_name'])));
                        },
                        onLongPress: (){
                          deleteConfirmation(context,orgs['organization_name']);
                        },
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  void deleteConfirmation( BuildContext context, String org) {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: 115,
            margin: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 40.0),
            decoration: modalDecoration,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Delete this item?",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: IconButton(
                        icon: Icon(Icons.check,color: Colors.green,size: 30.0,),

                        onPressed: (){
                          Firestore.instance.collection("organizations").document(org).delete();
                          Firestore.instance.collection(org).document().delete();
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: "Organization Deleted");
                        },

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        icon: Icon(Icons.close,color: Colors.red,size: 30.0,),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  displaySearchResults(BuildContext context) {
    setState(() {
      isSearch = false;
    });
    return StreamBuilder(
      stream: Firestore.instance.collection("organizations")
          .where("organization_name".toLowerCase(), isGreaterThanOrEqualTo: searchQuery)
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.data.documents.length == 0
            ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: Colors.grey,
                size: 70.0,
              ),
              Text(
                "No Organization Found",
                style: TextStyle(color: Colors.grey, fontSize: 20.0),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot orgs = snapshot.data.documents[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 3.0, horizontal: 8.0),
              child: Card(
                child: ListTile(
                  title: Text(orgs['organization_name']),
                  subtitle: Text(DateFormat("dd MMMM yyyy - hh:mm:aa")
                      .format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(orgs['created_time'])))),
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => AllStudentsList(orgName: orgs['organization_name'])));
                    Navigator.push(context, BouncyPageRoute(widget: StudentList(orgName: orgs['organization_name'])));
                  },
                  onLongPress: (){
                    deleteConfirmation(context,orgs['organization_name']);
                  },
                ),
              ),
            );
          },
        );
      },
    );

  }
}
