import 'package:hive_ce_flutter/hive_flutter.dart';

class TransactionService {

  static final transactionBox =
      Hive.box(
    "transactionBox",
  );

  static Future<void>
      saveTransaction({

    required double amount,
    required String category,
    required String note,

  }) async {

    await transactionBox.add({

      "amount": amount,
      "category": category,
      "note": note,
      "date": DateTime.now(),
    });

    await transactionBox.flush();
  }

  static List
      getTransactions() {

    return transactionBox
        .values
        .toList()
        .reversed
        .toList();
  }
}