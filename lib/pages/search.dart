import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/user.dart';
import 'package:instaclone/pages/home.dart';
import 'package:instaclone/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> searchResultsFuture;
  TextEditingController searchController = TextEditingController();
  List<UserResult> searchResults = [];

  handleSearch(String query) {
    Future<QuerySnapshot> users = userRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  buildSearchResults() {
    return FutureBuilder(
        future: searchResultsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          searchResults = [];
          snapshot.data.documents.forEach((doc) {
            User user = User.fromDocument(doc);
            searchResults.add(UserResult(user: user));
          });
          if (searchResults.length == 0) {
            return Center(
              child: Text("No User Found"),
            );
          }
          return ListView(
            children: searchResults,
          );
        });
  }

  AppBar buildSearchField() {
    return AppBar(
      actions: <Widget>[
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 15.0),
            child: Text("Cancel",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.green,
                    fontWeight: FontWeight.w400)),
          ),
        )
      ],
      centerTitle: false,
      backgroundColor: Colors.white,
      title: Theme(
        data: new ThemeData(
          primaryColor: Colors.black12,
          primaryColorDark: Colors.black12,
        ),
        child: Container(
          width: 300.0,
          height: 40.0,
          child: TextFormField(
            style: TextStyle(fontSize: 15.0, color: Colors.grey),
            onFieldSubmitted: handleSearch,
            controller: searchController,
            decoration: InputDecoration(
                hintText: "",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0))),
                filled: true,
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        searchResultsFuture = null;
                      });
                    })),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? Container() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  User user;

  UserResult({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(onTap: (){print("pressed");},
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(user.username),
              subtitle: Text(user.displayName),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Divider(height: 2.0,color: Colors.grey,),
          )
        ],
      ),
    );
  }
}
