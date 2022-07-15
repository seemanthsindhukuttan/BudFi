import 'package:budfi/db/category/category_db.dart';
import 'package:budfi/db/transaction/transaction_db.dart';
import 'package:budfi/model/transaction/transaction_model.dart';
import 'package:budfi/screens/category/widgets/add_category_bottom_sheet.dart';
import 'package:budfi/screens/addscreen/widgets/custom_elevated_button.dart';
import 'package:budfi/screens/addscreen/widgets/custom_radio_button.dart';
import 'package:budfi/widgets/customSizedBox.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../model/category/category_model.dart';
import '../../theme/Light/colors/colors.dart';

class AddScreen extends StatefulWidget {
  TransactionModel? updateID;
  AddScreen({Key? key, this.updateID}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _selectedDate = ValueNotifier<DateTime>(DateTime.now());

  final _type = ValueNotifier(categorytype.income);
  final ValueNotifier<String?> _selectedCategory = ValueNotifier(null);

  final _amountController = TextEditingController();

  final _noteController = TextEditingController();

  final _incomeFormKey = GlobalKey<FormState>();
  final _noteFormKey = GlobalKey<FormState>();
  CategoryModel? _selectedCategoryModel;

  @override
  void initState() {
    if (widget.updateID != null) {
      _amountController.text = widget.updateID!.amount.toString();
      _noteController.text = widget.updateID!.notes;
      _selectedDate.value = widget.updateID!.dateTime;
      _type.value = widget.updateID!.type;
      _selectedCategoryModel = widget.updateID!.category;
      _selectedCategory.value = widget.updateID?.category.id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Transactions',
          style: TextStyle(
            fontFamily: 'Prompt',
            color: BudFiColor.textColorBlack,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth / 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // income form field
                Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.35, top: deviceHeight / 25),
                  child: Form(
                    key: _incomeFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Amount is required';
                        } else if (value.length >= 10) {
                          return " Max limit 9,00,00,000 crore";
                        } else {
                          return null;
                        }
                      },
                      autofocus: true,
                      controller: _amountController,
                      // autofocus: true,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'Prompt',
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontFamily: 'Prompt',
                          color: Theme.of(context).hintColor,
                        ),
                        prefixIcon: Icon(
                          Icons.currency_rupee,
                          size: 35,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ),

                // notes form field

                CustomSizedBox(height: deviceWidth / 30),
                // choiese button
                ValueListenableBuilder(
                    valueListenable: _type,
                    builder: (BuildContext context, categorytype changedValue,
                        Widget? _) {
                      CategoryDB.instance.refreshUI();
                      return Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.arrowDownUpAcrossLine,
                            color: Theme.of(context).hintColor,
                          ),
                          CustomSizedBox(width: 12),
                          CustomRadioButton(
                            value: categorytype.income,
                            groupValue: changedValue,
                            onChanged: (value) {
                              _type.value = value;
                              _type.notifyListeners();
                              _selectedCategory.value = null;
                            },
                            text: 'Income',
                          ),
                          CustomRadioButton(
                            value: categorytype.expense,
                            groupValue: changedValue,
                            onChanged: (value) {
                              _type.value = value;
                              _type.notifyListeners();
                              _selectedCategory.value = null;
                            },
                            text: 'Expense',
                          ),
                        ],
                      );
                    }),

                CustomSizedBox(height: deviceWidth / 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: _type,
                        builder: (BuildContext context,
                            categorytype updateCategory, Widget? _) {
                          return Builder(builder: (context) {
                            return ValueListenableBuilder(
                                valueListenable: _selectedCategory,
                                builder: (BuildContext context,
                                    String? updateValue, Widget? _) {
                                  return DropdownButton(
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      color: BudFiColor.textColorBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    underline: CustomSizedBox(),
                                    value: updateValue,
                                    isDense: true,
                                    borderRadius: BorderRadius.circular(20),
                                    hint: Text(
                                      'Select Category',
                                      style: TextStyle(
                                        fontFamily: 'Prompt',
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: (updateCategory ==
                                                categorytype.income
                                            ? CategoryDB
                                                .instance
                                                .incomeCategoryListNotifier
                                                .value
                                            : CategoryDB
                                                .instance
                                                .expenseCategoryListNotifier
                                                .value)
                                        .map((item) => DropdownMenuItem(
                                              onTap: () {
                                                _selectedCategoryModel = item;
                                              },
                                              value: item.id,
                                              child: Text(
                                                item.categoryname,
                                                style: const TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      _selectedCategory.value =
                                          value as String?;
                                    },
                                  );
                                });
                          });
                        }),
                    Text(
                      'OR',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return AddCategoryBottomSheet();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.category_outlined,
                        size: 30,
                      ),
                      label: Text(
                        ' Add new\nCategorys',
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomSizedBox(height: deviceHeight / 80),
                Form(
                  key: _noteFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Note is required';
                      } else if (value.length < 3) {
                        return "Please use at least 3 characters.";
                      } else if (value.length > 15) {
                        return "Please use at maximum 15 characters.";
                      } else {
                        return null;
                      }
                    },
                    controller: _noteController,
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      color: BudFiColor.textColorBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Note',
                      hintStyle: TextStyle(
                        fontFamily: 'Prompt',
                        color: Theme.of(context).hintColor,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: FaIcon(
                          size: 25,
                          FontAwesomeIcons.fileInvoice,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
                CustomSizedBox(height: deviceHeight / 80),
                ValueListenableBuilder(
                  valueListenable: _selectedDate,
                  builder:
                      (BuildContext context, DateTime newdatetime, Widget? _) {
                    return TextButton.icon(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: newdatetime,
                          firstDate: DateTime(2022, 1),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != _selectedDate.value) {
                          _selectedDate.value = picked;
                        }
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.solidCalendar,
                        color: Theme.of(context).hintColor,
                        size: 25,
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(),
                        child: Text(
                          DateFormat('yMEd')
                              .format(_selectedDate.value)
                              .toString(),
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            color: BudFiColor.textColorBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                CustomSizedBox(height: deviceWidth / 30),
                CustomElevatedButtonWidget(
                  buttonText: widget.updateID != null ? 'Update' : 'Save',
                  width: MediaQuery.of(context).size.shortestSide,
                  onpressed: () {
                    insertDb();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> insertDb() async {
    if (widget.updateID == null) {
      if (_noteFormKey.currentState!.validate() &&
          _incomeFormKey.currentState!.validate() &&
          _selectedCategory.value != null &&
          _selectedCategoryModel != null) {
        final _value = TransactionModel(
          notes: _noteController.text,
          amount: double.parse(_amountController.text.trim()),
          dateTime: _selectedDate.value,
          type: _type.value,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          category: _selectedCategoryModel!,
        );
        await TransactionDb.instance.addTransaction(_value);
        Navigator.pop(context);
      }
    }
    if (widget.updateID != null) {
      if (_noteFormKey.currentState!.validate() &&
          _incomeFormKey.currentState!.validate() &&
          _selectedCategory.value != null &&
          _selectedCategoryModel != null) {
        final _value = TransactionModel(
          notes: _noteController.text,
          amount: double.parse(_amountController.text.trim()),
          dateTime: _selectedDate.value,
          type: _type.value,
          id: widget.updateID!.id,
          category: _selectedCategoryModel!,
        );
        await TransactionDb.instance.updateDB(widget.updateID!.id, _value);
        Navigator.pop(context);
      }
    }
  }
}
