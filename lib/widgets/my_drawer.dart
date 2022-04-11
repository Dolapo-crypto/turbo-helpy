import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  final String? name;
  final String? email;

  MyDrawer({this.name, this.email});
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            //Drawer Header
            Container(
              height: 165,
              color: Colors.white,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    const CircleAvatar(
                      maxRadius: 25,
                      backgroundColor: Colors.black12,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.email.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // const Padding(
            //   padding: EdgeInsets.only(left: 8, right: 8),
            //   child: Divider(
            //     height: 1,
            //     thickness: 1,
            //     color: Colors.grey,
            //   ),
            // ),

            const SizedBox(
              height: 12,
            ),

            //Drawer Body
            GestureDetector(
              onTap: () {},
              child: const ListTile(
                leading: Icon(
                  Icons.history,
                  color: Colors.black54,
                ),
                title: Text(
                  "History",
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {},
              child: const ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black54,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {},
              child: const ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.black54,
                ),
                title: Text(
                  "About",
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                fAuth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const MySplashScreen()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
