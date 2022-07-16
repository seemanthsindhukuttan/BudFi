import 'package:budfi/screens/onboarding/onbording.dart';
import 'package:budfi/screens/settings/custom_drawer.dart';
import '../../db/category/category_db.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/user/user_model.dart';
import '../../theme/Light/colors/colors.dart';
import '../analysis/analysis_screen.dart';
import '/model/transaction/transaction_model.dart';
import '/screens/addscreen/add_screen.dart';
import '/screens/home/widgets/custom_appbar.dart';
import '/screens/home/widgets/custom_floating_action_button.dart';
import '/screens/home/widgets/custom_header_card.dart';
import '/screens/home/widgets/custom_transacton_tile.dart';
import '/widgets/customSizedBox.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../transaction/transaction_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int hours = DateTime.now().hour;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    TransactionDb.instance.refreshUI();
    CategoryDB.instance.refreshUI();

    return Scaffold(
        endDrawer: const CustomDrawer(),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth / 40, vertical: deviceWidth / 40),
            children: [
              const CustomAppBar(),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight / 80),
                child: Text(
                  hours < 12
                      ? 'Good Morning'
                      : hours < 17
                          ? 'Good Afternoon'
                          : 'Good Evening ',
                  style: TextStyle(
                    fontFamily: 'VariableFont',
                    color: BudFiColor.textColorGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 36,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: OnBording.userDb.listenable(),
                builder: (BuildContext context, Box<UserModel> value,
                    Widget? child) {
                  final username = value.get('user')!.username;
                  return Text(
                    username,
                    style: const TextStyle(
                      fontFamily: 'Prompt',
                      color: BudFiColor.textColorBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight / 90, bottom: deviceHeight / 40),
                child: const HeaderCard(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction History',
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      color: BudFiColor.textColorBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),

                  ValueListenableBuilder(
                    valueListenable:
                        TransactionDb.instance.transactionsListNotifer,
                    builder: (BuildContext context,
                        List<TransactionModel> value, Widget? child) {
                      return value.isNotEmpty
                          ? Row(
                              children: [
                                IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: const TransactionScreen(),
                                        type: PageTransitionType.leftToRight,
                                      ),
                                    );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.tableColumns,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                value.length >= 3
                                    ? IconButton(
                                        splashRadius: 20,
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AnalysisScreen(),
                                            ),
                                          );
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.chartPie,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      )
                                    : CustomSizedBox(),
                              ],
                            )
                          : CustomSizedBox();
                    },
                  ),
                  //
                ],
              ),
              ValueListenableBuilder(
                valueListenable: TransactionDb.instance.transactionsListNotifer,
                builder: (BuildContext context, List<TransactionModel> newlist,
                    Widget? _) {
                  return TransactionDb
                          .instance.transactionsListNotifer.value.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no_data.gif',
                              height: deviceHeight * 0.38,
                            ),
                            const Text(
                              '      No Transactions !!\n add some transactions',
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: newlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            final db = newlist[index];
                            return CustomTransactionTile(
                              onDoubleTap: () {
                                if (db.id != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddScreen(updateID: db),
                                      ));
                                }
                              },
                              color: db.type == categorytype.income
                                  ? Colors.green
                                  : Colors.red,
                              incomecard:
                                  db.type == categorytype.income ? true : false,
                              amount: db.amount.toString(),
                              date: DateFormat.yMMMEd()
                                  .format(db.dateTime)
                                  .toString(),
                              notes: db.notes,
                              avataricon: db.notes[0].toUpperCase(),
                              categoryName: db.category.categoryname,
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButtonWidget(
          onpressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: AddScreen(),
              ),
            );
          },
        ));
  }
}
