import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String username = "";
  TextEditingController temp = new TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();




  sendUsername(){

    final form = _formkey.currentState;
    if(form.validate()){
      form.save();
      Navigator.pop(context,username);
    }



  }



  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Set Your Username",style: TextStyle(fontWeight: FontWeight.w600),),
          Container(padding: EdgeInsets.all(16.0),
            child: Form(
              autovalidate: true,
              key: _formkey,
              child: new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.purpleAccent,
                    primaryColorDark: Colors.red,
                  ),
                child: TextFormField(
                  validator: (val){
                    if(val.trim().length<3||val.isEmpty){
                      return "Username short";
                    }else{

                      return null;
                    }
                  },
                  decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),hintText: "Must be 3 characters long"),
                  onSaved: (val)=> username = val,
                  controller: temp,
                ),
              ),
            ),
          ),SizedBox(height: 50.0,),
          Container(width: 300.0,child: FlatButton(color: Colors.purple,child: Text("okay",style: TextStyle(color: Colors.white),),onPressed: sendUsername,padding:EdgeInsets.all(16.0) ,))
        ],
      ),
    );
  }
}
