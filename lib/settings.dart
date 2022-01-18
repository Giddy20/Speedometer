import 'package:flutter/material.dart';
import 'package:speedometer/background_colors_alert.dart';
import 'package:speedometer/home.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);


  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
   double _volumeValue = 3;
   double _speedLimitAlertValue = 3;
   double _alertTiming = 3;
   double _speedTest = 3;

   String unit = 'mph';

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
                  color: Colors.black,
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


        backgroundColor:  Colors.white,
        elevation: 0,

        actions: [
          InkWell(
            onTap: (){
              setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              child: const Text('Save',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),),
            ),
          ),

          SizedBox(width: 20,)
        ],
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
                    fontWeight: FontWeight.bold
                ),),
            ),
            ListTile(
              title: const Text('Speed Limit',
                style: TextStyle(
                  fontSize: 16,
                ),),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
              },
            ),
            ListTile(
              title: const Text('Settings',
                style: TextStyle(
                  fontSize: 16,
                ),),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
              },
            ),
          ],
        ),
      ),

      body: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 35,
              color: Color(0xFF65000b),
              child: const Center(
                child: Text('SETTINGS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 22.5, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Speed Unit'),

                  InkWell(
                    onTap: (){
                      setState(() {
                        if (unit == 'mph') {
                          unit = 'km/h';
                        }
                        else if (unit != "mph") {
                          unit = 'mph';
                        }
                        print(unit);
                      });

                    },
                    child: Text(unit),
                  ),
                ],
              ),
            ),


            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               const  Text('Alert Volume'),

                Slider(
                  min: 0,
                  max: 10,
                  activeColor: Color(0xFF65000b),
                  inactiveColor: Colors.grey[300],
                  value: _volumeValue,
                    label: '${_volumeValue.round()}',
                    onChanged: (value) {
                      setState(() {
                        _volumeValue = value;
                      });
                    }
                ),

                const  Text('play'),
              ],
            ),

            const Divider(),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Text('Sound alert when Speed Limit exceeded by:'),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_speedLimitAlertValue.round()} MPH'),

                      Slider(
                          min: 0,
                          max: 80,
                          activeColor: Color(0xFF65000b),
                          inactiveColor: Colors.grey[300],
                          value: _speedLimitAlertValue,
                          label: '${_speedLimitAlertValue.round()}',
                          onChanged: (value) {
                            setState(() {
                              _speedLimitAlertValue = value;
                              changeColor(_speedLimitAlertValue);
                            });
                          }
                      ),

                    ],
                  )
                ],
              ),
            ),

            const Divider(),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Play Sound Alert every ${_alertTiming.round()} seconds:'),


                  Slider(
                      min: 0,
                      max: 80,
                      activeColor: Color(0xFF65000b),
                      inactiveColor: Colors.grey[300],
                      value: _alertTiming,
                      label: '${_alertTiming.round()}',
                      onChanged: (value) {
                        setState(() {
                          _alertTiming = value;
                        });
                      }
                  )
                ],
              ),
            ),


            const Divider(),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Manual Speed tester'),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_speedTest.round()} MPH'),

                      Slider(
                          min: 0,
                          max: 80,
                          activeColor: Color(0xFF65000b),
                          inactiveColor: Colors.grey[300],
                          value: _speedTest,
                          label: '${_speedTest.round()}',
                          onChanged: (value) {
                            setState(() {
                              _speedTest = value;
                              changeColor(_speedTest);
                            });
                          }
                      ),

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
