import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GraphQlScreen extends StatefulWidget {
  const GraphQlScreen({Key? key}) : super(key: key);

  @override
  _GraphQlScreenState createState() => _GraphQlScreenState();
}

class _GraphQlScreenState extends State<GraphQlScreen> {
  List<int> ratingsData = [0, 0, 0, 0, 0]; // For storing counts of ratings 1-5
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRatings(); // Fetch the ratings when the screen is initialized
  }

  Future<void> fetchRatings() async {
    try {
      var ratingSnapshot =
          await FirebaseFirestore.instance.collection('ratings').get();
      List<int> counts = [0, 0, 0, 0, 0];

      // Loop through each document and count the ratings
      for (var doc in ratingSnapshot.docs) {
        var rate = (doc.data()['rating'] as num).toDouble(); // Handle as double
        if (rate >= 1 && rate <= 5) {
          counts[rate.toInt() - 1] +=
              1; // Increment the count for the respective rating
        }
      }

      setState(() {
        ratingsData = counts; // Update state with the fetched counts
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching ratings: $error");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch data: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings vs Frequency'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  minY: 0, // Minimum y-axis value
                  maxY: ratingsData.reduce((a, b) => a > b ? a : b).toDouble() +
                      1, // Set max Y based on data
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                            toY: ratingsData[0].toDouble(), color: Colors.amber)
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                            toY: ratingsData[1].toDouble(), color: Colors.amber)
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                            toY: ratingsData[2].toDouble(), color: Colors.amber)
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                            toY: ratingsData[3].toDouble(), color: Colors.amber)
                      ],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(
                            toY: ratingsData[4].toDouble(), color: Colors.amber)
                      ],
                    ),
                  ],

                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval:
                            1, // Set the interval to 1 to show only integer values
                        getTitlesWidget: (value, meta) {
                          // Show title only if the value is an integer
                          if (value % 1 == 0) {
                            return Text(value.toInt().toString());
                          }
                          return Container(); // Return empty container for fractional values
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 1:
                              return Text('1*');
                            case 2:
                              return Text('2*');
                            case 3:
                              return Text('3*');
                            case 4:
                              return Text('4*');
                            case 5:
                              return Text('5*');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
