import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../model/customUser.dart';

class CurrentUserController extends GetxController {
  Rx<CustomUser> currentUser = const CustomUser(username: null, age: 0).obs;
  
  RxString usernameTest = "Default".obs; 
  String? get username => currentUser.value?.username;
  String? get pfp => currentUser.value?.pfp;

  void setCurrentUser(CustomUser updatedUser) {
    currentUser.value = updatedUser;
    usernameTest.value = updatedUser.username!;
  }


  void updateUser(String name, int age) {
      currentUser.value = currentUser.value.copyWith(
        username: name,
        age: age,
      );
  }

  // void deleteCurrentUser(){
  //   currentUser.value = pop(false);

    
  // }
}