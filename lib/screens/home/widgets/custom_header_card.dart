import 'package:budfi/db/transaction/transaction_db.dart';
import 'package:budfi/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/customSizedBox.dart';
import 'custom_card_arrow.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          backgroundBlendMode: BlendMode.srcOver,
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: BudFiColor.gradientColor,
          ),
        ),
        child: Column(
          children: [
            CustomSizedBox(height: deviceHeight / 40),
            Text(
              DateFormat.yMMMMEEEEd().format(DateTime.now()).toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            CustomSizedBox(height: deviceHeight / 100),
            Text(
              'Balance',
              style: Theme.of(context).textTheme.headline5,
            ),
            ValueListenableBuilder(
              valueListenable: TransactionDb.instance.totalBalanceAmount,
              builder: (BuildContext context, double totalBalance, Widget? _) {
                return Text(
                  '₹ $totalBalance'.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
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
                    valueListenable: TransactionDb.instance.totalIncomeAmount,
                    builder: (BuildContext context, double totalIncomeAmount,
                        Widget? _) {
                      return CardArrow(
                        amount: totalIncomeAmount.toString(),
                      );
                    },
                  ),
                  //income arrow

                  //expense arrow
                  ValueListenableBuilder(
                    valueListenable: TransactionDb.instance.totalExpenseAmount,
                    builder: (BuildContext context, double totalExpenseAmount,
                        Widget? _) {
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
  }
}
