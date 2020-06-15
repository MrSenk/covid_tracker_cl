import 'dart:convert';
import 'package:covid_chile/datasource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid_chile/panels/countrypanel.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map countryData;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await fetchCountryData();
    await fetchHistoricCountryData();
    await fetchRegionData();
    await fetchHistoricRegionData();
    _refreshController.refreshCompleted();
  }

  fetchCountryData() async {
    http.Response response = await http
        .get('https://chile-coronapi.herokuapp.com/api/v3/latest/nation');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  Map historicCountryData;

  fetchHistoricCountryData() async {
    http.Response response = await http
        .get('https://chile-coronapi.herokuapp.com/api/v3/historical/nation');
    setState(() {
      historicCountryData = json.decode(response.body);
    });
  }

  Map regionData;

  fetchRegionData() async {
    http.Response response = await http
        .get('https://chile-coronapi.herokuapp.com/api/v3/latest/regions');
    setState(() {
      regionData = json.decode(response.body);
    });
  }

  Map historicRegionData;

  fetchHistoricRegionData() async {
    http.Response response = await http
        .get('https://chile-coronapi.herokuapp.com/api/v3/historical/regions');
    setState(() {
      historicRegionData = json.decode(response.body);
    });
  }

  List selectedRegion = [];

  @override
  void initState() {
    fetchCountryData();
    fetchHistoricCountryData();
    fetchRegionData();
    fetchHistoricRegionData();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  final formatter = new NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: clearWhite,
        body: SmartRefresher(
          enablePullDown: true,
          header: MaterialClassicHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 14.0,
                    top: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Hola! 👋',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Aquí está la última información!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 14.0),
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(
                            'https://i.imgur.com/amzHa4O.jpg',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                countryData == null || historicCountryData == null
                    ? Container(
                        height: size.height / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: darkBlue,
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: clearWhite,
                              ),
                            ),
                          ),
                        ),
                      )
                    : CountryPanel(
                        countryData: countryData,
                        historicCountryData: historicCountryData,
                      ),
                Container(
                  height: 30,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: DataSource.regions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: ButtonTheme(
                            minWidth: 50.0,
                            child: FlatButton(
                              splashColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              onPressed: () {
                                Map info = regionData[DataSource.regions[index]
                                        ['id']
                                    .toString()]['regionData'];
                                List selectedRegionInfo = [];
                                info.forEach((key, value) {
                                  selectedRegionInfo.add(value);
                                  selectedRegionInfo.add({
                                    'order': DataSource.regions[index]['order'],
                                    'name': DataSource.regions[index]['name']
                                  });
                                });
                                setState(() {
                                  selectedRegion = selectedRegionInfo;
                                });
                              },
                              color: Colors.blue,
                              child: Text(
                                DataSource.regions[index]['order'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: clearWhite,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: size.height > 1200 ? size.height / 4 * 0.9 : size.height / 2 * 0.8,
                    width: size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: darkGreen,
                      child: selectedRegion.length == 0
                          ? Center(
                              child: Text(
                                'Seleccione una región...',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: clearWhite,
                                  fontSize: 20.0,
                                ),
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: clearWhite,
                                        child: CircleAvatar(
                                          backgroundColor: darkGreen,
                                          radius: 12,
                                          child: Text(
                                            selectedRegion[1]['order'].toString(),
                                            style: TextStyle(
                                                color: clearWhite,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        'Región ' +
                                            selectedRegion[1]['name'].toString(),
                                        style: TextStyle(
                                          color: clearWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width > 800 ? 18.0 : 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: Divider(
                                    thickness: 2.0,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: darkerGreen,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Confirmados',
                                                style: TextStyle(
                                                  color: clearOrange,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                formatter.format(selectedRegion[0]['confirmed']).replaceAll(',', '.'),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                  color: clearWhite,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Muertos',
                                                style: TextStyle(
                                                  color: clearRed,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                formatter.format(selectedRegion[0]['deaths']).replaceAll(',', '.'),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                  color: clearWhite,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
