import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speedometer/main.dart';
import 'package:speedometer/settings.dart';
import 'background_colors_alert.dart';
import 'map_page.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  PermissionStatus permissionStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
  }

  void onLayoutDone(Duration timeStamp) async {
    permissionStatus = await Permission.location.status;
    setState(() {});
  }

  void _askLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      permissionStatus = await Permission.location.status;
      setState(() {
        if(permissionStatus.isGranted){
          Get.to(MapPage());
        }
      });
    }
    else{
      Permission.location.request();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              size: 40,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations
                .of(context)
                .openAppDrawerTooltip,
          );
        }
    ),


        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Speedometer',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
            ),

            const SizedBox(height:25,),

            ListTile(
              title: const Text('Speed Limit',
                style: TextStyle(
                    fontSize: 16,
                ),),
              onTap: () {
                // Update the state of the app.
                // ...
                Get.to(() => Home());

              },
            ),

            ListTile(
              title: const Text('Map View',
                style: TextStyle(
                  fontSize: 16,
                ),),
              onTap: () {
                // Update the state of the app.
                // ...
                _askLocationPermission();
              },
            ),

            ListTile(
              title: const Text('Settings',
                style: TextStyle(
                    fontSize: 16,
                ),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.30,
                  padding:const EdgeInsets.all(2),
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(width: 1.0, color: Colors.black,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 6.0, color: Colors.black,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text('SPEED\n LIMIT',
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4.0
                            ),),

                          Text('35',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 98,
                                letterSpacing: 13.0
                            ),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),


              Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.height * 0.45,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),

                child: InkWell(
                  onTap: (){
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 4.0, color: Colors.black,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('34',
                          style: TextStyle(
                              fontSize: 79,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0
                          ),),

                        Text('Actual Speed',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16
                          ),)
                      ],
                    ),
                  ),
                ),
              )
            ]
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.grey[200],
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: const[
      //       Icon(Icons.map,
      //         color: Colors.lightBlue,
      //       size: 30,),
      //
      //       Text('Map View',
      //         style: TextStyle(
      //         fontSize: 8,
      //         color: Colors.black,
      //           fontWeight: FontWeight.bold
      //       ),),
      //
      //       SizedBox(height: 8 ,)
      //     ],
      //   ),
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
      //   },
      // ),
    );
  }
}

