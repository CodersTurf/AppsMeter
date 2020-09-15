import 'package:AppsMeter/datalayer/models/appdatapoint_model.dart';
import 'package:AppsMeter/screens/home/widgets/appusage_modal.dart';

import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:AppsMeter/widgets/curve_header.dart';

import 'package:AppsMeter/widgets/topusedapps.dart';
import 'package:AppsMeter/widgets/usage_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'animated-header.dart';
import 'home_bloc.dart';

import 'package:AppsMeter/utilities/helper.dart';

class HomeScreen extends StatefulWidget {
  Widget leadingAppBarIcon;
  HomeScreen(this.leadingAppBarIcon);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final NavigationService navService = locator<NavigationService>();

  String sortType = 'USAGE';
  Animation<double> selectedTabAnimation;
  bool isUsageSortIncrease = false;
  final HomeBloc homeBloc = new HomeBloc();

  double appBArHeight = 300;
  final List<String> dailyHeaders = getDailyHeaders();
  _HomeScreenState() {
    getData(_selectedDay);
  }

  getData(String selectedDay) async {
    homeBloc.getUsedApps(1);
  }

  String selectedView = 'Daily';
  String headerText = "Today's usage";
  String _selectedDay = '0';
  Animation selectedTabOffset;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    selectedTabOffset =
        Tween<Offset>(begin: Offset(-2.2, 0.0), end: Offset(2.1, 0.0))
            .animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      getHeader(),
      StreamBuilder(
          stream: homeBloc.topAppsUsedObservable,
          builder: (context, AsyncSnapshot<List<AppUsageModel>> snapshot) {
            if (snapshot.data != null && snapshot.data.length > 0) {
              return getBody(snapshot.data);
            } else {
              return Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: SpinKitDoubleBounce(color: Colors.purple));
            }
          })

      // apps == null
      //     ? SpinKitDoubleBounce(color: Colors.white)
      //     : Container(
      //         // height: MediaQuery.of(context).size.height - appBArHeight,
      //         width: MediaQuery.of(context).size.width * 0.92,
      //         child: TopApps(apps)),
    ]);
  }

  sortApps(bool isIncreasing) {
    homeBloc.sortApps(sortType, isIncreasing);
  }

  getBody(apps) {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      var maxHeight = viewportConstraints.maxHeight;
      return Column(children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 40,
            child: StreamBuilder(
                stream: homeBloc.sortTypeObservable,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  return GestureDetector(
                      onTap: () {
                        isUsageSortIncrease = !isUsageSortIncrease;
                        homeBloc.changeSorting("USAGE", isUsageSortIncrease);
                      },
                      child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Top Used Apps',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.purple[400],
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Row(children: <Widget>[
                              Icon(
                                  isUsageSortIncrease
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_drop_up,
                                  color: Colors.purple[400])
                            ]),

                            // GestureDetector(
                            //     onTap: () {
                            //       isUsageSortIncrease = !isUsageSortIncrease;
                            //       homeBloc.changeSorting(
                            //           "USAGE", isUsageSortIncrease);
                            //     },
                            //     child: Column(children: <Widget>[
                            //       Row(children: <Widget>[
                            //         Icon(
                            //           Icons.sort,
                            //           color: snapshot.data == "USAGE"
                            //               ? Colors.pink
                            //               : Colors.grey,
                            //         ),
                            //         Icon(
                            //           isUsageSortIncrease
                            //               ? Icons.arrow_drop_down
                            //               : Icons.arrow_drop_up,
                            //           color: snapshot.data == "USAGE"
                            //               ? Colors.pink
                            //               : Colors.grey,
                            //         )
                            //       ]),
                            //       Text(
                            //         'Sort by usage',
                            //         style: TextStyle(
                            //           fontSize: 11,
                            //           color: snapshot.data == "USAGE"
                            //               ? Colors.pink
                            //               : Colors.grey,
                            //         ),
                            //       )
                            //     ])),
                          ]));
                })),
        SizedBox(
          height: 10,
        ),
        Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            height: maxHeight - 65,
            child: apps != null && apps.length > 0
                ? getAppList(apps)
                : Container())
      ]);
    }));
  }

  getAppList(apps) {
    return ListView.builder(
        itemCount: apps.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return TweenAnimationBuilder(
              key: GlobalKey(),
              tween: Tween<double>(begin: 0.0, end: 1),
              duration: Duration(seconds: 1),
              builder: (_, double opacity, __) {
                return Opacity(
                  child: AppDetails(apps[index], showAppUsageModal),
                  opacity: opacity,
                );
              });
        });
  }

  getTabs(String viewType) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: (Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    homeBloc.changeViewType("DAILY");
                    animationController.reverse();
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      'DAILY',
                      style: TextStyle(
                          fontSize: 17,
                          color: viewType == 'DAILY'
                              ? Colors.white
                              : Colors.white54,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    homeBloc.changeViewType("WEEKLY");
                    animationController.forward();
                  },
                  child: Container(
                    child: Text('WEEKLY',
                        style: TextStyle(
                            color: viewType == 'WEEKLY'
                                ? Colors.white
                                : Colors.white54,
                            fontSize: 17,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500)),
                  ))
            ],
          ),
          SlideTransition(
              position: selectedTabOffset,
              child: Container(
                height: 2,
                color: Colors.white,
                width: 40,
              ))
        ])));
  }

  getHeader() {
    var child = Container(
        height: appBArHeight,
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              widget.leadingAppBarIcon,
              Expanded(
                  child: StreamBuilder(
                      stream: homeBloc.viewTypeObservable,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return getTabs(snapshot.data);
                      }))
            ]),
            SizedBox(
              height: 20,
            ),
            getUsageForHeaderInfo("DAILY")
          ],
        ));
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: appBArHeight),
        child: CustomHeader(headerText, child));
  }

  showAppUsageModal(AppUsageModel app) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AppUsageScreen(app));
  }

  getDailyUsage() {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Text(
        'Total Usage',
        style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w500, color: Colors.white),
      ),
      SizedBox(
        height: 10,
      ),
      StreamBuilder(
          stream: homeBloc.totalUsedObservable,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return Text(
              snapshot.data ?? '',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            );
          })
    ]));
  }

  getWeeklyUsage() {
    return StreamBuilder(
        stream: homeBloc.dataPointAllApps,
        builder: (context, AsyncSnapshot<List<AppDataPoint>> snapshot) {
          return snapshot.data != null && snapshot.data.length > 0
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder(
                              stream: homeBloc.totalUsedObservable,
                              builder:
                                  (context, AsyncSnapshot<String> snapshot) {
                                return Text(
                                  'Total Usage- ${snapshot.data}',
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                );
                              })),
                      Container(
                        child: UsageChart(snapshot.data, 'hrs'),
                        height: 130,
                      )
                    ])
              : Container();
        });
  }

  getUsageForHeaderInfo(String viewType) {
    return AnimatedHeader(
        getDailyUsage(), getWeeklyUsage(), animationController);
  }

  dispose() {
    super.dispose();
    homeBloc.dispose();
  }
}
