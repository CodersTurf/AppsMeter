import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/screens/unused_apps/unused_apps_bloc.dart';
import 'package:AppsMeter/screens/unused_apps/unusedapp_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UnusedAppsScreen extends StatefulWidget {
  Function onBack;
  Key key;
  Widget menuIcon;
  UnusedAppsScreen(this.onBack, this.menuIcon, this.key) : super(key: key);
  @override
  _UnusedAppsScreenState createState() => _UnusedAppsScreenState();
}

class _UnusedAppsScreenState extends State<UnusedAppsScreen>
    with TickerProviderStateMixin {
  double appBArHeight = 180;

  List<AppUsageModel> unUsedApps;

  UnUsedAppBloc _bloc = new UnUsedAppBloc();

  @override
  void initState() {
    super.initState();
  }

  _UnusedAppsScreenState() {
    getUnUsedApps();
  }
  getUnUsedApps() async {
    unUsedApps = await _bloc.getUnUsedApps();
    setState(() {});
  }

  Future<bool> _willPopCallback() async {
    //closeScreen(); // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Stack(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.menuIcon,
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            (MediaQuery.of(context).size.width / 2) - 120,
                            10,
                            20,
                            0),
                        child: Column(children: <Widget>[
                          Text("Unused Apps", style: TextStyle(fontSize: 22)),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Since past 7+ days',
                            style: TextStyle(color: Colors.white70),
                          )
                        ]))
                  ]),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.cyan[200], Colors.cyan[900]],
                      begin: Alignment.centerRight,
                      end: Alignment.topLeft)),
            ),
            Positioned(
                top: 120,
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    height: viewportConstraints.maxHeight - 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    width: MediaQuery.of(context).size.width,
                    child: unUsedApps == null
                        ? SpinKitDoubleBounce(color: Colors.cyan)
                        : unUsedApps.length > 0
                            ? Center(
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: UnusedAppList(unUsedApps)),
                              )
                            : Column(children: <Widget>[
                                SizedBox(height: 20),
                                Text(
                                  "No unused apps in your device.",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black54),
                                ),
                                SizedBox(height: 15),
                                Icon(
                                  Icons.thumb_up,
                                  size: 45,
                                  color: Colors.orange[500],
                                )
                              ])))
          ]);
        })));
  }

  dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
