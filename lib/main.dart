import 'package:flutter/material.dart';

import 'package:flight_appplication/custom_shape_clipper.dart';
import 'package:flight_appplication/constants.dart';
import 'package:flight_appplication/components/choice_clip.dart';
import 'package:flight_appplication/AppBar/custom_app_bar.dart';
import 'package:flight_appplication/pages/FlightList/flight_list.dart';
import 'package:flight_appplication/model/city.dart';
import 'package:flight_appplication/components/city_card.dart';

import 'package:flight_appplication/bloc/main_bloc.dart';
import 'package:flight_appplication/bloc/events.dart';
import 'package:flight_appplication/bloc/bloc_provider.dart';

import 'package:flight_appplication/pages/HomeScreen/home_screen.dart';
import 'package:flight_appplication/pages/WatchListScreen/watchlist_screen.dart';
import 'package:flight_appplication/pages/DealsScreen/deals_screen.dart';

void main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc mainBloc = MainBloc();
  final textFieldContent = TextEditingController(text: 'New York (JFK)');
  String location = 'LA';
  // final Function save

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      InheritedHomePage(
        child: HomeScreen(),
        textFieldContent: textFieldContent,
        saveSelectedLocation: saveSelectedLocation
      ),
      WatchListScreen(),
      DealsScreen()
    ];

    return MaterialApp(
      title: 'Flight App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(
        bottomNavigationBar: CustomAppBar(bloc: mainBloc, index: 0),
        body: InheritedFlightApp(bloc: mainBloc, child: _children[0]),
      ),
      routes: {
        '/search': (BuildContext context) {
          mainBloc.refillForSearch();
          mainBloc.refillForSearch();
          return StreamBuilder(
            stream: mainBloc.locations,
            builder: (context, snapshot) {
              mainBloc.refillForSearch();
              List<String> locationList =
                  snapshot.data == null ? ['LA'] : snapshot.data;
              return StreamBuilder(
                stream: mainBloc.selectedPopupItemIndex,
                builder: (context, snapshot) {
                  var selectedPopupItemIndex =
                      snapshot.data == null ? 0 : snapshot.data;
                  return InheritedFlightListPage(
                    bloc: mainBloc,
                    child: FlightListPage(),
                    fromLocation: location,
                    toLocation: textFieldContent.text,
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  void saveSelectedLocation(String fromLocation) {
    location = fromLocation;
  }

  @override
  void dispose() {
    super.dispose();
    mainBloc.dispose();
  }
}

//class HomeScreenTopPart extends StatelessWidget {
//  final textFieldContent = TextEditingController(text: 'New York (JFK)');
//
//  @override
//  Widget build(BuildContext context) {
//    MainBloc _bloc = InheritedFlightApp.of(context).bloc;
//    return StreamBuilder(
//      stream: _bloc.locations,
//      builder: (context, snapshot) {
//        List<String> locationList = snapshot.data;
//        return Stack(
//          children: <Widget>[
//            ClipPath(
//              clipper: CustomShapeClipper(),
//              child: Container(
//                height: 400.0,
//                decoration: BoxDecoration(
//                  gradient: LinearGradient(
//                    begin: Alignment.centerLeft,
//                    end: Alignment.centerRight,
//                    colors: [Color(0xFFF47D15), Color(0xFFEF772C)],
//                  ),
//                ),
//                child: StreamBuilder<Object>(
//                  stream: _bloc.selectedPopupItemIndex,
//                  builder: (context, snapshot) {
//                    var selectedPopupItemIndex =
//                        snapshot.data == null ? 0 : snapshot.data;
//                    return Column(
//                      children: <Widget>[
//                        SizedBox(
//                          height: 40.0,
//                          width: MediaQuery.of(context).size.width,
//                        ),
//                        Row(
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.all(16.0),
//                              child: Icon(
//                                Icons.location_on,
//                                color: Colors.white,
//                              ),
//                            ),
//                            SizedBox(
//                              width: 10.0,
//                            ),
//                            PopupMenuButton(
//                              onSelected: (int index) {
//                                var flightEvent = SelectLocationEvent();
//                                flightEvent.content = index;
//                                _bloc.flightEventSink.add(flightEvent);
//                              },
//                              child: Row(
//                                children: <Widget>[
//                                  Text(
//                                    locationList[selectedPopupItemIndex],
//                                    style: dropDownMenuText,
//                                  ),
//                                  Icon(
//                                    Icons.keyboard_arrow_down,
//                                    color: Colors.white,
//                                  )
//                                ],
//                              ),
//                              itemBuilder: (BuildContext context) =>
//                                  locationList.map((String location) {
//                                    return PopupMenuItem(
//                                      child: Text(
//                                        location,
//                                        style: dropDownItemsStyle,
//                                      ),
//                                      value: locationList.indexOf(location),
//                                    );
//                                  }).toList(),
//                            ),
//                            Spacer(),
//                            Container(
//                              alignment: Alignment.topRight,
//                              padding: EdgeInsets.only(right: 16.0),
//                              child: Icon(
//                                Icons.settings,
//                                color: Colors.white,
//                              ),
//                            )
//                          ],
//                        ),
//                        SizedBox(
//                          height: 50.0,
//                        ),
//                        Text(
//                          'Where Would\n You Wanna Go?',
//                          style: TextStyle(color: Colors.white, fontSize: 24.0),
//                          textAlign: TextAlign.center,
//                        ),
//                        SizedBox(
//                          height: 20.0,
//                        ),
//                        Padding(
//                          padding: EdgeInsets.symmetric(horizontal: 32.0),
//                          child: Material(
//                            elevation: 10.0,
//                            borderRadius:
//                                BorderRadius.all(Radius.circular(30.0)),
//                            child: TextField(
//                              controller: textFieldContent,
//                              cursorColor: appTheme.primaryColor,
//                              style: dropDownItemsStyle,
//                              decoration: InputDecoration(
//                                border: InputBorder.none,
//                                contentPadding: EdgeInsets.symmetric(
//                                    vertical: 14.0, horizontal: 32.0),
//                                suffixIcon: Material(
//                                  elevation: 5.0,
//                                  borderRadius:
//                                      BorderRadius.all(Radius.circular(30.0)),
//                                  child: InkWell(
//                                    onTap: () {
//                                      Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                          builder: (context) =>
//                                              InheritedFlightListPage(
//                                                bloc: _bloc,
//                                                child: FlightListPage(),
//                                                fromLocation: locationList[
//                                                    selectedPopupItemIndex],
//                                                toLocation:
//                                                    textFieldContent.text,
//                                              ),
//                                        ),
//                                      );
//                                    },
//                                    child: Icon(
//                                      Icons.search,
//                                      color: Colors.black,
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(top: 30.0),
//                          child: StreamBuilder(
//                            stream: _bloc.isFlightSelected,
//                            builder: (context, snapshot) {
//                              var isFlight =
//                                  snapshot.data == null ? true : snapshot.data;
//                              return Row(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  ChoiceClip(
//                                    icon: Icons.flight_takeoff,
//                                    text: 'Flights',
//                                    isFlightSelected: isFlight,
//                                    onChoiceSelected: (type) =>
//                                        onChoiceClicked(type, isFlight, _bloc),
//                                  ),
//                                  SizedBox(
//                                    width: 20.0,
//                                  ),
//                                  ChoiceClip(
//                                    icon: Icons.hotel,
//                                    text: 'Hotels',
//                                    isFlightSelected: isFlight,
//                                    onChoiceSelected: (type) =>
//                                        onChoiceClicked(type, isFlight, _bloc),
//                                  ),
//                                ],
//                              );
//                            },
//                          ),
//                        ),
//                      ],
//                    );
//                  },
//                ),
//              ),
//            ),
//          ],
//        );
//      },
//    );
//  }
//
//  onChoiceClicked(String type, bool isFlightSelected, MainBloc bloc) {
//    if (type == 'Flights' && !isFlightSelected) {
//      bloc.flightEventSink.add(SelectTypeEvent());
//    }
//
//    if (type == 'Hotels' && isFlightSelected) {
//      bloc.flightEventSink.add(UnSelectTypeEvent());
//    }
//  }
//}
//
//class HomeScreenBottomPart extends StatelessWidget {
//  Widget _buildCityCards(City city) {
//    return CityCard(city: city);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    MainBloc _bloc = InheritedFlightApp.of(context).bloc;
//
//    return Column(
//      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.only(
//              top: 30.0, left: 16.0, right: 16.0, bottom: 10.0),
//          child: Row(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Text(
//                'Currently Watched Items',
//                style: TextStyle(
//                  fontSize: 15.0,
//                  color: Colors.black,
//                  fontFamily: 'Oxygen',
//                ),
//              ),
//              Text(
//                'VIEW ALL (12)',
//                style: TextStyle(
//                  fontSize: 15.0,
//                  color: appTheme.primaryColor,
//                  fontFamily: 'Oxygen',
//                ),
//              ),
//            ],
//          ),
//        ),
//        Container(
//          height: 240.0,
//          child: StreamBuilder(
//            stream: _bloc.cities,
//            builder: (context, snapshot) {
//              return ListView.builder(
//                scrollDirection: Axis.horizontal,
//                itemBuilder: (context, index) {
//                  return _buildCityCards(snapshot.data[index]);
//                },
//                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
//              );
//            },
//          ),
//        ),
//      ],
//    );
//  }
//}
