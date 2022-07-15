import 'package:budfi/db/category/category_db.dart';
import 'package:budfi/model/category/category_model.dart';
import 'package:flutter/material.dart';
import '../../../theme/Light/colors/colors.dart';
import '../../../widgets/customSizedBox.dart';
import '../../addscreen/widgets/custom_elevated_button.dart';
import '../../addscreen/widgets/custom_radio_button.dart';
import 'package:budfi/model/transaction/transaction_model.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  CategoryModel? updateID;
  AddCategoryBottomSheet({Key? key, this.updateID}) : super(key: key);

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _type = ValueNotifier(categorytype.income);
  final _categoryNameController = TextEditingController();

  @override
  void initState() {
    if (widget.updateID != null) {
      _categoryNameController.text = widget.updateID!.categoryname;
      _type.value = widget.updateID!.type;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: deviceHeight / 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: deviceHeight / 100),
              child: Divider(
                color: Theme.of(context).hintColor,
                thickness: 2,
                indent: MediaQuery.of(context).size.longestSide / 5,
                endIndent: MediaQuery.of(context).size.longestSide / 5,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: deviceWidth / 20),
              child: const Text(
                'Add Categories',
                style: TextStyle(
                  fontFamily: 'Prompt',
                  color: BudFiColor.textColorBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextFormField(
                controller: _categoryNameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Category name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth / 10),
              child: ValueListenableBuilder(
                valueListenable: _type,
                builder: (BuildContext context, categorytype changedValue,
                    Widget? _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      CustomSizedBox(width: 10),
                      CustomRadioButton(
                        value: categorytype.income,
                        groupValue: changedValue,
                        onChanged: (value) {
                          _type.value = value;
                          _type.notifyListeners();
                          print(_type.value);
                        },
                        text: 'Income',
                      ),
                      CustomRadioButton(
                        value: categorytype.expense,
                        groupValue: changedValue,
                        onChanged: (value) {
                          _type.value = value;
                          _type.notifyListeners();
                          print(_type.value);
                        },
                        text: 'Expense',
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth / 3.5),
              child: CustomElevatedButtonWidget(
                buttonText: widget.updateID == null ? 'Save' : 'Update',
                width: MediaQuery.of(context).size.width * 0.5,
                onpressed: () async {
                  if (widget.updateID == null) {
                    if (_categoryNameController.text.isNotEmpty) {
                      await CategoryDB.instance.addCategoryes(
                        CategoryModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          categoryname: _categoryNameController.text,
                          type: _type.value,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                  if (widget.updateID != null) {
                    if (_categoryNameController.text.isNotEmpty) {
                      CategoryDB.instance.updateCategory(
                        widget.updateID!.id,
                        CategoryModel(
                            id: widget.updateID!.id,
                            categoryname: _categoryNameController.text,
                            type: _type.value),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
