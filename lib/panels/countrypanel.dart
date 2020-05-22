import 'package:covid_chile/components/historicchart.dart';
import 'package:flutter/material.dart';

class CountryPanel extends StatelessWidget {
  final Map countryData;
  final Map historicCountryData;

  const CountryPanel({Key key, this.countryData, this.historicCountryData})
      : super(key: key);

  static final fromDate = DateTime(2020, 3, 7);

  static final toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color(0xff222b45),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xfff2f6fC),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        'https://cdn.countryflags.com/thumbs/chile/flag-square-250.png',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Chile',
                    style: TextStyle(
                        color: Color(0xfff2f6fC),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                color: Color(0xff1f273d),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Confirmados',
                            style: TextStyle(
                              color: Color(0xffe59928),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            countryData['confirmed'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color(0xfff2f6fC),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Muertos',
                            style: TextStyle(
                              color: Color(0xfff45051),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            countryData['deaths'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color(0xfff2f6fC),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.only(bottom: 20.0, right: 14.0, left: 14.0),
              child: HistoricChart(
                historicCountryData: historicCountryData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
