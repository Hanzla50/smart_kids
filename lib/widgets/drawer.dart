import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kids_v1/controllers/currentUserController.dart';
import 'package:smart_kids_v1/pages/Homepage/ParentalControl/ParentControl_page.dart';
import 'package:smart_kids_v1/pages/Homepage/ParentalControl/password_parent.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  CurrentUserController controller = Get.put(CurrentUserController());

  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.green,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 200, // Adjust height to desired size for the header
              child: Obx(
                () => UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  accountName: Text(
                    "",
                    style: TextStyle(
                      color: Colors.white, 
                    ),
                  ),
                  accountEmail: Text(
                    "${controller.currentUser.value.username}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  currentAccountPicture: SizedBox(
                    width: 40, // Adjust width to desired size
                    height:40, // Adjust height to desired size
                    child: CircleAvatar(
                      backgroundImage: controller.currentUser.value.pfp != null ? 
                        Image.network(controller.currentUser.value.pfp!).image 
                        : const AssetImage("assets/images/Profile.png"),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white, 
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
              onTap: () {
                // Navigate to Home screen or perform specific action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              title: Text(
                "Account",
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
              onTap: () {
                // Navigate to Account screen or perform specific action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.timeline,
                color: Colors.white, 
              ),
              title: Text(
                "Progress Center",
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
              onTap: () {
                // Navigate to Progress Center screen or perform specific action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.child_care,
                color: Colors.white, 
              ),
              title: Text(
                "Parental Control",
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordPage()));
                // Navigate to Parental Control screen or perform specific action
                //Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.white, 
              ),
              title: Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
              onTap: () {
                // Navigate to Settings screen or perform specific action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white, 
              ),
              title: Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
              onTap: () {
                // Navigate to Settings screen or perform specific action
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Add more ListTiles or custom widgets for additional drawer items
          ],
        ),
      ),
    );
  }
}
