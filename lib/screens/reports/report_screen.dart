import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/screens/unused_apps/unused_apps_bloc.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/widgets/appicon.dart';
import 'package:AppsMeter/widgets/curve_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReportScreen extends StatefulWidget {
  Function onBack;
  ReportScreen(this.onBack);
  @override
  _ReportScreenScreenState createState() => _ReportScreenScreenState();
}

class _ReportScreenScreenState extends State<ReportScreen>
    with TickerProviderStateMixin {
  double appBArHeight = 180;
  AnimationController _controller;
  List<AppUsageModel> unUsedApps = new List<AppUsageModel>();
  bool isReverse = false;
  bool _visible = true;
  UnUsedAppBloc _bloc = new UnUsedAppBloc();
  Animation<Offset> _offsetFloat;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0),
    );
    _offsetFloat = Tween<Offset>(begin: Offset(0, 0.0), end: Offset(1, 0))
        .animate(_controller);

    _offsetFloat.addListener(() {
      setState(() {
        if (_controller.isCompleted) {
          if (isReverse) {
            widget.onBack(0);
          }
        }
      });
    });
    _controller.reverse();
  }

  Future<bool> _willPopCallback() async {
    closeScreen(); // return true if the route to be popped
  }

  closeScreen() {
    isReverse = true;
    _visible = false;
    _controller.duration = Duration(milliseconds: 150);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 130),
            child: SlideTransition(
                position: _offsetFloat,
                child: Scaffold(
                    body: unUsedApps == null
                        ? SpinKitDoubleBounce(color: Colors.white)
                        : LayoutBuilder(builder: (BuildContext context,
                            BoxConstraints viewportConstraints) {
                            return Stack(children: <Widget>[
                              Container(
                                  color: Colors.grey[800],
                                  height: viewportConstraints.maxHeight,
                                  width: viewportConstraints.maxWidth),
                              Positioned(
                                  child: CustomHeader(
                                      appBArHeight,
                                      "Weekly Report",
                                      IconButton(
                                          onPressed: () {
                                            closeScreen();
                                          },
                                          icon: Icon(
                                            Icons.arrow_back,
                                            size: 30,
                                          )))),
                              Positioned(
                                  top: appBArHeight,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(children: <Widget>[
                                    SizedBox(height: 10),
                                    Text(
                                      "No data available.",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white54),
                                    )
                                  ]))
                            ]);
                          })))));
  }

  getUnusedAppList() {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        itemCount: unUsedApps.length,
        itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(2.0),
              child: ListTile(
                  //dense: true,

                  leading: new SizedBox(
                      height: 50,
                      width: 50,
                      child: AppIcon(unUsedApps[index].decodedImage)),
                  title: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(unUsedApps[index].appName)),
                  trailing: GestureDetector(
                      onTap: () async {
                        _bloc.unInstallApp(unUsedApps[index].appPackage);
                        unUsedApps.removeAt(index);
                        setState(() {});
                      },
                      child: Text('Uninstall',
                          style: TextStyle(color: Colors.pink[400])))),
            ));
  }

  dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
