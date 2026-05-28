import 'package:flutter/material.dart';
import 'package:moneytracker/services/transaction_service.dart';
import 'package:moneytracker/widgets/animated_background.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final amountController = TextEditingController();

  final noteController = TextEditingController();

  String selectedCategory = "Food";

  DateTime selectedDate = DateTime.now();

  final categories = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Education",
    "Entertainment",
    "Other",
  ];

  @override
  void dispose() {
    amountController.dispose();

    noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child:SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Add Expense",

              style: TextStyle(
                fontFamily: "Poppins",

                fontSize: 30,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: amountController,

              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: "Amount",

                prefixIcon: const Icon(Icons.currency_rupee),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(
              initialValue: selectedCategory,

              decoration: InputDecoration(
                labelText: "Category",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: noteController,

              maxLines: 3,

              decoration: InputDecoration(
                labelText: "Note",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: () async {
                  if (amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter amount")),
                    );

                    return;
                  }

                  double amount = double.tryParse(amountController.text) ?? 0;

                  if (amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid amount")),
                    );

                    return;
                  }

                  await TransactionService.saveTransaction(
                    amount: amount,

                    category: selectedCategory,

                    note: noteController.text,
                  );

                  amountController.clear();

                  noteController.clear();

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Expense Saved")),
                  );
                },

                child: const Text("Save Expense"),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
