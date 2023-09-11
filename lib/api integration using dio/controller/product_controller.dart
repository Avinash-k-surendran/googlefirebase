import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:googlefirebase/api%20integration%20using%20dio/Model/post/model.dart';
import 'package:googlefirebase/api%20integration%20using%20dio/service/dio_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Product_controller extends GetxController{
  RxList post = RxList();     //the list post is observable and empty(initally)
RxBool isLoading = true.obs;
RxBool isListScrollDown =false.obs;
RxBool isInternetConnecttion = true.obs;

var url = "https://jsonplaceholder.typicode.com/posts";
//to perform scroll action animation etc on scrollable position list
var itemController = ItemScrollController();

//for checking internet connection
checkInternetConnect() async{
  isInternetConnecttion.value = await InternetConnectionChecker().hasConnection;
}

//calling api and get response

getposts() async{
  checkInternetConnect();
  isLoading.value = true ;
  var response = await Dioservice().getMethod(url);
  if(response.statusCode ==200){
    response.data.forEach((element){
      post.add(PostModel.fromJson(element));
    });
    isLoading.value = false;
  }
}
ScrolltoDown(){
  itemController.scrollTo(
      index: post.length - 5,
      duration: const Duration(
          seconds: 2
      ),
  curve: Curves.linearToEaseOut);
  isListScrollDown.value = true;
}
//scroll listview to top
ScrolltoUp(){
  itemController.scrollTo(index: 0, duration: Duration(seconds: 2),
  curve: Curves.bounceIn
  );
  isListScrollDown.value = false;
}
//actions perform when the app is loaded
@override
  void onInit(){
  getposts();
  isInternetConnecttion();
  super.onInit();
}
}