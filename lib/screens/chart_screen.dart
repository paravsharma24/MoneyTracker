import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:moneytracker/widgets/animated_background.dart';
import 'dart:async';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int selectedIndex = 2;

  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  final filters = ["Daily", "Weekly", "Monthly", "Yearly"];

  List<double> generateData(List transactions) {
    final now = DateTime.now();

    late List<double> data;

    switch (selectedIndex) {
      case 0:
        data = List.filled(24, 0);

        break;

      case 1:
        data = List.filled(7, 0);

        break;

      case 2:
        data = List.filled(31, 0);

        break;

      default:
        data = List.filled(12, 0);
    }

    for (var transaction in transactions) {
      DateTime date = transaction["date"];

      double amount = transaction["amount"];

      switch (selectedIndex) {
        case 0:
          if (date.day == now.day &&
              date.month == now.month &&
              date.year == now.year) {
            data[date.hour] += amount;
          }

          break;

        case 1:
          final weekStart = now.subtract(Duration(days: now.weekday - 1));

          if (date.isAfter(weekStart.subtract(const Duration(days: 1)))) {
            data[date.weekday - 1] += amount;
          }

          break;

        case 2:
          if (date.month == now.month && date.year == now.year) {
            data[date.day - 1] += amount;
          }

          break;

        case 3:
          if (date.year == now.year) {
            data[date.month - 1] += amount;
          }

          break;
      }
    }

    return data;
  }

  List<String> getLabels() {
    switch (selectedIndex) {
      case 0:
        return [
          "12AM",
          "1AM",
          "2AM",
          "3AM",
          "4AM",
          "5AM",
          "6AM",
          "7AM",
          "8AM",
          "9AM",
          "10AM",
          "11AM",

          "12PM",
          "1PM",
          "2PM",
          "3PM",
          "4PM",
          "5PM",
          "6PM",
          "7PM",
          "8PM",
          "9PM",
          "10PM",
          "11PM",
        ];

      case 1:
        return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

      case 2:
        return List.generate(31, (i) => "${i + 1}");

      default:
        return [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec",
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionBox = Hive.box("transactionBox");

    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),

      builder: (context, box, child) {
        final transactions = box.values.toList();

        final data = generateData(transactions);

        final labels = getLabels();

        return AnimatedBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Analytics",

                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 45,

                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,

                      itemCount: filters.length,

                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),

                          child: ChoiceChip(
                            label: Text(filters[index]),

                            selected: selectedIndex == index,

                            onSelected: (_) {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,

                        border: Border.all(color: Colors.black),

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: data.isEmpty
                          ? const Center(child: Text("No data available"))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,

                              child: SizedBox(
                                width: data.length * 70,

                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,

                                    maxY:
                                        data.reduce((a, b) => a > b ? a : b) +
                                        100,

                                    gridData: const FlGridData(show: true),

                                    borderData: FlBorderData(show: false),

                                    titlesData: FlTitlesData(
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),

                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),

                                      leftTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,

                                          reservedSize: 40,
                                        ),
                                      ),

                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,

                                          reservedSize: 35,

                                          getTitlesWidget: (value, meta) {
                                            int i = value.toInt();

                                            if (i < labels.length) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),

                                                child: Text(
                                                  labels[i],

                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              );
                                            }

                                            return const Text("");
                                          },
                                        ),
                                      ),
                                    ),

                                    barGroups: List.generate(data.length, (
                                      index,
                                    ) {
                                      return BarChartGroupData(
                                        x: index,

                                        barRods: [
                                          BarChartRodData(
                                            toY: data[index],

                                            width: 18,

                                            color: Colors.green,

                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

@override
void dispose(){

  refreshTimer?.cancel();

  super.dispose();
}
  
}
