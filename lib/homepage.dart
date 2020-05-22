import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid_chile/panels/countrypanel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map countryData;

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

  @override
  void initState() {
    fetchCountryData();
    fetchHistoricCountryData();
    fetchRegionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f6fC),
      body: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).padding,
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
                            fontSize: 30.0,
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
                            fontSize: 18.0,
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
                      height: MediaQuery.of(context).size.height / 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Color(0xff222b45),
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Color(0xfff2f6fC),
                            ),
                          ),
                        ),
                      ),
                    )
                  : CountryPanel(
                      countryData: countryData,
                      historicCountryData: historicCountryData,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
