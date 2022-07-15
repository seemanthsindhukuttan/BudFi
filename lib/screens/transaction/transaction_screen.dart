import 'package:budfi/screens/transaction/expense_transaction.dart';
import 'package:budfi/screens/transaction/income_transaction.dart';
import 'package:budfi/screens/transaction/widgets/custom_date_picker.dart';
import 'package:budfi/screens/transaction/widgets/transaction_headercard.dart';
import 'package:budfi/widgets/customSizedBox.dart';
import 'package:flutter/material.dart';
import '../../db/transaction/transaction_db.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  static final ValueNotifier<int?> selectedDropDownValue = ValueNotifier(0);
  static final ValueNotifier<int> selectedCurrentYear =
      ValueNotifier(DateTime.now().year);
  static final ValueNotifier<DateTime> selectedMonth =
      ValueNotifier(DateTime.now());
  static final ValueNotifier<bool> showYear = ValueNotifier(false);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    TransactionScreen.selectedDropDownValue.value = 0;
    TransactionScreen.showYear.value = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).hintColor,
          ),
        ),
        title:
            Text('Transactions', style: Theme.of(context).textTheme.headline2),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TransactionHeaderCard(),
              CustomSizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                  ),
                  child: TabBar(
                    splashBorderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    controller: tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
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
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(
                        text: 'Income',
                      ),
                      Tab(
                        text: 'Expense',
                      ),
                    ],
                  ),
                ),
              ),
              // tab bar view here
              Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth / 40, top: deviceHeight / 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder(
                        valueListenable:
                            TransactionScreen.selectedDropDownValue,
                        builder: (BuildContext context,
                            int? selectedDropDownValue, Widget? _) {
                          return DropdownButton(
                            borderRadius: BorderRadius.circular(20),
                            underline: CustomSizedBox(),
                            style: Theme.of(context).textTheme.headline1,
                            value: selectedDropDownValue,
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text("All"),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text("Monthly"),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text("Yearly"),
                              ),
                            ],
                            onChanged: (value) async {
                              TransactionScreen.selectedDropDownValue.value =
                                  value as int?;

                              if (value == 2) {
                                TransactionScreen.showYear.value = true;
                              }
                              if (value == 1) {
                                TransactionScreen.showYear.value = false;
                                TransactionScreen.selectedMonth.value =
                                    await SimpleMonthYearPicker
                                        .showMonthYearPickerDialog(
                                            context: context);
                              }
                              if (value == 0) {
                                TransactionScreen.showYear.value = false;
                              }
                              await TransactionDb.instance.refreshUI();
                            },
                          );
                        }),
                    ValueListenableBuilder(
                        valueListenable: TransactionScreen.showYear,
                        builder:
                            (BuildContext context, bool boolValue, Widget? _) {
                          return boolValue == true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      splashRadius: 20,
                                      color: Colors.grey,
                                      onPressed: () {
                                        TransactionScreen.selectedCurrentYear
                                            .value = TransactionScreen
                                                .selectedCurrentYear.value -
                                            1;
                                        TransactionDb.instance.refreshUI();
                                      },
                                      icon:
                                          const Icon(Icons.keyboard_arrow_left),
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: TransactionScreen
                                            .selectedCurrentYear,
                                        builder: (BuildContext context,
                                            int updateDate, Widget? _) {
                                          return Text(
                                            updateDate.toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Prompt',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          );
                                        }),
                                    IconButton(
                                      splashRadius: 20,
                                      color: Colors.grey,
                                      onPressed: () {
                                        TransactionScreen.selectedCurrentYear
                                            .value = TransactionScreen
                                                .selectedCurrentYear.value +
                                            1;
                                        TransactionDb.instance.refreshUI();
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_right),
                                    ),
                                  ],
                                )
                              : CustomSizedBox();
                        })
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    IncomeTransaction(),
                    ExpenseTransaction(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
