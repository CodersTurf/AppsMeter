import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/screens/unused_apps/unused_apps_bloc.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/widgets/appicon.dart';
import 'package:AppsMeter/widgets/curve_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UnusedAppsScreen extends StatefulWidget {
  Function onBack;
  UnusedAppsScreen(this.onBack);
  @override
  _UnusedAppsScreenState createState() => _UnusedAppsScreenState();
}

class _UnusedAppsScreenState extends State<UnusedAppsScreen>
    with TickerProviderStateMixin {
      double appBArHeight=130;
  AnimationController _controller;
  List<AppUsageModel> unUsedApps;
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

  _UnusedAppsScreenState() {
    getUnUsedApps();
  }
  getUnUsedApps() async {
    unUsedApps = await _bloc.getUnUsedApps();
    setState(() {});
  }

  closeScreen() {
    isReverse = true;
    _visible = false;
    _controller.duration = Duration(milliseconds: 150);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 130),
        child: SlideTransition(
            position: _offsetFloat,
            child: Scaffold(
                body: unUsedApps == null
                    ? SpinKitDoubleBounce(color: Colors.white)
                    : LayoutBuilder(
                             builder: (BuildContext context, BoxConstraints viewportConstraints) {
                               return Column(
                        children: <Widget>[
                          ClipPath(
                              clipper: CurvedBottomClipper(),
                              child: Container(
                                  color: Colors.grey[800],
                                  height: appBArHeight,
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.only(bottom: 50),
                                    child:Row(children: <Widget>[
                                      SizedBox(width: 10,),
                                      IconButton(
                                        onPressed: (){
                                          closeScreen();
                                          },
                                        icon:Icon(Icons.arrow_back,size: 30,)),
                                      Expanded(child:Center(child:Padding(
                                        padding:EdgeInsets.fromLTRB(0, 0,30,0),
                                        child:Text(
                                      "Apps not used since 7+ days",
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.pink,
                                      ))),
                                    ))])
                                  )))),
                                  SizedBox(height: 10,),
                         unUsedApps.length>0? Container(
                              height:viewportConstraints.maxHeight-(appBArHeight+10),
                              padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                              color: Colors.grey[800],
                              child: getUnusedAppList()
                              ):Column(children: <Widget>[
                                SizedBox(height: 10),
                                Text("No unused apps in your device.",style: TextStyle(fontSize: 18,color: Colors.white54),),
                                SizedBox(height: 15),
                                Icon(Icons.thumb_up,size: 45,color: Colors.green[500],)])
                        ]);}
                      ))));
  }

  getUnusedAppList() {
    return
   
     ListView.separated(
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
                          style: TextStyle(color: Colors.pink[500])))),
            ));
  }

  dispose() {
    super.dispose();
    _bloc.dispose();
  }
}

//    child: Card(
//     // color:Colors.black12,
//      elevation: 1,
//   child:Padding(padding:EdgeInsets.all(10),child: Column(
//     mainAxisSize: MainAxisSize.min,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//       Row(
//         //mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//         Expanded(flex: 1,child:SizedBox(height:40,width: 30,
//          child:  AppIcon(unUsedApps[index].decodedImage))),
//         SizedBox(width:10),
//         Expanded(flex: 4,child:  Text(capitalizeText(unUsedApps[index].appName),
//         style: TextStyle(color: Colors.white,fontSize: 16))),

//          Expanded(flex:4, child:
//          Align(alignment: Alignment.centerRight,child: GestureDetector(onTap: (){_bloc.unInstallApp(unUsedApps[index].appPackage); },
//          child: Text('Uninstall',style: TextStyle(color: Colors.blue[500])))
//           ))
//       ]),
//      SizedBox(height: 6,),

//     Text('Not used since past 7+ days.',style: TextStyle(color: Colors.white60,fontSize: 14))
//   ]),
// ))
//  );
