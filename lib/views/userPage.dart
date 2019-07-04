import 'package:flutter/material.dart';
import 'package:flutter1/apis/UserApi.dart';

class UserPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _UserPageState();
  }
}
class _UserPageState extends State<UserPage>{
  String userInfo ="未登录";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人中心"),
      ),
      body: Text("$userInfo"),
    );
  }
  @override
  void initState() {
    super.initState();
    UserApi.info().then((user){
      if(user!= null){
      setState(() {
        userInfo = user;
      });}
    });
  }
}