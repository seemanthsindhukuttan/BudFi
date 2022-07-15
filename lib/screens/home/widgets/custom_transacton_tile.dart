import 'package:budfi/widgets/customSizedBox.dart';
import 'package:flutter/material.dart';
import '../../../theme/Light/colors/colors.dart';

class CustomTransactionTile extends StatelessWidget {
  bool editButton;
  bool incomecard;
  String amount;
  String date;
  String notes;
  String categoryName;
  String avataricon;
  Color color;
  VoidCallback? onDoubleTap;
  Function(int)? onSelected;

  CustomTransactionTile(
      {Key? key,
      this.editButton = false,
      this.incomecard = true,
      required this.color,
      required this.amount,
      required this.date,
      required this.notes,
      required this.avataricon,
      required this.categoryName,
      this.onSelected,
      this.onDoubleTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Card(
        elevation: 0.20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(deviceHeight / 40),
          child: Row(
            children: [
              CircleAvatar(
                //backgroundColor: Colors.blue,
                backgroundColor: color,
                //  Colors.primaries[Random().nextInt(Colors.primaries.length)],
                radius: 20,
                child: Text(
                  avataricon,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Prompt',
                    fontSize: 20,
                  ),
                ),
              ),
              CustomSizedBox(width: deviceWidth / 40),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoryName,
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        color: BudFiColor.textColorBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      notes,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        fontFamily: 'Prompt',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight / 80),
                      child: Text(
                        incomecard == true ? '+ ₹ $amount' : '- ₹ $amount',
                        style: TextStyle(
                          fontSize: 18,
                          color: incomecard == true ? Colors.green : Colors.red,
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Prompt',
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              editButton == false
                  ? CustomSizedBox()
                  : Padding(
                      padding: EdgeInsets.only(top: deviceHeight / 80, left: 0),
                      child: PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text('Delete'),
                            )
                          ];
                        },
                        onSelected: onSelected,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
