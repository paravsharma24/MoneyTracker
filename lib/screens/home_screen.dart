import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:moneytracker/services/transaction_service.dart';
import 'package:moneytracker/widgets/animated_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userName;

  double getCurrentMonthExpense() {
    final transactions = TransactionService.getTransactions();

    double total = 0;

    final now = DateTime.now();

    for (var transaction in transactions) {
      DateTime date = transaction["date"];

      if (date.month == now.month && date.year == now.year) {
        total += transaction["amount"];
      }
    }

    return total;
  }

  @override
  void initState() {
    super.initState();

    final userBox = Hive.box("userBox");

    userName = userBox.get("name", defaultValue: "User");
  }

  @override
  Widget build(BuildContext context) {
    final transactionBox = Hive.box("transactionBox");

    final currentMonth = DateTime.now();

    final monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),

      builder: (context, box, child) {
        List transactions = box.values.toList().reversed.toList();

        List recent = transactions.take(4).toList();

        return Scaffold(
          body: AnimatedBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Hello, $userName 👋",

                      style: const TextStyle(
                        fontFamily: "Poppins",

                        fontSize: 30,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Track your spending smarter",

                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(25),

                      decoration: BoxDecoration(
                        color: Colors.green,

                        borderRadius: BorderRadius.circular(25),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "${monthNames[currentMonth.month - 1]} Expense",

                            style: const TextStyle(
                              color: Colors.white70,

                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "₹${getCurrentMonthExpense().toStringAsFixed(2)}",

                            style: const TextStyle(
                              color: Colors.white,

                              fontSize: 40,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      "Recent Activity",

                      style: TextStyle(
                        fontFamily: "Poppins",

                        fontSize: 22,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    if (recent.isEmpty)
                      Container(
                        width: double.infinity,

                        height: 230,

                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,

                          borderRadius: BorderRadius.circular(20),

                          border: Border.all(color: Colors.grey.shade300),
                        ),

                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 50,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 15),

                            Text(
                              "No transactions yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "Your recent activity will appear here",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    else
                      ...recent.map((transaction) {
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.payments),
                            ),

                            title: Text(transaction["category"]),

                            subtitle: Text(transaction["note"]),

                            trailing: Text("₹${transaction["amount"]}"),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
