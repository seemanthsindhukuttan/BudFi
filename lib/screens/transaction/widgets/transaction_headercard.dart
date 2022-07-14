import 'package:budfi/db/transaction/transaction_db.dart';
import 'package:budfi/screens/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/customSizedBox.dart';
import '../../home/widgets/custom_card_arrow.dart';

class TransactionHeaderCard extends StatelessWidget {
  const TransactionHeaderCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: TransactionScreen.selectedDropDownValue,
      builder: (BuildContext context, int? selectedDropDownValue, Widget? _) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              backgroundBlendMode: BlendMode.srcOver,
              gradient: const LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                tileMode: TileMode.mirror,
                colors: [
                  Colors.blue,
                  Colors.purpleAccent,
                ],
              ),
            ),
            child: Column(
              children: [
                CustomSizedBox(height: deviceHeight / 40),
                ValueListenableBuilder(
                  valueListenable: TransactionScreen.selectedCurrentYear,
                  builder: (BuildContext context, int updatedYear, Widget? _) {
                    return ValueListenableBuilder(
                      valueListenable: TransactionScreen.selectedMonth,
                      builder: (BuildContext context, DateTime updatedDate,
                          Widget? _) {
                        return Text(
                          selectedDropDownValue == null ||
                                  selectedDropDownValue == 0
                              ? DateFormat.yMMMMEEEEd()
                                  .format(DateTime.now())
                                  .toString()
                              : selectedDropDownValue == 1
                                  ? DateFormat.yMMM()
                                      .format(updatedDate)
                                      .toString()
                                  : selectedDropDownValue == 2
                                      ? updatedYear.toString()
                                      : '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        );
                      },
                    );
                  },
                ),
                CustomSizedBox(height: deviceHeight / 100),
                const Text(
                  'Balance',
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: selectedDropDownValue == 0 ||
                          selectedDropDownValue == null
                      ? TransactionDb.instance.totalBalanceAmount
                      : selectedDropDownValue == 1
                          ? TransactionDb.instance.monthlyTotalBalanceAmount
                          : selectedDropDownValue == 2
                              ? TransactionDb.instance.yearlyTotalBalanceAmount
                              : TransactionDb.instance.totalBalanceAmount,
                  builder:
                      (BuildContext context, double totalBalance, Widget? _) {
                    return Text(
                      '₹ $totalBalance'.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: deviceHeight / 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //income arrow
                      ValueListenableBuilder(
                        valueListenable: selectedDropDownValue == null ||
                                selectedDropDownValue == 0
                            ? TransactionDb.instance.totalIncomeAmount
                            : selectedDropDownValue == 1
                                ? TransactionDb
                                    .instance.monthlyTotalIncomeAmount
                                : selectedDropDownValue == 2
                                    ? TransactionDb
                                        .instance.yearlyTotalIncomeAmount
                                    : TransactionDb.instance.totalIncomeAmount,
                        builder: (BuildContext context,
                            double totalIncomeAmount, Widget? _) {
                          return CardArrow(
                            amount: totalIncomeAmount.toString(),
                          );
                        },
                      ),
                      //income arrow
                      //expense arrow
                      ValueListenableBuilder(
                        valueListenable: selectedDropDownValue == null ||
                                selectedDropDownValue == 0
                            ? TransactionDb.instance.totalExpenseAmount
                            : selectedDropDownValue == 1
                                ? TransactionDb
                                    .instance.monthlyTotalExpenseAmount
                                : selectedDropDownValue == 2
                                    ? TransactionDb
                                        .instance.yearlyTotalExpenseAmount
                                    : TransactionDb.instance.totalExpenseAmount,
                        builder: (BuildContext context,
                            double totalExpenseAmount, Widget? _) {
                          return CardArrow(
                            amount: totalExpenseAmount.toString(),
                            isExpense: true,
                          );
                        },
                      ),
                      //expense arrow
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
