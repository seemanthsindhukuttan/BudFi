import 'package:flutter/material.dart';

import '../../../widgets/customSizedBox.dart';

class CardArrow extends StatelessWidget {
  bool isExpense;
  String amount;
  CardArrow({Key? key, this.isExpense = false, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Icon(
            isExpense == false ? Icons.arrow_downward : Icons.arrow_downward,
            color: isExpense == false ? Colors.green : Colors.red,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: deviceWidth / 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpense == false ? 'Income' : 'Expense',
                style: TextStyle(
                    fontFamily: 'Prompt',
                    color: Colors.grey.shade100,
                    fontWeight: FontWeight.bold),
              ),
              CustomSizedBox(
                height: deviceWidth / 100,
              ),
              Text(
                '₹ $amount',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Prompt',
                    color: Colors.grey.shade100,
                    fontWeight: FontWeight.w200),
              ),
            ],
          ),
        )
      ],
    );
  }
}
