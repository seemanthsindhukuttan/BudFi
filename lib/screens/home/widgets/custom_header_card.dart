import 'package:budfi/db/transaction/transaction_db.dart';
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
          gradient: const LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [
              Colors.blue,
              Colors.purpleAccent,
            ],
          ),
        ),
        child: Column(
          children: [
            CustomSizedBox(height: deviceHeight / 40),
            Text(
              DateFormat.yMMMMEEEEd().format(DateTime.now()).toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Prompt',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Colors.white,
              ),
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
              valueListenable: TransactionDb.instance.totalBalanceAmount,
              builder: (BuildContext context, double totalBalance, Widget? _) {
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
