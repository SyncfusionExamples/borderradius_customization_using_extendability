import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chart Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Initailize the chart's data source globally.
List<_SalesData> chartData = <_SalesData>[
  _SalesData('Jan', 36),
  _SalesData('Feb', 28),
  _SalesData('Mar', 34),
  _SalesData('Apr', 32),
  _SalesData('May', 40)
];

// State class that holds the chart widget
class _MyHomePageState extends State<_MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Center(
          child: Container(
              height: 500,
              width: 340,
              child: SfCartesianChart(
                  backgroundColor: Colors.white,
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Half yearly sales analysis'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  series: <ChartSeries<_SalesData, String>>[
                    ColumnSeries<_SalesData, String>(
                        // Event with which the overridng is done in the chart.
                        onCreateRenderer:
                            (ChartSeries<dynamic, dynamic> series) {
                          return CustomColumnSeriesRenderer();
                        },
                        dataSource: chartData,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ])),
        ));
  }
}

// Custom colum series renderer for creating the custom segemnt painter
class CustomColumnSeriesRenderer extends ColumnSeriesRenderer {
  CustomColumnSeriesRenderer();

  @override
  ChartSegment createSegment() {
    // Custom segement painter returned
    return CustomChartPainter();
  }
}

// Initialized Custom Segment painter for customizing each segements of the series based on the current segment index value.
class CustomChartPainter extends ColumnSegment {
  // Initialized a rect to store the segment rect of each column
  Rect rect;
  @override
  void onPaint(Canvas canvas) {
    rect = segmentRect.outerRect;
    // Based on teh y value of the column, we have set the border radius for the each column segment
    // here, if the value is above 35, the bottom corner parts of the colum segement will be rounded.
    if (chartData[currentSegmentIndex].sales > 35) {
      segmentRect = RRect.fromRectAndCorners(rect,
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25));
      // here, if the value is below 35, the top corner parts of the colum segement will be rounded.
    } else if (chartData[currentSegmentIndex].sales < 35) {
      segmentRect = RRect.fromRectAndCorners(rect,
          topLeft: Radius.circular(25), topRight: Radius.circular(25));
    } // You can set the radius values as per your wish using the necessary parameters(topLeft, topRight, bottomRight, bottomLeft) of the RRect.fromRectAndCorners method.

    // Called the superclass's methods and properties for column segment rendering.
    super.onPaint(canvas);
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
