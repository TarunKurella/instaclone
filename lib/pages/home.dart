import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instaclone/models/user.dart';
import 'package:instaclone/pages/activity_feed.dart';
import 'package:instaclone/pages/create_account.dart';
import 'package:instaclone/pages/profile.dart';
import 'package:instaclone/pages/search.dart';
import 'package:instaclone/pages/timeline.dart';
import 'package:instaclone/pages/upload.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final userRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  void initState() {
    super.initState();
    pageController = PageController();
    //detects when user signins in or out
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignin(account);
    }, onError: (err) {
      print('error signing in : $err');
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignin(account);
    }).catchError((err) {
      print('error signing in : $err');
    });
  }

  @override
  void dispose() {
    pageController.dispose();
  }

  handleSignin(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    //if user exists in users collection according in id

    final GoogleSignInAccount user = googleSignIn.currentUser;
     DocumentSnapshot doc = await userRef.document(user.id).get();

    // if user dosent exitsts, then get them to create username page
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      userRef.document(user.id).setData({
        "id" : user.id,
        "username":username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp":timestamp
      });
      doc = await userRef.document(user.id).get();
    }
    //get username from create account, use it to make new user document in users collection.
currentUser =  User.fromDocument(doc);

  }

  login() {
    googleSignIn.signIn();
  }

  logout() {

      googleSignIn.signOut();

  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
        pageIndex, duration: Duration(milliseconds: 150),
        curve: Curves.fastOutSlowIn);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
//          Center(child: RaisedButton(child: Text("logoot"),
//            onPressed: logout,)),
          Search(),
          Upload(),
          ActivityFeed(),
          Profile()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,

        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              size: 30.0,
              color: pageIndex == 0 ? Colors.black : Colors.grey,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30.0,
              color: pageIndex == 1 ? Colors.black : Colors.grey,
            ),
            title: Text(''),
          ), BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Color(0xFF23B66F),
                onPressed: () => print('Upload photo'),
                child: Icon(
                  Icons.add,
                  size: 35.0,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(''),
          ), BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
              size: 30.0,
              color: pageIndex == 3 ? Colors.black : Colors.grey,
            ),
            title: Text(''),
          ), BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30.0,
              color: pageIndex == 4 ? Colors.black : Colors.grey,
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.deepPurple, Colors.pink])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("InstaClone",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Billabong",
                    fontSize: 90.0)),
            Container(
                width: 300.0,
                child: Text(
                    "Sign up to see photos and videos from your friends.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400))),
            SizedBox(
              height: 200.0,
            ),
            Center(
              child: GestureDetector(
                  onTap: login,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    height: 50.0,
                    width: 300.0,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 70.0),
                        Container(
                          height: 20.0,
                          width: 20.0,
                          child: Image.asset(
                            "assets/images/gpng.png",
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Log In With Google",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
