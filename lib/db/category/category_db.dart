import 'dart:math';

import 'package:budfi/model/category/category_model.dart';
import 'package:budfi/model/transaction/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

import '../../model/analysis/analysis_model.dart';
import '../transaction/transaction_db.dart';

const String CATEGORY_DB_NAME = 'category_db'; //database name.

abstract class CategoryDbFuction {
  //get function.
  Future<List<CategoryModel>> getCategoryes();
  //add function.
  Future<void> addCategoryes(CategoryModel value);
  //delete function.
  Future<void> deleteCategoryes(String key);
  //update function.
  Future<void> updateCategory(String key, CategoryModel value);
  //clear all categorys.
  Future<void> clearAllCategories();
  // auto addadding
  Future<void> autoAdding();
}

class CategoryDB implements CategoryDbFuction {
  /// *******************************************************/
  //singletone
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }
  //singletone
  /// *******************************************************/
  //income category list notifier.
  ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier =
      ValueNotifier([]);
  //expense category list notifier.
  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);

  /// *******************************************************/

  //add fuction.
  @override
  Future<void> addCategoryes(CategoryModel value) async {
    final _db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _db.put(value.id, value);
    await refreshUI();
  }

  /// *******************************************************/

  // get function.
  @override
  Future<List<CategoryModel>> getCategoryes() async {
    final _db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _db.values.toList();
  }

  /// *******************************************************/
  ///update function.
  @override
  Future<void> updateCategory(String key, CategoryModel value) async {
    final _db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _db.put(key, value);
    await refreshUI();
  }

  /// *******************************************************/

  /// delete function.
  @override
  Future<void> deleteCategoryes(String key) async {
    final _db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _db.delete(key);
    await refreshUI();
  }

  /// *******************************************************/
  @override
  Future<void> autoAdding() async {
    int _id = Random().nextInt(9999999);

    //list of income category.
    List<String> incomeCategoryItems = [
      'Salary',
      'Wages',
      'Commission',
      'Intrest',
      'Selling',
      'Investment',
      'Allowance',
      'Voucher',
      'Bonus',
      'Goverment payments',
      'Others',
    ];

    //list of Expense category.
    List<String> expenseCategoryItems = [
      'Rent',
      'Transportation',
      'Groceries',
      'Food',
      'Gifts',
      'Insurance',
      'Bill & Emi',
      'Education',
      'Health & Personal care',
      'Home & utilites',
      'Others',
    ];
    Iterator<String> expenseItem = expenseCategoryItems.iterator;
    Iterator<String> incomeItem = incomeCategoryItems.iterator;
    while (expenseItem.moveNext()) {
      await CategoryDB.instance.addCategoryes(
        CategoryModel(
          id: _id.toString(),
          categoryname: expenseItem.current,
          type: categorytype.expense,
        ),
      );
      _id++;
    }

    while (incomeItem.moveNext()) {
      await CategoryDB.instance.addCategoryes(
        CategoryModel(
          id: _id.toString(),
          categoryname: incomeItem.current,
          type: categorytype.income,
        ),
      );
      _id++;
    }
  }

  // clear all data
  @override
  Future<void> clearAllCategories() async {
    final _db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _db.clear();
    await refreshUI();
  }

  /// *******************************************************/

  //income Piechart function.

  List<GDPdataModel> pieDataListIncome(List<TransactionModel> transaction) {
    List<GDPdataModel> piechartList = [];
    final transactionList = transaction;
    final categoryList = incomeCategoryListNotifier.value;
    double amount = 0;
    for (var i = 0; i < categoryList.length; i++) {
      piechartList.add(
        GDPdataModel(
          categoryName: categoryList[i].categoryname,
          totalamount: amount,
        ),
      );

      for (var j = 0; j < transactionList.length; j++) {
        if (piechartList[i].categoryName ==
            transactionList[j].category.categoryname) {
          piechartList[i].totalamount += transactionList[j].amount;
        }
      }
    }

    return piechartList;
  }

  //income Piechart function.

  /// *******************************************************/
  //Expense Piechart function.
  List<GDPdataModel> pieDataListExpense(List<TransactionModel> transaction) {
    List<GDPdataModel> piechartList = [];
    final transactionList = transaction;

    final categoryList = expenseCategoryListNotifier.value;
    double amount = 0;
    for (var i = 0; i < categoryList.length; i++) {
      piechartList.add(
        GDPdataModel(
          categoryName: categoryList[i].categoryname,
          totalamount: amount,
        ),
      );

      for (var j = 0; j < transactionList.length; j++) {
        if (piechartList[i].categoryName ==
            transactionList[j].category.categoryname) {
          piechartList[i].totalamount += transactionList[j].amount;
        }
      }
    }

    return piechartList;
  }
  //Expense Piechart function.

  /// *******************************************************/
  // refreshUI function.
  Future<void> refreshUI() async {
    final _allCategories = await getCategoryes();
    incomeCategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();

    await Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == categorytype.income) {
          incomeCategoryListNotifier.value.add(category);
        } else {
          expenseCategoryListNotifier.value.add(category);
        }
      },
    );

    incomeCategoryListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
  }
}
