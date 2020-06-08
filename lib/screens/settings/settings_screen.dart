import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:AppsMeter/datalayer/models/appdetails_model.dart';
import 'package:AppsMeter/services/localstorage_service.dart';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:AppsMeter/widgets/bottombar.dart';
import 'enableapps/enableapp_bloc.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
   final EnableAppBloc _enableAppBloc = new EnableAppBloc();
  final NavigationService navService = locator<NavigationService>();
  final LocalStorageService storageService = locator<LocalStorageService>();
  _SettingScreenState() {
    _enableAppBloc.getAllApps();
  }
 getSettingScreen(List<AppDetailsModel> apps) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
                height: constraints.maxHeight - 10,
                child: Card(
                    elevation: 4,
                    color: Colors.grey[900],
                    child: ListView.builder(
                        itemCount: apps.length,
                        itemBuilder: (context, position) {
                          return Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey[700]))),
                              child: ListTile(
                                leading: Container(
                                    width: 250,
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Image.memory(
                                            apps[position].decodedImage,
                                            width: 30,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 10, 0)),
                                          Flexible(
                                              child: Text(
                                                  apps[position].appName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.white70)))
                                        ])),
                                trailing: Switch(
                                  value: apps[position].active,
                                  activeTrackColor: Colors.blue[300],
                                  activeColor: Colors.blue[700],
                                  onChanged: (bool value) {
                                   
                                    _enableAppBloc.addRemoveApp(
                                        apps[position].appPackage, value);
                                        setState(() {
                                           apps[position].active=!apps[position].active;
                                        });
                                  },
                                ),
                              ));
                        })))
          ]);
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.settings,
              color: Colors.pink,
            ),
            SizedBox(width: 10,),
            Text('Enable/Disable Apps', style: TextStyle(color: Colors.pink)),
            // Your widgets here
          ],
        ),
       
        automaticallyImplyLeading: false,
        
      ),
      body: StreamBuilder(
          stream: _enableAppBloc.allAppsObservable,
          builder: (context, AsyncSnapshot<List<AppDetailsModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data != null && snapshot.data.length > 0) {
                return getSettingScreen(snapshot.data);
              } else {
                return (Text('Data not found'));
              }
            } else {
              return SpinKitDoubleBounce(
                color: Colors.white,
              );
            }
          }),
    );

 
  }
}

 
 
