import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegramchatapp/shared/BouncyPageRoute.dart';
import 'package:telegramchatapp/shared/FormDecoration.dart';

import 'AddStudentInfo.dart';
import 'EditStudentInfo.dart';
import 'LoginPage.dart';

class StudentList extends StatefulWidget {
  final String orgName;
  StudentList({this.orgName});

  @override
  _StudentListState createState() => _StudentListState(this.orgName);
}

class _StudentListState extends State<StudentList> {

  String orgName;
  _StudentListState(this.orgName);

  String id;
  String photoName;

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
        //automaticallyImplyLeading: false, //remove default back button
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
              hintText: 'Search Name',
              hintStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              filled: true,
              //prefixIcon: Icon(Icons.search, color: Colors.grey[300], size: 30.0,),
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
        tooltip: "Add Student Information",
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add, color: Colors.white,
        ),
        onPressed: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudents(orgaName: orgName)));
          Navigator.push(context, BouncyPageRoute(widget: AddStudents(orgaName: orgName)));
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
      stream: Firestore.instance.collection(orgName).snapshots(),
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
            DocumentSnapshot students = snapshot.data.documents[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
              child: Card(
                child: ListTile(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditStudent(
                    //   name: students['name'],
                    //   roll: students["roll/id"],
                    //   address: students['address'],
                    //   mobile: students['mobile'],
                    //   blood: students['blood group'],
                    //   email: students['email'],
                    //   photoUrl: students['photoUrl'],
                    //   orgName: students['org name'],
                    //   photoName: students['photo name'],
                    // )));
                    Navigator.push(context, BouncyPageRoute(widget: EditStudent(
                      name: students['name'],
                      roll: students["roll/id"],
                      address: students['address'],
                      mobile: students['mobile'],
                      blood: students['blood group'],
                      email: students['email'],
                      photoUrl: students['photoUrl'],
                      orgName: students['org name'],
                      photoName: students['photo name'],
                    )));
                  },
                  title: Text(students['roll/id']),
                  subtitle: Text(students['name']),
                  trailing: IconButton(
                    onPressed: (){
                      setState(() {
                        id=students['roll/id'];
                        photoName = students['photo name'];
                      });
                      deleteConfirmation(context);
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.red[400],),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void deleteConfirmation( BuildContext context) {
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
                          FirebaseStorage.instance.ref().child(orgName).child(photoName).delete();
                          Firestore.instance.collection(orgName).document(id).delete();
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: "Item Deleted");
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
      stream: Firestore.instance.collection(orgName)
          .where("name", isGreaterThanOrEqualTo: searchQuery)
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
                "No Student Found",
                style: TextStyle(color: Colors.grey, fontSize: 20.0),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot students = snapshot.data.documents[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
              child: Card(
                child: ListTile(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditStudent(
                    //   name: students['name'],
                    //   roll: students["roll/id"],
                    //   address: students['address'],
                    //   mobile: students['mobile'],
                    //   blood: students['blood group'],
                    //   email: students['email'],
                    //   photoUrl: students['photoUrl'],
                    //   orgName: students['org name'],
                    //   photoName: students['photo name'],
                    // )));
                    Navigator.push(context, BouncyPageRoute(widget: EditStudent(
                      name: students['name'],
                      roll: students["roll/id"],
                      address: students['address'],
                      mobile: students['mobile'],
                      blood: students['blood group'],
                      email: students['email'],
                      photoUrl: students['photoUrl'],
                      orgName: students['org name'],
                      photoName: students['photo name'],
                    )));
                  },
                  title: Text(students['roll/id']),
                  subtitle: Text(students['name']),
                  trailing: IconButton(
                    onPressed: (){
                      setState(() {
                        id=students['roll/id'];
                        photoName = students['photo name'];
                      });
                      deleteConfirmation(context);
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.red[400],),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

  }
}
