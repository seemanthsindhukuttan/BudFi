import 'package:budfi/screens/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/transaction/transaction_model.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../addscreen/add_screen.dart';
import '../home/widgets/custom_transacton_tile.dart';

class ExpenseTransaction extends StatelessWidget {
  const ExpenseTransaction({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        ValueListenableBuilder(
          valueListenable: TransactionScreen.selectedDropDownValue,
          builder:
              (BuildContext context, int? selectedDropDownValue, Widget? _) {
            return ValueListenableBuilder(
              valueListenable: selectedDropDownValue == 0
                  ? TransactionDb().expenseTransactionsListNotifer
                  : selectedDropDownValue == 1
                      ? TransactionDb().expenseTransactionsMontlyListNotifier
                      : selectedDropDownValue == 2
                          ? TransactionDb
                              .instance.expenseTransactionsYearlyListNotifier
                          : TransactionDb().expenseTransactionsListNotifer,
              builder: (BuildContext context, List<TransactionModel> newlist,
                  Widget? _) {
                return newlist.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/no_data.gif',
                            height: deviceHeight * 0.30,
                          ),
                          const Text(
                            'No Expense Transaction',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Prompt',
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: newlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          final db = newlist[index];
                          return CustomTransactionTile(
                            color: db.type == categorytype.income
                                ? Colors.green
                                : Colors.red,
                            incomecard: false,
                            editButton: true,
                            onSelected: (button) async {
                              if (button == 1) {
                                if (db.isInBox) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: AddScreen(updateID: db),
                                    ),
                                  );
                                }
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      heading: 'Delete message',
                                      content:
                                          'Are you sure ? Do you want to delete this transaction?',
                                      firstbuttonName: 'DELETE',
                                      secondbuttonName: 'CANCLE',
                                      onpressedFirstbutton: () {
                                        if (db.id.isNotEmpty) {
                                          TransactionDb.instance
                                              .deleteTransaction(db.id);
                                        }
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            amount: db.amount.toString(),
                            date: DateFormat.yMMMd()
                                .format(db.dateTime)
                                .toString(),
                            notes: db.notes,
                            avataricon: db.notes[0].toUpperCase(),
                            categoryName: db.category.categoryname,
                          );
                        },
                      );
              },
            );
          },
        ),
      ],
    );
  }
}
