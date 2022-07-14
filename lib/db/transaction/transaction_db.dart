import 'package:budfi/model/transaction/transaction_model.dart';
import 'package:budfi/model/user/user_model.dart';
import 'package:budfi/screens/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../screens/onboarding/onbording.dart';

const String TRANSACTION_DB_NAME = 'transaction_db';

abstract class TransactionDbFunction {
  //get Function.
  Future<List<TransactionModel>> getTransaction();
  //add Function.
  Future<void> addTransaction(TransactionModel value);
  // refreshUI function.
  Future<void> refreshUI();
  // update function.
  Future<void> updateDB(String key, TransactionModel value);
  //delete function.
  Future<void> deleteTransaction(String key);

  //clear all data function.
  Future<void> clearAllTransactions();
}

class TransactionDb implements TransactionDbFunction {
  /// *******************************************************/
  ///singletone
  TransactionDb._internal();
  static TransactionDb instance = TransactionDb._internal();
  factory TransactionDb() {
    return instance;
  }

  /// *******************************************************/
  ///
  /// *******************************************************/
  // all income and expense transaction list ValueNotifier.
  ValueNotifier<List<TransactionModel>> transactionsListNotifer =
      ValueNotifier([]);
  // income list ValueNotifier.
  ValueNotifier<List<TransactionModel>> incomeTransactionsListNotifer =
      ValueNotifier([]);
  // expense list ValueNotifier.
  ValueNotifier<List<TransactionModel>> expenseTransactionsListNotifer =
      ValueNotifier([]);
  //expense list for calculation.
  List<double> incomeAmountList = [];
  //income list for calculation.
  List<double> expenseAmountList = [];

  // monthly income list for calculation.
  List<double> montlyIncomeAmountList = [];
  // monthly expense list for calculation.
  List<double> montlyExpenseAmountList = [];
  // Yearly income list for calculation.
  List<double> yearlyIncomeAmountList = [];
  // Yearly expense list for calculation.
  List<double> yearlyExpenseAmountList = [];

  // filter list ValueNotifier with month and year//
  // all income Transactions MontlyList Notifier.
  ValueNotifier<List<TransactionModel>> incomeTransactionsMontlyListNotifier =
      ValueNotifier([]);
  // all Expense Transactions MontlyList Notifier.
  ValueNotifier<List<TransactionModel>> expenseTransactionsMontlyListNotifier =
      ValueNotifier([]);

  // all income Transactions YearlyList Notifier.
  ValueNotifier<List<TransactionModel>> incomeTransactionsYearlyListNotifier =
      ValueNotifier([]);
  // all Expense Transactions YearlyList Notifier.
  ValueNotifier<List<TransactionModel>> expenseTransactionsYearlyListNotifier =
      ValueNotifier([]);

  /// *******************************************************/
  /// all transactions.
  // total balance ValueNotifier to display balance
  ValueNotifier<double> totalBalanceAmount = ValueNotifier(0);
  // total income balance ValueNotifier to display income balance
  ValueNotifier<double> totalIncomeAmount = ValueNotifier(0);
  // total expense balance ValueNotifier to display expense balance
  ValueNotifier<double> totalExpenseAmount = ValueNotifier(0);

  /// all transactions.
  /// *******************************************************/

  /// monthly transactions.
  // monthly Total BalanceAmount ValueNotifier to display balance
  ValueNotifier<double> monthlyTotalBalanceAmount = ValueNotifier(0);
  //  monthly Total income balance ValueNotifier to display income balance
  ValueNotifier<double> monthlyTotalIncomeAmount = ValueNotifier(0);
  //  monthly Total expense balance ValueNotifier to display expense balance
  ValueNotifier<double> monthlyTotalExpenseAmount = ValueNotifier(0);
  //monthly transactions.
  //Yearly transactions.
  // Yearly Total BalanceAmount ValueNotifier to display balance
  ValueNotifier<double> yearlyTotalBalanceAmount = ValueNotifier(0);
  //  Yearly Total income balance ValueNotifier to display income balance
  ValueNotifier<double> yearlyTotalIncomeAmount = ValueNotifier(0);
  //  Yearly Total expense balance ValueNotifier to display expense balance
  ValueNotifier<double> yearlyTotalExpenseAmount = ValueNotifier(0);

  //Yearly transactions.

  /// *******************************************************/

  // add function.
  @override
  Future<void> addTransaction(TransactionModel value) async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _transactionDb.put(value.id, value);

    await refreshUI();
  }
  // add function.

  /// *******************************************************/
  ///get function.
  @override
  Future<List<TransactionModel>> getTransaction() async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _transactionDb.values.toList();
  }

  ///get function.
  /// *******************************************************/
  ///delete function.
  @override
  Future<void> deleteTransaction(String key) async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _transactionDb.delete(key);
    await refreshUI();
  }

  ///delete function.
  /// *******************************************************/

  ///update function.
  @override
  Future<void> updateDB(String key, TransactionModel value) async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _transactionDb.put(key, value);
    await refreshUI();
  }

  ///update function.
  /// *******************************************************/

  //clear all data function.
  @override
  Future<void> clearAllTransactions() async {
    final _transactionDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _transactionDb.clear();
    await refreshUI();
  }

  /// *******************************************************/

  /// screen refresh function.
  @override
  Future<void> refreshUI() async {
    final _list = await getTransaction();
    OnBording.userDb.get('user');
    /*********************************************************/
    // clearing all the list to inseting values.
    // all income expense calaculating List clearing.
    incomeAmountList.clear();
    expenseAmountList.clear();

    montlyExpenseAmountList.clear();
    montlyIncomeAmountList.clear();
    yearlyIncomeAmountList.clear();
    yearlyExpenseAmountList.clear();

    // all income expense calaculating List clearing.

    // all income expense ListNotifier clearing.
    transactionsListNotifer.value.clear();
    incomeTransactionsListNotifer.value.clear();
    expenseTransactionsListNotifer.value.clear();
    // all income expense ListNotifier clearing.

    //monthly and  yearly ListNotifier clearing
    incomeTransactionsMontlyListNotifier.value.clear();
    expenseTransactionsMontlyListNotifier.value.clear();
    incomeTransactionsYearlyListNotifier.value.clear();
    expenseTransactionsYearlyListNotifier.value.clear();

    monthlyTotalBalanceAmount.value = 0;
    monthlyTotalIncomeAmount.value = 0;
    monthlyTotalExpenseAmount.value = 0;

    yearlyTotalBalanceAmount.value = 0;
    yearlyTotalExpenseAmount.value = 0;
    yearlyTotalIncomeAmount.value = 0;

    totalIncomeAmount.value = 0;
    totalExpenseAmount.value = 0;
    totalBalanceAmount.value = 0;

    //monthly and  yearly ListNotifier clearing

    // clearing all the list to inseting values.

    /*********************************************************/
    /// sort & add to the all transaction to list.

    _list.sort((second, first) {
      return first.dateTime.compareTo(second.dateTime);
    });

    transactionsListNotifer.value.addAll(_list);

    incomeTransactionsListNotifer.value.sort(
      (second, first) => first.dateTime.compareTo(second.dateTime),
    );
    expenseTransactionsListNotifer.value.sort(
      (second, first) => first.dateTime.compareTo(second.dateTime),
    );

    /// sort & add to the all transaction to list.

    /*********************************************************/
    /// spliting income and expense to list.

    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.type == categorytype.income) {
          incomeTransactionsListNotifer.value.add(transaction);

          incomeAmountList.add(transaction.amount);
        } else {
          expenseTransactionsListNotifer.value.add(transaction);
          expenseAmountList.add(transaction.amount);
        }
      },
    );

    /// spliting spliting income and expense  to list.
    /*********************************************************/

    //get user wallet balance from intial opening app.
    OnBording.userDb.listenable();
    final value = OnBording.userDb.get('user');
    totalBalanceAmount.value = value!.amount;

    /*********************************************************/
    /// calaculate incomes.
    if (incomeAmountList.isNotEmpty) {
      totalIncomeAmount.value =
          incomeAmountList.reduce((value, element) => value + element);
    }

    /// calaculate incomes.

    /// calaculate expense.
    if (expenseAmountList.isNotEmpty) {
      totalExpenseAmount.value =
          expenseAmountList.reduce((value, element) => value + element);
    }

    /// calaculate expense.

    /// total balance.

    if (incomeAmountList.isNotEmpty || expenseAmountList.isNotEmpty) {
      if (incomeAmountList.isNotEmpty) {
        totalBalanceAmount.value += totalIncomeAmount.value;
      }
      if (expenseAmountList.isNotEmpty) {
        totalBalanceAmount.value -= totalExpenseAmount.value;
      }
    }

    /*********************************************************/
    // filter transactions with monthly algoritham.
    await Future.forEach(_list, (TransactionModel monthlyTransaction) {
      if (monthlyTransaction.dateTime.month ==
              TransactionScreen.selectedMonth.value.month &&
          monthlyTransaction.type == categorytype.income) {
        incomeTransactionsMontlyListNotifier.value.add(monthlyTransaction);
        montlyIncomeAmountList.add(monthlyTransaction.amount);
      } else {
        if (monthlyTransaction.dateTime.month ==
                TransactionScreen.selectedMonth.value.month &&
            monthlyTransaction.type == categorytype.expense) {
          expenseTransactionsMontlyListNotifier.value.add(monthlyTransaction);
          montlyExpenseAmountList.add(monthlyTransaction.amount);
        }
      }
    });
    // filter transactions with monthly algoritham.
    // filter transactions with Yearly algoritham.
    await Future.forEach(_list, (TransactionModel yearlyTransactions) {
      if (yearlyTransactions.dateTime.year ==
              TransactionScreen.selectedCurrentYear.value &&
          yearlyTransactions.type == categorytype.income) {
        incomeTransactionsYearlyListNotifier.value.add(yearlyTransactions);
        yearlyIncomeAmountList.add(yearlyTransactions.amount);
      } else {
        if (yearlyTransactions.dateTime.year ==
                TransactionScreen.selectedCurrentYear.value &&
            yearlyTransactions.type == categorytype.expense) {
          expenseTransactionsYearlyListNotifier.value.add(yearlyTransactions);
          yearlyExpenseAmountList.add(yearlyTransactions.amount);
        }
      }
    });
    /*********************************************************/
    //monthly transactions calculation.
    if (montlyIncomeAmountList.isNotEmpty) {
      monthlyTotalIncomeAmount.value =
          montlyIncomeAmountList.reduce((value, element) => value + element);
    }
    if (montlyExpenseAmountList.isNotEmpty) {
      monthlyTotalExpenseAmount.value =
          montlyExpenseAmountList.reduce((value, element) => value + element);
    }

    if (montlyIncomeAmountList.isNotEmpty) {
      monthlyTotalBalanceAmount.value += monthlyTotalIncomeAmount.value;
      if (expenseTransactionsListNotifer.value.isNotEmpty) {
        monthlyTotalBalanceAmount.value -= monthlyTotalExpenseAmount.value;
      }

      // print(monthlyTotalBalanceAmount.value);
    }

    //monthly  transactions calculation.

    //Yearly transactions calculation.
    if (yearlyIncomeAmountList.isNotEmpty) {
      yearlyTotalIncomeAmount.value =
          yearlyIncomeAmountList.reduce((value, element) => value + element);
    }
    if (yearlyExpenseAmountList.isNotEmpty) {
      yearlyTotalExpenseAmount.value =
          yearlyExpenseAmountList.reduce((value, element) => value + element);
    }

    if (yearlyIncomeAmountList.isNotEmpty) {
      yearlyTotalBalanceAmount.value += yearlyTotalIncomeAmount.value;
      if (expenseTransactionsListNotifer.value.isNotEmpty) {
        yearlyTotalBalanceAmount.value -= yearlyTotalExpenseAmount.value;
      }

      //print(yearlyTotalBalanceAmount.value);
    }

    //Yearly  transactions calculation.

    /*********************************************************/
    // all income expense List notifyListeners.
    transactionsListNotifer.notifyListeners();
    incomeTransactionsListNotifer.notifyListeners();
    expenseTransactionsListNotifer.notifyListeners();
    // all income expense List notifyListeners.

    // all income ,expense and total balance calaculating Notifylisteners
    totalIncomeAmount.notifyListeners();
    totalExpenseAmount.notifyListeners();
    totalBalanceAmount.notifyListeners();
    // all income ,expense and total balance calaculating Notifylisteners

    //income and expense transaction monthlyNotifylisteners
    incomeTransactionsMontlyListNotifier.notifyListeners();
    expenseTransactionsMontlyListNotifier.notifyListeners();
    //income and expense transaction monthlyNotifylisteners

    //income and expense transaction yearlyNotifylisteners
    incomeTransactionsYearlyListNotifier.notifyListeners();
    expenseTransactionsYearlyListNotifier.notifyListeners();
    //income and expense transaction yearlyNotifylisteners

    monthlyTotalBalanceAmount.notifyListeners();
    monthlyTotalIncomeAmount.notifyListeners();
    monthlyTotalExpenseAmount.notifyListeners();

    yearlyTotalBalanceAmount.notifyListeners();
    yearlyTotalIncomeAmount.notifyListeners();
    yearlyTotalExpenseAmount.notifyListeners();
  }

  /// screen refresh function.

}
