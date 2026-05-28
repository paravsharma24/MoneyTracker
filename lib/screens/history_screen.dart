import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneytracker/services/transaction_service.dart';
import 'package:moneytracker/widgets/animated_background.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void showDetails(Map transaction) {
    showDialog(
      context: context,

      barrierColor: Colors.black.withValues(alpha: 0.2),

      builder: (context) {
        return  BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

          child: AlertDialog(
            backgroundColor: Colors.white.withValues(alpha: 0.75),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),

            title: const Text("Transaction Details"),

            content: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text("Amount : ₹${transaction["amount"]}"),

                const SizedBox(height: 10),

                Text("Category : ${transaction["category"]}"),

                const SizedBox(height: 10),

                Text("Note : ${transaction["note"]}"),

                const SizedBox(height: 10),

                Text("Date : ${transaction["date"].toString().split(" ")[0]}"),
              ],
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = TransactionService.getTransactions();

    return AnimatedBackground( 
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "History",

              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (transactions.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No transactions yet",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,

                  itemBuilder: (context, index) {
                    final transaction = transactions[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(25),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),

                              blurRadius: 10,
                            ),
                          ],
                        ),

                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.withValues(
                              alpha: 0.2,
                            ),

                            child: const Icon(Icons.payments),
                          ),

                          title: Text(transaction["category"]),

                          subtitle: Text(
                            transaction["date"].toString().split(" ")[0],
                          ),

                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text("₹${transaction["amount"]}"),

                              GestureDetector(
                                onTap: () {
                                  showDetails(transaction);
                                },

                                child: const Text(
                                  "Details",

                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    ),
    );
  }
}
