import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/screens/unused_apps/unused_apps_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UnusedAppList extends StatelessWidget {
  List<AppUsageModel> unUsedApps;

  UnusedAppList(this.unUsedApps);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemCount: unUsedApps.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return TweenAnimationBuilder(
                  key: GlobalKey(),
                  tween: Tween<double>(begin: 0.0, end: 1),
                  duration: Duration(seconds: 1),
                  builder: (_, double opacity, __) {
                    return Opacity(
                      child: AppDetails(unUsedApps[index]),
                      opacity: opacity,
                    );
                  });
            }));
  }
}

class AppDetails extends StatelessWidget {
  UnUsedAppBloc _bloc = new UnUsedAppBloc();
  AppUsageModel app;
  AppDetails(this.app);
  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey[300],
                //offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                spreadRadius: 2.0),
          ],
        ),
        margin: EdgeInsets.all(8),
        child: Material(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(7),
            child: Center(
                child: ListTile(
              //dense: true,
              contentPadding: EdgeInsets.fromLTRB(8, 5, 8, 5),
              leading: Image.memory(
                app.decodedImage,
                fit: BoxFit.contain,
                height: 52,
              ),
              trailing: IconButton(
                  onPressed: () async {
                    await _bloc.unInstallApp(app.appPackage);
                    //getUnUsedApps();
                    //unUsedApps.removeAt(index);
                    //setState(() {});
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.pink[300],
                  )),
              title: Text(
                app.appName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ))));
  }
}
