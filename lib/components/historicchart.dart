import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:intl/intl.dart';

class HistoricChart extends StatelessWidget {
  final Map historicData;

  const HistoricChart({Key key, this.historicData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = [];
    historicData.forEach((key, value) {
      list.add(value);
    });
    final fromDate = DateTime(2020, 3, 7);
    var toDate = DateTime.now().add(Duration(days: 1));
    List<DataPoint<dynamic>> data = [];
    var newCases;
    var formatter = new DateFormat('yyyy-MM-dd');
    for (var i = 0; i < list.length; i++) {
      if (i > 0) {
        newCases = double.parse(list[i]['confirmed'].toString()) -
            double.parse(list[i - 1]['confirmed'].toString());
        var dateTime = DateFormat('M/d/yyyy').parse(list[i]['day']);
        data.add(DataPoint<DateTime>(value: newCases, xAxis: dateTime));
        if (i == list.length - 1 && formatter.format(dateTime) != formatter.format(toDate.subtract(Duration(days: 1)))) {
          toDate = DateTime.now();
        }
      }
    }

    return BezierChart(
      fromDate: fromDate,
      bezierChartScale: BezierChartScale.WEEKLY,
      toDate: toDate,
      selectedDate: toDate.subtract(
        Duration(days: 1),
      ),
      footerDateTimeBuilder: (DateTime value, BezierChartScale scaleType) {
        final newFormat = DateFormat('dd/MM');
        return newFormat.format(value);
      },
      series: [
        BezierLine(
          lineStrokeWidth: 5.0,
          label: 'Nuevos Casos',
          data: data,
        ),
      ],
      config: BezierChartConfig(
        showDataPoints: false,
        verticalIndicatorStrokeWidth: 2.0,
        verticalIndicatorColor: Color(0xffe59928),
        showVerticalIndicator: true,
        verticalIndicatorFixedPosition: false,
        pinchZoom: false,
        updatePositionOnTap: true,
        backgroundColor: Color(0xff222b45),
        physics: ScrollPhysics(),
      ),
    );
  }
}
